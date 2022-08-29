FROM debian:stable-20220822
RUN apt-get update
RUN apt-get install -y curl wget
RUN curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash
RUN apt-get install -y speedtest
RUN speedtest --accept-license --accept-gdpr
RUN wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -
RUN wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-debian11-x86_64-100.6.0.deb
RUN apt-get install ./mongodb-database-tools-*.deb

ENV MONGODB_PORT 27017

ENTRYPOINT ["bash", "-c", "mongoimport --host ${MONGODB_HOST} --port ${MONGODB_PORT} --db ${MONGODB_DATABASE} --collection ${MONGODB_COLLECTION} --username ${MONGODB_USERNAME} --password ${MONGODB_PASSWORD} --type json --file <(speedtest -f json)"]
