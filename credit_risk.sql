create database Porject2;

use Project2;

create table credit_risk (Customer_ID int primary key, 
Age int, Sex varchar(100), Job int,
Housing varchar(100), Saving_Account varchar(100), Checking_Account varchar(100),
Credit_Amount int, Duration int, Purpose varchar (100), Risk varchar(100),
Credit_Band varchar(100), Age_Band varchar(100) ,Duration_Band varchar(100), Risk_Flag int);

select * from credit_risk;