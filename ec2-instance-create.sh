#!/bin/bash

instances=("mongodb" "redis" "mysql" "rebbitmq" "catalog" "cart" "user" "shipping" "payment" "web")
domain_name="anuprasad.online"
hosted_zone_id="Z09535903HQQW5WY5LPXH"

for name in ${instances[@]}; do
    if [ $name == "shipping"] || [ $name == "mysql" ]
    then
       instances_type="t2.medium"
    else
       instances_type="t2.micro" 
    fi
    echo "Creating instance for: $name with instance type: $instance_type"
    instance_id=$(aws ec2 run-instances --image-id ami-041e2ea9402c46c32 --instance-type $instance_type --security-group-ids sg-0fea5e49e962e81c9 --subnet-id subnet-09863c54177764565 --query 'Instances[0].InstanceId' --output text)
    echo "Instance created for: $name" 
    
    aws ec2 create-tags --resources $instance_id --tags Key=Name,Value=$name

    