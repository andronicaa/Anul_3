--. S? se creeze un subprogram prin care se ob?ine media valorilor oferite de un sponsor al
--c?rui cod este introdus ca parametru, pentru prezent?rile în care au existat minim x
--vestimentatii. Parametrul x va avea valoarea implicita 3. 

create or replace function get_medie_valori(cod_sponsor in default 3 sponsor.cod_sp%type) 
    return number is
        -- declaratii locale
        v_suma_valori number
        -- numar cate prezentari a sponsorizat un sponsor
        v_numar_prez number
        -- rezultatul
        v_rezultat_medie number
    begin
        -- gasesc numarul de prezentari
        select sum(suma), count(*) into v_suma_valori, v_numar_prez
        from sponsor sp, sustine st, prezentare pr
        where sp.cod_sp = st.cod_sp and st.cod_pr = pr.cod_pr and sp.cod_sp = cod_sponsor;
        
        -- rezultat
        v_rezultat = v_suma_valori / v_numar_prez
        return v_rezultat
    exception
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000,'nu exista sponsorul cu codul dat');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');

        
end get_medie_valori;



-- BOOOOOOKSSS
-- antetul pachetului
create or replace package book_pk as
    -- cursor care sa obtina toate cartile scrise de un anumit autor
    -- cursor parametrizat
    cursor c(v_cod_autor number) return books%rowtype;
    
    -- subprogram care sa returneze pentru un titlu de carte, nr de exemplare comandata
    function nr_carti_comandate(titlu_carte books.title%type) return number;            
end book_pk;
/
create or replace package body book_pd as
    -- se obtin toate cartile scrise de un autor
    create c(v_cod_autor number) return books%type
    is
        select * from books
        from books bk, bookauthor ba
        where bk.isbn = ba.isbn and ba.authorid = v_cod_author;
        
    -- functia care calculeaza numarul de carti comandate
    function nr_carti_comandate(titlu_carte books.title%type)
    return number is
        -- declaratii locale 
        
end book_pk;




-- EXEMPLU TABELE MUTATING
-- Sa se implementeze cu ajutoul unui declansator restrictia ca intr-o sala
-- pot sa fie expuse maximum 10 opere de arta
-- tabel mutating
-- acest declansator interogheaza chiar tabelul opera la care este asociat 

create or replace trigger trLimitaOpere
before insert or update of cod_sala on opera
for each row
declare
    v_max_opere constant number := 1-;
    v_opere_curente number;
begin
    select count(*) into v_opere_curente
    from opera
    where cod_sala = :new.cod_sala;
    
    if v_opere_curente + 1 > v_max_opere then
        raise_application_error(-20000, 'Prea multe opere in aceasta sala');
    end if;
end trLimitaOpere;



-- un trigger la nivel de linie si unul la nivel de instructiune
create or replace package pSalaDate as
    type t_cod_sala is table of opera.cod_sala%type index by binary_integer;
    type t_cod_opera is table of opera.cod_opera%type index by binary_integer;
    v_cod_sala t_cod_sala;
    v_cod_opera t_cod_opera;
    v_NrIntrari binary_integer := 0;
end pSalaDate;    

-- TRIGGER LA NIVEL DE LINIE
-- se inregistreaza valoarea lui :new_cod_opera
-- DAR NU VA FI INTEROGAT TABELUL OPERA
create or replace trigger TrLimitaSala 
before insert or update of cod_sala on opera 
for each row
begin
    -- se actualizeaza numarul de opere dintr-o sala
    pSalaDate.v_NrIntrari := pSalaDate.v_NrIntrari + 1;
    pSalaDate.v_cod_sala(pSalaDate.v_NrIntrari) := :new.cod_sala;
    pSalaDate.v_cod_opere(pSalaDate.v_NrIntrari) := :new.cod_opera;
end TrLimitaSala;

-- TRIGGER LA NIVEL DE INSTRUCTIUNE
-- AICI SE VA FACE INTEROGAREA
-- SI VA FOLOSI INREGISTRARILE DIN TRIGGERUL FACUT LA NIVEL DE LINIE

create or replace trigger TrLimitaOpere
after insert or update of cod_sala on opera
declare
    v_max_opere constant number := 10;
    opere_curente
end TrLimitaOpere;


-- Sa se creeze un declansator care:
-- a. Daca este eliminata o sala => sterge toate operele expuse in sala raspectiva
-- b. Daca se schimba codul unei sali => va modifica aceatsa valoare
-- pentru fiecare opera de arta expusa in sala respectiva

create or replace trigger sala_cascada
before delete or update of cod_sala on sala 
for each row
begin
    if deleting then
        delete from opera
        where cod_sala = :old_sala;
    end if;
    if updating and :old.cod_sala != :new.cod_sala then
        -- trebuie sa actualizez aceasta valoare la toate operele expuse
        -- in acea sala
        update opera
        set cod_sala = :new.cod_sala
        where cod_sala = :old.cod_sala;
    end if;
end sala_cascada;
-- se presupune ca asupra tabelului opera exista o constrangere de integritate
