-- 1
declare
    -- dam numele de la tastatura
    v_nume employees.last_name%type := initcap ('&p_nume');
    function f1 return number is
        salariu employees.salary%type;
    begin
        select salary into salariu
        from employees 
        where last_name = v_nume;
        return salariu;
    exception
        when no_data_found then
            dbms_output.put_line('Nu exista angajati cu numele dat');
        when too_many_rows then
            dbms_output.put_line('Exista mai multi angajati cu numele dat');
        when others then
            dbms_output.put_line('a aparut o alta eroare');
    end f1;
begin
    dbms_output.put_line('Salariu este ' || f1);
    exception
        when others then
            dbms_output.put_line('Eroarea are codul = ' || sqlcode || ' si mesajul = ' || sqlerrm);
end;


-- 2
-- rezolvarea exercitiului 1 cu functii stocate
create or replace function f2_aan
    (v_nume employees.last_name%type default 'Bell')
    return number is 
    salariu employees.salary%type;
    begin
        select salary into salariu
        from employees
        where last_name = v_nume;
    return salariu;
    exception
        when no_data_found then
            raise_application_error(-20000, 'Nu exista angajati cu numele dat');
        when too_many_rows then
            raise_application_error(-20001, 'Exista mai multi angajati cu numele dat');
        when others then
            raise_application_error(-20002, 'alta eroare');
    end f2_aan;
/

-- metode de apelare
-- 1. bloc plsql
-- ne folosim de parametrul default
begin
    dbms_output.put_line('Salariu este ' || f2_aan);
end;

-- dam noi un parametru
begin
    dbms_output.put_line('Salariul este ' || f2_aan('King'));
end;

-- 2. sql
select f2_aan from dual;
select f2_aan('King') from dual;

-- 3. sql*plus cu variabila de legatura(NU se pune virgula dupa ea)
variable nr number
execute :nr := f2_aan('Bell');
print nr

-- 3
-- rezolvarea exercitiului 1 folosind proceduri locale
-- fara sa-i dam parametru de out
declare
    v_nume employees.last_name%type := initcap('&p_nume');
    procedure p3 is
        salariu employees.salary%type;
    begin
        select salary into salariu
        from employees
        where last_name = v_nume;
        dbms_output.put_line('Salariu este ' || salariu);
    exception
        when no_data_found then
            dbms_output.put_line('Nu exista angajati cu numele dat');
        when too_many_rows then
            dbms_output.put_line('Exista mai multi angajati cu numele dat');
        when others then
            dbms_output.put_line('a aparut o alta eroare');
    end p3;
begin
    p3;
end;

-- cu parametru de out
declare
    v_nume employees.last_name%type := initcap('&p_nume');
    v_salariu employees.salary%type;
    procedure p3(salariu out employees.salary%type) is
    begin   
        select salary into salariu
        from employees
        where last_name = v_nume;
    exception
    when no_data_found then
        raise_application_error(-20000, 'Nu exista angajati cu numele dat');
    when too_many_rows then
        raise_application_error(-20001, 'Exista mai multi angajati cu numele dat');
    when others then
        raise_application_error(-20002, 'alta eroare');
    end p3;
begin
    p3(v_salariu);
    dbms_output.put_line('salariul este ' || v_salariu);
end;

-- 4
-- folosim procedure stocata
create or replace procedure p4_aan
    (v_nume employees.last_name%type)
    is
    salariu employees.salary%type;
    begin
        select salary into salariu
        from employees
        where last_name = v_nume;
        dbms_output.put_line('Salariu este ' || salariu);
    exception
    when no_data_found then
        raise_application_error(-20000, 'Nu exista angajati cu numele dat');
    when too_many_rows then
        raise_application_error(-20001, 'Exista mai multi angajati cu numele dat');
    when others then
        raise_application_error(-20002, 'alta eroare');
    end p4_aan;
    
-- apelare
begin
    p4_aan('Bell');
end;

execute p4_aan('Bell');
execute p4_aan('King');
execute p4_aan('Kimball');

create or replace procedure p5_aan
            (v_nume in employees.last_name%type,
             salariu out employees.salary%type) is
    begin
        select salary into salariu
        from employees
        where last_name = v_nume;
    exception
    when no_data_found then
        raise_application_error(-20000, 'Nu exista angajati cu numele dat');
    when too_many_rows then
        raise_application_error(-20001, 'Exista mai multi angajati cu numele dat');
    when others then
        raise_application_error(-20002, 'alta eroare');
    end p5_aan;
    
-- apelare
declare
    v_salariu employees.salary%type;
begin
    p5_aan('Bell', v_salariu);
    dbms_output.put_line('Salariul este ' || v_salariu);
end;

-- variabila de legatura
variable v_sal number 
execute p5_aan ('Bell', :v_sal)
print v_sal

-- 5
select manager_id
from employees
where employee_id = 200;



create or replace procedure p6_aan (cod_ang in out number) is
    begin
        select manager_id into cod_ang
        from employees
        where employee_id = cod_ang;
    end p6_aan;
/
variable v_cod number
begin
    :v_cod := 200;
end;
execute p6_aan(:v_cod)
print v_cod


