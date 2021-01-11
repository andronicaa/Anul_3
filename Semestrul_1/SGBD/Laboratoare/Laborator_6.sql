
-- Exercitiul 1
select * from emp_aan;
create or replace trigger trig1_aan
    before insert or update or delete on emp_aan
begin
    if to_char(sysdate, 'D') = 1 or to_char(sysdate, 'hh24') not between 8 and 9 then
        raise_application_error(-20001, 'tabelul nu poate fi actualizat');
    end if;
end;
rollback;
delete from emp_aan where employee_id < 102;
drop trigger trig1_aan;
-- 2
-- varianta 1
create or replace trigger trig21_aan
    before update of salary on emp_aan
    for each row
begin
    if :new.salary < :old.salary then
        raise_application_error(-20002, 'Salariul nu poate fi micsorat');
    end if;
end;
/
update emp_aan
set salary = salary - 100;
drop trigger trig21_aan;
-- varianta 2
create or replace trigger trig22_aan
    before update of salary on emp_aan
    for each row
    when (new.salary < old.salary)
begin
    raise_application_error(-20002, 'Salariul nu poate fi miscosat');
end;
/
update emp_aan
set salary = salary + 100;
drop trigger trig22_aan;

-- 3
create table job_grades_aan as select * from job_grades;

create or replace trigger trig3_aan
    before update of lowest_sal, highest_sal on job_grades_aan
    for each row
declare
    v_min_sal emp_aan.salary%type;
    v_max_sal emp_aan.salary%type;
    exceptie exception;
begin
    select min(salary), max(salary)
    into v_min_sal, v_max_sal
    from emp_aan;
    if :old.grade_level = 1 and v_min_sal < :new.lowest_sal then
        raise exceptie;
    end if;
    
    if :old.grade_level = 7 and v_max_sal > :new.highest_sal then
        raise exceptie;
    end if;
exception
    when exceptie then
        raise_application_error(-20003, 'Exista salarii care se gasesc in afara intervalului');
end;

update job_grades_aan
set lowest_sal = 3000
where grade_level = 1;

update job_grades_aan
set highest_sal  = 20000
where grade_level = 7;


-- 4
create table info_dept_aan (cod_dept number,
                            nume_dept varchar2(20),
                            plati number);
                            
create or replace procedure modific_plati_aan (v_cod info_dept_aan.cod_dept%type,
                                               v_plati info_dept_aan.plati%type) as
begin
    update info_dept_aan
    set plati = nvl(plati, 0) + v_plati
    where cod_dept = v_cod;
end modific_plati_aan;


-- adaug informatii in coloana plati
insert into info_dept_aan
select d.department_id, department_name, nvl(sum(salary), 0)
from employees e, departments d
where e.department_id(+) = d.department_id
group by d.department_id, department_name;
rollback;
select * from info_dept_aan;
create or replace trigger trig4_aan
    after delete or update or insert of salary on emp_aan
    for each row
begin
    if deleting then
        modific_plati_aan(:old.department_id, -1 * :old.salary);
    elsif updating then
        -- adaug diferenta
        modific_plati_aan(:old.department_id, :new.salary - :old.salary);
    else
        -- pentru un id nou => trebuie sa se actualizeze si suma salariilor
        modific_plati_aan(:new.department_id, :new.salary);
    end if;
end;

select * from info_dept_aan where cod_dept = 90;
drop table info_dept_aan;

-- 5
drop table info_dept_aan;
drop table info_emp_aan;
create table info_dept_aan
(id number(3) primary key,
nume_dept varchar(50),
plati number);


create table info_emp_aan
(id number(3) primary key,
nume varchar(50),
prenume varchar(50),
salariu number(6),
id_dept number(3) references info_dept_aan);

desc info_emp_aan;
desc info_dept_aan;
alter table info_dept_aan drop column numar;
insert into info_emp_aan
select employee_id, last_name, first_name, salary, department_id
from  employees;

CREATE OR REPLACE VIEW v_info_aan AS
  SELECT e.id, e.nume, e.prenume, e.salariu, e.id_dept, 
         d.nume_dept, d.plati 
  FROM   info_emp_aan e, info_dept_aan d
  WHERE  e.id_dept = d.id;

