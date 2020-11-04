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
set serveroutput on
declare
    type tablou_indexat is table of number index by pls_integer;
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
    -- c
    t.delete(t.first);
    t.delete(5, 7);
    t.delete(t.last);
    dbms_output.put_line('Primul element are indicele ' || t.first || ' si valoarea ' || nvl(t(t.first), 0));
    dbms_output.put_line('Ultimul element are indicele ' || t.last || ' si valoarea ' || nvl(t(t.last), 0));
    dbms_output.put_line('Tabloul are ' || t.count || ' elemente: ');
    for i in t.first..t.last loop
        if t.exists(i) then
            dbms_output.put(nvl(t(i), 0) || ' ');
        end if;
    end loop;
    dbms_output.new_line;
    
    -- d
    t.delete;
    dbms_output.put_line('Tabloul are ' || t.count || ' elemente.');
    
end;
    
    
-- 5
declare
    type tablou_indexat is table of emp_aan%rowtype
                            index by binary_integer;
    t tablou_indexat;                     
begin
    -- trebuie sa stergem primele doua linii din tabel
    delete from emp_aan
    where rownum <= 2
    returning employee_id, first_name, last_name, email, phone_number, hire_date,
              job_id, salary, commission_pct, manager_id, department_id
    bulk collect into t;
    
    -- afisarea elementelor tabloului
    dbms_output.put_line(t(1).employee_id || ' ' || t(1).last_name || ' ' || t(1).first_name);
    dbms_output.put_line(t(2).employee_id || ' ' || t(2).last_name || ' ' || t(2).first_name);
    
    -- inserarea celor 2 linii in tabel
    insert into emp_aan values t(1);
    insert into emp_aan values t(2);
    
end;

-- 6
declare
    type tablou_imbricat is table of number;
    t tablou_imbricat := tablou_imbricat();
begin
    -- a
    for i in 1..10 loop
        t.extend;
        t(i) := i;
    end loop;
    dbms_output.put('Tabloul are ' || t.count || ' elemente: ');
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
    
    dbms_output.put('Tabloul are ' || t.count || ' elemente: ');
    for i in t.first..t.last loop
        dbms_output.put(nvl(t(i), 0) || ' ');
    end loop;
    dbms_output.new_line;
    
    -- c
    t.delete(t.first);
    t.delete(5, 7);
    t.delete(t.last);
    dbms_output.put_line('Primul element are indicele ' || t.first || ' si valoarea ' || nvl(t(t.first), 0));
    dbms_output.put_line('Ultimul element are indicele ' || t.last || ' si valoarea ' || nvl(t(t.last), 0));
    dbms_output.put_line('Tabloul are ' || t.count || ' elemente: ');
    for i in t.first..t.last loop
        if t.exists(i) then
            dbms_output.put(nvl(t(i), 0) || ' ');
        end if;
    end loop;
    dbms_output.new_line;
    
    -- d
    t.delete;
    dbms_output.put_line('Tabloul are ' || t.count || ' elemente.');
    
            

end;


-- 7
declare
    type tablou_imbricat is table of char(1);
    t tablou_imbricat := tablou_imbricat('m', 'i', 'n', 'i', 'm');
    i integer;
begin
    -- afisare in ordine
    i := t.first;
    while i <= t.last loop
        dbms_output.put(t(i));
        i := t.next(i);
    end loop;
    dbms_output.new_line;
    
    -- afisare inversa
    i := t.last;
    while i >= t.first loop
        dbms_output.put(t(i));
        i := t.prior(i);
    end loop;
    dbms_output.new_line;
     -- stergem elementele cu index 2 si 4
    t.delete(2);
    t.delete(4);
    
    -- afisam elementele dupa stergere
    i := t.last;
    while i >= t.first loop
        dbms_output.put(t(i));
        i := t.prior(i);
    end loop;
    dbms_output.new_line;
end;
/

-- 8
declare
    type t_vector is varray(20) of number;
    t t_vector := t_vector();
begin
    -- a
    for i in 1..10 loop
        t.extend;
        t(i) := i;
    end loop;
    
    dbms_output.put('Tabloul are ' || t.count || ' elemente: ');
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
    
    dbms_output.put('Tabloul are ' || t.count || ' elemente:');
    for i in t.first..t.last loop
        dbms_output.put(nvl(t(i), 0) || ' ');
    end loop;
    dbms_output.new_line;
    
    -- c ->   DIN VECTOR NU SE POT STERGE ELEMENTE INDIVIDUALE
    
    -- d
    t.delete;
    dbms_output.put_line('Tabloul are ' || t.count || ' elemente.');
end;
/

-- 9
-- vector de dimensiune maxima 10
create or replace type subordonati_aan as array(10) of number(4);
/
-- tabel
create table manageri_aan (cod_mgr number(10), nume varchar(20), lista subordonati_aan);

declare
    v_sub subordonati_aan := subordonati_aan (100, 200, 300);
    v_lista manageri_aan.lista%type;
begin   
    -- adauga 3 linii in tabel
    insert into manageri_aan values (1, 'Manager 1', v_sub);
    insert into manageri_aan values (2, 'Manager 2', null);
    insert into manageri_aan values (3, 'Manager 3', subordonati_aan(700, 800));
    
    select lista
    into v_lista
    from manageri_aan
    where cod_mgr = 1;
    
    for j in v_lista.first..v_lista.last loop
        dbms_output.put_line(v_lista(j));
    end loop;

end;
/
drop table manageri_aan;
drop type subordonati_aan;


-- 10
-- creati tabelul emp_test_aan cu coloanele employee_id, last_name 
create table emp_test_aan as select employee_id, last_name
                             from employees
                             where rownum <= 2;
create or replace type tip_telefon_aan is table of varchar(11);
/
-- se adauga la emp_text_*** o coloana de tip_telefon
-- inserarea coloanei in tabel
alter table emp_test_aan
add (telefon tip_telefon_aan)
nested table telefon store as tabel_telefon_aan;

-- inserare linie noua
insert into emp_test_aan
values (500, 'Andronic', tip_telefon_aan('1234562345', '123456', '1234567'));

-- actualizare linie din tabel
update emp_test_aan
set telefon = tip_telefon_aan('0231456', '1236547')
where employee_id = 100;

-- afisarea informatiilor din tabel
select a.employee_id, b.*
from emp_test_aan a, table(a.telefon) b;

drop table emp_test_aan;
drop type tip_telefon_aan;