-- 6
declare
    v_nume employees.last_name%type;
    procedure ex6 (rezultat out employees.last_name%type,
                   comision in employees.commission_pct%type := null,
                   cod in employees.employee_id%type := null)
    is
    begin
        if comision is not null then
            select last_name into rezultat
            from employees
            where commission_pct = comision;
            dbms_output.put_line('Numele salariatului care are acest comision este ' || rezultat);
    else
        select last_name into rezultat
        from employees
        where employee_id = cod;
        dbms_output.put_line('Numele salariatului avand acest cod este ' || rezultat);
    end if;
    end ex6;
begin
    ex6(v_nume, 0.4);
    ex6(v_nume, cod => 200);
end;

-- 7
declare
    medie1 number(10, 2);
    medie2 number(10, 2);
    function medie (cod_dept employees.department_id%type) 
        return number is
        rezultat number(10, 2);
    begin
        select avg(salary) into rezultat
        from employees
        where department_id = cod_dept;
        return rezultat;
    end;
    
    function medie (cod_dept employees.department_id%type,
                    cod_job employees.job_id%type)
        return number is
        rezultat number(10, 2);
        begin
            select avg(salary) into rezultat
            from employees
            where department_id = cod_dept and job_id = cod_job;
        return rezultat;
        end;
begin
    medie1 := medie(80);
    dbms_output.put_line('Media salariilor din departamentul 80 este ' || 
        medie1);
    medie2 := medie(80, 'SA_MAN');
    dbms_output.put_line('Media salariilor din departamentul 80 este si cu jobul sa_man' || 
        medie2);
end;

-- 8
create or replace function factorial(n number)
    return integer is
    begin
        if n = 0 then return -1;
        else return n * factorial(n-1);
        end if;
    end factorial;
    
-- 9
create or replace function medie_aan
    return number
    is
    rezultat number;
    begin
        select avg(salary) into rezultat
        from employees;
        return rezultat;
    end;
select avg(salary)
from employees;

select * from employees
where salary >= 6461;
select last_name, salary
from employees
where salary >= medie_aan;

-- Exercitii
-- 1
create table info_and (utilizator varchar2(30),
                       timp date,
                       comanda varchar2(10),
                       nr_linii number,
                       eroare varchar2(1000));
commit;
-- 2
create or replace function getSalary (v_nume employees.last_name%type default 'Bell')
    return number is
        v_salary employees.salary%type;
    begin
        select salary into v_salary
        from employees
        where last_name = v_nume;
    
    
    -- daca nu s-a aruncat nicio exceptie se ajunge aici
    -- inseram datele in tabel
    insert into info_and
    values (user, sysdate, 'getSalary', 0, null);
    commit;
    return v_salary;
    exception
        when no_data_found then
            insert into info_and 
            values (user, sysdate, 'getSalary', 0, 'Nu exista angajatul cu numele dat');
            commit;
            raise_application_error(-20000, 'Nu exista angajati cu numele dat');
        when too_many_rows then
            insert into info_and 
            values (user, sysdate, 'getSalary', 0, 'Exista mai multi angajati cu numele dat');
            commit;
            raise_application_error(-20001, 'Exista mai multi angajati cu numele dat');
        when others then
            insert into info_and 
            values (user, sysdate, 'getSalary', 0, 'Alta eroare');
            commit;
            raise_application_error(-20002, 'alta eroare');
    
    
end getSalary;

-- apelam functia dintr-un bloc plsq
-- ma folosesc de parametrul default
begin
    dbms_output.put_line('Salariul este ' || getSalary);
end;
select * from info_and;

-- 3
select * from job_history;
select * from employees where employee_id = 101;
select *
from departments d, locations l
where d.location_id(+) = l.location_id;
select count(count(*))
from job_history jh, employees e, departments dp, locations l
where e.department_id = dp.department_id and dp.location_id = l.location_id and jh.employee_id = e.employee_id
    and city = 'Roma'
group by jh.employee_id
having count(*) >= 2;

select city
from locations 
where location_id = 1700 or location_id = 2500;
create or replace function getEmp (v_city locations.city%type)
    return number is
        nr_ang number;
    begin
        nr_ang := 0;
        select count(count(*)) into nr_ang
        from job_history jh, employees e, departments dp, locations l
        where e.department_id = dp.department_id and dp.location_id = l.location_id and jh.employee_id = e.employee_id
            and upper(city) = upper(v_city) 
        group by jh.employee_id
        having count(*) >= 2;
        return nr_ang;
    exception
        when no_data_found then
            dbms_output.put_line('Acel oras nu exista.');
        
end getEmp;

-- apelare
begin
    
    dbms_output.put_line('Numarul de angajati din orasul respectiv este ' || getEmp('Roma'));
end;

-- 4
create or replace procedure ex4 (cod_manager employees.manager_id%type) is
    -- fac o colectie in care sa adaug toti angajatii
    type tablou is table of employees.employee_id%type;
    t_emp tablou;
    begin
        select employee_id bulk collect into t_emp
        from employees
        start with employee_id = cod_manager
        connect by manager_id = prior employee_id;
end ex4;


-- 5
