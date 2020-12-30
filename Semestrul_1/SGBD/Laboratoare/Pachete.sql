-- Pachete definite de utilizator
-- 1
-- partea cu specificatii
create or replace package pachet1_aan as
    -- functie care calculeaza numarul de angajati dintr-un departament
    function numar_angajati(v_dept departments.department_id%type)
        return number;
    -- functie care calculeaza suma ce trebuie alocata pentru salarii
    function suma_salarii(v_dept departments.department_id%type)
        return number;
end pachet1_aan;
/
-- corpul pachetului
create or replace package body pachet1_aan as
    -- implementam functiile
    function numar_angajati(v_dept departments.department_id%type)
        return number is
            -- declaratii locale
            numar_ang number;
        begin
            select count(*) into numar_ang
            from employees
            where department_id = v_dept;
        return numar_ang;
        end numar_angajati;
    
    function suma_salarii(v_dept departments.department_id%type) 
        return number is
            --declaratii locale
            suma_sal number;
        begin
            select sum(salary + salary * nvl(commission_pct, 0)) into suma_sal
            from employees
            where department_id = v_dept;
        return suma_sal;
        end suma_salarii;
        
end pachet1_aan;

-- Modalitati de apelare
-- in SQL
select pachet1_aan.numar_angajati(80)
from dual;
select pachet1_aan.suma_salarii(80)
from dual;

-- In PLSQL
set serveroutput on;
begin
    dbms_output.put_line('Numarul de salariati din departament este ' || pachet1_aan.numar_angajati(80));
    dbms_output.put_line('Suma alocata pentru salariatii din departament este ' || pachet1_aan.suma_salarii(80));
end;


-- 3
create or replace package pachet3_aan as
    cursor lista_angajati(sal number) return employees%rowtype;
    function f_max(v_oras locations.city%type) return number;
end pachet3_aan;
/
create or replace package body pachet3_aan as
    cursor lista_angajati(sal number) return employees%rowtype is
        select * 
        from employees
        where salary >= sal;
        
    function f_max(v_oras locations.city%type)
        return number is
            sal_max number;
        begin
            select max(salary) into sal_max
            from employees e, departments d, locations l
            where e.department_id = d.department_id and 
            d.location_id = l.location_id
            and upper(city) = upper(v_oras);
        return sal_max;
        end f_max;
end pachet3_aan;
/
declare
    v_oras locations.city%type := 'toronto';
    val_max number;
begin
    val_max := pachet3_aan.f_max(v_oras);
    for i in pachet3_aan.lista_angajati(val_max) loop
        dbms_output.put_line(i.last_name || ' ' || i.salary);
    end loop;
end;


-- 4
create or replace package pachet4_aan is
    procedure verif_comb(v_cod employees.employee_id%type,
                          v_job employees.job_id%type);
    cursor c_emp return employees%rowtype;
end pachet4_aan;
/
create or replace package body pachet4_aan is
    cursor c_emp return employees%rowtype is
        select * 
        from employees;
    procedure verif_comb(v_cod employees.employee_id%type,
                         v_job employees.job_id%type) is
        gasit boolean := false;
        lista employees%rowtype;
        begin
            -- deschidem cursorul
            open c_emp;
            loop
                fetch c_emp into lista;
                exit when c_emp%notfound;
                if lista.employee_id = v_cod and lista.job_id = v_job then
                    gasit := true;
                end if;
            end loop;
            -- inchidem cursorul 
            close c_emp;
            if gasit = true then
                dbms_output.put_line('Combinatia exista');
            else
                dbms_output.put_line('Combinatia data nu exista');
            end if;
        end verif_comb;
    
end pachet4_aan;

begin
    pachet4_aan.verif_comp(102, 'AD_VP');
end;

-- EXERCITII
create or replace package ex1 is
    procedure adaug_angajat(nume varchar2(20), prenume varchar2(20), 
                            telefon varchar2(11), email varchar2(20))                        
end ex1;
create or replace package body ex1 is
    procedure adaug_angajat(nume varchar2(20), prenume varchar2(20),    
                            telefon varchar2(11), email varchar2(20)) is
        -- declaratii locale
        -- vom determina codul angajatului
        v_cod_ang_max employees.employee_id%type;
        v_cod_ang employees.employee_id%type;
        v_salariu employees.salary%type;
        v_data_angajare date := sysdate;
    begin
        --determin codul angajatului
        select max(employee_id) into v_cod_ang_max
        from employees;
        v_cod_ang := v_cod_ang_max + 1;
        -- data angajarii este sysdate
        --determin salariul
        
    end adaug_angajat;
end ex1;