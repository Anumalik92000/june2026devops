# Day 19- Git deploy, RDS skeleton, ROlling Strategy, Ping check
## Ansible- Deploy App using Git

---
- name: Deploy app from Git for Pathnex
  hosts: all
  become: yes

  tasks: 
    - name: Install Git 
      yum:
        name: git
        state: present

    - name: Clone repository
      git:
        repo: "https://github.com/pathnex/app.git"
        dest: "/opt/pathnex-app"


## Terraform - RDS Skeleton (MySQL)

resources "aws_db_instance" "PathnexRDS" {
    allocated_storage = 20
    engine            = "mysql"
    instance_class    = "db.t3.micro"
    username          = "admin"
    password          = "Pathnex123"
    skip_final_snapshot = true
}


## Kubernetes - Deployment Rplling Update (Detailed)

apiVersion: apps/v1
kind: Deployment
metadata: 
    name: pathnex-rollout
spec:
    replicas: 3
    strategy:
        type: RollingUpdate
        rollingUpdate:
            maxSurge: 2
            maxUnavailable: 1
    selector:
        matchLabels:
            app: rollout
    template:
        metadata:
            labels:
                app: rollout
        spec:
            containers:
                - name: app
                  image: nginx


## Shell Script - check Internet Connectivity

#!/bin/bash

ping -c 2 google.com &> /dev/null

if [ $2 -eq 0 ]; then
    echo "Internet is available"
else
    echo "No Internet connection"
fi

# Approvals
## Jenkins Pipeline- Manual Approval - to learn how to pause pipeline untill manual approval

pipeline {
    agent any
    environment {
            INSTITUTE_NAME = "Pathnex"
    }
    stages {
        stage('Deploy') {
            steps{
                input message: "Approve deployment for $INSTITUTE_NAME?"
                sh 'echo "Deployment approved and executed!"'
            }
        }
    }
}


## GitLab CI- Manual Approval job - to learn how to use manual jobs in GItlab CI for approvals

stages:
    - deploy

variables:
    INSTITUTE_NAME: "Pathnex"

deploy:
    stage: deploy
    image: apline:latest
    script:
        - echo "Ready to deploy $INSTITUTE_NAME"
    when:manual