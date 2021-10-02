-- 1.a
select title
from course
where credits > 3;

-- 1.b
select room_number
from classroom
where building = 'Watson'
   or building = 'Packard';

--1.c
select *
from course
where dept_name = 'Comp. Sci.';

-- 1.d

select title
from course
where course_id in (select course_id
                    from takes
                    where semester = 'Fall')

--1.e
select name
from student
where tot_cred between 44 and 89

--1.f
select name
from student
where lower(name) like '%a'
   or lower(name) like '%e'
   or lower(name) like '%i'
   or lower(name) like '%o'
   or lower(name) like '%u';

--1.g

select title
from course
where course_id in (select course_id
                    from prereq
                    where prereq_id = 'CS-101');

--2.a

select dept_name, avg(salary)
from instructor
group by dept_name;

--2.b

select building, count(building) as cnt
from section
group by building
order by cnt desc
limit 1;

--2.c
select dept_name, count(course_id) as cnt
from course
group by dept_name
order by cnt
limit 1;

--2d
with cnt_takes_Comp as (
    select id, count(id) as cnt
    from takes
    where course_id in (select course_id
                        from course
                        where dept_name = 'Comp. Sci.') -- cnt takes and name taken com.sci
    group by id),
     id_st_more_3 as (
         select id
         from cnt_takes_Comp
         where cnt > 3
     ) -- extract where more than 3
select id, name
from student
where id in (select id from id_st_more_3);
-- select id, name

--2e

select name
from instructor
where dept_name = 'Biology'
   or dept_name = 'Philosophy'
   or dept_name = 'Music';

--2f

with teach_and_year as (
    select id, string_agg(year::text, ', ') as year_teach
    from teaches
    group by id
    order by year_teach) --extract unique id and teach year
select id
from teach_and_year
where ('{2017}'::text[] && string_to_array(year_teach, ', '))
  and not ('{2018}'::text[] && string_to_array(year_teach, ', '))
--select id where teaches 2017 and not 2018


--3.a

select name
from student
where id in (select distinct id
             from (select id
                   from takes
                   where (grade = 'A' or grade = '-A')
                     and course_id in (
                       select course_id
                       from course
                       where dept_name = 'Comp. Sci.' --select cool grade and deptname comp
                   )) as ti)
order by name;

--3.b
select i_id
from advisor
where s_id in (select distinct id
               from takes
               where grade = 'B-'
                  or grade = 'C+'
                  or grade = 'C'
                  or grade = 'C-'
                  or grade is null);

--3.c
select distinct dept_name
from course
    except
select distinct dept_name -- dept name with bad
from course
where course_id in (select distinct course_id
                    from takes
                    where grade = 'F' --course id with bad
                       or grade = 'C');

--3.d

select name
from instructor
where id in (select distinct id
from teaches                                                --select who dont give A
where( course_id, sec_id, semester, year) in (select course_id, sec_id, semester, year as pk
                                        from takes                                                 --select pk who dont give A
                                        where grade != 'A'));


--3.e
select distinct course_id
from section
where time_slot_id in (select distinct time_slot_id
                       from time_slot
                       where (end_hr || '.' || time_slot.end_min)::double precision < 13)