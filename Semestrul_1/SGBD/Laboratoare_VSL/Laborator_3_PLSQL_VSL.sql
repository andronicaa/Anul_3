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
        dbms_output.put_line(sql%rowcount);
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
    open c(104);
    fetch c into v_nume;
    while c%found loop
        dbms_output.put_line('Angajatul ' || v_nume.last_name || ' are ' || v_nume.salary);
        fetch c into v_nume;
    end loop;
    close c;
    open c (null);
    dbms_output.put_line('----------------------');
    fetch c bulk collect into v_num, v_salariu;
    for i in v_num.first..v_num.last loop
        dbms_output.put_line('Angajatul ' || v_num(i) || ' are ' || v_salariu(i));
    end loop;
end;

select * from employees where employee_id = 105;

-- 9
create table mesaje (text varchar2(500));
declare
    cursor c is
        select 
begin

end;