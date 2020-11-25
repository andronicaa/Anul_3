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
-- 3
select * from emp_aan;
alter table emp_aan drop column vechime;
declare
    v_ang1 emp_aan%rowtype;
    v_ang2 emp_aan%rowtype;
begin
    -- sterg angajatii ce au codurile 100 si 101
    -- 100
    delete from emp_aan
    where employee_id = 100
    returning employee_id, first_name, last_name, email, phone_number, hire_date,
              job_id, salary, commission_pct, manager_id, department_id
    into v_ang1;
    -- 101
    delete from emp_aan
    where employee_id = 101
    returning employee_id, first_name, last_name, email, phone_number, hire_date,
              job_id, salary, commission_pct, manager_id, department_id
    into v_ang2;
    
    -- introducem informatiile sterge in tabel
    insert into emp_aan
    values v_ang1;
    
    insert into emp_aan
    values v_ang2;
    
    
end;

-- 4

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
    dbms_output.put_line('Afisare cu for reverse ');
    for i in reverse t.first..t.last loop
        dbms_output.put(t(i));
    end loop;
    dbms_output.new_line;
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


-- Exercitii
-- 1
set serveroutput on
declare
    type tip_cod is varray(5) of emp_aan.employee_id%type;
    coduri tip_cod;
    salariu emp_aan.salary%type;
begin
    select employee_id
    bulk collect into coduri
    from (  select employee_id, salary
            from emp_aan
            where commission_pct is null order by salary)
    where rownum <= 5;
    for i in coduri.first..coduri.last loop
        select salary
        into salariu
        from emp_aan
        where employee_id = coduri(i);
        dbms_output.put_line('Angajatul cu codul ' || coduri(i) || ' are salariul vechi ' || salariu);
        update emp_aan
        set salary = salary * 1.05
        where employee_id = coduri(i);
        select salary
        into salariu
        from emp_aan
        where employee_id = coduri(i);
        dbms_output.put_line('Angajatul cu codul ' || coduri(i) || ' are salariul nou ' || salariu);
        dbms_output.new_line;
    end loop;
    
end;



-- Tema 
-- Exercitiul 2
create or replace type tip_orase_aan as varray(20) of varchar2(20);
/
create table excursie_aan (cod_excursie number(4),
                           denumire varchar2(20),
                           orase tip_orase_aan,
                           status varchar2(15));
    
-- a. Inserati 5 inregistrari in tabel
    insert into excursie_aan
    values (100, 'Excursie1', tip_orase_aan('Bucuresti', 'Brasov', 'Sibiu'), 'disponibila');
    insert into excursie_aan
    values (101, 'Excursie2', tip_orase_aan('Iasi', 'Suceava', 'Chisinau'), 'anulata');
    insert into excursie_aan
    values (102, 'Excursie3', tip_orase_aan('Focsani', 'Galati', 'Tulcea'), 'disponibila');
    insert into excursie_aan
    values (103, 'Excursie4', tip_orase_aan('Bucuresti', 'Pitesti', 'Targu Jiu'), 'disponibila');
    insert into excursie_aan
    values (104, 'Excursie5', tip_orase_aan('Constanta', 'Braila', 'Buzau', 'Focsani'), 'anulata');
/    
select * from excursie_aan;           
commit;                  
-- b. Actualizati coloana orase pentru o excursie specificata   
-- adaugati un nou oras in lista => va fi ultimul vizitat in excursia respectiva
/
declare
    v_cod_exc excursie_aan.cod_excursie%type := &p_cod_exc;
    v_oras_nou varchar2(20) := '&p_oras_nou';
    v_orase tip_orase_aan;
begin
    select orase into v_orase
    from excursie_aan
    where cod_excursie = v_cod_exc;
    
    -- trebuie sa extind vectorul
    v_orase.extend;
    -- adaug orasul dat de la tastatura
    v_orase(v_orase.count) := v_oras_nou;
    
    -- actualizez in tabel
    update excursie_aan
    set orase = v_orase
    where cod_excursie = v_cod_exc;
    
exception
    when no_data_found then
        dbms_output.put_line('Nu exista excursia cu codul specificat');
    when others then
        dbms_output.put_line('Eroare');
end;
/
select * from excursie_aan;   
/
-- adaugati un oras nou in lista ce va fi al doilea oras vizitat in excursia respectiva
declare
    v_cod_exc excursie_aan.cod_excursie%type := &p_cod_exc;
    v_oras_nou varchar2(20) := '&p_oras_nou';
    v_orase tip_orase_aan;