-- se pot realiza actualizari asupra acestei vizualizari? care este tabelul protejat prin cheie
SELECT *
FROM   user_updatable_columns
WHERE  table_name = UPPER('v_info_aan');

create or replace function verif_ex_cod_dept(cod_dept number)
    return number is
        ex_cod number;
    begin
        select count(*) into ex_cod
        from info_dept_aan
        where id = cod_dept;
        return ex_cod;
end verif_ex_cod_dept;

begin
    dbms_output.put_line(verif_ex_cod_dept(500));
end;
CREATE OR REPLACE TRIGGER trig5_aan
    INSTEAD OF INSERT OR DELETE OR UPDATE ON v_info_aan
    FOR EACH ROW
BEGIN
IF INSERTING THEN 
    -- inserarea in vizualizare determina inserarea 
    -- in info_emp_mng si reactualizarea in info_dept_mng
    -- se presupune ca departamentul exista
    -- trebuie sa verificam daca mai exista acest departament
    -- daca nu exista il adaugam mai intai pe acesta in tabelul cu departmente
        if verif_ex_cod_dept(:new.id_dept) = 0 then
            -- adaugam departamentul in tabelul info_dept_aan
            insert into info_dept_aan
            values (:new.id_dept, :new.nume_dept, 0);
        end if;
       INSERT INTO info_emp_aan
       VALUES (:NEW.id, :NEW.nume, :NEW.prenume, :NEW.salariu,
               :NEW.id_dept);
         
       UPDATE info_dept_aan
       SET    plati = plati + :NEW.salariu
       WHERE  id = :NEW.id_dept;

ELSIF DELETING THEN
   -- stergerea unui salariat din vizualizare determina
   -- stergerea din info_emp_mng si reactualizarea in
   -- info_dept_mng
   DELETE FROM info_emp_aan
   WHERE  id = :OLD.id;
     
   UPDATE info_dept_aan
   SET    plati = plati - :OLD.salariu
   WHERE  id = :OLD.id_dept;

ELSIF UPDATING ('salariu') THEN
   /* modificarea unui salariu din vizualizare determina 
      modificarea salariului in info_emp_mng si reactualizarea
      in info_dept_mng    */
    	
   UPDATE  info_emp_aan
   SET     salariu = :NEW.salariu
   WHERE   id = :OLD.id;
    	
   UPDATE info_dept_aan
   SET    plati = plati - :OLD.salariu + :NEW.salariu
   WHERE  id = :OLD.id_dept;

ELSIF UPDATING ('id_dept') THEN
    /* modificarea unui cod de departament din vizualizare
       determina modificarea codului in info_emp_mng 
       si reactualizarea in info_dept_mng  */  
    UPDATE info_emp_aan
    SET    id_dept = :NEW.id_dept
    WHERE  id = :OLD.id;
    
    UPDATE info_dept_aan
    SET    plati = plati - :OLD.salariu
    WHERE  id = :OLD.id_dept;
    	
    UPDATE info_dept_aan
    SET    plati = plati + :NEW.salariu
    WHERE  id = :NEW.id_dept;
  END IF;
END;
/

-- adaugarea unui nou angajat
select * from info_dept_aan where id = 10;
insert into v_info_aan
values (400, 'N1', 'P1', 3000, 10, 'Nume dept', 0);

select * from info_dept_aan;
insert into v_info_aan
values (207, 'Andronic', 'Alexandra', 3000, 500, 'Num d', 0);
insert into v_info_aan
values (208, 'Andronic', 'Alexandru', 2000, 500, 'Num d', 0);
select * from info_emp_aan;
select * from info_dept_aan;
rollback;

-- modificarea salariului unui angajat
update v_info_aan
set salariu = salariu + 1000
where id = 400;

-- modificarea departamentului unui angajat
select * from info_dept_aan where id = 90;
update v_info_aan
set id_dept = 90
where id = 400;
select * from info_emp_aan where id = 400;
select * from info_dept_aan where id in (10, 90);

