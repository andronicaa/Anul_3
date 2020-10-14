-- 3
-- Apartenenta la o lista finita de valori se poate testa cu operatorul IN
select last_name, first_name, department_id
from employees
where department_id in (10, 30);
-- 4. Data curenta
select sysdate
from dual;

-- 5
select first_name, hire_date
from employees
where to_char(hire_date, 'YYYY') = 1987;

select first_name, hire_date
from employees
where hire_date like '%87';

--6
select first_name, last_name, job_id
from employees
where manager_id is null;

-- 7
select first_name, salary, commission_pct
from employees
order by salary desc, commission_pct desc;

-- 9. A treia litera din nume sa fie A
select first_name
from employees
where upper(first_name) like '__A%';

-- 10
select last_name, department_id, manager_id
from employees
where (upper(first_name) like '%L%L%' and department_id = 30) or manager_id = 102;

-- 11 
select last_name, job_id, salary
from employees
where upper(job_id) like '%CLERK%' or upper(job_id) like '%REP%' and salary not in (1000, 2000, 3000);

-- 12
select last_name, department_name
from employees e, departments d
where e.department_id = d.department_id(+);

-- 13
select last_name, department_name
from employees e, departments d
where e.department_id(+) = d.department_id;

-- 14 ii afiseaza si pe ce care nu au sef
select e1.employee_id, e1.last_name, e1.manager_id, e2.last_name
from employees e1, employees e2
where e1.manager_id = e2.employee_id(+);


select employee_id, last_name, manager_id, (select last_name
                                            from employees
                                            where employee_id = e.manager_id) sefu
from employees e;

-- 16
-- a
select department_id
from departments
minus
select distinct department_id
from employees;

-- b
select department_id
from departments d
where (select count(employee_id)
       from employees
       where d.department_id = department_id) = 0;
       
-- c
select department_id
from departments
where department_id not in (select d.department_id
                            from departments d, employees e
                            where d.department_id = e.department_id);
                            
-- d
select department_id
from departments
where department_id not in (select department_id
                            from employees
                            where department_id is not null);
                            
-- e
select d.department_id, department_name
from departments d
where not exists(select 1
                 from employees e
                 where e.department_id = d.department_id)
order by department_id;


-- 17
select max(salary), min(salary), round(avg(salary), 2)
from employees;

-- 18
select max(salary), min(salary), round(avg(salary), 2)
from employees
group by job_id;

-- 19
select count(*), job_id
from employees
group by job_id;

-- 20
select department_name, city, count(employee_id) Nr_Angajati, round(avg(salary), 2) Sal_Mediu
from employees e, departments d, locations l
where e.department_id = d.department_id and d.location_id = l.location_id
group by department_name, city;

-- 21
select employee_id, last_name, salary
from employees
where salary > (select round(avg(salary), 2) from employees)
order by salary;

-- 22
select min(Sal_Mediu) "Salariu Mediu Minim"
from (select job_id, avg(salary) Sal_Mediu
      from employees
      group by job_id);
      
-- 23
with salarii_medii as
    (select job_id, avg(salary) Sal_Mediu
     from employees
     group by job_id
     order by Sal_Mediu 
    )
select job_id, sal_mediu
from salarii_medii
where rownum = 1;


-- 24
-- a
with informatii_departamente as
        (select d.department_id, department_name, count(1) Nr_Angajati
         from employees e, departments d
         where e.department_id = d.department_id
         group by d.department_id, department_name)
select *
from informatii_departamente
where Nr_Angajati < 4
order by Nr_Angajati;

-- b
with informatii_departamente as
        (select d.department_id, department_name, count(1) Nr_Angajati
         from employees e, departments d
         where e.department_id = d.department_id
         group by d.department_id, department_name)
select *
from informatii_departamente
where Nr_Angajati = (select max(Nr_Angajati) from informatii_departamente);


-- 25
select department_id, count(1) Nr_Angajati
from employees
group by department_id
having count(1) >= 15;

-- 26
with angajati_pe_zi as
        (select hire_date, count(1) Angajati_Zi
         from employees
         group by hire_date)
select last_name, hire_date
from employees
where hire_date = (select hire_date
                   from angajati_pe_zi
                   where Angajati_zi = (select max(Angajati_Zi)
                                        from angajati_pe_zi));
                                        
-- 27

with salarii_minime as 
        (select department_id, min(salary) Salariu_minim
         from employees
         group by department_id)
select last_name, e.department_id, salary
from employees e, salarii_minime sal
where e.salary = sal.Salariu_minim and e.department_id is not null;

-- 28
with afisare_salarii as
        (select *
         from employees
         order by salary desc)
select last_name, first_name, salary
from afisare_salarii
where rownum <= 10;

-- 29
select e.department_id, department_name, sum(salary) Suma_Sal
from employees e, departments d
where e.department_id = d.department_id
group by e.department_id, department_name
order by Suma_Sal desc;


-- 30
with salarii_medii as
        (select department_id, round(avg(salary), 2) Salariu_Mediu
         from employees
         group by department_id)
select last_name, e.department_id, e.salary
from employees e, salarii_medii sm
where e.department_id = sm.department_id and e.salary >= sm.Salariu_Mediu;

-- 31
with salariu_minim as
        (select department_id, min(salary) Salariu_Minim
         from employees
         group by department_id)
select last_name, first_name, salary
from employees e, salariu_minim smin
where e.department_id= smin.department_id and salary = smin.Salariu_Minim;