select department_id, count(*)
from emp_aan
group by department_id
order by department_id;


select employee_id, last_name, department_id
from emp_aan
order by department_id;
create or replace package pachet as
    type tip_rec is record(cod_dept emp_aan.department_id%type, nr_ang number(3));
    type tip_tablou is table of tip_rec index by pls_integer;
    tb tip_tablou;
    
end pachet;

create or replace trigger trig_mutating_instr
before insert or update of department_id on emp_aan
begin
    select department_id, count(*)
    bulk collect into pachet.tb
    from emp_aan
    group by department_id;
end;

create or replace trigger trig_mutating_linie
before insert or update of department_id on emp_aan
for each row
begin
    dbms_output.put_line(:new.department_id);
    for i in pachet.tb.first..pachet.tb.last loop
        if pachet.tb(i).cod_dept = :new.department_id then
            dbms_output.put_line('A intrat aici');
            if pachet.tb(i).nr_ang + 1 > 45 then
                -- inseamna ca nu mai putem introduce angajati in acel departament, depaseste limita de 45
                raise_application_error(-20000, 'Nu se mai pot introduce angajati in acest departament');
            else
                pachet.tb(i).nr_ang := pachet.tb(i).nr_ang + 1;
            end if;    
        end if;        
    end loop;

end;

desc emp_aan;
insert into emp_aan
values (300, 'Andronic', 'Alexandra', 'andronic@gmail.com', '0740159113', '18-JAN-1995', 'SA_REP', 3455, 0.2, 100, 50);
update emp_aan
set department_id = 50
where employee_id = 200;
rollback;
