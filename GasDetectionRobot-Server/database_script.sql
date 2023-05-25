create database gas_detekt_db;

use gas_detekt_db;

show tables;

create table user (
	uuid varchar(36) primary key not null,
    username varchar(100),
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100),
    password varchar(100),
    avatar_url varchar(50),
    device_serial_number varchar(15),
    created_time datetime,
    modified_time datetime
);

create table device (
	serial_number varchar(15) primary key not null,
    model_name varchar(100),
    image_url varchar(50),
    device_status varchar(100),
    description text
);

create table room (
	room_id varchar(36) primary key not null,
    room_name varchar(100),
    owner_uuid varchar(36) not null,
    is_gas_detect boolean,
    room_status varchar(100),
    map2d_url varchar(50),
    created_time datetime,
    modified_time datetime
);

select * from user;
select * from device;
select * from room;

/* permission for root account */
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'qwerty123';
flush privileges;


/* add record to tables */
insert into user (uuid, username, password, device_serial_number)
values ('123e4567-e89b-12d3-a456-426655440000', 'hungnq', '123', 'RB23GT1708');


insert into device (serial_number, model_name, description)
values ('RB23GD1708', 'Gas detection robot', 'Using Raspberry Pi 3, Ultrasonic sensor, gas detect sensor');

insert into device (serial_number, model_name, description)
values ('RB23GD0002', 'Gas detection robot', 'Using Raspberry Pi 3, Ultrasonic sensor, gas detect sensor');


/* select querry */
select * from user where username='hungnq' and password='123';

SELECT * FROM user WHERE username = "hungnq";
SELECT * FROM user WHERE email = "hungnq@cdc.com";
SELECT * FROM device WHERE serial_number = "RB23GT1708";


select count(*) from user, device
where user.device_serial_number!='RB23GT1807' and device.serial_number='RB23GD1807';

SELECT COUNT(*) as count FROM user JOIN device 
ON user.device_serial_number!='RB23GT1708' AND device.serial_number='RB23GD1708';

SELECT COUNT(*) as count FROM user JOIN device 
ON user.device_serial_number!='RB23GT1807' AND device.serial_number='RB23GD1807';

Select * from device
where  device.serial_number='RB23GT1807' And not exists (
	select device_serial_number 
    from user
    where user.device_serial_number!='RB23GT1807');

SELECT COUNT(*) as count FROM user WHERE device_serial_number = "RB23GD1708";