begin
    -- trebuie sa extragem lista cu orase din excursia respectiva
    select orase into v_orase
    from excursie_aan
    where cod_excursie = v_cod_exc;
    
    v_orase.extend;
    -- trebuie sa mut elementele din lista pentru a-l adauga pe cel nou pe pozitia a doua
    for i in reverse v_orase.next(2)..v_orase.last loop
        v_orase(i) := v_orase(i-1);
    end loop;
    -- trebuie sa adaug pe pozitia 2 orasul
    v_orase(2) := v_oras_nou;
    
    -- actualizez in tabel
    update excursie_aan 
    set orase = v_orase
    where cod_excursie = v_cod_exc;
exception
    when no_data_found then
        dbms_output.put_line('Nu exista excursia cu codul specificat');
    when others then
        dbms_output.put_line('Eroare');
end;
/
select * from excursie_aan;
/

-- inversati ordinea de vizitare a doua dintre orase al caror nume este specificat
declare
    v_cod_exc excursie_aan.cod_excursie%type := &p_cod_exc;
    v_orase tip_orase_aan;
    v_oras1 varchar2(20) := '&p_oras1';
    v_oras2 varchar2(20) := '&p_oras2';
    v_index_oras1 number;
    v_index_oras2 number;
    v_aux varchar2(20);
begin
    select orase into v_orase
    from excursie_aan
    where cod_excursie = v_cod_exc;
    
    -- gasesc indexul primului oras
    for i in v_orase.first..v_orase.last loop
        if upper(v_orase(i)) = upper(v_oras1) then
            v_index_oras1 := i;
        elsif upper(v_orase(i))= upper(v_oras2) then
            v_index_oras2 := i;
        end if;
    end loop;
    
    -- interschimb ordinea celor doua orase in vector
    v_aux := v_orase(v_index_oras1);
    v_orase(v_index_oras1) := v_orase(v_index_oras2);
    v_orase(v_index_oras2) := v_aux;
    
    -- actualizez in tabel
    update excursie_aan
    set orase = v_orase
    where cod_excursie = v_cod_exc;
exception
    when no_data_found then
        dbms_output.put_line('Nu exista excursia cu codul specificat');
    when others then
        dbms_output.put_line('Eroare');
end;
/
select * from excursie_aan;
/
-- eliminati din lista un oras al carui nume este specificat

declare
    v_cod_exc excursie_aan.cod_excursie%type := &p_cod_exc;
    v_orase tip_orase_aan;
    v_oras1 varchar2(20) := '&p_oras1';
    v_index number;
begin
    select orase into v_orase
    from excursie_aan
    where cod_excursie = v_cod_exc;
    -- trebuie sa fiu atenta daca se repeta orasele
    for i in v_orase.first..v_orase.last loop
        if upper(v_orase(i)) = upper(v_oras1) then
            v_index := i;
        end if;
    end loop;
    v_index := v_index + 1;
    -- trebuie sa-l sterg din lista
    -- vreau sa verific daca merge si cu v_orase.last
    for i in v_index..v_orase.count loop
        v_orase(i-1) := v_orase(i);
    end loop;
    -- trebuie sa sterg ultimul element ramas null
    v_orase.trim;
    update excursie_aan
    set orase = v_orase
    where cod_excursie = v_cod_exc;
exception
    when no_data_found then
        dbms_output.put_line('Nu exista excursia cu codul specificat');
    when others then
        dbms_output.put_line('Eroare');
end;
/
select * from excursie_aan;
/

-- c. Pentru o excursie al cãrui cod este dat, afi?a?i numãrul de ora?e vizitate, respectiv numele ora?elor
declare
    v_cod_exc excursie_aan.cod_excursie%type := &p_cod_exc;
    v_orase tip_orase_aan;
begin
    select orase into v_orase
    from excursie_aan
    where cod_excursie = v_cod_exc;
    -- trebuie sa afisam numarul de orase vizitate
    dbms_output.put_line('In excusia cu codul ' || v_cod_exc || ' s-au vizitat ' || v_orase.count || ' excursii.');
   
    for i in v_orase.first..v_orase.last loop
        dbms_output.put(v_orase(i) || ' ');
    end loop;   
    dbms_output.new_line;
exception
    when no_data_found then
        dbms_output.put_line('Nu exista excursia cu codul specificat');
    when others then
        dbms_output.put_line('Eroare');
