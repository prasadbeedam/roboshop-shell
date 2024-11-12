#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
MONGO_HOST=mongodb.anuprasad.online

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "Disabling current nodejs"

dnf module enable nodejs:20 -y &>> $LOGFILE
VALIDATE $? "Enabling nodejs:20"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "Installing NodeJS"

id roboshop &>> $LOGFILE
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "Adding roboshop user"
else
    echo -e "roboshop user already exist...$Y SKIPPING $N"
fi

rm -rf /app &>> $LOGFILE
VALIDATE $? "clean up existing directory"

mkdir -p /app &>> $LOGFILE
VALIDATE $? "Creating app directory"

cd /app &>> $LOGFILE
VALIDATE $? "Moving to app dir"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "download code"

unzip /tmp/catalogue.zip &>> $LOGFILE
VALIDATE $? "unzip code"

npm install  &>> $LOGFILE
VALIDATE $? "install dependencies"

cp /home/ec2-user/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "Demaon reload"

systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enable catalog"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "Start catalog"

cp /home/ec2-user/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copying mongodbrepo"

dnf install -y mongodb-mongosh &>> $LOGFILE

VALIDATE $? "install mysql

SCHEMA_EXISTS=$(mongosh --host $MONGO_HOST --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')") &>> $LOGFILE

if [ $SCHEMA_EXISTS -lt 0 ]
then
    echo "Schema does not exists ... LOADING"
    mongosh --host $MONGO_HOST </app/schema/catalogue.js &>> $LOGFILE
    VALIDATE $? "Loading catalogue data"
else
    echo -e "schema already exists... $Y SKIPPING $N"
fi