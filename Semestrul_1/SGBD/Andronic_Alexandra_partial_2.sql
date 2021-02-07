select * from subiecte;
--1 .Pe un tabel din schema de examen definiti un trigger cu ajutorul caruia sa implementati comportamentul on delete update. 
--(observatii: trebuie sa apara explicit pe ce tabel si care este comportamentul dorit; 1p din barem este alocat pentru manipularea 
--liniilor cu ajutorul optiunii forall)


desc acvariu;
desc crescut;
-- comportamentul on delete update se va face pe tabelele ACVARIU si CRESCUT
-- daca un acvariu este eliminat => trebuie sa eliminam si toti pestii care sunt crescuti in el
-- voi face un trigger delete or update la nivel de linie
create or replace trigger delete_acvariu
before delete or update of cod_acvariu on acvariu
for each row
declare
    -- tablou in care retinem codurile pestilor care sunt crescut in acvariul ce se doreste a fi sters sau actualizat
    type pesti is table of peste.cod_peste%type;
    pst pesti;
    cod_acv acvariu.cod_acvariu%type;
begin
    
    cod_acv := :old.cod_acvariu;
    -- nu este un tabel mutating deoarece triggerul se activeaza pe tabelul acvariu si eu am facut selectul pe tabelul crescut
    -- trebuie sa salvez intr-un tablou toti pestii care se afla in acel acvariu
    select cod_peste bulk collect into pst
    from crescut
    where cod_acvariu = cod_peste;
    -- acum in tabloul pst am toti pestii care sunt crescuti in acvatiul care are codul :old.cod_acvariu
    -- trebuie sa elimin toti acesti pesti din tabelul peste, dar si din tabelul crescut
    -- ma voi folosi de comanda forall care permite ca toate liniile unei colectii sa fie transmise simultan unei operatii(in cazul meu de update)

    if deleting then
        forall i in pst.first..pst.last
            delete from peste 
            where cod_peste = pst(i);
        forall i in pst.first..pst.last
            delete from crescut
            where cod_peste = pst(i);
    elsif updating then
        forall i in pst.first..pst.last
            update crescut
            set cod_acvariu = :new.cod_acvariu
            where cod_peste = pst(i);
    end if;   
    
end;


--2. Implementati constrangerea conform careia un peste nu poate fi cumparat de 2 ori.
select data from cumpara;
select * from client;
select cl.cod_client, ps.cod_peste, specie
from client cl, cumpara cmp, peste ps
where cl.cod_client = cmp.cod_client and ps.cod_peste = cmp.cod_peste
order by cl.cod_client;
select cod_peste from peste;
-- nu se poate adauga acest peste pentru clientul care are codul 202 deoarece deja este achizitionat de clientul 102 => triggerul arunca exceptie
insert into cumpara
values (2, 202, '06-JAN-17', 200.20);
-- acest peste poate fi achizitionat deoarece nu mai exista inainte in tabelul cumpara => triggerul nu va arunca exceptia
insert into cumpara
values (7, 202, '06-JAN-17', 23.23);
desc cumpara;
select * from cumpara;

-- o sa declar intr-un pachet un tablou ce retine din tabelul cumpara un record cu fiecare cod de client si ce peste cumpara fiecare
-- astfel, atunci cand voi incerca adaugarea unei noi achizitii in tabelul cumpara => voi verifica daca acel peste a fost deja achizitionat de un client
create or replace package acvariu_pack as
    -- declar un tabel in care voi retine codurile pestilor cumparati
    type pesti is table of peste.cod_peste%type index by pls_integer;
    -- declar un record ce contine (codul de client si pestii cumparati de acesta)
    type rec_pesti is record (clientId client.cod_client%type, pst pesti);
    -- declar un tablou de record-uri pentru a retine pentru toti clientii ce pesti cumpara
    type rec_achizitii is table of rec_pesti index by pls_integer;
    --declar un tablou de tipul rec_achizitii
    tb rec_achizitii;
end acvariu_pack;

-- intr-un trigger la nivel de instructiune voi initializa tabloul tb(de tipul rec_achizitii) cu inregistrarile din tabelul cumpara
-- conform ordinii de activare a triggerilor, acesta before la nivel de instructiune este activatul primul in cazul unei instructiuni de tip insert
create or replace trigger acvariu_instr
before insert or update of cod_peste on cumpara 
declare
    -- indicii pentru intializarea vectorului
    i number := 1;
    j number := 1;
begin
    for c in (select cod_client from client) loop
        acvariu_pack.tb(i).clientId := c.cod_client;
        -- pentru clientul cu id_ul c.cod_client trebuie sa salvez si ce pesti a cumparat
        j := 1;
        for p in (select cod_peste from cumpara where cod_client = c.cod_client) loop
            acvariu_pack.tb(i).pst(j) := p.cod_peste;
            j := j + 1;
        end loop;
        i := i + 1;
    end loop;    
end acvatiu_instr;

-- intr-un trigger la nivel de linie voi verifica daca noua achizitie ce se doreste a fi inserata contine cumva un peste ce deja este achizitionat de un client
create or replace trigger acvariu_linie
before insert on cumpara
for each row
declare
    -- cu ajutorul acestei variabile verific daca :new.cod_peste exista in tablou
    ok boolean := false;
    -- numarul de elemente intr-un vector
    nr_elemente number;
begin
    -- trebuie sa parcurg tabloul initializat in triggerul la nivel de instructiune si sa vad daca :new.cod_peste exista deja
    for i in acvariu_pack.tb.first..acvariu_pack.tb.last loop
       
            -- o actualizez pentru fiecare parcurgere
            ok := false;
            for j in acvariu_pack.tb(i).pst.first..acvariu_pack.tb(i).pst.last loop
                if acvariu_pack.tb(i).pst(j) = :new.cod_peste then
                    ok := true;
                end if;
            end loop;
            -- verific daca pestele cu codul :new.cod_peste exista
            if ok = true then
                -- arunc exceptie 
                raise_application_error(-20001, 'Pestele cu codul ' || :new.cod_peste || 'a fost deja cumparat');
            else
                -- altfel, inseamna ca acel peste nu a mai fost achizitionat niciodata => poate fi achizitionat de clientul ce are codul :new.cod_client
                -- il adaug in vector la codul clientului corespunzator
                if acvariu_pack.tb(i).clientId = :new.cod_client then
                    nr_elemente := acvariu_pack.tb(i).pst.count;
                    acvariu_pack.tb(i).pst(nr_elemente + 1) := :new.cod_peste;
                end if;
            end if;
        
    end loop;
end;


