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
    own_device_sn varchar(15),
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

select * from device;

/* add record to tables */
insert into device (serial_number, model_name, description)
values ('RB23GT1708', 'Gas detection robot', 'Using Raspberry Pi 3, Ultrasonic sensor, gas detect sensor');

insert into device (serial_number, model_name, description)
values ('RB23GT1807', 'Gas detection robot', 'Using Raspberry Pi 3, Ultrasonic sensor, gas detect sensor');
