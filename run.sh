#!/bin/bash
if [ "$REPL_MASTER" == "false" ]; then

	touch /.mongodb_password_set
	sleep 1

elif [ ! -f /.mongodb_password_set ]; then

	/set_mongodb_password.sh
	sleep 1

fi


if [ "$AUTH" == "yes" ]; then
    export mongodb="/usr/bin/mongod --nojournal --auth --httpinterface --rest --replSet '$MONGODB_REPLICA_SET' --noprealloc --smallfiles"
else
    export mongodb='/usr/bin/mongod --nojournal --httpinterface --rest'
fi


if [ "$REPL_MASTER" == "true" ]; then

	if [ ! -f /data/db/mongod.lock ]; then

		exec $mongodb

		sleep 2

		mongo admin -u RootAdmin -p ${MONGODB_PASS} --eval "rs.initiate()"
	else
			export mongodb=$mongodb' --dbpath /data/db'
			rm /data/db/mongod.lock
			mongod --dbpath /data/db --repair && exec $mongodb

elif [ ! -f /data/db/mongod.lock ]; then
    exec $mongodb
else
    export mongodb=$mongodb' --dbpath /data/db'
    rm /data/db/mongod.lock
    mongod --dbpath /data/db --repair && exec $mongodb
fi
