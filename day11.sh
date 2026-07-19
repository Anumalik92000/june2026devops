# day 11 - Database, outputs, sidecars, functions
## Ansible- Install MAria DB

---
- name: Install Maria DB
  hosts: all
  become: yes

  tasks:   
    - name: Install MariaDB
  yum:
    name: mariadb-server
    state: present

- name: Start MariaDB
  service:
    name: mariadb
    stae: started
    enabled: yes
    

## terraform - output Public IP (r5.2xlarge)

resource "aws_instance" "PathnexServer" {
    ami = "ami-0abcd1234abcd1234"
    instance_type = "r5.2xlarge"

    tags = {
        Name = "Pathnex-Output-EC2"
    }
}

output "PathnexPublicIP" {
    value = aws_instance.PathnexServer.public_ip
}

## Kubernetes- Sidecar Container

apiVersion: v1
kind: Pod
metadata:
    name: pathnex-sidecar
spec:
    containers:
        - name: main
        imag: nginx
        - name: sidecar
          image: busybox
          command: ["sh", "-c", "echo Sidecar running: sleep 3600"]


## shell script- Function Example

#!/bin/bash
greet (){
    echo "Welcome to Pathnex DevOps Training"
}

greet

# Notifications
## Jenkins Pipeline - Email Notifications - to learn how to send email notification on failure or success

pipeline {
    agent any
    enviroonment {
        INSTITUTE_NAME = "Pathnex"
    }
    stages {
        stage('Checkout'){
            steps{
                git url: https://github.com/Pathnex/sample-java-app.git
            }
        }
        stage ('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
    }
    post {
        success{
         mail to: 'team@pathnex.com',
            subject: "SUCCESS: Build #$ {env.BUILD_NUMBER}" , 
            body: "Build completed successfully for INSTITUTE_NAME"
        }
        failure{
            mail to: 'team@pathnex.com',
                subject: "FAILURE: Build #${env.BUILD_NUMBER}",
                body: "Build failed for INSTITUTE_NAME"
        }
    }
}

## Gitlab CI - Notifications - to learn how to notify via email after job is completed

stages:
    - build

build:
    stage: build
    image: maven:3.8.1-jdk-17
    script:
        - git clone https://github.com/Pathnex/sample-java-app.git
        - cd sample-java-app
        - mvn clean package
    after_script:
        - echo "Sending notification email to team@pathnex.com"