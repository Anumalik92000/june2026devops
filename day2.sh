#day2
---
- name: Install and start Nginx on Pathnex
    hosts: all
    become: yes

    tasks: 
      - name: Install Nginx
        yum:
          name: nginx
          state: present

      - name: Enable nginx
        service:
          name: nginx
          state: started
          enabled: yes

## terraform-EC2 with tags

provider "aws" {
    region= "us-east-1"
}

resource "aws_instance" "PathnexEC2" {
    ami = "ami-0abcd1234abcd1234"
    instance_type= "r5.2xlarge"

    tags ={
        Name = "Pathnex-Server"
        Environment = "Training"
        Owner = "PathnexStudent"
    }
}

## Kubernetes- deployment with 2 replicas

apiVersion: apps/v1
kind: Deployment
metadata:
    name: pathnex-deployment
spec:
    replicas: 2
    selector:
        matchLables:
            app: pathnex-app
        template:
            matadata:
                labels:
                    app: pathnex-app
            spec:
                containers: 
                    - name: app
                      image: nginx
                      ports:
                        - containerPort: 80

## shell script -Disk usage

#!/bin/bash
df -h

# Maven Build
## jenkinds Pipeline- Maven Build

pipeline {
    agent any
    tools{
        maven 'Maven-3.8.1'
        jdk 'JDK-17'
    }

    stages {
        stage('Checkout'){
            steps {
                git url: 'https://github.com/Pathnex/sample-java-app.git'
                  }
            }
        }

        stage('Compile') {
            steps {
            sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }
    }   
}

## Gitlab CI- Maven build

stages:
    - build
    - test
    - package

maven-build:
    stage: build
    image: maven:3.8.1-jdk-17
    script:
        - git clone https://github.com/Pathnex/sample-java-app.git
        - cd sample-java-app
        - mvn clean compile

maven-test:
    stage: test
    image: maven:3.8.1-jdk-17
    script:
        - cd sample-java-app
        - mvn test

maven-package:
    stage: package
    image: maven:3.8.1-jdk-17
    script:
        - cd sample-java-app
        - mvn package
    