end;
/

-- d. Pentru fiecare excursie afi?a?i lista ora?elor vizitate
begin
    for i in (select * from excursie_aan) loop
        dbms_output.put('Excursia cu codul ' || i.cod_excursie || ' prin orasele ');
        for j in i.orase.first..i.orase.last loop
            dbms_output.put(i.orase(j) || ' ');
        end loop;
        dbms_output.put(' cu statusul de ' || i.status);
        dbms_output.new_line;
    end loop;
end;
/
select * from excursie_aan;
/
-- e. Anula?i excursiile cu cele mai pu?ine ora?e vizitate
declare
    v_min_orase number := 100000;
    v_count_oras number;
begin
    for i in (select orase from excursie_aan) loop
        v_count_oras := i.orase.count;
        if v_count_oras < v_min_orase then
            v_min_orase := v_count_oras;
        end if;
    end loop;
    for i in (select * from excursie_aan) loop
        if i.orase.count = v_min_orase then
            -- trebuie sa actualizez statusul
            update excursie_aan
            set status = 'anulata'
            where cod_excursie = i.cod_excursie;
        end if;
    end loop;
    
end;
/

-- Exercitiul 3
drop table excursie_aan;

create or replace type orase_aan is table of varchar2(20);
/
create table excursie_aan (cod_excursie number(4),
                           denumire varchar2(20),
                           orase orase_aan,
                           status varchar2(15))
nested table orase store as orase_exc;

-- a. Inserati 5 inregistrari in tabel
    insert into excursie_aan
    values (100, 'Excursie1', orase_aan('Bucuresti', 'Brasov', 'Sibiu'), 'disponibila');
    insert into excursie_aan
    values (101, 'Excursie2', orase_aan('Iasi', 'Suceava', 'Chisinau'), 'anulata');
    insert into excursie_aan
    values (102, 'Excursie3', orase_aan('Focsani', 'Galati', 'Tulcea'), 'disponibila');
    insert into excursie_aan
    values (103, 'Excursie4', orase_aan('Bucuresti', 'Pitesti', 'Targu Jiu'), 'disponibila');
    insert into excursie_aan
    values (104, 'Excursie5', orase_aan('Constanta', 'Braila', 'Buzau', 'Focsani'), 'anulata');

/    
select * from excursie_aan;           
commit;     
-- b. Actualiza?i coloana orase  pentru o excursie specificatã:  - adãuga?i un ora? nou în listã, ce va fi ultimul vizitat în excursia respectivã; 
declare
    v_cod_exc excursie_aan.cod_excursie%type := &p_cod_exc;
    v_oras_nou varchar2(20) := '&p_oras_nou';
    v_orase orase_aan;
begin
    select orase into v_orase
    from excursie_aan
    where cod_excursie = v_cod_exc;
    
    -- trebuie sa extind vectorul
    v_orase.extend;
    -- adaug orasul dat de la tastatura
    v_orase(v_orase.count) := v_oras_nou;
    
    -- actualizez in tabel
    update excursie_aan
    set orase = v_orase
    where cod_excursie = v_cod_exc;
    
exception
    when no_data_found then
        dbms_output.put_line('Nu exista excursia cu codul specificat');
    when others then
        dbms_output.put_line('Eroare');
end;
/
select * from excursie_aan;
/
-- adãuga?i un ora? nou în listã, ce va fi al doilea ora? vizitat în excursia respectivã;
declare
    v_cod_exc excursie_aan.cod_excursie%type := &p_cod_exc;
    v_oras_nou varchar2(20) := '&p_oras_nou';
    v_orase orase_aan;
begin
    -- trebuie sa extragem lista cu orase din excursia respectiva
    select orase into v_orase
    from excursie_aan
    where cod_excursie = v_cod_exc;
    
    v_orase.extend;
    -- trebuie sa mut elementele din lista pentru a-l adauga pe cel nou pe pozitia a doua
    for i in reverse v_orase.next(2)..v_orase.last loop
        v_orase(i) := v_orase(i-1);
    end loop;
    -- trebuie sa adaug pe pozitia 2 orasul
    v_orase(2) := v_oras_nou;
    
    -- actualizez in tabel
    update excursie_aan 
    set orase = v_orase
    where cod_excursie = v_cod_exc;
exception
    when no_data_found then
        dbms_output.put_line('Nu exista excursia cu codul specificat');
    when others then
        dbms_output.put_line('Eroare');
