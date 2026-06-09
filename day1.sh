#day1- basics
## Ansible task - install Nginx on Pathnex server

YAML
--- 
- name: Install Nginx on Pathnex server
hosts: all
become: yes

tasks:
    - name: Install nginx
      yum:
        name:nginx
        state: present

## Terraform Task - create EC2(c5.xlarge)
 provider "aws" {
 region = "us-east-1"
 }

 resource "aws_instance" "PathnexEC2"{
 ami = "ami-0abcd1234abcd1234"
 instance_type = "c5.xlarge"

 tags = {
 Name = "Pathnex-EC2"
   }
 }

 ##Kubernetes task- create Nginx pod

 apiVersion: v1
 kind: Pod
 metadata:
    name: pathnex-pod
  spec:
    containers:
        - name: web
        image: nginx:latest
        ports:
           - containerPort: 80


## Shell scripts- Print Date & hostname

#!/bin/bash
echo "Date: $(date)"
echo "Hostname: $(hostname)"

#Git Integration
## jenkins pipeline- checkout Git- to learn how to **checkout git repository** and list files

pipeline{
    agent any
        stage('Checkout')
            steps {
                git branch: 'main', url: 'https://github.com/Pathnex/sample-java-app.git'
            }
        }
    stage('List Files') {
        steps{
            sh 'ls - la'
        }
      }
     }
    }
    
## Gitlab CI- checkout git - to learn how to checkout git repository in gitlab CI

stages:
    - checkout

git-checkout:
    stage: checkout
    script: 
        - git clone https://github.com/Pathnex/sample-java-app.git
        - cd sample-java-app
        - ls - la


