-- Exercitiul 2
desc locations;
select * from departments where department_id = 30;
select * from locations;
set serveroutput on
declare
    v_oras locations.city%type;
begin
    select city into v_oras
    from locations l, departments d
    where l.location_id = d.location_id and d.department_id = 30;
dbms_output.put_line('Orasul este ' || v_oras);
end;

-- cu variabile de legatura
variable g_oras varchar2(20)
begin
    select city into :g_oras
    from departments d, locations l
    where d.location_id = l.location_id and department_id = 30;
end;
/
print g_oras


-- Exercitiul 3
declare
    v_media_sal employees.salary%type;
    v_dept number(3) := 50;
begin
    select avg(salary) into v_media_sal
    from employees
    where department_id = v_dept;

dbms_output.put_line('Media este ' || v_media_sal);
end;

-- Exercitiul 4
declare
    v_dept employees.department_id%type := &cod_dept;
    v_nr_angajati number(5);
begin
    select count(*) into v_nr_angajati
    from employees
    where department_id = v_dept;
    
    if v_nr_angajati >= 30 then
        dbms_output.put_line('Numarul este ' || v_nr_angajati || ' => departamentul este mare');
    ELSIF v_nr_angajati in (10, 30) then 
        dbms_output.put_line('Numarul este ' || v_nr_angajati || ' => departamentul este mediu');
    else
        dbms_output.put_line('Numarul este ' || v_nr_angajati || ' => departamentul este mic');
    end if;
end;

-- Exercitiul 5 
set verify off
declare 
    v_cod_dept number(10) := &p_cod_dep;
    v_com number(10) := &p_com;
begin
    update emp_aan
    set commission_pct = v_com / 100
    where department_id = v_cod_dept;
    if sql%rowcount = 0 then 
        dbms_output.put_line('Nicio linie nu a fost actualizata');
    else
        dbms_output.put_line(sql%rowcount || ' linii actualizate');
    end if;
end;

-- Exercitiul 7
select * from emp_aan;
select * from job_history;
alter table emp_aan add vechime varchar2(20);
select * from emp_aan;


-- Exercitii propuse
-- 2
declare
    v_x number(2) := &number_x;
    v_y number(2) := &number_y;
    v_func_result number(4);
begin
    if v_y = 0 then
        v_func_result := v_x * v_x;
    else
        v_func_result := v_x / v_y + v_y;
    end if;
    dbms_output.put_line('Valoare functiei este ' || v_func_result);
end;


-- 3

declare
    v_cod_job varchar2(10) := '&p_cod_job';
    v_result number(20);
begin
    select sum(salary) into v_result
    from employees
    where upper(job_id) = upper(v_cod_job);
    dbms_output.put_line('Suma salariilor este ' || v_result);
end;

-- 4
select * from employees where employee_id = 105;
desc employees;
declare
    v_cod_ang employees.employee_id%type := &p_cod_ang;
    v_salariu employees.salary%type;
    v_commission_pct employees.commission_pct%type;
begin
    select salary into v_salariu
    from employees
    where employee_id = v_cod_ang;
    if v_salariu < 1000 then
        v_commission_pct := 0.10;
    elsif v_salariu in (1000, 1500) then
        v_commission_pct := 0.15;
    elsif v_salariu > 1500 then
        v_commission_pct := 0.20;
    else
        v_commission_pct := 0;
    end if;
    dbms_output.put_line('Comisionul nou este ' || v_commission_pct);
    update emp_aan
    set commission_pct = v_commission_pct
    where employee_id = v_cod_ang;
end;
select * from emp_aan where employee_id = 105;

-- 5
create table org_tab (cod_tab integer,
                      text_tab varchar2(20));
select * from org_tab;

declare 
    v_contor binary_integer := 1;
begin
    loop
        insert into org_tab
        values (v_contor, 'Pasul '|| v_contor);
        v_contor := v_contor + 1;
        exit when v_contor > 70;
    end loop;
end;
select * from org_tab;

drop table org_tab;

declare
    v_contor binary_integer := 1;
begin
    while v_contor <= 70 loop
        insert into org_tab
        values (v_contor, 'Pasul ' || v_contor);
        v_contor := v_contor + 1;
    end loop;
end;

-- 6
declare
    v_contor binary_integer := 1;
    v_verif varchar2(10);
begin
    while v_contor <= 70 loop
        if v_contor mod 2 = 0 then
            v_verif := 'Este par';
        else
            v_verif := 'Este impar';
        end if;
        
        insert into org_tab
        values (v_contor, v_verif);
        v_contor := v_contor + 1;  
    end loop;
end;

select * from org_tab;

-- 7

create table dept_aan as (select * from departments);
select * from dept_aan;
desc dept_aan;
-- aici puteam sa folosesc si o variabile normala declarata in sectiunea declare???
variable g_dept_maxim number
begin
    select max(department_id) into :g_dept_maxim
    from dept_aan;
end;
/
print g_dept_maxim

-- 8
desc dept_aan;
select * from dept_aan;
declare
    v_dept_nou departments.department_id%type := :g_dept_maxim + 10;
    v_nume_dept departments.department_name%type := '&p_nume_dept';
begin
    dbms_output.put_line(v_dept_nou);
    dbms_output.put_line(v_nume_dept);
    insert into dept_aan
    values (v_dept_nou, v_nume_dept , null, null);
end;

select * from dept_aan;

-- 9

declare
    v_loc_act departments.location_id%type := &p_loc_act;
    v_nr_dept departments.department_id%type := &p_nr_dept;
begin
    update dept_aan
    set location_id = v_loc_act
    where department_id = v_nr_dept;
end;

select * from dept_aan where department_id = 120;

-- 10
declare
    v_linii_del number(10);
begin
    delete from dept_aan
    where department_id = (:g_dept_maxim + 10);
    v_linii_del := sql%rowcount;
    dbms_output.put_line('S-au sters ' || v_linii_del);
end;

