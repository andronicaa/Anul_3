-- 3
create table emp_job_aan (cod_job varchar2(20),
                          sal number);
insert into emp_job_aan
values ('SA_MAN', 50000);
insert into emp_job_aan
values ('AD_PRES', 20000);
rollback;
select * from emp_job_aan;
create or replace trigger sal_trig
    before insert or update of sal on emp_job_aan
    for each row
begin
    if :new.cod_job not in ('AD_PRES', 'AD_VP') and :new.sal > 15000 then
        raise_application_error(-20002, 'Angajatul nu poate avea acest salariu');
    end if;
end;

drop trigger sal_trig;

-- 5
select * from emp_aan
where job_id = 'SA_REP';

create or replace trigger trig5
    before insert or update of salary on emp_aan
    for each row 
    when (new.job_id = 'SA_REP')
begin
    if inserting then
        :new.commission_pct := 0;
    elsif :old.commission_pct is null then
        :new.commission_pct := 0;
    else
        :new.commission_pct := :old.commission_pct * (:new.salary / :old.salary);
    end if;
end;


-- 7
create table copie_emp_aan as select * from emp_aan;
create or replace trigger check_sal_aan
    before insert or update of salary, job_id on emp_aan
    for each row
    when (new.job_id <> 'AD_PRES')
declare
    v_min employees.salary%type;
    v_max employees.salary%type;
begin
    -- determinam valorile pentru v_min, v_max
    select min(salary), max(salary) into v_min, v_max
    from copie_emp_aan
    where job_id = :new.job_id;
    if :new.salary < v_min or :new.salary > v_max then
        raise_application_error(-20505, 'Valorile se afla in afara domeniului');
    end if;
end;

select * from emp_aan;
update emp_aan
set salary = 3500
where last_name = 'Stiles';

select job_id 
from emp_aan
where last_name = 'Stiles';

-- 8
select * from dept_aan;
alter table dept_aan
add (total_sal number);

update dept_aan
set total_sal = (select sum(salary)
                 from emp_aan
                 where emp_aan.department_id = dept_aan.department_id);

-- trigger care permite actualizarea automata a acestui camp




-- Exercitiul 1
select * from emp_aan;
create or replace trigger trig1_aan
    before insert or update or delete on emp_aan
begin
    if to_char(sysdate, 'D') = 1 or to_char(sysdate, 'hh24') not between 8 and 9 then
        raise_application_error(-20001, 'tabelul nu poate fi actualizat');
    end if;
end;
rollback;
delete from emp_aan where employee_id < 102;
drop trigger trig1_aan;
-- 2
-- varianta 1
create or replace trigger trig21_aan
    before update of salary on emp_aan
    for each row
begin
    if :new.salary < :old.salary then
        raise_application_error(-20002, 'Salariul nu poate fi micsorat');
    end if;
end;
/
update emp_aan
set salary = salary - 100;
drop trigger trig21_aan;
-- varianta 2
create or replace trigger trig22_aan
    before update of salary on emp_aan
    for each row
    when (new.salary < old.salary)
begin
    raise_application_error(-20002, 'Salariul nu poate fi miscosat');
end;
/
update emp_aan
set salary = salary + 100;
drop trigger trig22_aan;

-- 3
create table job_grades_aan as select * from job_grades;

create or replace trigger trig3_aan
    before update of lowest_sal, highest_sal on job_grades_aan
    for each row
declare
    v_min_sal emp_aan.salary%type;
    v_max_sal emp_aan.salary%type;
    exceptie exception;
begin
    select min(salary), max(salary)
    into v_min_sal, v_max_sal
    from emp_aan;
    if :old.grade_level = 1 and v_min_sal < :new.lowest_sal then
        raise exceptie;
    end if;
    
    if :old.grade_level = 7 and v_max_sal > :new.highest_sal then
        raise exceptie;
    end if;
exception
    when exceptie then
        raise_application_error(-20003, 'Exista salarii care se gasesc in afara intervalului');
end;

update job_grades_aan
set lowest_sal = 3000
where grade_level = 1;

update job_grades_aan
set highest_sal  = 20000
where grade_level = 7;


-- 4
create table info_dept_aan (cod_dept number,
                            nume_dept varchar2(20),
                            plati number);
                            
create or replace procedure modific_plati_aan (v_cod info_dept_aan.cod_dept%type,
                                               v_plati info_dept_aan.plati%type) as
begin
    update info_dept_aan
    set plati = nvl(plati, 0) + v_plati
    where cod_dept = v_cod;
end modific_plati_aan;


-- adaug informatii in coloana plati
insert into info_dept_aan
select d.department_id, department_name, nvl(sum(salary), 0)
from employees e, departments d
where e.department_id(+) = d.department_id
group by d.department_id, department_name;
rollback;
select * from info_dept_aan;
create or replace trigger trig4_aan
    after delete or update or insert of salary on emp_aan
    for each row
begin
    if deleting then
        modific_plati_aan(:old.department_id, -1 * :old.salary);
    elsif updating then
        -- adaug diferenta
        modific_plati_aan(:old.department_id, :new.salary - :old.salary);
    else
        -- pentru un id nou => trebuie sa se actualizeze si suma salariilor
        modific_plati_aan(:new.department_id, :new.salary);
    end if;
end;

select * from info_dept_aan where cod_dept = 90;


-- EXERCITII
-- 2
CREATE OR REPLACE TRIGGER trig_comision_mrz
BEFORE UPDATE OF commission_pct ON emp_mrz
FOR EACH ROW
BEGIN
    IF (:NEW.commission_pct > 0.5) THEN
        RAISE_APPLICATION_ERROR(-20202,'Comision prea mare');
    END IF;
END;
/

-- 3
select * from info_dept_aan;
alter table info_dept_aan
add (numar number);
select * from employees;
select department_id, count(*)
from employees
where department_id =100
group by department_id;


update info_dept_aan
set numar = (select count(*)
             from emp_aan e, dept_aan d
             where d.department_id = e.department_id
             group by d.department_id);
