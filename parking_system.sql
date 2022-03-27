create schema parking_system;
use parking_system;

set sql_safe_updates=0;

create table parking_lot(id int not null auto_increment primary key,
num_of_blocks int, parking_name varchar(20), address varchar(100),
zip varchar(10), valet_parking varchar(1), reentry varchar(1));

insert into parking_lot(num_of_blocks, parking_name, address, zip, valet_parking, reentry)
values(2, 'safe avenue','hazratganj','226001','y','y'),
(2, 'safe zone','hazratganj','226001','y','y');
select * from parking_lot;

create table blocks(id int not null auto_increment,
parking_lot_id int not null, block_code varchar(1),
num_of_floors int not null,
primary key(id),
foreign key(parking_lot_id) REFERENCES parking_lot(id));

insert into blocks(parking_lot_id, block_code, num_of_floors)
values(1, 'a',2),(1, 'b',2),(2, 'a',2),(2, 'b',2);

select * from blocks;

create table floors(id int not null auto_increment,
block_id int not null, floor_num varchar(5), num_of_wings int,
primary key(id),
foreign key(block_id) REFERENCES blocks(id));

insert into floors(block_id,floor_num, num_of_wings)
values(1,'1st',2),(1,'2nd',2),(2,'1st',2),(2,'2nd',2),(3,'1st',2),
(3,'2nd',2),(4,'1st',2),(4,'2nd',2);

select * from floors;

create table wings(id int not null auto_increment,
floor_id int not null, wing_code varchar(1),
num_of_slots int,
primary key(id),
foreign key(floor_id) REFERENCES floors(id));


insert into wings(floor_id, wing_code, num_of_slots)
values(1,'x',3),(1,'y',3),(2,'x',3),(2,'y',3),(3,'x',3),(3,'y',3),(4,'x',3),(4,'y',3),
(5,'x',3),(5,'y',3),(6,'x',3),(6,'y',3),(7,'x',3),(7,'y',3),(8,'x',3),(8,'y',3);

create table slots(id int not null auto_increment,
wing_id int not null, slot_code varchar(3),
primary key(id),
foreign key(wing_id) REFERENCES wings(id));

select * from wings;
select * from floors;
insert into slots(wing_id,slot_code)
values(1,'xa'),(1,'xb'),(1,'xc'),(2,'ya'),(2,'yb'),(2,'yc'),(3,'xa'),(3,'xb'),(3,'xc'),(4,'ya'),
(4,'yb'),(4,'yc'),(5,'xa'),(5,'xb'),(5,'xc'),(6,'ya'),(6,'yb'),(6,'yc'),(7,'xa'),(7,'xb'),(7,'xc'),
(8,'ya'),(8,'yb'),(8,'yc'),(9,'xa'),(9,'xb'),(9,'xc'),(10,'ya'),(10,'yb'),(10,'yc'),
(11,'xa'),(11,'xb'),(11,'xc'),(12,'ya'),(12,'yb'),(12,'yc'),
(13,'xa'),(13,'xb'),(13,'xc'),(14,'ya'),(14,'yb'),(14,'yc'),
(15,'xa'),(15,'xb'),(15,'xc'),(16,'ya'),(16,'yb'),(16,'yc');

select * from slots;

create table parking_info as
select p.id parking_lot_id,p.parking_name, b.id block_id, b.block_code,
f.id floor_id, f.floor_num,w.id wing_id, w.wing_code, s.id slot_id, s.slot_code
from parking_lot p
join blocks b on p.id=b.parking_lot_id join floors f on b.id= f.block_id
join wings w on f.id= w.floor_id join slots s on w.id= s.wing_id;

select * from parking_info;

create table customers(id int not null primary key,
cus_name varchar(20), age int CHECK(age>=18),
city varchar(10), mobile_num varchar(15));


create table vehicles(id int not null auto_increment,
cus_id int not null,
vehicle_name varchar(20), vehicle_colour varchar(20),vehicle_num varchar(20),
arrival_datetime DATETIME,departure_datetime DATETIME,
primary key(id),
foreign key(cus_id) references customers(id));



create table parking_slip(id int not null auto_increment primary key,
cus_id int not null, parking_lot_id int not null,
block_code varchar(1), floor_num varchar(3),
wing_code varchar(1), slot_code varchar(3),
cus_name varchar(20), age int CHECK(age>=18),
city varchar(10), mobile_num varchar(15), vehicle_name varchar(20),
vehicle_colour varchar(20),vehicle_num varchar(20),
arrival_datetime DATETIME);


