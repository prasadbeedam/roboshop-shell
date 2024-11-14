#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGO_HOST=mongodb.anuprasad.online

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi

dnf module disable nodejs -y &>>$LOGFILE

VALIDATE $? "disabled defult nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE

VALIDATE $? ""Enabled nodejs20 version"

dnf install nodejs -y &>>$LOGFILE

VALIDATE $? "Install Nodejs"

useradd roboshop &>>$LOGFILE

VALIDATE $? "Adding user"


mkdir /app   &>>$LOGFILE

VALIDATE $? "creating directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOGFILE

VALIDATE $? "Download code"

cd /app &>>$LOGFILE

VALIDATE $? "Changing the dir"

unzip /tmp/user.zip  &>>$LOGFILE

VALIDATE $? "Unzip code"

cd /app &>>$LOGFILE

VALIDATE $? "Changing Dir"

npm install &>>$LOGFILE

VALIDATE $? "Install dependencies"

cp /home/ec2-user/roboshop-shell/user.service /etc/systemd/system/user.service &>>$LOGFILE

VALIDATE $? "Copy the service file"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "Daemon reload"

systemctl enable user  &>>$LOGFILE

VALIDATE $? "Enable user "

systemctl start user &>>$LOGFILE

VALIDATE $? "Start user service"


 
