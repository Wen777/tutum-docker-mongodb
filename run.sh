#!/bin/bash
if [ ! -f /.mongodb_password_set ]; then
	/set_mongodb_password.sh
	sleep 2
fi

if [ "$AUTH" == "yes" ]; then
    export mongodb="/usr/bin/mongod --nojournal --auth --httpinterface --rest --replSet '$MONGODB_REPLICA_SET' --noprealloc --smallfiles"
else
    export mongodb='/usr/bin/mongod --nojournal --httpinterface --rest'
fi

if [ "$REPL_MASTER" == "true" ]; then
	exec $mongodb

	sleep 2

	mongo admin -u admin -p ${MONGODB_PASS} --eval "rs.initiate()"

elif [ ! -f /data/db/mongod.lock ]; then
    exec $mongodb
else
    export mongodb=$mongodb' --dbpath /data/db'
    rm /data/db/mongod.lock
    mongod --dbpath /data/db --repair && exec $mongodb
fi
