-- 1. Definiti un bloc anonim care afiseaza mesajul "Hello World"

set serveroutput on
begin
dbms_output.put_line('Hello World');
end;

-- 2. Definiti un bloc anonim care citeste de la tastatura cod de angajat si ii afiseaza numele
set serveroutput on
declare
    cod_angajat number(20);
    nume_angajat varchar(20);
begin
    cod_angajat := '&user_angajat';
    select first_name into nume_angajat 
    from employees
    where employee_id = cod_angajat;
    dbms_output.put_line('Angajatul cu codul dat este ' || nume_angajat);
end;

-- 3. Definiti un bloc anonim care citeste de la tastatura nume de angajat si afiseaza salariul
set serveroutput on
declare 
    nume_angajat varchar(20);
    salariu number(20);
begin
    nume_angajat := '&user_nume';
    select salary into salariu
    from employees
    where upper(last_name) = upper(nume_angajat);
    dbms_output.put_line('Angajatul cu codul dat este ' || salariu);
end;



