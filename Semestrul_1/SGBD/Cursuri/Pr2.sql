select * from student;
select * from note;
select * from curs;
select s.cod_student, sum(nr_credite), max(cnp)
from student s, note n, curs c
where s.cod_student = n.cod_student and n.cod_curs = c.cod_curs
group by s.cod_student
having sum(nr_credite) >= 24;

select s.cod_student, nume, nr_credite
from student s, note n, curs c
where s.cod_student = n.cod_student and n.cod_curs = c.cod_curs
order by s.cod_student;

-- pentru studentii care au acumulat mai mult de n credite se vor returna
-- numarul matricol, CNP-ul si cel mai mare numar de cradite pe care l-a acumulat la un singur examen
create table smart_students (nr_matricol varchar2(20),
                             cnp varchar2(13),
                             nr_credite number(4)); 
declare
    procedure proc(n number) is
        -- declaratii locale
        cursor c is
            select s.cod_student, sum(nr_credite) suma
            from student s, note n, curs c
            where s.cod_student = n.cod_student and n.cod_curs = c.cod_curs
            group by s.cod_student
            having sum(nr_credite) >= n;
        
        cursor st(cod student.cod_student%type) is
            select nr_matricol, cnp, nr_credite, denumire
            from student s, note n, curs c
            where s.cod_student = n.cod_student and n.cod_curs = c.cod_curs
            and cod_student = cod
            order by nr_credite;
        v_cod_student student.cod_student%type;
        v_suma number;
        v_cnp student.cnp%type;
        v_nr_matricol student.nr_matricol%type;
        v_nr_credite curs.nr_credite%type;
        v_denumire curs.denumire%type;
    begin
        -- trebuie sa adun creditele pentru toti studentii si sa vad daca acest
        -- numar este mai mare decat n
        open c;
        loop
            exit when c%notfound;
            fetch c into v_cod_student, v_suma;
            open st(v_cod_student);
            loop
                exit when st%notfount or st%rowcount > 1;
                fetch st into v_nr_matricol, v_cnp, v_nr_credite, v_denumire;
                insert into smart_students
                values (v_nr_matricol, v_cnp, v_nr_credite);
            end loop;
        end loop;
    end proc;
begin

end;