-- exercitiul 1

declare
type rec_ang is record (cod employees.employee_id%type,
                        nume employees.last_name%type,
                        cod_job employees.job_id%type);
type tablou_angajat is table of rec_ang;
t_ang tablou_angajat := tablou_angajat();
    procedure ex1 (t_ang out tablou_angajat) is 
    
    begin
    select max(e.employee_id), max(last_name), max(j.job_id) bulk collect into t_ang
    from job_history jh, employees e, jobs j
    where jh.employee_id = e.employee_id and e.job_id = j.job_id
    group by jh.employee_id
    having count(*) = (select max(count(*))
                        from job_history
                        group by employee_id);
    
    end ex1;
begin
    -- apelez procedura
    ex1(t_ang);
    dbms_output.put_line('angajatii cu numar maxim de joburi sunt: ');
    for i in t_ang.first..t_ang.last loop
        dbms_output.put_line(t_ang(i).cod || ' ' || t_ang(i).nume || ' ' ||
            t_ang(i).cod_job);
    end loop;
end;

-- exercitiul 2
select * from employees;
create or replace function ex2 (cod_manager employees.manager_id%type)
    return number is
        v_subalterni number;
    begin
        select count(*) into v_subalterni
        from employees 
        group by manager_id
        having manager_id = cod_manager;
    return v_subalterni;
    exception
        when no_data_found then
            dbms_output.put_line('Nu exista acel manager');
end ex2;
declare
    v_cod_manager employees.manager_id%type := &p_cod_manager;
begin
    dbms_output.put_line('Numarul de subalterni pentru managerul ' || 
        v_cod_manager || ' este ' || ex2(v_cod_manager));
end;
select employee_id, last_name, hire_date
from employees
where hire_date > '21-MAY-91'
order by hire_date;
select employee_id,last_name, hire_date
from employees
order by hire_date;


-- exercitiul 3
create or replace procedure ex3 (cod_angajat in out employees.employee_id%type) is
    -- declaratii locale
    v_data_angajare employees.hire_date%type;
    v_hire_date employees.hire_date%type;
    cursor c is
        select employee_id, hire_date
        from employees;
    begin
        -- determin data de angajare a agajatului dat ca param
        select hire_date into v_data_angajare
        from employees
        where employee_id = cod_angajat;
        
        -- deschid cursorul
        open c;
        loop
            fetch c into cod_angajat, v_hire_date;
            exit when c%notfound or v_hire_date > v_data_angajare;
        end loop;
        -- inchidem cursorul
        close c;
--       
    exception
        when no_data_found then
            dbms_output.put_line('nu exista respectivul angajat');
 
end ex3;

-- apelam procedura
variable v_data number
begin
    :v_data := 104;
end;
/
execute ex3(:v_data)
print v_data



-- exercitiul 4
select * from emp_aan;
alter table emp_aan
add next_sef varchar2(50);

declare
    type sub is table of employees.employee_id%type;
    resultSub sub;
    -- functie care intoarce subalternii unui manager
    function subalt (cod_manager employees.manager_id%type)
        return sub is
            subalterni sub := sub();
    begin
        select employee_id bulk collect into subalterni
        from employees
        where manager_id = cod_manager;
    return subalterni;
    end subalt;
begin
    resultSub := subalt(100);
    for i in resultSub.first..resultSub.last loop
        dbms_output.put_line(resultSub(i));
    end loop;
end;
