# Use Maven base image with JDK 17
FROM maven:3.9.6-eclipse-temurin-17

# Create non-root user
RUN useradd -m appuser

# Set working directory and fix permissions before switching user
WORKDIR /app
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Copy pom and download dependencies
COPY --chown=appuser:appuser pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY --chown=appuser:appuser src ./src

# Build the app
RUN mvn clean package

# Copy JAR
#COPY --chown=appuser:appuser target/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "target/app.jar"]
