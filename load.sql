CREATE TABLE location (
	id serial PRIMARY KEY,
	latitude NUMERIC,
	longitude NUMERIC,
	time TIMESTAMPTZ,
	license VARCHAR(25) NOT NULL,
	model VARCHAR(25) NOT NULL,
	engine_number VARCHAR(25) NOT NULL,
	chasis_number VARCHAR(25) NOT NULL
);
\COPY location(latitude,longitude,time,license,model,engine_number,chasis_number) FROM 'sql_test_data1 .csv' DELIMITER ',' CSV HEADER;
\COPY location(latitude,longitude,license,time,model,engine_number,chasis_number) FROM 'sql_test_data2.csv' DELIMITER ',' CSV HEADER;
 
create table vehicle as select distinct license,model,engine_number,chasis_number from location;
alter table vehicle add column id serial PRIMARY KEY;
alter table vehicle add constraint uniq_constraint UNIQUE (license,engine_number,chasis_number);
UPDATE location set license = (select id from vehicle where vehicle.license=location.license);
alter table location rename column license to vehicle_id;
alter table location drop column engine_number, drop column chasis_number,drop column model;
alter table location alter column vehicle_id TYPE INT using vehicle_id::integer;
ALTER table location ADD CONSTRAINT constraint_fk FOREIGN KEY (vehicle_id) REFERENCES vehicle (id);
