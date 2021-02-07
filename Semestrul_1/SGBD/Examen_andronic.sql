-- SUBIECTUL 1. Schema bazei de date
-- EDITURA, PUBLICA, CARTE
-- Relatie many to many intre EDITURA  si CARTE => se va construi un tabel asociativ PUBLICA ce contine cheile primare din tabelele editura si carte
-- cheia primara a tabelului PUBLICA este cheie primara compusa din cod_editura si cod_carte
create table editura (cod_editura number(5) primary key,
                      nume_editura varchar2(20) not null,
                      adresa varchar2(20) not null);
create table publica (cod_editura number(5), 
                      cod_carte number(5),
                      data_publicare date,
                      pret_vanzare number(3),
                      discount number(3, 2),
                      primary key(cod_editura, cod_carte));
                      
create table carte (cod_carte number(5) primary key,
                    nume_carte varchar2(30) not null,
                    autor varchar2(30) not null,
                    nr_pagini number(3));

-- SUBIECTUL 2. 
-- a) Cheia primara este proprietatea prin care o inregistrare dintr-un tabel se indentifica in mod unic. In schema mea, o cheie primara este
-- cod_editura din tabelul EDITURA ce indentifica in mod unic o editura din acest tabel => nu pot exista doua edituri(inregistrari in tabel) cu aceeasi cheie primara.
-- Cheia externa este o constrangere folosita pentru a "uni" doua tabele printr-un tip de relatie existenta in schema bazei de date(de exemplu: relatia one-to-many)
-- Aceasta ne ajuta la introducerea unor date valide in tabele. De exemplu: nu pot fi introduse date in tabelul copil, daca nu exista in tabelul parinte deoarece se incalca
-- constrangerea de cheie externa. 
-- In schema mea, o cheie externa ar fi putut fi in tabelul publica(cod_editura sau cod_carte), dar am ales sa le folosesc drept chei primare compuse.

-- b) Ambele tipuri de date, vectorii si tablourile imbricate pot fi folosite ca si coloane in tabele.
-- Pentru a adauga ca si coloana intr-un tabel o colectie de tip tablou imbricat este necesara si clauza de stocare NESTED TABLES, DAR aceasta nu este
-- necesara la adaugarea unui vector(varray) ca si coloana intr-un tablou.
-- Tablourile imbricate sunt dense la initializare, insa pe parcursul programului pot deveni nedense(dupa ce s-au facut anumite instructiuni de DELETE pe anumite elemente).
-- Vectorii vor ramane structuri dense pe tot parcursul programului(nu se pot sterge elemente din acestia).

-- c) Cursoarele sunt pointeri catre zone de memorie ce se aloca atunci cand se face o instructiune de tip SELECT.
-- Cursoarele predefinite sunt cele in care comanda SELECT se cunoaste inca de la declarare(din sectiunea DECLARE) si nu mai poate fi schimbata pe tot parcursul programului.
-- Cursoarelor dinamice li se pot asocia diferite cereri SELECT in functie de niste criterii.
-- Acestea sunt de tipul REFCURSOR si se declara in urmatorul mod: TYPE ref_cursor IS REF CURSOR;

-- d) Sa se construiasca un subbloc care actualizeaza pretul de vanzare pentru cartile publicate in data curenta, aplicand si discount-ul. Se va aplica discount-ul cel mai mare
-- din tabel. Sa se scrie o functie care returneaza acest discount. In acest caz ne vom folosit de valoarea returnata de functie.
-- Functiile returneaza intotdeauna o singura valoare.


-- e) Deosebiri:
-- Triggerii la nivel de linie se vor executa pentru fiecare linie afectata din tabel.
-- Trigerii la nivel de instructiune se executa o singura data pentru instructiunea declansatoare.
-- In triggerii la nivel de linie nu se poate interoga tabelul pe care se declanseaza triggerul => este mutating(in schimbare).
-- In triggerii la nivel de instructiune se poate face acest lucru(nu este considerat mutating).
-- Asemanari
-- instructiunile LCD (COMMIT, ROLLBACK, SAVEPOINT) nu sunt permise in corpul unui trigger 
-- ambele tipuri de trigger se invoca implicit



-- SUBIECTUL 3. 
-- O relatie one-to-many in tabelele mele este aceea dintre editura si publica
-- a) Definire vector si tablou imbricat
-- colectie de tip vector(trebuie sa i se dea lungimea maxima de la declarare)
create or replace type info_varray is varray(100) of number;
/
-- colectie de tip tablou imbricat
create or replace type info_nested is table of number;
/
-- creez tabele cu acestea 2
create table info_varray_table (cod_varray number(2) primary key,
                                tb info_varray);
-- spre deosebire de varray, la tablourile imbricate trebuie sa mai adaugam si clauza de stocare atunci cand il adaugam ca si coloana intr-un tabel al bazei de date                                
create table info_nested_table (cod_nested number(2) primary key,
                                tbs info_nested)
nested table tbs store as tabel_nested_tablou;    

-- b)
-- Sa se scrie un program care primeste ca parametru un cod de editura si adauga in tabelul info_varray_table pentru acea editura cartile pe care le-a publicat anul curent.
create or replace procedure carti_edituraa(cod_edit editura.cod_editura%type) is
    -- declaratii locale
    tb_book_id info_varray := info_varray();