-- adaugarea unui angajat cu un cod de departament nou
select * from info_emp_aan;
-- eliminarea unui angajat
delete from v_info_aan where id = 400;


-- 7
-- a
create table audit_aan (utilizator varchar2(20),
                        nume_bd varchar2(20),
                        eveniment varchar2(20),
                        nume_obiect varchar2(20),
                        data_modif date);

-- b
create or replace trigger trig7_aan
after create or drop or alter on schema
begin
    insert into audit_aan
    values (sys.login_user, sys.database_name, sys.sysevent, sys.dictionary_obj_name, sysdate);
end;

-- 8
create or replace package pachet8 is
    smin emp_aan.salary%type;
    smax emp_aan.salary%type;
    smed emp_aan.salary%type;
end pachet8;
-- declansator la nivel de comanda in care se act variabilele din pachet
create or replace trigger trig81_aan
before update of salary on emp_aan
begin
    select min(salary), avg(salary), max(salary)
    into pachet8.smin, pachet8.smed, pachet8.smax
    from emp_aan;
end;
/
-- declansator la nivel de linie care sa realizeze verificare conditiilor
create or replace trigger trig82_aan
before update of salary on emp_aan
for each row
begin
    if (:old.salary = pachet8.smin) and (:new.salary > pachet8.smed) then
        raise_application_error(-20001, 'Acest salariu depaseste valoarea medie');    
    elsif (:old.salary = pachet8.smax) and (:new.salary < pachet8.smed)
        raise_application_error(-20001, 'Acest salariu este sub valoarea medie');
    end if; 
    
    
end;


-- EXERCITII
-- 1
select * from dept_aan;
create or replace trigger trig_ex_1
before delete on dept_aan
begin
    if user != 'SCOTT' then
        raise_application_error(-20000, 'doar scott poate sterge acest tabel');
    end if;
end;

delete from dept_aan;


-- 2
CREATE OR REPLACE TRIGGER trig_comision_mrz
BEFORE UPDATE OF commission_pct ON emp_mrz
FOR EACH ROW
BEGIN
    IF (:NEW.commission_pct > 0.5) THEN
        RAISE_APPLICATION_ERROR(-20202,'Comision prea mare');
    END IF;
END;
/

-- 3
-- a
alter table info_dept_aan
add (numar number);

update info_dept_aan d
set numar = (select count(*)
             from info_dept_aan
             where d.id = id);

-- b
create or replace trigger trig_ex_3
after update or delete or insert of numar on info_dept_aan
begin
    update info_dept_aan d
    set numar = (select count(*)
                 from info_dept_aan
                 where d.id = id);
end;

-- 4
create or replace trigger trig_ex_4
before insert on emp_aan
for each row
declare
    v_nr_ang number;
begin
    select count(*) into v_nr_ang
    from emp_aan
    where :new.department_id = department_id;
    
    if v_nr_ang >= 45 then
        raise_application_error(-20000, 'Sunt mai mult de 45 de persoane');
    end if;
end;

select department_id, count(*)
from emp_aan
group by department_id;

insert into emp_aan(employee_id, department_id)
values (207, 50);


-- 5
-- a
drop table emp_test_aan;
drop table dept_test_aan;
create table emp_test_aan (cod_emp number primary key,
                           last_name varchar2(20),
                           first_name varchar2(20),
                           department_id number,
                            foreign key(department_id) references dept_test_aan(department_id) on delete cascade);

create table dept_test_aan (department_id number primary key,
                            department_name varchar2(20));  
insert into dept_test_aan
select department_id, department_name
from departments;
insert into emp_test_aan
select employee_id, last_name, first_name, department_id
from employees;
-- b
-- stergeri si modificari in cascada
drop trigger dep_cascada_aan;
create or replace trigger dep_cascada_aan
before delete or update of department_id on dept_test_aan
for each row
begin
    if deleting then
        delete from emp_test_aan
        where department_id = :old.department_id;
    end if;
    if updating and :old.department_id != :new.department_id then
        update emp_test_aan
        set department_id := :new.department_id
        where department_id := :old.department_id;
    end if;
end;
select * from emp_test_aan where department_id = 10;
delete from dept_test_aan
where department_id = 10;
