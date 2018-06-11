FROM openjdk:8 AS base

#Intermediate build image
FROM base AS build

RUN apt update && apt install -y \
        wget

WORKDIR /app
#Build from github source
RUN wget https://ci.nukkitx.com/job/NukkitX/job/master/lastSuccessfulBuild/artifact/target/nukkit-1.0-SNAPSHOT.jar

#Runtime image
FROM base AS run

#Copy from build
COPY --from=build /app /app

#Setup minecraft user
RUN useradd --user-group \
            --no-create-home \
            --home-dir /data \
            --shell /usr/sbin/nologin \
            minecraft

#Volumes
VOLUME /data /home/minecraft

#Ports
EXPOSE 19132

#Make phar owned by minecraft user
RUN chown -R minecraft:minecraft /app

#User and group to run as
USER minecraft:minecraft

#Set runtime workdir
WORKDIR /data

ENTRYPOINT ["java"]
CMD ["-jar","/app/nukkit-1.0-SNAPSHOT.jar"]