select * from parking_slip;


DELIMITER //
CREATE PROCEDURE getcustomerandvehicleinfo(
cus_id int, parking_lot_id int,
block_code varchar(1), floor_num varchar(3),
wing_code varchar(1), slot_code varchar(3),
cus_name varchar(20), age int,
city varchar(10), mobile_num varchar(15), vehicle_name varchar(20),
vehicle_colour varchar(20),vehicle_num varchar(20),
arrival_datetime DATETIME)
BEGIN
START TRANSACTION;
INSERT INTO customers(id,cus_name, age,
city, mobile_num) 
VALUES(cus_id, cus_name, age,
city, mobile_num);

INSERT INTO vehicles(cus_id ,vehicle_name,
vehicle_colour,vehicle_num ,
arrival_datetime)
VALUES(cus_id,vehicle_name,
vehicle_colour,vehicle_num ,
arrival_datetime);

insert into parking_slip(cus_id, parking_lot_id,block_code, floor_num,wing_code, slot_code,
cus_name, age,city, mobile_num, vehicle_name,vehicle_colour,vehicle_num,
arrival_datetime)
values(cus_id, parking_lot_id,block_code, floor_num,wing_code, slot_code,
cus_name, age,city, mobile_num, vehicle_name,vehicle_colour,vehicle_num,
arrival_datetime);
COMMIT;
END//
DELIMITER ;

CALL getcustomerandvehicleinfo(1, 1, 1, 1, 1, 1, 'manav', 24, 'lucknow', '9856748833', 'maruti swift desire', 'white',
'up328888', '2022-01-03 12:00:00');
CALL getcustomerandvehicleinfo(2, 1, 2, 2, 1, 1, 'jhanvi', 25, 'varanasi', '9234558833', 'maruti baleno', 'blue',
'up652222', '2022-01-03 11:00:00');
CALL getcustomerandvehicleinfo(3, 1, 3, 3, 1, 10, 'rakesh', 28, 'lucknow', '9944748833', 'maruti ertiga', 'grey',
'up323344', '2022-02-03 13:00:00');
CALL getcustomerandvehicleinfo(4, 1, 4, 4, 1, 15, 'saurav', 30, 'lucknow', '9122748800', 'maruti wagonr', 'white',
'up325656', '2022-02-03 12:00:00');
CALL getcustomerandvehicleinfo(5, 2, 1, 1, 2, 5, 'amit', 24, 'kanpur', '8656748899', 'maruti celerio', 'black',
'up788769', '2022-03-03 10:00:00');
CALL getcustomerandvehicleinfo(6, 2, 1, 1, 2, 3, 'raman', 38, 'kanpur', '8856741122', 'maruti brezza', 'brown',
'up782342', '2022-04-03 09:00:00');
CALL getcustomerandvehicleinfo(7, 2, 2, 2, 2, 12, 'sameer', 41, 'lucknow', '8856744567', 'maruti ciaz', 'black',
'up321212', '2022-04-03 12:00:00');
CALL getcustomerandvehicleinfo(8, 2, 3, 3, 2, 9, 'subodh', 20, 'lucknow', '7256748000', 'maruti ignis', 'red',
'up328906', '2022-03-03 14:00:00');
CALL getcustomerandvehicleinfo(9, 2, 2, 2, 2, 7, 'shalini', 27, 'varanasi', '7356745555', 'maruti swift desire', 'white',
'up654378', '2022-02-03 12:00:00');
CALL getcustomerandvehicleinfo(10, 2, 4, 4, 2, 16, 'riya', 22, 'lucknow', '8656742233', 'maruti s-cross', 'blue',
'up328830', '2022-03-03 12:00:00');
CALL getcustomerandvehicleinfo(11, 1, 4, 4, 1, 8, 'pradeep', 35, 'lucknow', '7256748493', 'maruti jimny', 'yellow',
'up328378', '2022-01-03 12:00:00');
drop procedure getcustomerandvehicleinfo;


select * from customers;
select * from vehicles;
select * from parking_slip;
select * from slots;
select * from wings;
select * from floors;
select * from blocks;
select * from parking_lot;







