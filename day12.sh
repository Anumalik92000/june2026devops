# day 12- File Content, RDS Skeleton, Rolling updqte.,bqckup
## ansible - ensure File with content

---
- name: Create config file for Pathnex
    hosts: all
    become: Yes

    tasks:
        - name: Write content to file
        copy:
        dest:/etc/pathnex.conf
        content: |
            Welcome to Pathnex DevOps training
                Today is day 12

## Terraform - RDS Skeleton

resource "aws_db_instance" "PathnexRDS" {
    allocated_storage  = 20
    engine:           = "mysql"
    instance class = "db.t3.micro"  
    name = "pathnexdb"
    username = "admin"
    password = "password123"
    skip_final_snapshot = true                                   
}


## kubernetes - rolling udpate Strategy

apiVersion: apps/v1
kind: Deployment
metadata:
    name: pathnex-rolling
spec:
    replicas: 3
    strategy:
        type: RollingUpdate
        rollingUpdate:
            maxSurge:1
            maxUnavailable: 1
        selector:
            matchLables:
                app: roll
            template:
                metadata:
                    labels:
                        app: roll
                spec:
                    containers:
                        - name: web
                        image: nginx


## shell script- backup directory

#!/bin/bash
SOURCE = "/var/log"
DEST = "/backup/pathnex-$(date +%F).tar.gz"

tar -czf $DEST $SOURCE
echo "Backup created at : $DEST"


## Multi branch pipelines

## Jenkins pipeline - MULTI branch- how to handle multiple branches in jenkins pipelines

pipeline {
    agent any
    environment {
        INSTITUTE_NAME = "Pathnex"
    }
    stages {
        stage('Checkout') {
            steps{
                checkout scm
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }
    }
}

## GitLab CI- branch specific jobs- to learn how to run jobs for specific branches in GitLab CI

stages:
    - build

build-main:
    stage: build
    image: maven:3.8.1-jdk-17
    script:
        - mvn clean compile
    only:
        - main

build-dev:
    stage: build
    image: maven:3.8.1.-jdk-17
    script:
        - mvn clean compile
    only:
        - dev
    
