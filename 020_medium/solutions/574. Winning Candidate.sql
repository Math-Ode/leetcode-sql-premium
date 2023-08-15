-- Table Structure:
drop table if exists Vote;
drop table if exists Candidate;

create table Candidate (
    id int primary key,
    name varchar(50)
);

create table Vote (
    id int auto_increment,
    candidateId int,
    foreign key (candidateId) references Candidate(id)
);

-- Insert Query:
insert into Candidate values (1, 'A');
insert into Candidate values (2, 'B');
insert into Candidate values (3, 'C');
insert into Candidate values (4, 'D');
insert into Candidate values (5, 'E');

insert into Vote values (1, 2);
insert into Vote values (2, 4);
insert into Vote values (3, 3);
insert into Vote values (4, 2);
insert into Vote values (5, 5);

-- MySQL Solution:
with
cte_candidate_vote as (
    select
        candidateId,
        count(id) as vote_cnt
    from Vote
    group by candidateId
)

select
    name
from
    cte_candidate_vote vote
left join
    Candidate candidate
    on candidate.id = vote.candidateId
order by vote_cnt desc
limit 1
