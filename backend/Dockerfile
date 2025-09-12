# Simple Dockerfile using pre-built JAR
FROM amazoncorretto:17-alpine3.18

# Create non-root user for security (Alpine Linux compatible)
RUN addgroup -g 1001 -S appuser && \
    adduser -u 1001 -S appuser -G appuser

# Set working directory
WORKDIR /app

# Copy the pre-built JAR file
COPY target/backend-1.0-SNAPSHOT.jar app.jar

# Change ownership to non-root user
RUN chown -R appuser:appuser /app
USER appuser

# Expose the port that Spring Boot runs on
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]