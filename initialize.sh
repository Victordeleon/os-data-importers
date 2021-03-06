#!/bin/sh
set -e

rm celerybeat-schedule || ls -la
cd eu-structural-funds
export PYTHONPATH=$PYTHONPATH:`pwd`
export DPP_PROCESSOR_PATH=`pwd`/common/processors
python3 -m common.generate
cd ..
rm -f celeryd.pid
rm -f celerybeat.pid
dpp init
python3 -m celery -b amqp://guest:guest@mq:5672// -A datapackage_pipelines.app -l INFO beat &
python3 -m celery -b amqp://guest:guest@mq:5672// --concurrency=1 -A datapackage_pipelines.app -Q datapackage-pipelines-management -l INFO worker &
python3 -m celery -b amqp://guest:guest@mq:5672// --concurrency=4 -A datapackage_pipelines.app -Q datapackage-pipelines -l INFO worker &
/usr/bin/env os-types "[]" | true
dpp serve
