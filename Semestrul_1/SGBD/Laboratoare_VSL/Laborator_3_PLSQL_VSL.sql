-- Exercitii (Cursoare implicite)
-- 1
select * from emp_aan;
set serveroutput on
declare
    v_salariu emp_aan.salary%type := '&p_salariu';
    
begin
    update emp_aan
    set commission_pct = commission_pct + 0.1 * commission_pct
    where salary < v_salariu;
    
    if sql%found = true then
        dbms_output.put_line('Numarul de linii modificate este ' || sql%rowcount);
    end if;        
end;

-- 2
create table dept_emp_aan (cod_dep number(4),
                           cod_ang number(4));
declare
    type t_dep is table of number;
    v_dep t_dept;
begin
    select department_id bulk collect into v_dep from emp_aan;
    forall j in v_dep.first..v_dep.last
        insert into dept_emp_aan
            select department_id, employee_id
            from emp_aan
            where department_id = v_dep(j);
    for j in v_dep.first..v_dep.last loop
        dbms_output.put_line('Pentru departamentul ' || v_dep(j) || 
        ' au fost inserati ' || sql%bulk_rowcount(j) || 'inregistrari.');
    end loop;
    dbms_output.put_line('Numarul total de inregistrari inserate este ' || 
        sql%rowcount);
end;

-- Cursoare explicite
-- 3
-- varianta cu while
declare
    cursor c is 
        select last_name, salary * 12 sal_anual
        from employees
        where department_id = 50;
    v_emp c%rowtype;
begin
    open c;
    fetch c into v_emp;
    while c%found loop
        dbms_output.put_line('Nume' || v_emp.last_name || ' are salariul anual ' ||
            v_emp.sal_anual);
        fetch c into v_emp;
    end loop;
    close c;
end;

-- varianta cu loop
declare
    cursor c is
        select last_name, salary * 12 sal_anual
        from employees
        where department_id = 50;
    v_emp c%rowtype;
begin
    -- deschidem cursorul
    open c;
    loop
        fetch c into v_emp;
        exit when c%notfound;
        dbms_output.put_line('Nume ' || v_emp.last_name || ' are salariul anual ' ||
            v_emp.sal_anual);
    end loop;
    close c;
end;


-- 4

begin
    for emp in (select last_name, salary
                from employees
                where salary < 7000) loop
        dbms_output.put_line('Angajatul ' || emp.last_name || ' ia ' || emp.salary);
    end loop;
end;

-- 5
create table top_salarii_aan (salariu number(10));
declare
    v_nr number(4) := &p_nr;
    cursor c is
        select distinct salary
        from employees
        order by salary desc;
    v_sal c%rowtype;
begin
    open c;
    fetch c into v_sal;
    while c%rowcount <= v_nr and c%found loop
        insert into top_salarii_aan
        values v_sal;
        fetch c into v_sal;
    end loop;
    close c;
end;
select * from top_salarii_aan;

-- Cursoare cu parametru
-- 6
declare
    cursor c (p_id employees.employee_id%type) is
        select last_name, salary
        from employees
        where p_id is null or employee_id = p_id;
    v_nume c%rowtype;
    type t_nume is table of employees.last_name%type;
    type t_salariu is table of employees.salary%type;
    v_num t_nume;
    v_salariu t_salariu;
begin
    -- aici o sa-mi returneze doar o linie
    open c(104);
    fetch c into v_nume;
    while c%found loop
        dbms_output.put_line('Angajatul ' || v_nume.last_name || ' are ' || v_nume.salary);
        fetch c into v_nume;
    end loop;
    close c;
    -- aici o sa-mi returneze toate inregistrarile din tabel
    open c(null);
    dbms_output.put_line('----------------------');
    fetch c bulk collect into v_num, v_salariu;
    for i in v_num.first..v_num.last loop
        dbms_output.put_line('Angajatul ' || v_num(i) || ' are ' || v_salariu(i));
    end loop;
end;

select * from employees where employee_id = 105;

-- 7
-- rezolvarea exercitiului 6 folosind comanda loop
declare
    cursor c (p_id employees.employee_id%type) is
        select last_name, salary
        from employees
        where p_id is null or employee_id = p_id;
    v_nume c%rowtype;
    type t_nume is table of employees.last_name%type;
    type t_salariu is table of employees.salary%type;
    v_num t_nume;
    v_salariu t_salariu;
