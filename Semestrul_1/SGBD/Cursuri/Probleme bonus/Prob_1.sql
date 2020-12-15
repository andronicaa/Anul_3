--1. Sa se adauge o colona (next_sef - contine viitori sefi) tabelului emp (copie a tabelului employees). 
--Sa se scrie un subprogram care actualizeaza aceasta coloana. Viitorul sef va fi ales dintre subalternii sefului curent care au vechimea cea mai mare

select * from emp_aan;
select distinct(manager_id)
from employees;
-- fac un vector cu toti managerii
select manager_id, employee_id, last_name, first_name, hire_date, sysdate-hire_date vechime
from emp_aan
where manager_id = 108;
declare
    procedure next_s is
        -- declaratii locale
        cursor c(par number) is 
            select employee_id, sysdate-hire_date vechime
            from emp_aan
            where manager_id = par;
        cod_ang emp_aan.employee_id%type;
        vechime number;
    begin
        for man in (select distinct(manager_id) cod_mgr
                    from employees) loop
            open c(man.cod_mgr);
            fetch c into cod_ang, vechime;
            update emp_aan
            set next_sef = cod_ang
            where manager_id = man.cod_mgr;
            close c;
        end loop;
    end;
begin
    next_s;
end;

select * from emp_aan;


--2. Subprogram ce prime?te ca parametru un cod de turist ?i întoarce lista excursiilor la care ar dori s? participe 
--(nu are o achizi?ie f?cut?), ordonat? dup? num?rul de prieteni (prin prieten se în?elege un turist cu care a mai participat, în trecut, la o alta excursie)

select * from turist;
select * from achizitioneaza;
select * from excursie;