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

dnf install nginx -y &>> $LOGFILE
VALIDATE $? "INSTALL NGINX"

systemctl enable nginx &>> $LOGFILE
VALIDATE $? "ENABLE VERSION"

systemctl start nginx &>> $LOGFILE
VALIDATE $? "START NGINX"


rm -rf /usr/share/nginx/html/* &>> $LOGFILE
VALIDATE $? "Remove all existing files"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE
VALIDATE $? "download code"

cd /usr/share/nginx/html &>> $LOGFILE
VALIDATE $? "moving in to the file"

unzip /tmp/web.zip &>> $LOGFILE
VALIDATE $? "unzip the file"

cp /home/ec2-user/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE
VALIDATE $? "copy file"

systemctl restart nginx &>> $LOGFILE
VALIDATE $? "restart nginx"