begin
    -- aici o sa-mi returneze doar o linie
    open c(104);
    loop
        fetch c into v_nume;
        exit when c%notfound;
        dbms_output.put_line('Angajatul ' || v_nume.last_name || ' are salariul ' || v_nume.salary);
    end loop;
    close c;
end;

-- 8
-- rezolvarea exercitiului 6 folosind for => deschiderea, incarcarea si inchiderea sunt operatii care se fac automat
declare
    cursor c (p_id employees.employee_id%type) is
        select last_name, salary
        from employees
        where p_id is null or employee_id = p_id;
begin
    for i in c(104) loop
        dbms_output.put_line('Angajatul ' || i.last_name || ' are salariul ' || i.salary);
    end loop;
end;


-- 9 ???
-- cursor parametrizat


-- 10
select hire_date from employees;
declare
    cursor c is
        select * 
        from emp_aan
        where commission_pct is null and hire_date <= '01-01-1995'
        for update of salary nowait;
begin
    for i in c loop
        update emp_aan
        set salary = salary * 2
        where current of c;
    end loop;
    commit;
end;

-- 11 ????
select * from dept_aan;
select location_id from locations;
declare
    cursor c(cod_loc locations.location_id%type) is
        select 'x'
        from departments d, locations l
        where d.location_id = l.location_id
        and d.location_id = cod_loc
        for update of department_name nowait;
    v_cod_loc locations.location_id%type := &p_num;
    v_linie c%rowtype;
begin
    open c(v_cod_loc);
    loop
        fetch c into v_linie;
        exit when c%notfound;
        update dept_aan
        set location_id = 100
        where current of c;
    end loop;
    close c;
end;



-- 12 - cursoare dinamice
-- cursor care intoarce linii de tipul celor din tabelul emp_aan
select * from emp_aan;
declare
    type refcursor is ref cursor return emp_aan%rowtype;
    -- pointer catre refcursor
    c_emp refcursor;
    v_opt number := &p_opt;
begin
    if v_opt = 1 then
        open c_emp for select * from emp_aan;
        dbms_output.put_line('Angajatul ' || c_emp.last_name || ' are salariul ' || c_emp.salary);
    elsif v_opt = 2 then
        open c_emp for select * from emp_aan where salary in (10000, 20000);
        dbms_output.put_line('Angajatul ' || c_emp.last_name || ' are salariul ' || c_emp.salary);
    elsif v_opt = 3 then
        open c_emp for select * from emp_aan where to_char(hire_date, 'YYYY') = 1990;
        dbms_output.put_line('Angajatul ' || c_emp.last_name || ' s-a angajat in data de' || v_emp.hire_date);
    else
        dbms_output.put_line('Optiunea este incorecta');
    end if;
end;


-- 14
-- expresii cursor
begin
    for i in (select region_id, region_name
              from regions) loop
        -- pentru fiecare regiune sa se afiseze numele tarilor
        dbms_output.put_line('------------------------');
        dbms_output.put_line('Regiune este ' || i.region_name || ' cu urmatoarele tari.');
        dbms_output.put_line('------------------------');
        for j in (select country_name
                  from countries
                  where region_id = i.region_id) loop
            dbms_output.put_line(j.country_name);
        end loop;
    end loop;
end;

declare
    type refcursor is ref cursor;
    cursor c is
        select region_name,
            cursor (select country_name
                    from countries c
                    where r.region_id = c.region_id)
        from regions r;
    v_cursor refcursor;
    v_reg regions.region_name%type;
    v_nume_tara countries.country_name%type;
begin
    -- deschidem cursorul
    open c;
    loop
        fetch c into v_reg, v_cursor;
        exit when c%notfound;
        dbms_output.put_line('------------------------');
        dbms_output.put_line('Regiune este ' || v_reg || ' cu urmatoarele tari.');
        dbms_output.put_line('------------------------');
        loop
            fetch v_cursor into v_nume_tara;
            exit when v_cursor%notfound;
            dbms_output.put_line(v_nume_tara);
        end loop;
    end loop;
    close c;
end;