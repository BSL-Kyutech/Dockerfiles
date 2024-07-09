#/bin/bash

# get current directory name
CDIR="$(basename `pwd`)"

# run container
if [ ! "$(docker ps -q -f name=$CDIR)" ]; then
	echo "Starting up ..."
	docker compose up -d
fi

unset CDIR

# display container
D_SERVICE="$(docker compose config --services)"
docker compose exec $D_SERVICE bash
unset D_SERVICE
