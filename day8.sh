# day 8- Variable, VPC, probes, Loops
## Ansible-Install Packages Using Variables

---
- name: Install packages for Pathnex using variables
    hosts: all
    become: yes

    vars:
        pathnex_packages:
            - tree
            - unzip
            - vim
        tasks:
            - name: Install required packages
            yum:
                name: "{{ pathnex_packages}}"
                state: present


## terraform- create VPC + subnet

provider "aws"{
    region: "us-east-1"
}

resource "aws_vpc" "PathnexVPC" {
    cidr_block = "10.10.0.0/16"
    
    tags = {
        Name = "Pathnex-VPC"
      }
    }

resource "aws_subnet" "PathnexSubnet" {
vpc_id = aws_vpc.PathnexVPC.id
cidr_block = "10.10.1.0/24"
map_public_ip_on_launch = true

tags = {
    Name= "Pathnex-Subnet"
    }
}


## kubernetes- add liveness & Readiness Probes

apiVersion: v1
kind: pod
metadata:   
    name: pathnex-probe-pod
spec:
    containers:
        - name: web
        image: nginx
        livenessProbe:
            httpGet:
                path: /
                port: 80
                initialDEplaySeconds: 5
                readinessProbe:
                    httpGet:
                        path: / 
                        port: 80 
                        initialDelaySeconds: 3


## Shell Script- Loop throiugh list

#!/bin/bash

for item in Pathnex Devops Training;  do
    echo "Item: $item"
    done
    
    
## conditional stages
## Jenkins Pipeline- conditional execution-- to run stages based on branch or parameter conditons

pipeline{
    agent any
    parameters{
        string(name: 'ENVIRONMENT', defaultValue: 'dev', description: 'Deployment Environment')
    }
    environment {
        INSTITUTE_NAME = "Pathnex"
    }

    stages {
        stage('Checkout'){
            steps {
                git branch: 'main', url: 'https://github.com/Pathnex/sample-java-app.git'
            }
        }

        stage('Build'){
            when {
                branch 'main'
            }
            steps {
                sh 'mvn clean compile'
            }
        }

        stage ('Deploy') {
            when {
                expression { params.ENVIRONMENT == 'dev'}
            }
            steps{
                sh 'echo "DEploying to $Environment by $INSTITUTE_NAME"'
            }
        }
    }
}

## GITLAB CI_ conditional job -- to run jobs based on variables or branches

stages:
    - build
    - deploy

build:
    stages: build
    image: maven:3.8.1-jdk-17
    script:
        - git clone https://github.com/Pathnex/sample-java-app.git
        - cd sample-java-app
        - mvn clean compile
    only:
        - main

deploy:
    stage: deploy
    image: alpine:latest
    script:
        - echo "Deploying to $CI_ENVIRONMENT_NAME by Pathnex"
    only:
        variables: 
            - $CI_ENVIRONMENT_NAME == "dev"