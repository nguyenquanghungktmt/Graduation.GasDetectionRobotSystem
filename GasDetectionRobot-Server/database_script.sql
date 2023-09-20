create database gas_detekt_db;

use gas_detekt_db;

SELECT version();

show tables;

create table user (
	uuid varchar(36) primary key not null,
    username varchar(100),
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100),
    password varchar(100),
    firebase_token varchar(200),
    avatar_url varchar(50),
    device_serial_number varchar(15),
    created_time datetime,
    modified_time datetime
);

create table device (
	serial_number varchar(15) primary key not null,
    model_id varchar(15),
    model_name varchar(100),
    image_url varchar(50),
    device_status varchar(100),
    description text,
    created_time datetime,
    modified_time datetime
);

create table room (
	room_id varchar(36) primary key not null,
    room_name varchar(100),
    owner_uuid varchar(36) not null,
    is_gas_detect smallint,
    room_status varchar(100),
    map2d_url varchar(50),
    created_time datetime,
    modified_time datetime
);

create table session (
	session_id varchar(36) primary key not null,
	user_uuid varchar(36) not null,
	room_id varchar(36) not null,
    firebase_token varchar(200),
	serial_number varchar(15) not null,
    created_time datetime,
    modified_time datetime
);

select * from user;
select * from device;
select * from room;
select * from session;

-- check mysql version --
select version();

/* permission for root account */
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'qwerty123';
flush privileges;

/* create new user*/
CREATE USER 'hungnq'@'localhost' IDENTIFIED BY 'HuyenAnh@123';
GRANT ALL PRIVILEGES ON * . * TO 'hungnq'@'localhost';
ALTER USER 'hungnq'@'localhost' IDENTIFIED WITH mysql_native_password BY 'HuyenAnh@123';
FLUSH PRIVILEGES;

/* add record to tables */
insert into user (uuid, username, password, device_serial_number)
values ('123e4567-e89b-12d3-a456-426655440000', 'hungnq', '123', 'RB23GT1708');


insert into device (serial_number, model_name, description)
values ('RB23GD1708', 'Gas detection robot', 'Using Raspberry Pi 3, Ultrasonic sensor, gas detect sensor');

insert into device (serial_number, model_name, description)
values ('RB23GD0002', 'Gas detection robot', 'Using Raspberry Pi 3, Ultrasonic sensor, gas detect sensor');

insert into room (room_id, room_name, owner_uuid, is_gas_detect, room_status, map2d_url)
values ('2', 'Room 2', 'b8950f09-50dc-4269-baea-6594e993e9a2', true, "Danger", null);

insert into room (room_id, room_name, owner_uuid, is_gas_detect, room_status, map2d_url)
values ('4', 'Living Room', 'b8950f09-50dc-4269-baea-6594e993e9a2', false, "Normal", null);

INSERT INTO room (room_id, room_name, owner_uuid, is_gas_detekt, rom_status, map2d_url, created_time, modified_time) 
VALUES (?, ?, ?, ?, ?, ?, ?, ?);

select * from room where owner_uuid='12c94f41-0c3c-4a1e-914c-212565d17695' ORDER BY created_time DESC;

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

/* edit: add field firebase_token to user */
ALTER TABLE user ADD firebase_token varchar(200) NOT NULL;

/* edit: add field firebase_token to session */
ALTER TABLE session ADD firebase_token varchar(200) NOT NULL;

/* edit: add field created_time, modified_time to device table */
ALTER TABLE device ADD created_time datetime;
ALTER TABLE device ADD modified_time datetime;
    
SELECT * FROM session ORDER BY created_time DESC LIMIT 1;

