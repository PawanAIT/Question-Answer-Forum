# Question Answer Forum

## Instructions

### Setup for Docker
Inside Directory Docker/

```bash
    sudo docker-compose up -d
    sudo docker ps
    docker cp ../PostgreSQL/postgres_schema.sql <Docker Postgres ID>:/
    docker exec -it docker_database_1 /bin/bash
    psql -U pawan QnAForum < postgres_schema.sql
```

### To Backup from PGAdmin
- filename : /postgres_schema.sql
- format : plain
- Dump Options : Schema Only

```bash
sudo docker cp <Docker PGadmin ID>:/var/lib/pgadmin/storage/pawan/postgres_schema.sql <Location in your PC>
```
