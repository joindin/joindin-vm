#!/bin/bash
docker-compose up -d
sleep 10;
docker-compose exec db bash /var/joindin/scripts/patchdb.sh -t /var/joindin -d joindin -u root -p joindin -i
docker-compose exec api php tools/dbgen/generate.php | docker-compose exec -T db mysql -u root -pjoindin joindin

