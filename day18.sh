# Day 18-- Facts , Variables, Affinity, log ARChiving
## ANsible - use Anisble facts

---
- name: Show system facts for Pathnex 
  hosts: all

  tasks: 
    - name: Print OS info
      debug:
        var: ansible_facts['os_family']

    -name: Print IP address
    debug:
        var: ansible_facts['default_ipv4']['address']


## Terraform- Variable, outputs,tfvars
#  variables.tf

variable "instance_type" {
    default = "c6a.12xlarge"
}

# output
output "Pathnex_ip" {
    value = aws_instance.PathnexServer.public_ip
}

## Kubernetes - Node Affinity

apiVersion: v1
kind: Pod
metaddata:
    name: pathnex-affinity
spec:
    affinity:
        nodeAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
                    - matchExpressions:
                        - key: disktype
                          operator: In
                          values:
                            -ssd
    containers:
        - name: web
          image: nginx


## Shell Script- Archive Log Files

#!/bin/bash

tar -czf /backup/pathnex-logs-$(date +%F).tar.gz /var/log/
echo "Logs archived."


## Rollback Simulation

## Jenkins Pipeline - Rollback on failure- to learn how to simulate rollback if deployment fails

pipeline {
    agent any
    environment{
        INSTITUTE_NAME = "Pathnex"
    }
    stages {
        stage('Deploy') {
            steps {
                script {
                    try {
                        sh 'echo "Deploying $INSTITUTE_NAME application..."'
                        sh 'exit 1'      //simulate failure
                    } catch (Exception e) {
                        echo "Deployment failed. Rolling back $INSTITUTE_NAME application..."
                    }
                }
            }
        }
    }
}


## Git lab CI- Rollback Simulation- to learn how to simulate roll back using after_script.

stages:
    - deploy

variables:
    INSTITUTE_NAME: "Pathnex"

deploy: 
    stage: deploy
    image: alpine: latest
    script:
        - echo "Deploying $INSTITUTE_NAME application..."
        - exit 1
    after_script:
        - echo "Deployment failed. Rolling back $INSTITUTE_NAME application..."
        