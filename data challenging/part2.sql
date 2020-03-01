#####################  Part 2 #####################


####################### Question 1 ############################
-- create table users
-- (
-- 	user_id int,
--     created_at date
-- );

-- create table exercises
-- ( 
--     exercise_id int, 
-- 	user_id int,
-- 	exercise_completion_date date
--    );


-- insert into users
-- values (1, '2019-05-07'), (2, '2019-04-28'), (3,'2019-5-11'), (4, '2019-5-2'), (5,'2019-6-16'),(6,'2019-5-30'),  (7, '2019-6-1'),(8, '2019-1-5'),(9,'2019-1-28');

-- insert into exercises
-- values (1, 1,  '2019-05-27'), (1, 2, '2019-04-29'),  (3,3, '2019-8-11'), (42, 2,  '2019-5-20'), (5,5, '2019-6-19'),(6,6,'2019-10-30'),  (7,7, '2019-8-1'),(8,8,  '2019-1-25'),(9,9,'2019-1-29'), (2 , 1,  '2019-06-27'),  (2, 2, '2019-04-30');


select 
	month(created_a0) as mon, 
    count(*) as user_count 
from (
		select 
			users.user_id, 
            min(created_at) as created_a0, 
            min(exercise_completion_date) as first_completion 
		from 
			users 
	    left join 
			exercises 
		on 
			users.user_id = exercises.user_id
		group by 
			user_id
		) 
        table1
group by 
	month(created_a0)
order by 
	month(created_a0)
    ;


####################### Question 2 ############################

-- create table Providers
-- (
-- 	provider_id int,
--     organization_id int,
-- 	organization_name varchar(20)
-- );

-- create table Phq9
-- (
-- 	patient_id int,
-- 	provider_id int,
--     score int, 
--     datetime_created date
-- );


select distinct 
	Providers.organization_id,  
    Providers.organization_name, 
    avg_score 
from 
	Providers
join (
		select 
			organization_id, 
			avg(score) as avg_score 
		from 
			Providers 
		left join 
			Phq9
		on 
        Providers.provider_id = Phq9.provider_id
		group by  
        organization_id
        ) table1
on 
	Providers.organization_id = table1.organization_id
order by
	avg_score desc
limit 5
;




