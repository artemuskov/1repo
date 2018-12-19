#!/bin/bash

aws cloudformation create-stack --region us-east-1 --stack-name artem-deploy --template-body file://jenkins.yaml