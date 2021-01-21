--1. Pe un tabel dependent din schema de examen implementati cu ajutorul unui trigger o constrangere de integritate la alegere. 
--(observatii: trebuie sa apara explicit pe ce tabel si care este constrangerea implementata.
-- NU POT SA AM DELETE SI UPDATE IN ACELASI TRIGGER????
-- DELETE ESTE DOAR PENTRU FOR EACH ROW?
-- DACA INCERC INSERAREA UNUI NOU ANGAJAT CARE APARTINE UNUI DEPARTAMENT CARE NU EXISTA
create or replace trigger constr_dept_linie
before insert or update of department_id on emp_aan
for each row
declare
    type tb_dept is table of dept_aan.department_id%type index by pls_integer;
    tb tb_dept;
    ok boolean := false;
begin
    -- trebuie sa salvez intr-o colectie toate departamentele
    select department_id 
    bulk collect into tb
    from dept_aan;
    -- daca departamentul pe care am vrut sa-l inseram odata cu angajatul(sal sa-l actualizam) nu exita => eroare
    for i in tb.first..tb.last loop
        if tb(i) = :new.department_id then
            ok := true;
        end if;
    end loop;
    -- daca ok a ramas tot false => nu exista departamentul
    if ok = false then
        raise_application_error(-20005, 'Nu exista departamentul avand codul ' || :new.department_id || '. Constrangerea de FK este incalcata.');
    end if;
end constr_dept_linie;

-- incerc sa actualizez un angajat cu un departament ce nu exista
select * from emp_aan;
update emp_aan
set department_id = 300
where employee_id = 176;



-- ar trebui caz separat si pentru update??
create or replace package dept_pack as
    type rec_dept is record (cod_dept departments.department_id%type, nr_ang number);
    type tablou is table of rec_dept index by pls_integer;
    tb tablou;
end dept_pack;


create or replace trigger dept_instr
before delete or update of department_id on dept_aan
begin
    select department_id, count(*) 
    bulk collect into dept_pack.tb
    from emp_aan
    group by department_id;
end dept_instr;

create or replace trigger dept_linie
before delete or update of department_id on dept_aan
for each row
begin
    dbms_output.put_line('A ajuns aici');
    for i in dept_pack.tb.first..dept_pack.tb.last loop
        if dept_pack.tb(i).cod_dept = :old.department_id then
            if dept_pack.tb(i).nr_ang is not null then
                raise_application_error(-20002, 'Nu se poate elimina sau actualiza acest departament');
            end if;
        end if;
    end loop;
end dept_linie;


select department_id, count(*)
from emp_aan
group by department_id
order by department_id;
select department_id from departments order by department_id;
-- n-are angajati => merge sa fac delete
delete from dept_aan where department_id = 270;
-- are angajati => se arunca exceptia
delete from dept_aan where department_id = 10;
-- PENTRU UPDATE
update dept_aan
set department_id = 300
where department_id = 10;
update dept_aan
set department_id = 300
where department_id = 270;
ROLLBACK;
--2.Implementati constrangerea prin care un magazin detine in stoc produse de o anumita categorie doar de la un singur producator.


--3. Implementati constrangerea prin care pe o factura nu pot sa existe mai mult de 10 produse distincte.
create or replace package factura_pachet as    
    -- tablou in care vreau sa retin codurile distincte ale produselor continute de o factura
    type tb_prd is table of number index by pls_integer;
    -- recordul care retine codul facturii si produsele de pe o factura(distincte)
    type rec_factura is record (cod_factura number, tablou tb_prd);
    -- un tablou de tipul record
    type tbf is table of  rec_factura index by pls_integer;
    -- declar un tablou de acest tip in care retin pentru fiecare factura(codul ei) ce produse se afla pe aceasta(codurile produselor)
    tb tbf;
end factura_pachet;

create or replace trigger trigger_factura_instr
before insert on contine
declare
    i number := 1;
    j number := 1;
begin
    -- in acest trigger trebuie sa initializez datele din pachet
    for c in (select id_factura from facturi) loop
        -- pentru un cod de factura caut toate produsele asociate ei
        tb(i).cod_factura := c.id_factura;
        j := 1;
        for prd in (select distinct(cod_produs) from contine where cod_factura = c.id_factura) loop
            -- trebuie sa adaug fiecare produs in tablou
            tb(i).tablou(j) := prd.cod_produs;
            j := j + 1;
        end loop;
    end loop;
end trigger_factura_instr;


create or replace trigger trigger_factura_linie
before insert on contine
for each row
declare
    ok boolean := false;
begin
    -- parcug vectorul de coduri de facturi si produse asociate
    for i in tb.first..tb.last loop
        if tb(i).cod_factura = :new.cod_factura then
             -- trebuie sa verific cate produse are acest cod de factura asociat
             -- daca deja are 10 produse => nu se mai poate insera nimic
             if tb(i).tablou.count >= 10 then
                -- inseamna ca deja am 10 produse 
                raise_application_error(-20004, 'Aceasta factura are deja 10 produse distincte');
            else
                -- trebuie sa vad daca produsul asociat mai exista
                for j in tb(i).tablou.first..tb(i).tablou.last loop
                    if tb(i).tablou(j) = :new.cod_produs then
                        ok := true;
                    end if;                    
                end loop;
                if ok = false then
                    if tb(i).tablou.count >= 10 then
                        raise_application_error(-20003, 'Deja exista 10 produse distincte pentru aceasta factura');
                    end if;                                        
                end if;
             end if;
        end if;
    end loop;
end trigger_factura_linie;






