-- Declararea si initializarea variabilelor
-- var a
set SERVEROUTPUT on;
declare 
    v_myName varchar(20);
begin
    dbms_output.put_line('My name is: ' || v_myName); -- nu afiseaza nimic
    v_myName := 'John';
    dbms_output.put_line('My name is: ' || v_myName);
end;

-- var b
declare 
    v_myName varchar(20) := 'John';
begin
    v_myName := 'Steven'; -- i se atribuie o noua valoarea => o variabile poate fi reasignata
    dbms_output.put_line('My name is: ' || v_myName);
end;

-- CLASIFICAREA VARIABILELOR
-- Scalare
-- Pointer
-- Colectii
-- Obiecte externe

-- Pentru initializare se foloseste " := " sau DEFAULT
-- Pentru a "obliga" ca o variabila sa retina intotdeauna o valoare se foloseste NOT NULL


-- Variabile de legatura
-- denumire variabile host
-- NU sunt variabile globale
-- ex

variable b_result number
begin
    select (salary * 12) + nvl(comission_pct, 0) into :b_result
    from employees
    where employees_id = 144;
end;
print b_result

-- IMPORTANT: Intr-un bloc PL/SQL sunt disponibile toate functiile single-row
-- NU sunt disponibile functiile grup si functia DECODE


-- Utilizarea variabilelor in cadrul blocurilor imbricate 
-- exemplu 1
set SERVEROUTPUT on;
declare
    v_outer_variable varchar2(20) := 'Variabila Globala';
begin
    declare
        v_inner_variable varchar2(20) := 'Variabila Locala';
    begin
        dbms_output.put_line(v_inner_variable); -- variabila locala
        dbms_output.put_line(v_outer_variable); -- variabila globala
    end;
    dbms_output.put_line(v_outer_variable);
end;

-- exemplu 2
set serveroutput on;
declare
    v_father_name varchar2(20) := 'Patrick';
    v_date_of_birth date := '20-Apr-1972';
begin
    declare
        v_child_name varchar2(20) := 'Mike';
        v_date_of_birth date := '12-Dec-2002';
    begin
        dbms_output.put_line('Numele tatalui: ' || v_father_name);
        dbms_output.put_line('Data de nastere ' || v_date_of_birth); -- o sa ia ca data de nastere pe cea a copilului deoarece este declarata ca variabila locala
        
        dbms_output.put_line('Nume copilului ' || v_child_name);
    end;
    -- variabila globala -> o sa afiseze data de nastere a tatalui
    dbms_output.put_line('Data de nastere: ' || v_date_of_birth);
end;

-- Exercitiu
begin <<outer>>
declare 
    v_sal number(7, 2) := 60000;
    v_comm number(7, 2) := v_sal * 0.20;
    v_message varchar2(255) := 'eligible for commission';
begin
    declare
        v_sal number(7, 2) := 50000;
        v_comm number(7, 2) := 0;
        v_total_comp number(7, 2) := v_sal + v_comm;
    begin
    -- CLERK not eligible for comission
        v_message := 'CLERK not ' || v_message;
        outer.v_comm := v_sal * 0.30;
    end;
    -- SALESMANCLERCK not eligible for comission
        v_message := 'SALESMAN' || v_message;
end;
end outer;

-- Formatarea unui bloc anonim
DECLARE
    v_fname VARCHAR2(20);
BEGIN
    SELECT
        first_name
    INTO v_fname
    FROM
        employees
    WHERE
        employee_id = 100;

END;

