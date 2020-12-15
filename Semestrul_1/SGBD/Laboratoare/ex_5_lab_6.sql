drop table emp_test_aan;
drop table dept_test_aan;
create table emp_test_aan (cod_emp number primary key,
                           last_name varchar2(20),
                           first_name varchar2(20),
                           department_id number,
                            foreign key(department_id) references dept_test_aan(department_id) on delete cascade);

create table dept_test_aan (department_id number primary key,
                            department_name varchar2(20));
         
         
-- populam tabelele
insert into dept_test_aan
select department_id, department_name
from departments;
insert into emp_test_aan
select employee_id, last_name, first_name, department_id
from employees;
commit;
create or replace trigger dep_cascada_aan
before delete or update of department_id on dept_test_aan
for each row
begin
    if deleting then
        delete from emp_test_aan
        where department_id = :old.department_id;
    end if;
    if updating and :old.department_id != :new.department_id then
        update emp_test_aan
        set department_id = :new.department_id
        where department_id = :old.department_id;
    end if;
end;    


delete from dept_test_aan
where department_id = 10;

update dept_test_aan
set department_id = 12
where department_id = 10;