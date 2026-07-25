# Day 14- Mini Project

## Terraform - Create EC2 (any instance type)
##- VPC,- Subnet,- Internet gateway,- Route table,EC2 (c5.xlarge / r5.2xlarge / r6i.4xlarge / c6i.8xlarge / c6a.12xlarge)


provider "aws" {
    region = "us-east-1"
}

## VPC

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "Day14-VPC"
    }
}

# Subnet

resource "aws_subnet" "Public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-eat-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "Day14-Subnet"
    }
}

## Internet Gateway

resource "aws_internet_gateway" "igw" {
    vpc_id = "aws_vpc.main.id"

    tags = {
        Name = "Day14-IGW"
    }
}

## Route Table

resource "aws_route_table" "public" {
    vpc_id = "aws_vpc.main.id"

    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "Day14- RouteTable"
    }
}

## associating route tablw with subnet

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

## EC2 instance

resource "aws_instance"  "web"{
    ami = "ami-0abcd1234abcd1234"
    instance_type = "c5.xlarge"
    subnet_id = aws_subnet.public.id
}

tags = {
Name = "Day14-EC2"
    }
}

## Ansible- install nginx & deploy HTML file

---
- name: Install Nginx and Deploy HTML
    hosts: all
    become: yes

  tasks:
    - name- Install Nginx
        yum:
            name: ngincx
            state: present

    - name: Start Nginx
        service:
            name : nginx
            state: started
            enabled: yes

    - name: Deploy HTML file
      copy: 
        dest: /usr/share/nginx/html/index.html

        content: 
            <html>
            <head>
            <title> Pathnex </title> 
            </head>
            <body>
            <h1> welcome to Pathnex DevOps </h1>
            </body>
            </html>


## kubernetes - deployment + service

apiVersion: apps/v1
kind: Deployment

metadata:
    name: nginx-deployment

spec:
    replicas: 2

    selector:
        matchLabels:
            app: nginx

    template:
        metadata:
            labels:
                app: nginx

        spec:
            containers:
                - name: nginx
                image: nginx
                ports:
                    - containerPort: 80

---
apiVersion: v1
kind: Service

metadata: 
    name: nginx-service
spec: 
    selector: 
        app: nginx

    ports:
        - port: 80
          targetPort: 80
    type: NodePort


## shell script- Print CPU, Memory & DIsk

#!/bin/bash

echo" CPU information"
lscpu

echo " Memory usage"
free -h

echo " Disk Usage"
df -h

# Scheduled Pipelines
## Jenkins Pipeline -scheduled build - to learn how to schedule a jenkin pipeline using cron job

pipeline{
    agent any
    environment{
        INSTITUTE_NAME = "Pathnex"
    }
    triggers {
        cron('H 2 * * *') //everyday at 2 am
    }
    stages{
        stage ('Checkout') {
            steps {
                git url: 'https://github.com/Pathnex/sample-java-app.git'
            }
        }
        stage ('Build') {
            steps {
            sh 'mvn clean package'
            }
        }
    }
}

## GitLab CI - Scheduled Pipeline - to learn how to schedule pipeline via cron in Gitlab CI

stages:
    - build

build:
    stage: build
    image: maven:3.8.1-jdk-17
    script:
        - git clone https://github.com/Pathnex/sample-java-app.git
        - cd sample-java-app
        - mvn clean package

