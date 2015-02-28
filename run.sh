#!/bin/bash
if [ ! -f /.mongodb_password_set ]; then
	/set_mongodb_password.sh
	sleep 1
fi

if [ "$AUTH" == "yes" ];
	then
		if [ "$KEYFILE" == "true" ]; then
				export mongodb="/usr/bin/mongod --nojournal --auth --httpinterface --rest --replSet '$MONGODB_REPLICA_SET' --noprealloc --smallfiles --keyFile /etc/mongod_conf/mongodb-keyfile"
		else
    		export mongodb="/usr/bin/mongod --nojournal --auth --httpinterface --rest --replSet '$MONGODB_REPLICA_SET' --noprealloc --smallfiles"
		fi
elif [ "$KEYFILE" == "true" ];
	then
		export mongodb="/usr/bin/mongod --nojournal --httpinterface --rest --replSet '$MONGODB_REPLICA_SET' --noprealloc --smallfiles --keyFile /etc/mongod_conf/mongodb-keyfile"
else
	export mongodb="/usr/bin/mongod --nojournal --httpinterface --rest --replSet '$MONGODB_REPLICA_SET' --noprealloc --smallfiles"
fi


if [ ! -f /data/db/mongod.lock ];
	then
    exec $mongodb
else
  export mongodb=$mongodb' --dbpath /data/db'
  rm /data/db/mongod.lock
  mongod --dbpath /data/db --repair && exec $mongodb
fi
