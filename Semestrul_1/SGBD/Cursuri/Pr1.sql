-- Problema 1

--1. Subprogram care populeaz? tabelul info cu informa?ii (pentru fiecare cod de angajat se re?in codurile utilajelor 
--pe care le-a folosit ?i num?rul total de ore de munc? pe aceste utilaje)

drop table lucreaza;
drop table utilaj;
drop table angajat;
drop table firma;
drop table info;
drop type utilaje;
drop type pereche;

desc lucreaza;
desc utilaj;
desc angajat;
desc firma;
desc info;
desc utilaje;
desc pereche;

select cod_ang, nume
from angajat;

select cod_angajat, id_utilaj, nr_ore
from lucreaza;

select id_utilaj, denumire
from utilaj;

select nr_ore, u.id_utilaj
from angajat a, lucreaza l, utilaj u
where a.cod_ang = l.cod_angajat and l.id_utilaj = u.id_utilaj and a.cod_ang = 101;

declare
    tabel_utilaje utilaje := utilaje();
    v_pereche pereche;
    cursor c (v_par angajat.cod_ang%type)is 
        select u.id_utilaj, nr_ore 
        from angajat a, lucreaza l, utilaj u
        where a.cod_ang = l.cod_angajat and l.id_utilaj = u.id_utilaj and a.cod_ang = v_par;
    v_nr_ora lucreaza.nr_ore%type;
    v_cod_utilaj lucreaza.id_utilaj%type;
begin
    for j in (select cod_ang
              from angajat) loop
        open c(j.cod_ang);
        
        loop
            fetch c into v_cod_utilaj, v_nr_ora;
            exit when c%notfound;
            tabel_utilaje.extend;
            v_pereche := pereche(v_cod_utilaj, v_nr_ora);
            tabel_utilaje(tabel_utilaje.count) := v_pereche;
        end loop;  
        close c;
        -- inseram in tabel
        insert into info
        values (j.cod_ang, tabel_utilaje);
        
        
        dbms_output.put_line('Angajatul cu codul ' || j.cod_ang || ' a lucrat.');
        dbms_output.put_line(tabel_utilaje.count);
        tabel_utilaje.delete;
    end loop;

--        for i in tabel_utilaje.first..tabel_utilaje.last loop
--            dbms_output.put_line(tabel_utilaje(i).id_u || ' ' ||tabel_utilaje(i).ore);
--        end loop;
end;


select a.cod, b.*
from info a, table(a.fisa) b;