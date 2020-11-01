<<principal>>
declare
    v_client_id number(4):= 1600;
    v_client_nume varchar2(50) := 'N1';
    v_nou_client_id number(3) := 500;    
begin
<<secundar>>
    declare
        v_client_id number(4) := 0;
        v_client_nume varchar2(50) := 'N2';
        v_nou_client_id number(3) := 300;
        v_nou_client_nume varchar2(50) := 'N3';
    begin
        v_client_id := v_nou_client_id;
        principal.v_client_nume := v_client_nume || ' ' || v_nou_client_nume;
    -- pozitia 1
    end;
    v_client_id := (v_client_id * 12) / 10;
    -- pozitia 2
end;
-- 300
-- N2
-- 300
-- N3
-- 1920
-- N2 N3

-- 3
-- var 1
variable g_mesaj varchar2(50)
begin
    :g_mesaj := 'Invat';
end;
/
print g_mesaj

-- var 2
set serveroutput on
begin
    dbms_output.put_line('Invat la sgbd');
end;

-- 4
declare
    v_dep departments.department_name%type;
begin
    select department_name
    into v_dep
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (select max(count(*))
                       from employees 
                       group by department_id);
    dbms_output.put_line('Departamentul este ' || v_dep);
end;

-- 5 - variabile de legatura
variable v_dep varchar2(50)
begin
    select department_name
    into :v_dep
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (select max(count(*))
                       from employees 
                       group by department_id);
    dbms_output.put_line('Departamentul este ' || :v_dep);
end;
/
print v_dep

-- 6 - afiseaza si numarul de angajati din departamentul respectiv
declare
    v_dep departments.department_name%type;
    v_nr_angajati number(4);
begin
    select department_name, count(*)
    into v_dep, v_nr_angajati
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (select max(count(*))
                       from employees 
                       group by department_id);
    dbms_output.put_line('Departamentul este ' || v_dep);
end;


-- 7
set verify off
declare
    v_cod employees.employee_id%type := &t_cod;
    v_bonus number(8);
    v_salariu_anual number(8);
begin
    select salary * 12 into v_salariu_anual
    from employees
    where employee_id = v_cod;
    if v_salariu_anual >= 200001
        then v_bonus := 20000;
    elsif v_salariu_anual between 100001 and 200000
        then v_bonus := 10000;
    else v_bonus := 5000;
end if;
dbms_output.put_line('Bonusul este ' || v_bonus);
end;
/
set verify on

-- 8
declare
    v_cod employees.employee_id%type := &t_cod;
    v_bonus number(8);
    v_salariu_anual number(8);
begin
    select salary * 12 into v_salariu_anual
    from employees
    where employee_id = v_cod;
    case when v_salariu_anual >= 200001
            then v_bonus := 20000;
         when v_salariu_anual between 100001 and 200000
            then v_bonus := 10000;
         else v_bonus := 5000;
    end case;
dbms_output.put_line('Bonusul este ' || v_bonus);
end;
/

-- 9
create table emp_aan as select * from employees;

define p_cod_sal = 200
define p_cod_dep = 80
define p_procent = 20
declare 
    v_cod_sal emp_aan.employee_id%type := &p_cod_sal;
    v_cod_dept emp_aan.department_id%type := &p_cod_dept;
    v_procent number(8) := &p_procent;
begin
    update emp_aan
    set department_id = v_cod_dept, salary = salary + (salary * v_procent / 100)
    where employee_id = v_cod_sal;
    if sql%rowcount = 0 then
        dbms_output.put_line('Nu exista angajat cu acest cod');
    else dbms_output.put_line('Actualizare realizata' || v_cod_sal);
    end if;
end;
/
rollback;

-- 10
create table zile_aan
(id number,
data date,
nume_zi varchar2(30));

declare
    contor number(6) := 1;
    v_data date;
    maxim number(2) := last_day(sysdate) - sysdate;
begin
    loop
        v_data := sysdate + contor;
        insert into zile_aan
        values (contor, v_data, to_char(v_data, 'Day'));
        contor := contor + 1;
        exit when contor > maxim;
    end loop;
end;    
/

select * from zile_aan;

-- 11
declare
    contor number(6) := 1;
    v_data date;
    maxim number(2) := last_day(sysdate) - sysdate;
begin
    while contor <= maxim loop
        v_data := sysdate + contor;
        insert into zile_aan
        values (contor, v_data, to_char(v_data, 'Day'));
        contor := contor + 1;
    end loop;
end;    
/

-- 12
declare
    v_data date;
    maxim number(2) := last_day(sysdate) - sysdate;
begin
    for contor in 1..maxim loop
        v_data := sysdate + contor;
        insert into zile_aan
        values (contor, v_data, to_char(v_data, 'Day'));
    end loop;
end;    
/

-- 13
-- varianta 1
declare
    i positive := 1;
    max_loop constant positive := 10;
