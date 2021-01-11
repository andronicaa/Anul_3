CREATE TABLE sala (
    id_sala int
);

CREATE TABLE opera (
    id_opera int,
    cod_sala int
);

insert into sala
values(1);
insert into sala
values(2);
insert into sala
values(3);
insert into sala
values(4);
insert into sala
values(5);

select * from sala;

insert into opera
values(1,1);
insert into opera
values(2,2);
insert into opera
values(3,3);
insert into opera
values(4,4);
insert into opera
values(5,5);

select * from opera;
drop table opera;

CREATE OR REPLACE PACKAGE pachet AS
    TYPE t_cod_sala IS TABLE OF opera.cod_sala%TYPE  INDEX BY BINARY_INTEGER;
    TYPE t_nr_opere IS TABLE OF number  INDEX BY BINARY_INTEGER;
    cod_sala t_cod_sala;
    nr_opere t_nr_opere;
END pachet;

CREATE OR REPLACE TRIGGER nivel_instructiune 
BEFORE INSERT OR UPDATE OF cod_sala ON opera 
begin 
    select cod_sala, count(id_opera)
    bulk collect into pachet.cod_sala, pachet.nr_opere 
    from opera
    group by cod_sala;
END nivel_instructiune;

CREATE OR REPLACE TRIGGER nivel_linie_before
before INSERT OR UPDATE OF cod_sala ON opera 
for each row --!!!!
begin 
    -- gandim doar cazul update
    -- opera se muta in alta sala
    -- gaseste numarul de opere din sala in are se muta opera si verifica daca este mai mic decat 2
    for i in pachet.cod_sala.first..pachet.cod_sala.last loop
        if pachet.cod_sala(i) = :new.cod_sala then -- am gasit sala in care se muta
            -- verificam nr de opere din sala
            if pachet.nr_opere(i) >= 2 then
                raise_application_error(-20003, 'te-ai ticnit?');
            -- else 
                -- pachet.nr_opere(i) := pachet.nr_opere(i) + 1;
            end if;
        end if;
    end loop;
END nivel_linie_before;

CREATE OR REPLACE TRIGGER nivel_linie_after 
after INSERT OR UPDATE OF cod_sala ON opera 
for each row --!!!!
begin 
    for i in pachet.cod_sala.first..pachet.cod_sala.last loop
        if pachet.cod_sala(i) = :new.cod_sala then -- am gasit sala in care s-a muta
            -- crestem nr de opere din sala
            pachet.nr_opere(i) := pachet.nr_opere(i) + 1;
        end if;
    end loop;
END nivel_linie_after;

update opera
set cod_sala = 1
where id_opera in (2,3);