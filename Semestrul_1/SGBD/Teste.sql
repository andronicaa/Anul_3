-- instructiunea while
set serveroutput on
declare
    i natural := 1;
begin
    while i <= 10 loop
        dbms_output.put(i**2 || ' ');
        i := i + 1;
    end loop;
    dbms_output.new_line;
    dbms_output.put_line('Iesire cand i = ' || i);
end;

declare
    i natural := 1;
begin
    while i <= 10 loop
        dbms_output.put(i**2 || ' ');
        i := i + 1;
        continue when i <= 5;
        dbms_output.new_line;
    end loop;
    dbms_output.new_line;
    dbms_output.put_line('Iesire cand i = ' || i);
end;

begin
    for i in reverse 1..10 loop
        dbms_output.put(i**2 || ' ');
        continue when i <= 5;
        dbms_output.new_line;
    end loop;
    dbms_output.new_line;
end;

declare
    i int(1);
begin
    for i in 1..5 loop
        if i = 3 then
            goto etic;
        else
            dbms_output.put_line('i= '||i);
        end if;
    end loop;
    <<etic>>
    dbms_output.put_line('Stop cand i = ' || i);
end;

declare
    j int(1);
begin
    for i in 1..5 loop
        j := i;
        if i = 3 then
            goto etic;
        else
            dbms_output.put_line('i= '||i);
        end if;
    end loop;
    <<etic>>
    dbms_output.put_line('Stop when i = ' || j);
end;


-- Vector imbricat
create type t_imb_categ is table of varchar2(40);
/
create table raion_grupe_imb (id_categori number(4) primary key,
                              denumire varchar2(40),
                              grupe t_imb_categ)
nested table grupe store as tab_imb_grupe;

insert into raion_grupe_imb
values (1, 'r1', t_imb_categ('r11', 'r12'));

insert into raion_grupe_imb
values (2, 'r2', t_imb_categ('r21'));

insert into raion_grupe_imb(id_categori, denumire)
values (3, 'r3');

update raion_grupe_imb
set grupe = t_imb_categ('r31', 'r32')
where id_categori = 3;

select * from raion_grupe_imb;

select id_categori, denumire, b.*
from raion_grupe_imb a, table(a.grupe) b;

select grupe
from raion_grupe_imb
where id_categori = 1;

select * 
from table(select grupe
           from raion_grupe_imb
           where id_categori = 1);


-- Colectii pe mai multe niveluri
declare
    type t_linie is varray(3) of integer;
    type matrice is varray(3) of t_linie;
    v_linie t_linie := t_linie(4, 5, 6);
    a matrice := matrice(t_linie(1, 2, 3), v_linie);
begin
    -- adaugam un element de tip vector in matrice(o linie noua)
    a.extend;
    a(3) := t_linie(7, 8);
    -- se extinde a(3)
    a(3).extend;
    -- se adauga valoarea elementului nou
    a(3)(3) := 9;
    for i in 1..3 loop
        for j in 1..3 loop
            dbms_output.put(a(i)(j) || ' ');
        end loop;
        dbms_output.new_line;
    end loop;
end;


-- adaugare element in colectie
insert into table (select grupe
                   from raion_grupe_imb
                   where id_categori = 1)
values('r13');       

select * from raion_grupe_imb;

-- actualizare
update table (select grupe
              from raion_grupe_imb
              where id_categori = 1) a
set value(a) = 'r1333'
where column_value = 'r13';

-- Laborator 2 (Madalina)
-- sa se afiseze codul, numele, salariul si codul departamentului din care face parte
-- un angajat al carui cod este introdus de utilizator de la tastatura
-- a
select employee_id, last_name, salary, department_id
from employees
where employee_id = &p_cod;

-- b
define p_cod
select employee_id, last_name, salary, department_id
from employees
where employee_id = &p_cod;
undefine p_cod;