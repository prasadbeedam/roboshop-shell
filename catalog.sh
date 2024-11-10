#!/bin/bash

ID=$( id -u )

VALIDATE (){
    if [ $1 ne 0 ]
    than
       echo  "$2 ... Failed"
       exit 1
    else
       echo  "$2 .. Success"
    fi   
}

if [ $ID -ne 0 ]
than
  echo  "Please run this script with root user"
  exit 1
else
  echo "you the super user"
fi 

dnf module disable nodejs -y

dnf module enable nodejs -y

dnf install nodejs -y 

user add roboshop

mkdir /app

cd /app

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip

cd /app

unzip /tmp/catalogue.zip

cd /app

npm install 