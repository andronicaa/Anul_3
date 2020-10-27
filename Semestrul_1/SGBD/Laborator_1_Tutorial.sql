-- 3. Creati un bloc anonim care sa afiseze ceva
-- varianta 1
set serveroutput on
variable g_mesaj varchar2(50)
begin
    :g_mesaj := 'Invat la PL/SQL';
end;
/
print g_mesaj

-- varianta 2
begin
    dbms_output.put_line('Invat PL/SQL');
end;

-- 4. Definiti un bloc anonim in care sa se afle numele departamentului cu cei 
-- mai mult angajati
declare v_dep departments.department_name%type;
begin
    select department_name into v_dep
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (select max(count(*))
                       from employees
                       group by department_id);
    dbms_output.put_line('Departamentul ' || v_dep);
end;

-- 5. Rezolvati problema anterioara utilizand variabile de lagatura
variable rezultat varchar2(50)
begin
    select department_name into :rezultat
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (select max(count(*))
                       from employees
                       group by department_id);
    dbms_output.put_line('Departamentul ' || :rezultat);
end;
/
print rezultat
-- 6. Modificati exercitiul anterior astfel incat sa obtineti si numarul
-- de angajati din departamentul respectiv
declare 
    v_dep departments.department_name%type;
    v_nr_angajati number(4);
begin
    select department_name, count(*) into v_dep, v_nr_angajati
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (select max(count(*))
                       from employees
                       group by department_id);
    dbms_output.put_line('Departamentul ' || v_dep || 'si are ' || v_nr_angajati || ' angajati');
end;

-- 7
--set verify off
declare 
    v_cod employees.employee_id%type := &p_cod;
    v_bonus number(10);
    v_salariu_anual number(10);
begin
    select salary * 12 into v_salariu_anual
    from employees
    where employee_id = v_cod;
    if v_salariu_anual >= 20001
        then v_bonus := 2000;
    elsif v_salariu_anual between 10001 and 20000
        then v_bonus := 1000;
    else v_bonus := 500;
end if;
dbms_output.put_line('Bonusul este ' || v_bonus);
end;

--set verify on



