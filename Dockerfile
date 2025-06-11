FROM maven:3.9.6-eclipse-temurin-17

RUN useradd -m appuser

WORKDIR /app
COPY pom.xml .

# Ensure appuser owns the working directory and pom.xml
RUN chown -R appuser:appuser /app && chmod a-w pom.xml

USER appuser

RUN mvn dependency:go-offline

COPY --chown=appuser:appuser src ./src
RUN find ./src -type f -exec chmod a-w {} \;

# Explicitly create target/ so Maven doesn't fail
RUN mkdir -p target

RUN mvn clean package

RUN mv target/*.jar target/app.jar

RUN find target -type f -exec chmod a-w {} \;

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "target/app.jar"]