begin
    loop
        i := i + 1;
        if i > max_loop then
            dbms_output.put_line('in loop i = ' || i);
            goto urmator;
        end if;
    end loop;
    <<urmator>>
    i := 1;
    dbms_output.put_line('dupa loop i = ' || i);
end;

-- varianta 2
declare
    i positive := 1;
    max_loop constant positive := 10;
begin
    loop
        i := i + 1;
        dbms_output.put_line('in loop i = ' || i);
        exit when i > max_loop;
        end loop;

    
    i := 1;
    dbms_output.put_line('dupa loop i = ' || i);
end;

-- EXERCITII
-- 1
declare
    numar number(3) := 100;
    mesaj1 varchar2(255) := 'text 1';
    mesaj2 varchar2(255) := 'text 2';
begin
    declare
        numar number(3) := 1;
        mesaj1 varchar2(255) := 'text 2';
        mesaj2 varchar2(255) := 'text 3';
    begin
        numar := numar + 1;
        mesaj2 := mesaj2 || ' adaugat in sub-bloc';
    end;
    numar := numar + 1;
    mesaj1 := mesaj1 || ' adaugat in blocul principal';
    mesaj2 := mesaj2 || ' adaugat in blocul principal';
end;
-- a. 2
 -- b. text 2
 -- c. text 3 adaugat in sub-bloc
 -- d. 101
 -- e. text 1 adaugat un blocul principal
 -- f. text 2 adaugat in blocul principal
 
 
-- 2
create table octombrie_aan
(id number,
data date);
select * from title;



select * from member;
-- 3
set SERVEROUTPUT on
declare
    v_name varchar2(30) := '&name';
    v_selected_id member.member_id%type;
    v_rental_count number(2);
begin
    -- trebuie sa gasim id-ul membrului
    select member_id into v_selected_id
    from member
    where upper(first_name) = upper(v_name);
    select count(*) into v_rental_count
    from title t, rental r
    where t.title_id = r.title_id and member_id = v_selected_id;
    dbms_output.put_line(v_rental_count);
    
    exception
        when no_data_found then dbms_output.put_line('no data found');
        when too_many_rows then dbms_output.put_line('too many rows');
end;

-- 4

DECLARE
  numele member.last_name%type := '&input';
  rental_id number;
   rental_count NUMBER(2);
   total Number(3);
   procent number(2);
BEGIN
  SELECT member_id
  INTO rental_id
  FROM  member m
  WHERE lower(m.last_name)= lower(numele);

  SELECT COUNT(DISTINCT title_id)
  INTO rental_count
  FROM rental r, member m
  WHERE r.member_id = m.member_id
  and lower(m.last_name)= lower(numele);

  DBMS_OUTPUT.PUT_LINE(rental_count || ' filme imprumutate');
  
  Select count(*)
  into total
  from title;
  
  procent := rental_count/total;
  If procent >= 0.75
  then  DBMS_OUTPUT.PUT_LINE('category 1');
    elsif procent >=0.5 
      then  DBMS_OUTPUT.PUT_LINE('category 2');
        elsif procent>=0.25
            then DBMS_OUTPUT.PUT_LINE('category 3');
            else  DBMS_OUTPUT.PUT_LINE('category 4');
  end if;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('no data found');
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('too many rows');
 
END;
/
-- 5
create table member_aan as select * from member;
alter table member_aan add discount number default 0;
select * from member_aan;

DECLARE
  numele member.last_name%type := '&input';
  rental_id number;
   rental_count NUMBER(2);
   total Number(3);
   procent number(2);
BEGIN
  SELECT member_id
  INTO rental_id
  FROM  member m
  WHERE lower(m.last_name)= lower(numele);

  SELECT COUNT(DISTINCT title_id)
  INTO rental_count
  FROM rental r, member m
  WHERE r.member_id = m.member_id
  and lower(m.last_name)= lower(numele);

  DBMS_OUTPUT.PUT_LINE(rental_count || ' filme imprumutate');
  
  Select count(*)
  into total
  from title;
  
  procent := rental_count/total;
  If procent >= 0.75
  then  DBMS_OUTPUT.PUT_LINE('category 1');
        update member_aan set discount=10 where member_id = rental_id;
    elsif procent >=0.5 
      then  DBMS_OUTPUT.PUT_LINE('category 2');
      update member_aan set discount=5 where member_id = rental_id;
        elsif procent>=0.25
            then DBMS_OUTPUT.PUT_LINE('category 3');
            update member_aan set discount=3 where member_id = rental_id;
            else  DBMS_OUTPUT.PUT_LINE('category 4');
  end if;
      if SQL%rowcount >0
          then DBMS_OUTPUT.PUT_LINE( 'Discount adaugat pt membrul ' || Initcap(numele));
          else DBMS_OUTPUT.PUT_LINE (' Nu s-a facut update');
      end if;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('no data found');
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('too many rows');
 
END;
/