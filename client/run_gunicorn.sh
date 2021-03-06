#!/bin/bash
#Run gunicorn
PID_FILE=/var/run/gunicorn_vasirtactics.pid
WORKERS=1
BIND_ADDRESS=127.0.0.1:7200
WORKER_CLASS=gevent
LOGFILE=/var/log/gunicorn/gunicorn_vasirtactics.log

cd /home/erik/Code/VasirTactics/client
source /home/erik/Code/VasirTactics/client/env/bin/activate

gunicorn app:app --pid=$PID_FILE --debug --log-level=debug --workers=$WORKERS --error-logfile=$LOGFILE --bind=$BIND_ADDRESS --worker-class=$WORKER_CLASS
