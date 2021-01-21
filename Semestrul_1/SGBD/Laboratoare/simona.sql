-- 2. Implementati constrangerea prin care o statie trebuie sa comercializeze cel putin 3 produse distincte.

select * from achizitie;
select cod_st, count(distinct cod_prod) from achizitie
group by cod_st;

create or replace package pack_comert as
type t_comert is table of achizitie.cod_st%type;
v_comert t_comert;
end;
/

create or replace trigger trig_comert_b
before delete or update of cod_st,cod_prod on achizitie
begin
    select cod_st bulk collect into pack_comert.v_comert
    from achizitie
    group by cod_st
    having count(distinct cod_prod) < 3;
end trig_comert_b;
/

create or replace trigger trig_comert_a
after delete or update of cod_st,cod_prod on achizitie
begin
    for v_row in (select cod_st, count(distinct cod_prod) nr
                  from achizitie
                  group by cod_st) loop
        if ((v_row.nr < 3) and (v_row.cod_st not member of pack_comert.v_comert)) then
            raise_application_error(-20003,'Statia ' || v_row.cod_st || ' trebuie sa comercializeze cel putin 3 produse!');
        end if;
    end loop;
end trig_comert_a;
/

select * from achizitie where cod_st = 75;
delete from achizitie
where cod_st = 105 and cod_prod = 50;