end;
/
select * from excursie_aan;
/
-- inversati ordinea de vizitare a doua dintre orase al caror nume este specificat
declare
    v_cod_exc excursie_aan.cod_excursie%type := &p_cod_exc;
    v_orase orase_aan;
    v_oras1 varchar2(20) := '&p_oras1';
    v_oras2 varchar2(20) := '&p_oras2';
    v_index_oras1 number;
    v_index_oras2 number;
    v_aux varchar2(20);
begin
    select orase into v_orase
    from excursie_aan
    where cod_excursie = v_cod_exc;
    
    -- gasesc indexul primului oras
    for i in v_orase.first..v_orase.last loop
        if upper(v_orase(i)) = upper(v_oras1) then
            v_index_oras1 := i;
        elsif upper(v_orase(i))= upper(v_oras2) then
            v_index_oras2 := i;
        end if;
    end loop;
    
    -- interschimb ordinea celor doua orase in vector
    v_aux := v_orase(v_index_oras1);
    v_orase(v_index_oras1) := v_orase(v_index_oras2);
    v_orase(v_index_oras2) := v_aux;
    
    -- actualizez in tabel
    update excursie_aan
    set orase = v_orase
    where cod_excursie = v_cod_exc;
exception
    when no_data_found then
        dbms_output.put_line('Nu exista excursia cu codul specificat');
    when others then
        dbms_output.put_line('Eroare');
end;
/
select * from excursie_aan;
/
-- eliminati din lista un oras al carui nume este specificat

declare
    v_cod_exc excursie_aan.cod_excursie%type := &p_cod_exc;
    v_orase orase_aan;
    v_oras1 varchar2(20) := '&p_oras1';
    v_index number;
begin
    select orase into v_orase
    from excursie_aan
    where cod_excursie = v_cod_exc;
    -- trebuie sa fiu atenta daca se repeta orasele
    for i in v_orase.first..v_orase.last loop
        if upper(v_orase(i)) = upper(v_oras1) then
            v_index := i;
        end if;
    end loop;
    v_orase.delete(v_index);
    update excursie_aan
    set orase = v_orase
    where cod_excursie = v_cod_exc;
exception
    when no_data_found then
        dbms_output.put_line('Nu exista excursia cu codul specificat');
    when others then
        dbms_output.put_line('Eroare');
end;
/
select * from excursie_aan;
/
-- c. Pentru o excursie al cãrui cod este dat, afi?a?i numãrul de ora?e vizitate, respectiv numele ora?elor
declare
    v_cod_exc excursie_aan.cod_excursie%type := &p_cod_exc;
    v_orase orase_aan;
begin
    select orase into v_orase
    from excursie_aan
    where cod_excursie = v_cod_exc;
    -- trebuie sa afisam numarul de orase vizitate
    dbms_output.put_line('In excusia cu codul ' || v_cod_exc || ' s-au vizitat ' || v_orase.count || ' excursii.');
   
    for i in v_orase.first..v_orase.last loop
        dbms_output.put(v_orase(i) || ' ');
    end loop;   
    dbms_output.new_line;
exception
    when no_data_found then
        dbms_output.put_line('Nu exista excursia cu codul specificat');
    when others then
        dbms_output.put_line('Eroare');
end;

-- d. Pentru fiecare excursie afi?a?i lista ora?elor vizitate
begin
    for i in (select * from excursie_aan) loop
        dbms_output.put('Excursia cu codul ' || i.cod_excursie || ' prin orasele ');
        for j in i.orase.first..i.orase.last loop
            dbms_output.put(i.orase(j) || ' ');
        end loop;
        dbms_output.put(' cu statusul de ' || i.status);
        dbms_output.new_line;
    end loop;
end;
/
select * from excursie_aan;
/
-- e. Anula?i excursiile cu cele mai pu?ine ora?e vizitate
declare
    v_min_orase number := 100000;
    v_count_oras number;
begin
    for i in (select orase from excursie_aan) loop
        v_count_oras := i.orase.count;
        if v_count_oras < v_min_orase then
            v_min_orase := v_count_oras;
        end if;
    end loop;
    for i in (select * from excursie_aan) loop
        if i.orase.count = v_min_orase then
            -- trebuie sa actualizez statusul
            update excursie_aan
            set status = 'anulata'
            where cod_excursie = i.cod_excursie;
        end if;
    end loop;
    
end;
/
