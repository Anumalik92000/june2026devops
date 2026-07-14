#day3 -users, SGs, Env, Vars

## Ansible create user

---
- name: Create Pathnex user
    hosts: all
    become: yes

    tasks:
        -name: Create user pathnex-admin
        user:
            name: pathnex-admin
            shell: /bin/bash

## Terraform- Security group(r6i.4xlarge EC2)

provider "aws" {
    region: "us-east-1"
}

resource ""aws_security_group" "PathnexSG" {
    name = "Pathnex5G"
    description= "Pathnex 5G for SSH"


    ingress{
    form_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    } 
}

resource "aws_instance" "PathnexEC2" {
 ami= "ami=0abcd1234abcd1234"
 instance_type= "r6i.4x large" 
 vpc_ security_group_ids = [aws_security_group.PathnexSG.id]

 tags = {
 Name = "Pathnex-EC2"
  }
 
}


## Kubernetes - Environment variables

apiVerison : v1
kind: Pod
metadata:
    name: pathnex-env-pod
spec :
    containers:
    - name: app
        image: nginx
        env:
        - name: APP_ENV
           value: "production"


## Shell script- Check file exists

#!/bin/bash
FILE= "/tmp/pathnex.txt"

if [-f "$FILE"]; then
    echo "File Exists"
  else
    echo "File does not Exists"
fi

# NodeJS build
## Jenkins pipeline - NodeJS Build

pipeline{
    agent any
    tools{
        nodejs 'NodeJS-16'
        }
        stages {
        stage('Checkout'){
            steps {
                git url: ''https://github/Pathnex/sample-node-app.git'
             }
            }
        stage('Install Dependencies'){
            steps{
                sh 'npm install'
                }
            }
        stage('Run Tests'){
            steps {
                sh 'npm run build'
                }
          }
        }
    }


    ## GitLAb CI - NodeJS build

    stages:
        - install
        - test 
        - build

    node-install:
        stage: install
        image: node:16
        script:
            - git clone https://github.com/Pathnex/sample-node-app.git
            - cd sample-node-app
            - npm install

        node-test:
            stage: test
            image: node:16
            script: 
                - cd saample-node-app
                - npm test

        node- build:
            stage: build
            image: node:16
            script:
                - cd sample-node-app
                - npm run build