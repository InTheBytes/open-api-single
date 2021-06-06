FROM openjdk:17
 ADD target/openapi-0.0.1-SNAPSHOT.jar OpenAPI.jar
 EXPOSE 8080
ENTRYPOINT ["java","-jar","OpenAPI.jar"]