# Day 09- templates, Internet Gateway, ConfigMap, CPU LOad
## Ansible - Use Jinja2 Template

---
- name: Deploy template for Pathnex
  hosts: all
  become: yes

  tasks:
    - name: Copy template file
    template:
        src: pathnex.conf.j2
        dest:/etc/pathnex.conf


## Terraform - Internet Gateway

resource "aws_internet_gateway" "PathnexIGW" {
vpc_id = aws_vpc.PathnexVPV.id

tags = {
    Name = "PAthnex-IGW"
    }
}

## kubernetes- Create ConfigMap

apiVersion: v1
kind: ConfigMap
metadata:
    name: Pathnex-config
data: 
    APP_MODE: "production"
    WELCOME_MSG: "Hello Pathnex"


## Shell Script - Check CPU Load

#!/bin/bash

Load=$(uptime | awk '{print $10}')
echo "Current CPU Load: $LOAD"


# Artifacts and Archiving

## JEnkins Pipeline- Archive Artifacts -- how to save build artifacts for future use

pipeline {
    agent any
    environment {
        INSTITUTE_NAME = "Pathnex"
    }
    stages {
        stage('Checckout'){
            steps { 
               git url: 'https://github.com/Pathnex/sample-java-app.git' 
                }
        }
        stage('Build'){
            steps{
                archiveARtifacts artifacts: 'target/*.jar', fingerprint: true
                }
        }
    }
}

## Gitlab CI- Artifacts- learn how to **store artifacts in Gitlab CI

stages:
    - build

build:
    stage: build
    image: maven:3.8.1-jdk-17
    script:
        - git clone https://github.com/Pathnex/sample-java-app.git
        - cd sample-java-app
        - mvn clean package
    artifacts:
        paths:
            - target/*.jar
            expire_in: 1 week
            

