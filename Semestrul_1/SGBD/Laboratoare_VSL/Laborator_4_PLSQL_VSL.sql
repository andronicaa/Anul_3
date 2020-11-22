-- proceduri locale
-- 1
alter table dept_aan
drop column info;
declare
    procedure add_dept (p_cod dept_aan.department_id%type,
                        p_nume dept_aan.department_name%type,
                        p_manager dept_aan.manager_id%type,
                        p_location dept_aan.location_id%type
                        ) is
        begin
            insert into dept_aan
            values (p_cod, p_nume, p_manager, p_location);
        end;
begin
    add_dept(45, 'db administration', 100, 2500);
end;
select * from dept_aan;
rollback;


-- 2
-- sa vad daca merge la p_rezultat doar de tip out
declare
    v_nume employees.last_name%type;
    procedure ex2 (p_rezultat in out employees.last_name%type,
                   p_comision in employees.commission_pct%type := null,
                   p_cod in employees.employee_id%type := null) is
        begin
            if p_comision is not null then
                select last_name into p_rezultat
                from employees
                where commission_pct = p_comision
                and salary = (select max(salary)
                              from employees
                              where commission_pct = p_comision);
                dbms_output.put_line('Numele salariatului care are comisionul ' || 
                    p_comision || ' este ' || p_rezultat);
            else
                select last_name into p_rezultat
                from employees
                where employee_id = p_cod;
                dbms_output.put_line('Numele salariatului care are codul ' || 
                    p_cod || ' este ' || p_rezultat);
            end if;
        end ex2;
begin
    ex2(v_nume, 0.4, null);
    ex2(v_nume, null,205);
end;

-- proceduri stocate
-- 3
create or replace procedure afis_aan is 
    azi date := sysdate;
    ieri azi%type;
    begin
        dbms_output.put_line('Programare plsql');
        dbms_output.put_line(to_char(azi, 'dd-month-yyyy hh24:mi:ss'));
        ieri := azi - 1;
        dbms_output.put_line(to_char(ieri, 'dd-month-yyyy'));
    end;
/
begin
    afis_aan;
end;

-- 4
create or replace procedure afis1_aan (p_nume varchar2) is
    begin
        dbms_output.put_line(p_nume || ' invata plsql.');
    end;

/
execute afis1_aan(user);

-- 5
-- a
desc jobs;
create table jobs_aan as select * from jobs;
alter table jobs_aan add constraint pk_jobs_aan primary key(job_id);

-- b
create or replace procedure add_job (p_id jobs_aan.job_id%type,
                          p_job_title jobs_aan.job_title%type) is
    begin
        insert into jobs_aan(job_id, job_title)
        values (p_id, p_job_title);
    end;

execute add_job ('IT_DBA', 'Database Administrator');
select * from jobs_aan;
select * from jobs_aan;
-- 6.a
create or replace procedure upd_job_aan (p_job_id jobs_aan.job_id%type, 
                                         p_job_title jobs_aan.job_title%type) is
    begin
        update jobs_aan
        set job_title = p_job_title
        where job_id = p_job_id;
        if sql%notfound then
            raise_application_error(-20202, 'Nicio actualizare');
        end if;
    end;

select * from jobs_aan;
execute upd_job_aan('IT_WEB', 'administrator');

-- 7
create or replace procedure del_job (p_job_id jobs_aan.job_id%type) is
    begin
        delete from jobs_aan
        where job_id = p_job_id;
         if sql%notfound then
            raise_application_error(-20202, 'Nicio actualizare');
        end if;
    end;
/
execute del_job('IT_DBA');


-- 8
variable v_medie_salarii number
create or replace procedure avg_salary(v_medie out employees.salary%type) as
    begin
        select avg(salary) into v_medie
        from employees;
        dbms_output.put_line('Media este ' || v_medie);
    end;

/
execute avg_salary(:v_medie_salarii)
print v_medie_salarii


-- 9
-- a
create or replace procedure act_sal(p_sal in out number) is
    begin
        case
            when p_sal < 3000 then p_sal := p_sal * 1.2;
            when p_sal in (3000, 7000) then p_sal := p_sal * 1.15;
            when p_sal > 7000 then p_sal := p_sal * 1.1;
            else p_sal := 1000;
        end case;
    end;
/
-- b
variable g_sal number
begin
    :g_sal := &p_sal;
end;
/
print g_sal
execute act_sal(:g_sal)
print g_sal

-- functii locale
-- 10
create or replace procedure proc (cod_dept employees.department_id%type) as
        -- functie care calculeaza numarul de angajati dintr-un departament
        function nr_sal(v_dept employees.department_id%type) 
            return number is
                v_nr_sal number;
            begin
                select count(*) into v_nr_sal
                from employees 
                where department_id = v_dept;
            return v_nr_sal;
            end nr_sal;
        
        -- functie care calculeaza suma salariilor
        function sum_salary (v_dept employees.department_id%type)
            return number is
                v_sum_sal number;
            begin
                select sum(salary) into v_sum_sal
                from employees
                where department_id = v_dept;
                return v_sum_sal;
            end sum_salary;
        
        -- numarul managerilor
        function nr_mag (v_dept employees.department_id%type)
            return number is
                v_nr_mag number;
            begin
                select count(distinct manager_id) into v_nr_mag
                from employees
                where department_id = v_dept;
                return v_nr_mag;
            end nr_mag;
begin
    dbms_output.put_line('Numarul salariatilor este ' || nr_sal(cod_dept));
    dbms_output.put_line('Suma salariilor este ' || sum_salary(cod_dept));
    dbms_output.put_line('Numarul managerilor este ' || nr_mag(cod_dept));
end proc;
/
execute proc(50);

-- 12
-- functii stocate
create or replace function func (cod_dept employees.department_id%type)
    return number is
        v_nr_ang number;
        begin
        select count(*) into v_nr_ang
        from employees
        where to_char(hire_date, 'yyyy') > 1995 and department_id = cod_dept;
        return v_nr_ang;
end func;

--metode de apelare
-- 1. variabila de legatura
variable nr number
execute :nr := func(80);
print nr

-- 2. folosind comanda call
-- NU FUNCTIONEAZ   
variable nr1 number
call func(80) into :nr1;
print nr1

-- 3. intr-o comanda select
select func(80)
from dual;

-- 13
-- a
create or replace function valid_dept_id (cod_dept employees.department_id%type)
        return boolean is
            v_aux varchar2(1);
        begin
            select 'x' into v_aux
            from departments
            where department_id = cod_dept;
            return(true);
            
            exception
                when no_data_found then 
                    return(false);
end valid_dept_id;
        
-- b
select * from emp_aan;
--create or replace procedure add_emp (prenume employees.first_name%type,
--                                     nume employees.last_name%type,
--                                     email employees.email%type,
--                                     job_id employees.job_id%type default 'SA_REP',
--                                     cod_man employees.manager_id%type default 145,
--                                     salariu employees.salary%type default 1000, 
--                                     comision employees.commission_pct%type default 0,
--                                     cod_dept employees.department_id%type default 30) is
--    begin
--        -- verificam daca codul departamentului este valid
--        if valid_dept_id(cod_dept) then
--            insert into emp_aan
--            values (207, prenume, nume, email, job_id, cod_man, salariu, comision, cod_dept);
--        else
--            raise_application_error(-20204, 'Cod invalid de departament');
--        end if;
--end add_emp;
--        
