FROM maven:3.9.6-eclipse-temurin-17

# Create non-root user
RUN useradd -m appuser

# Set working directory and copy only pom.xml
WORKDIR /app
COPY pom.xml .

# Set ownership and secure pom.xml
RUN chown -R appuser:appuser /app && chmod a-w pom.xml

# Switch to non-root user
USER appuser

# Download Maven dependencies (cached if src changes)
RUN mvn dependency:go-offline

# Copy source with ownership
COPY --chown=appuser:appuser src ./src

# Remove write permissions, build app, and secure JAR — all in one layer
RUN find ./src -type f -exec chmod a-w {} \; && \
    find ./src -type d -exec chmod a-w {} \; && \
    mkdir -p target && \
    mvn clean package && \
    cp target/*.jar target/app.jar && \
    chmod a-w target/app.jar

# Expose port and set default startup command
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "target/app.jar"]
