create table periodic_data(
 id serial  primary key,
 period_type varchar(10) not null,
 start_date date,
 end_date date,
 salesman_fio varchar(200) not null,
 chif_fio varchar(200) not null,
 sales_count int,
 sales_sum int,
 max_overcharge_item varchar(500),
 max_overcharge_percent numeric(22,2)
)
