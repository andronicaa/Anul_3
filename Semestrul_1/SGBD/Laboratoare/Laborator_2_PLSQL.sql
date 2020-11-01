-- 1
DECLARE
    x   NUMBER(1) := 5;
    y   x%TYPE := NULL;
BEGIN
    IF x <> y THEN
        dbms_output.put_line('valoare <> null este = true');
    ELSE
        dbms_output.put_line('valoare <> null este != true');
    END IF;

    x := NULL;
    IF x = y THEN
        dbms_output.put_line('null = null este = true');
    ELSE
        dbms_output.put_line('null = null este != true');
    END IF;

END;
/ 

-- Tipul de date RECORD
-- defineste un grup de date stocate sub forma de campuri(ca struct-ul)
-- numarul de campuri nu este limitat
-- se pot defini valori initiale si constrangeri not null asupra campurilor
-- 2
-- a
declare 
type emp_record is record
    (
        cod employees.employee_id%type,
        salariu employees.salary%type,
        cod_job employees.job_id%type
    );
    v_ang emp_record;
begin
    -- se intializeaza variabila definita
    v_ang.cod := 700;
    v_ang.salariu := 7000;
    v_ang.cod_job := 'SA_MAN';
    dbms_output.put_line('Angajatul cu codul ' || v_ang.cod || ' si jobul' ||
        v_ang.cod_job || ' are salariul ' || v_ang.salariu);
end;
/

-- b
declare 
type emp_record is record
    (
        cod employees.employee_id%type,
        salariu employees.salary%type,
        cod_job employees.job_id%type
    );
    v_ang emp_record;
begin
    -- se intializeaza variabila definita cu valorile respective ang cu emp_id = 101
    select employee_id, salary, job_id into v_ang
    from employees
    where employee_id = 101;
    dbms_output.put_line('Angajatul cu codul ' || v_ang.cod || ' si jobul' ||
        v_ang.cod_job || ' are salariul ' || v_ang.salariu);
end;
/

-- c 
-- stergeti angajatul avand codul 100 din tabelul emp_aan
declare 
type emp_record is record
    (
        cod employees.employee_id%type,
        salariu employees.salary%type,
        cod_job employees.job_id%type
    );
    v_ang emp_record;
begin
    delete from emp_aan
    where employee_id = 100
    returning employee_id, salary, job_id into v_ang;
    dbms_output.put_line('Angajatul sters are codul ' || v_ang.cod || ' si jobul' ||
        v_ang.cod_job || ' are salariul ' || v_ang.salariu);
end;
/

-- 4
declare
    type tablou_indexat is table of number index by plx_integer;
    t tablou_indexat;
begin
    -- a
    for i in 1..10 loop
        t(i) := i;
    end loop;
    dbms_output.put_line('Tabloul are ' || t.count || ' elemente: ');
    for i in t.first..t.last loop
        dbms_output.put(t(i) || ' ');
    end loop;
    dbms_output.new_line;
    
    -- b
    for i in 1..10 loop
        if i mod 2 = 1 then
            t(i) := null;
        end if;
    end loop;
    dbms_output.put_line('Tabloul are ' || t.count || ' elemente: ');
    for i in t.first..t.last loop
        dbms_output.put(nvl(t(i), 0) || ' ');
    end loop;
    dbms_output.new_line;
    
end;
    