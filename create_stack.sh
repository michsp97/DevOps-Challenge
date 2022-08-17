#!/bin/bash
# Author: Michelle Sanchez
# Description: Script to deploy CloudFormation stack
# Example: create_stack.sh --name cf-example

stack_name="Testing"
kp_value="MyKP-1"
dbpass="Test1234"

# Make sure to clean the stack in case it already exists
echo "Checking if stack already exists"
stack_exists=$(aws cloudformation describe-stacks --stack-name ${stack_name})
if [ $? -eq 0 ]; then
  echo "Stack exists, updating CloudFormation stack"
  aws cloudformation update-stack --stack-name ${stack_name} --template-body file://infrastructure.yaml \
  --parameters ParameterKey=KeyPairName,ParameterValue=${kp_value} \
  ParameterKey=DBPassword,ParameterValue=${dbpass}
  aws cloudformation wait stack-update-complete --stack-name ${stack_name}
  if [ $? -ne 0 ]; then
    echo "There was an error while updating CloudFormation stack"
    exit 1
  else
    echo "CloudFormation stack updated!"
  fi
else
  echo "Creating new CloudFormation stack"
  aws cloudformation create-stack --stack-name ${stack_name} --template-body file://infrastructure.yaml \
  --parameters ParameterKey=KeyPairName,ParameterValue=${kp_value} \
  ParameterKey=DBPassword,ParameterValue=${dbpass}
  aws cloudformation wait stack-create-complete --stack-name ${stack_name}

  if [ $? -ne 0 ]; then
    echo "There was an error while deploying CloudFormation stack"
    exit 1
  else
    echo "CloudFormation stack deployed!"
  fi
fi



