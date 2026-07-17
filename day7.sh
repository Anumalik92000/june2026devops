# Day 7-- speed typing 
## writting all code from scratch
## 1. Ansible: install nginx

---
- name: Install Nginx on Pathnex server
    hosts: all
    become: yes

    tasks: 
        - name: Install Nginx
        yum:
            name: nginx
            state: present


## 2. Terraform: EC2 (choose any Pathnex instance)

provider "aws" {
    region = "us-east-1"
    }

    resource "aws_instance" "PathnexEC2" {
        ami= "ami-0abcd1234abcd1234"
        instance_type = "c5.xlarge"

        tags = {
            Name= "Pathnex-EC2"
            }
    }

    ## 3. Kubernetes: Deployment 2 replicas

    apiVersion: apps/v1
    kind: Deployment

    metadata:
        name: pathnex-deployment
        spec:
            replicas:2
            selector:
                matchLabels:
                    app: pathnex-app
             templpate:
                matadata: 
                    labels:
                        app: pathnex-app
                    spec: 
                        containers:
                            - name: app
                            image: nginx
                            ports: 
                                - containerPort: 80


## 4. shell: Print date + uptime

    #!/bin/bash
    echo "Date: $(date)"
    echo "Uptime: $(uptime)"


## Parameterized Builds
## Jenkins pipeline-to create parameterized builds in jenkins

pipeline {
    agent any
    parameters {
    string(name: 'Environment', defaultValue: 'dev', description: 'Deployment Environment')
    }

    environment {
        INSTITUTE_NAME = "Pathnex"
    }

    stages{
        stage('Checkout')
       {
            steps{
             git url: 'https://github.com/Pathnex/sample-java-app.git'
            }
       }

       stage('Deploy'){
            steps {
            sh 'echo "Deploying to $ENVIRONMENT BY $INSTITUTE_NAME"'
            }
        }    
   }

}


##Gitlab CI- Parameterised via Variables


stage: 
    - deploy

variables:
INSTITUTE_NAME: "Pathnex"
ENVIRONMENT: "dev"

deploy:
    stage: deploy
    image: alpine: latest
    script:
        - echo "Deploying to $Environment by $ INSTITUTE_NAME"
        