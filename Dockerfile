FROM maven:3.9.1-eclipse-temurin-11-alpine
WORKDIR /app
COPY ./hr-api ./hr-api
COPY ./hr-boot ./hr-boot
COPY ./hr-model ./hr-model
COPY ./hr-ws ./hr-ws
COPY pom.xml .
EXPOSE 33333
RUN mvn install
WORKDIR /app/hr-boot
CMD mvn spring-boot:run