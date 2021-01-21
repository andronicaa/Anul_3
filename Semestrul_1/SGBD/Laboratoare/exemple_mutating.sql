--1. Your new salary cannot be more than 25x the lowest salary in the company. 
--Your salary will be automatically set to the maximum allowed, 
--if this rule is broken.
-- BAD!
create or replace trigger equitable_salary_trg
after insert or update on employees
for each row
declare
    l_max_allowed employees.salary%type;
begin
    select min(salary) * 25 into l_max_allowed
    from employees;
    
    if l_max_allowed < :new.salary then
        update employees
        set salary = l_max_allowed
        where employee_id = :new.employee_id;
    end if;
end;

update employees
set salary = 100000
where last_name = 'King';

-- GOOD!
create or replace package equitable_salary_pkg is
