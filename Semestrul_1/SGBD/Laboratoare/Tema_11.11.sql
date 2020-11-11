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
