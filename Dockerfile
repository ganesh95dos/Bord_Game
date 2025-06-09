# Start with a base Java image with JDK 17 (or your Java version)
FROM maven:3.9.6-eclipse-temurin-17 

# Set the working directory inside the container
WORKDIR /app

# Copy the built jar file into the container
COPY pom.xml .
RUN mvn dependency:go-offline


# Copy the source code
COPY src ./src

# Build the application (runs tests by default)
RUN mvn clean package

#COPY target/boardgame-listing-webapp.jar app.jar
COPY target/*.jar app.jar

#COPY --from=build /app/target/*.jar app.jar

# Expose port your app listens on (usually 8080)
EXPOSE 8080

# Run the jar file
ENTRYPOINT ["java","-jar","app.jar"]
