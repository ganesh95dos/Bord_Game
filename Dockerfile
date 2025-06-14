FROM maven:3.9.6-eclipse-temurin-17

RUN useradd -m appuser

WORKDIR /app
COPY pom.xml .

# Ensure appuser owns the working directory and pom.xml
RUN chown -R appuser:appuser /app && chmod a-w pom.xml

USER appuser

RUN mvn dependency:go-offline

# Copy source with correct ownership
COPY --chown=appuser:appuser src ./src && find ./src -type f -exec chmod a-w {} \; && \
    find ./src -type d -exec chmod a-w {} \;

# Build the application
USER appuser
RUN find ./src -type f -exec chmod a-w {} \; && \
    mkdir -p target && \
    mvn clean package && \
    cp target/*.jar target/app.jar && \
    chmod a-w target/app.jar
    
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "target/app.jar"]
