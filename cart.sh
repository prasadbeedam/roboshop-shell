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


curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip  &>>$LOGFILE

VALIDATE $? "Download code"

cd /app &>>$LOGFILE

VALIDATE $? "Changing dir"

unzip /tmp/cart.zip  &>>$LOGFILE

VALIDATE $? "unziping the file"

cd /app &>>$LOGFILE

VALIDATE $? "Changing the dir"

npm install  &>>$LOGFILE

VALIATE $? "Installig dependencies"

cp /home/ec2-user/roboshop-shell/cart.service /etc/systemd/system/cart.service &>>$LOGFILE

VALIDATE $? "Coping the service file"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "Daemon reload"

systemctl enable cart &>>$LOGFILE

VALIDATE $? "service enble"

systemctl start cart &>>$LOGFILE

VALIDATE $? "Starting the cart service"
