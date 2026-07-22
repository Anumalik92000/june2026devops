## fixing broken files

## Ansible

---
- name: Broken
    hosts: all
    tasks: 
        - name: Install nginx
          yum:
            name: nginx
            state: present

## Terraform

resource "aws_instance" "BadeEC2" {
    ami = "ami-0abcd1234abcd1234"
    instance_type = "c5.xlarge"
    tags = {
        Name = "Broken"
        }
}

## Kubernetes 

apiVersion: apps/v1
kind: Deployment
metadata:
    name: broken
    
spec: 
    replicas: 2
    selector:
        matchLabels: 
            app: broken
    template:
        metadata:
            lables: 
                app: broken
    spec: 
        containers:
            - name: app
              image: nginx

## Matrix builds

## jenkins pipeliine- Matrix Build-- to run same build on multiple environments

pipeline {
    agent any
    environment {
        INSTITUTE_NAME = "Pathnex"
    }
   stages{
    stages('Matrix Build') {
    matrix {
        axes {
            axis {
                name 'JAVA_VERSION'
                values '8','11','17'
            }
        }
            stages{
                 stage ('Build'){
                    steps {
                        sh 'echo Building with Java ${JAVA_VERSION}'
                        }
                    }
                }
            }
        }
    }
}

## GitLab CI - Matrix Jobs- to learn how to run jobs across multiple env using matrix

stages: 
    - build

build:
    stage: build
    image: maven:3.8.1-jdk-17
    parallel:
        matrix:
            - JAVA_VERSION: ['8'] 
            - JAVA_VERSION: ['11'] 
            - JAVA_VERSION: ['17']
            script:
                - echo " Buildiing with java $JAVA_VERSION"

