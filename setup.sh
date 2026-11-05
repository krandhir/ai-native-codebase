#!/usr/bin/env bash
set -euo pipefail

echo "⚙️ Initializing Git repository..."
if [ ! -d ".git" ]; then
    git init
fi

echo "📄 Generating .gitignore..."
cat << 'EOF' > .gitignore
.gradle
build/
!gradle/wrapper/gradle-wrapper.jar
.idea/
*.iml
*.ipr
*.iws
.vscode/
.settings/
.classpath
.project
bin/
.DS_Store
Thumbs.db
.env
.env.local
*.log
EOF

echo "🚀 Creating Modular Monolith directory skeleton..."
mkdir -p src/main/java/com/company/project/shared
mkdir -p src/main/java/com/company/project/orders/domain/model
mkdir -p src/main/java/com/company/project/orders/domain/ports
mkdir -p src/main/java/com/company/project/orders/infrastructure/web
mkdir -p src/main/java/com/company/project/orders/infrastructure/db
mkdir -p src/main/java/com/company/project/orders/config
mkdir -p src/main/resources
mkdir -p src/test/java/com/company/project/orders
mkdir -p docs/adr

echo "📄 Generating settings.gradle..."
cat << 'EOF' > settings.gradle
rootProject.name = 'assignment-modular-monolith'
EOF

echo "📄 Generating build.gradle..."
cat << 'EOF' > build.gradle
plugins {
    id 'java'
    id 'org.springframework.boot' version '3.4.0'
    id 'io.spring.dependency-management' version '1.1.6'
}

group = 'com.company.project'
version = '1.0.0-SNAPSHOT'

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    implementation 'org.springframework.boot:spring-boot-starter-validation'
    implementation 'org.springframework.boot:spring-boot-starter-actuator'
    compileOnly 'org.projectlombok:lombok:1.18.34'
    annotationProcessor 'org.projectlombok:lombok:1.18.34'
    implementation 'org.mapstruct:mapstruct:1.6.3'
    annotationProcessor 'org.mapstruct:mapstruct-processor:1.6.3'
    runtimeOnly 'org.postgresql:postgresql'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    testCompileOnly 'org.projectlombok:lombok:1.18.34'
    testAnnotationProcessor 'org.projectlombok:lombok:1.18.34'
}

test {
    useJUnitPlatform()
}
EOF

echo "📄 Creating Architectural Decision Record 001..."
cat << 'EOF' > docs/adr/001-modular-monolith.md
# ADR 001: Adoption of a Modular Monolith Architecture
## Status
Accepted
## Context
The assignment requires building a production-like application while leveraging AI tools as much as possible.
## Decision
We choose a Modular Monolith pattern within a single Gradle module structure, separating concerns via clean packages.
## Consequences
Pragmatic speed and simple delivery for evaluators.
EOF

echo "📄 Creating Architectural Decision Record 002..."
cat << 'EOF' > docs/adr/002-stream-processing-and-top-k.md
# ADR 002: Stream Processing and Top-K Sorting Strategy
## Status
Accepted
## Context
Processing financial datasets can exhaust memory if fully loaded.
## Decision
Enforce lazy stream evaluation and use a bounded PriorityQueue (Min-Heap) structure.
## Consequences
Deterministic space complexity capped at O(1) and time complexity at O(N log K).
EOF

echo "📄 Generating CLAUDE.md Agent Instructions..."
cat << 'EOF' > CLAUDE.md
# CLAUDE.md - Developer Guide & Rules
## Build & Test Commands
* Build: `./gradlew build`
* Test: `./gradlew test`
* Run: `./gradlew bootRun`
## Code Style Guidelines
* Pattern: Modular Monolith
* Domain: Zero external framework code in domain packages
* Models: Use immutable records
* Financials: Always use BigDecimal
EOF

echo "📄 Generating Spring Boot entry main class..."
cat << 'EOF' > src/main/java/com/company/project/Application.java
package com.company.project;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
EOF

echo "📄 Generating Spring boot application configuration..."
cat << 'EOF' > src/main/resources/application.yml
spring:
  application:
    name: modular-monolith-service
  datasource:
    url: ${DATABASE_URL:jdbc:postgresql://localhost:5432/assignment_db}
    username: ${DATABASE_USERNAME:postgres}
    password: ${DATABASE_PASSWORD:postgres}
    driver-class-name: org.postgresql.Driver
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: false
management:
  endpoints:
    web:
      exposure:
        include: health,info
EOF

echo "📄 Generating docker-compose.yml..."
cat << 'EOF' > docker-compose.yml
version: '3.8'
services:
  postgres:
    image: postgres:16-alpine
    container_name: assignment-postgres
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: assignment_db
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    volumes:
      - pgdata:/var/lib/postgresql/data
volumes:
  pgdata:
EOF

echo "📄 Creating PROMPTS.md..."
cat << 'EOF' > PROMPTS.md
# AI Agent Prompts Log
## Phase 1: Architecture & Scaffolding
* Initialized single-module Modular Monolith structure utilizing Java 21, Gradle, and registered performance ADRs.
EOF

echo "📄 Creating README.md..."
cat << 'EOF' > README.md
# High-Throughput Trade Data Aggregator
Built with Java 21 and Spring Boot 3.4.x.
## Quick Start
1. `docker-compose up -d`
2. `./gradlew clean build`
3. `./gradlew bootRun`
EOF

echo "📦 Provisioning Gradle Wrapper natively..."
mkdir -p gradle/wrapper
cat << 'EOF' > gradle/wrapper/gradle-wrapper.properties
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.11.1-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOF

curl -sL https://githubusercontent.com -o gradlew
curl -sL https://githubusercontent.com.bat -o gradlew.bat
chmod +x gradlew

echo "🔨 Running baseline verification build..."
if ./gradlew build -x test; then
    echo "📦 Staging workspace files to Git..."
    git add .
    git commit -m "chore: structural scaffolding and architecture baseline"
    echo "✅ Success! Workspace established cleanly."
else
    echo "⚠️ Warning: Initial compilation failed. Check your local Java 21 settings."
fi
