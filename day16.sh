## 
##
#tasks
---
- name: Install httpd
  yum:
    name: httpd
    state: present

- name: Start httpd
  servie: 
    name: httpd
    state: started
    enabled: yes


## handlers
---
- name: Restart httpd
service: 
    name: httpd
    state: restarted


## vars
---
package_name: httpd
service_name: httpd


##playbook
---
- hosts: all
  become: yes
  roles:
    - pathnex

## Terraform - DynamoDB table

resource "aws_dynamodb_table" "PathnexTable" {
    name = "PathnexTrainingTable"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "ID"

    attribute {
        name = "ID"
        type = "S"
    }

    tags = {
        Name = "Pathnex-DDB"
    }
}


## Kubernetes- StatefulSet

apiVersion: apps/v1
kind: StatefulSet
metadata:
    name: pathnex-db
spec:
    serviceName: "pathnex"
    replicas: 2
    selector:
        matchLabels:
            app: pathnex-db
        template:
            metadata:
                labels:
                    app: pathnex-db
        spec:
            containers:
                - name: db
                  image: mysql
                  env:
                    - name: MYSQL_ROOT_PASSWORD
                      value: "Pathnex123"


## Shell Script- Check service running

#!/bin/bash

SERVICE = "sshd"

if systemctl is-active --quiet $SERVICE; then
    echo "$SERVICE is running" 
else 
    echo "$SERVICE is NOT running"
fi

#Artifacts promotion

## Jenkins Pipeline- Promote Artifacts- to learn how to promote build artifacts from dev to staging

pipeline {
    agent any
        environment {
            INSTITUTE_NAME = "Pathnex"
        }
        stages{
            stage('Build') {
                steps {
                    sh 'mvn clean package'
                }
            }
            stage('Promote') {
                steps {
                    input message: "Promote artifacts to staging?"
                    sh 'echo "Promoting artifacts for $INSTITUTE_NAME"'
            }
        }
    }
}


## GitLab CI- Artifacts Promotion- to promote artifacts manually using GitLab CI manual job

stages:
    - build
    - promote

build:
    stage: build
    image: maven:3.8.1-jdk-17
    script:
        - mvn clean package
    artifacts:
        paths: 
            - target/*.jar
            expire_in: 1 week
promote:
    stage: promote
    image: alpine: latest
    script:
        - echo "Promoting artifacts for Pathnex"
    when: manual
    