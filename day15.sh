# Day 15- Java. S3 bucket, cron job, File Reader
## Ansible- Install Java and Set JAVA_HOME

---
- name: Install Java on Pathnex server
  hosts: all
  become: yes

  tasks: 
    - name: Install OpenJDK
      yum:
        name: java-11-openjdk
        state: present

    - name: Set JAVA_HOME
      lineinfile:
        path: /etc/profile
        line: 'export JAVA_HOME = /usr/lib/jvm/java-11-openjdk'


## Terraform - create S3 Bucket

provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "PathnexBucket" {
    bucket = "pathnex-devops-bucket"

    tags = {
        Name: "PathnexBucket"
    }
}


## kubernetes - CronJob

apiVersion: batch/v1
kind: CronJob
metadata:
    name: pathnex-cron

spec:
    schedule: "*/5 * * * *"
    jobTemplate:
        spec:
            template:
                spec:
                    containers:
                        - name: job
                          image: busybox
                          command: ["sh", "-c", "echo Pathnex CronJob running"]
                    restartPolicy: OnFailure


## Shell script- Read file Line by line

#!/bin/bash

FILE = "/etc/passwd"

while read line, do
    echo "Line: $line"
done < $FILE

# Advanced Notifications

## Jenkins Pipeline - Slack Notification - to learn how to send Slack notifications after build success or failure

pipeline {
    agent any
    environment {
        INSTITUTE_NAME = "Pathnex"
        SLACK_CHANNEL = "#Ddevops"
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://githun.com/Pathnex/sample[-java-app.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
    }
    post {
        success {
            slackSend(channel: "$SLACK_CHANNEL", message: "SUCCESS: $INSTITUTE_NAME Build #${env.BUILD_NUMBER}")
        }
        failure{
            slackSend(channel: "$SLACK_CHANNEL", message: "FAILURE:$INSTITUTE_NAME Build #${env.BUILD_NUMBER}")
        }
    }
}

## GitLab CI - Slack Notification- to learn how to notify slack in Gitlab CI

stages:
    - build
variables:
    INSTITUTE_NAME: "Pathnex"
    SLACK_WEBHOOK: "https://hooks.slack.com/services/XXXXX/YYYYY/ZZZZZ"

build:
    stage: build
    image: maven:3.8.1-jdk-17
    script:
        - git clone https://github.com/Pathnex/sample-java-app.git
        - cd sample-java-app
        - mvn clean package
        - curl -X POST -H 'Content- type: application/json' --data '{"text": "Build success for Pathnex"}' $SLACK_WEBHOOK