begin
    -- selectam din tabelul publica toate cartile publica de editura al carei cod l-am primit ca parametru
    -- procedeul de tip bulk collect permite stocarea liniilor intoarse de catre o comanda intr-o colectie fara a se mai face multe schimbari de context intre motorul sql si plsql
    select cod_carte bulk collect into tb_book_id
    from publica
    where cod_editura = cod_edit and to_char(sysdate, 'yyyy') = to_char(data_publicare, 'yyyy');
    -- inseram in tabel datele corespunzatoare
    insert into info_varray_table
    values(cod_edit, tb_book_id);
end;

insert into editura
values (1, 'Humanitas', 'Brasov');
insert into editura
values (2, 'Apolodor', 'Bucuresti');
insert into carte
values (200, 'Carte1', 'Ion Creanga', 30);
insert into carte
values (300, 'Carte2', 'Ion Barbu', 300);
insert into publica
values (1, 200, sysdate, 20, 2);
insert into publica
values (1, 300, sysdate, 20, 2);
select * from editura;
select * from publica;
select * from carte;

begin
    carti_edituraa(1);
end;
select * from info_varray_table;


-- c)
--cu ajutorul unui subprogram copia?i liniile din primul tabel în cel de al doilea, astfel
--încât datele s? fie sortate cresc?tor în coloana tablou imbricat;
create or replace procedure sorteaza_coduri_carti is
    -- declaratii locale
    -- trebuie sa imi declar un vector de tip varray deoarece vectorii ce sunt retinuti in tabele nu pot fi modificati direct
    tb_copie info_varray := info_varray();
    -- si o colectie de tip tablou imbricat
    tb_imbr info_nested := info_nested();
    aux number;
begin
    -- ma voi folosi de un ciclu cursor pentru a lua toate datele din tabelul ce contine coloana vector 
    for c in (select * from info_varray_table) loop
        -- salvez vectorul in copie
        tb_copie := c.tb;
        -- trebuie sa parcurg elementele si sa le sortez        
        for i in tb_copie.first..tb_copie.last - 1 loop
            for j in i+1..tb_copie.last loop
                if tb_copie(i) < tb_copie(j) then
                    aux := tb_copie(i);
                    tb_copie(i) := tb_copie(j);
                    tb_copie(j) := aux;
                end if;
            end loop;
        end loop;
        -- copiez elementele in tabelul imbricat
        for i in tb_copie.first..tb_copie.last loop
            tb_imbr.extend;
            tb_imbr(i) := tb_copie(i);
        end loop;
    insert into info_nested_table
    values (c.cod_varray, tb_imbr);
    -- la final trebuie sa sterg elementele din tabelul vector copie, ca sa pot sa adaug alte elemente la urmatorii pasi
    tb_copie.delete;
    tb_imbr.delete;
    end loop;
    
end;

begin
    sorteaza_coduri_carti;
end;
select * from info_nested_table;

--defini?i un bloc care utilizeaz? un cursor pentru a afi?a con?inutul unuia dintre
--tabelele definite la punctul a) in func?ie de o op?iune citit? de la tastatura.

-- d)
declare
    -- daca optiunea este 1 => se vor afisa datele din tabelul 1, altfel din tabelul 2
    v_optiune number := &p_optiune;
    cursor c_varray is 
        select cod_varray, tb
        from info_varray_table ;
    -- pentru a citit datele de tip tablou imbricat trebuie sa folosim functia table    
    cursor c_nested is
        select a.cod_nested, b.*
        from info_nested_table a, table(a.tbs) b;
    exceptie exception;    
begin
    -- in functie de optiunea introdusa deschides un anumit cursor
    if v_optiune = 1 then
        for i in c_varray loop
            dbms_output.put_line('Editura ce are codul ' || i.cod_varray || 'a publicat urmatoarele carti' || c.tb);            
        end loop;   
    elsif v_optiune = 1 then
        for i in v_nested loop
            dbms_output.put_line('Editura ce are codul ' || i.cod_varray || 'a publicat urmatoarele carti in ordine crescatoare' || c.tb);
        end loop;   
    else
        -- inseamna ca nu s-a introdus o optiune valida
        raise exceptie;
    end if;
    exception
        when exceptie then
            raise_application_error(-20005, 'Optiunea trebuia sa fie 1 sau 2');    
end;


-- 2) Simulare constrangere cheie primara
create or replace package tabel_editura as
-- tablou in care retin toate codurile editurilor din baza de date
    type tb_cod_edit is table of number index by pls_integer;
    -- declar un tablou de acel tip
    tb tb_cod_edit;
end tabel_editura;

-- trigger la nivel de instructiune in care salvez in tabloul din pachet facand un select in baza de date
create or replace trigger editura_instr 
before insert or update of cod_editura on editura
begin
    select cod_editura bulk collect into tabel_editura.tb
    from editura;
end editura_instr;

-- trigger la nivel de linie in care verific daca :new.cod_editura exista in acea colectie => daca da => s-a incalcat constrangerea de cheie primara(adica nu este unica) si instructiune de update sau insert este impiedicata
create or replace trigger editura_linie
before insert or update of cod_editura on editura
for each row
declare
    
    v_elemente number(2);
begin
    -- parcurg colectia
    
    for i in tabel_editura.tb.first..tabel_editura.tb.last loop
        -- daca codul exista deja in tabel(exista deja editura)
        if tabel_editura.tb(i) = :new.cod_editura then
            raise_application_error(-20002, 'Exista deja aceasta editura in baza de date. Cheia primara trebuie sa fie unica!');
        end if;
    end loop;
        -- putem sa adaugam codul in colectie
        v_elemente := tabel_editura.tb.count;
        tabel_editura.tb(v_elemente + 1) := :new.cod_editura;
    
end editura_linie;
-- nu functioneaza
insert into editura
values (1, 'Steaua nordului', 'Bucuresti');