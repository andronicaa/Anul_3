select * from subiecte;
-- exercitiul 1
--Enuntati o cerere in limbaj natural, pe schema de examen, care sa implice in rezolvare utilizarea unui cursor ce extrage 
--informatiile din cel putin 3 tabele. Scrieti un subprogram care utilizeaza acest cursor. 
--Vor fi afisate informatiile din cel putin doua coloane returnate de cursor.
--Tratati erorile care pot sa apara la apelare. Testati.




select * from achizitioneaza;
select * from agentie;
select * from excursie;
select * from turist;

select ex.id_excursie, max(ex.denumire), count(*)
from turist t, achizitioneaza ac, excursie ex
where t.id_turist = ac.cod_turist and ac.cod_excursie = ex.id_excursie
group by ex.id_excursie
order by count(*) desc;



select ex.id_excursie cod_excursir, max(ex.denumire), count(*)
        from turist t, achizitioneaza ac, excursie ex
        where t.id_turist = ac.cod_turist and ac.cod_excursie = ex.id_excursie
        group by ex.id_excursie;

-- exercitiul 1
-- Sa se afiseze primele 2 excursii achizitionate cel mai mult si pentru un cod dat de la tastatura sa se afiseze daca acea excursie se numara
-- printre cele cu caracteristicile date.
set serveroutput on
declare
    procedure proc (cod_excursie excursie.id_excursie%type) is
        -- declaratii locale
        cursor c is
            select ex.id_excursie cod_excursie, max(ex.denumire) nume_excursie, count(*) nr_excursii
            from turist t, achizitioneaza ac, excursie ex
            where t.id_turist = ac.cod_turist and ac.cod_excursie = ex.id_excursie
            group by ex.id_excursie
            order by count(*) desc;
        -- trebuie sa avem o variabile in care sa retinem numarul de excursii achizitionate si sa le afisam pe primele doua achizitionate cel mai ded
        -- in caz ca sunt 2 cu acelasi numar de achizitionari
        v_nr_achizitii number := 0;
        v_top number := 1;
        v_cod_ex_cautata excursie.id_excursie%type;
        -- definim variabilele in care retinem datele intoarse de cursor
        v_id_excursie excursie.id_excursie%type;
        v_nume_excursie excursie.denumire%type;
        v_nr_exc number;
        gasit boolean := false;
        begin
             -- deschidem cursorul
            open c;
            dbms_output.put_line('Primele 2 cele mai achizitionata excursii sunt: ');
            -- incarcam prima linie din cursor pentru a putea determina numarul maxim de achizitii
            fetch c into v_id_excursie, v_nume_excursie, v_nr_exc;
            v_nr_achizitii := v_nr_exc;
            
            -- verificam daca codul angajatului este egal cu cel dat ca parametru
            if v_id_excursie = cod_excursie then
                gasit := True;
            end if;
            -- afisam prima excursie 
            dbms_output.put_line('Excursia cu codul ' || v_id_excursie || ' cu numele ' || v_nume_excursie || ' are ' || v_nr_exc || ' achizitionari');
            -- parcurgem cursorul
            
            loop
                fetch c into v_id_excursie, v_nume_excursie, v_nr_exc;
                exit when c%notfound or v_top >= 2;
                if v_id_excursie = cod_excursie then
                    gasit := True;
                end if;
                if v_nr_achizitii = v_nr_exc then
                    dbms_output.put_line('Excursia cu codul ' || v_id_excursie || ' cu numele ' || v_nume_excursie || ' are ' || v_nr_exc || ' achizitionari');
                else
                    v_top := v_top + 1;
                    v_nr_achizitii := v_nr_exc;
                    dbms_output.put_line('Excursia cu codul ' || v_id_excursie || ' cu numele ' || v_nume_excursie || ' are ' || v_nr_exc || ' achizitionari');
                end if;
                
            end loop;
            -- verificam daca am gasit excursia cu codul cerut
            if gasit = false then
                dbms_output.put_line('Excursia cu codul cerut nu se afla printe primele doua cele mai achizitionate');
            else
                dbms_output.put_line('Excursia data are caracteristicile cerute');
            end if;
            exception
                when no_data_found then
                    dbms_output.put_line('Excursia cu codul data ca parametru nu exista');

    end proc;
begin
   -- apelam procedura
    proc(5000);
end;



-- exercitiul 2
-- Vom numi "tip3" un tip de date ce foloseste in definirea lui un alt tip de date ("tip2"), care la randul 
-- lui utilizeaza un alt tip de date ("tip1"). Definiti un astfel de tip, indicati ce anume reprezinta si utilizati-l 
-- prin adaugarea unei coloane de acest tip la unul dintre tabelele din schema de examen. Cu ajutorul unui bloc anonim 
-- actualizati coloana adaugata cu informatii relevante din schema de examen.

-- tablou imbricat ce retine numere de telefon
create or replace type tip1 is table of varchar2(11);
/
-- tablou ce retine un tablou in care fiecare element este un tablou de tip1 (fiecare element este un tablou de numere de telefon)
create or replace type tip2 is table of tip1;
/
-- tablou ce retine un tablou de tablouri de numere de telefon fiecar reprezentand o categorie de nr de telefon pentru o agentie 
-- de ex (nr de telefoane pentru departamentele de turism european, nr de telefoane pentru departamentul de turism romanesc)
create or replace type tip3 is table of tip2;
-- adaug aceasta coloana la tabelul agentie
-- si o salvez in schema bazei de date cu ajutorul lui nested table

alter table agentie
add (agenda_telefoane tip3)
nested table agenda store as agenda_telefoane;

