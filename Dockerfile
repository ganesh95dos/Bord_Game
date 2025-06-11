# Use Maven base image with JDK 17
FROM maven:3.9.6-eclipse-temurin-17

# Create non-root user
RUN useradd -m appuser

# Set working directory and fix permissions before switching user
WORKDIR /app

# Copy pom.xml and set ownership
COPY pom.xml .
RUN chown appuser:appuser pom.xml && chmod a-w pom.xml

# Switch to non-root user
USER appuser

# Download dependencies
RUN mvn dependency:go-offline

# Copy source code and lock down permissions
COPY --chown=appuser:appuser src ./src
RUN find ./src -type f -exec chmod a-w {} \;


# Build the app
RUN mvn clean package

# Optionally make the entire target/ read-only
RUN find target -type f -exec chmod a-w {} \;

# Expose application port
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "target/app.jar"]
