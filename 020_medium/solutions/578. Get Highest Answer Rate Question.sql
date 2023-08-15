-- Table Structure:
drop table if exists surveylog;
create table surveylog (
	id int,
  	action varchar(10),
  	question_id int,
  	answer_id int,
  	q_num int,
  	timestamp int
);

-- Insert Query:
insert into surveylog values (5, 'show', 285, null , 1, 123);
insert into surveylog values (5, 'answer', 285, 124124, 1, 124);
insert into surveylog values (5, 'show', 369, null, 2, 125);
insert into surveylog values (5, 'skip', 369, null, 2, 126);

-- MySQL Solution:
with cte_log as (
	select
  		question_id,
  		sum(case when action='answer' then 1 end) / 
        sum(case when action='show' then 1 end) as answer_rate
  	from surveylog
  	group by question_id
)

select
    question_id as survey_log
from cte_log
order by answer_rate desc, question_id
limit 1;
