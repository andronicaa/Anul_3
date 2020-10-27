-- Sintaxa SELECT
-- Cererea trebuie sa intoarca o singura linie
set serveroutput on;
--declare
--    v_fname varchar2(25);
--begin
--    select first_name into v_fname
--    from employees 
--    where employee_id = 200;
--    dbms_output.put_line('Firstname is: ' || v_fname);
--end;

--declare 
--    v_emp_hiredate employees.hire_date%type;
--    v_emp_salary employees.salary%type;
--begin
--    select hire_date, salary
--    into v_emp_hiredate, v_emp_salary
--    from employees
--    where employee_id = 100;
--    dbms_output.put_line('Hire date is: ' || v_emp_hiredate);
--    dbms_output.put_line('Salary is: ' || v_emp_salary);
--end;


--declare 
--    v_sum_sal number(10, 2);
--    v_deptno number not null := 60;
--begin
--    select sum(salary)
--    into v_sum_sal
--    from employees
--    where department_id = v_deptno;
--    dbms_output.put_line('The sum of salary is: ' || v_fname);
--end;


-- CURSOARE
-- Un cursor este un pointer catre o zona privata de memorie
-- utilizat pentru a controla/manipula rezultatul unei cereri
-- cursor implicit(definite automat)
-- explicite (definite de utilizator)

-- atributele unui cursor
declare
    v_rows_deleted varchar2(30);
    v_empno employees.employee_id%type := 176;
begin
    delete from employees
    where employee_id = v_empno;
    v_rows_deleted := (sql%rowcount || ' row deleted');
    dbms_output.put_line(v_rows_deleted);
end;

-- Clauza CASE
-- permite implementarea unor conditii multiple; are urmatoarea forma sintactica

-- Clauze iterative
-- LOOP
declare 
    v_countryid locations.country_id%type := 'CA';
    v_loc_id locations.location_id%type;
    v_counter number(2) := 1;
    v_new_city locations.city%type := 'Montreal';
begin
    select max(location_id) into v_loc_id
    from locations
    where country_id = v_countryid;
    loop
        insert into locations(location_id, city, country_id)
        values ((v_loc_id + v_counter), v_new_city, v_countryid);
        v_counter := v_counter + 1;
        exit when v_counter > 3;
    end loop;
end;


declare
    v_total simple_integer := 0;
begin
    for i in 1..10 loop
        v_total := v_total + i;
        dbms_output.put_line('Total is: ' || v_total);
        continue when i > 5;
        v_total := v_total + i;
        dbms_output.put_line('Out of loop total is: ' || v_total);
    end loop;
end;