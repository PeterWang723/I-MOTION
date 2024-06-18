# 使用官方 Java 17 运行时环境作为父镜像
# Use an official Ubuntu base image
FROM ubuntu:latest

# Install OpenJDK 17
RUN apt-get update && apt-get install -y openjdk-21-jdk && rm -rf /var/lib/apt/lists/*

# Set the working directory to /app
WORKDIR /app

# Copy the built executable jar file into the image
COPY target/auth-0.0.1-SNAPSHOT.jar app.jar

# Declare the port on which the container listens for connections
EXPOSE 8080

# Specify the command to run within the container
CMD ["java", "-jar", "app.jar"]