-- 1
set serveroutput on
declare
    v_nr number(4);
    v_nume departments.department_name%type;
    cursor c is 
        select department_name nume, count(employee_id) nr
        from departments d, employees e
        where d.department_id = e.department_id (+)
        group by department_name;
begin
--  deschid cursorul
    open c;
    loop
        -- incarc cursorul cu date
        fetch c into v_nume, v_nr;
        exit when c%notfound;
        if v_nr = 0 then
            dbms_output.put_line('In departamentul ' || v_nume|| ' nu lucreaza angajati');
        elsif v_nr = 1 then
            dbms_output.put_line('In departamentul ' || v_nume|| ' lucreaza un angajat');
        else
            dbms_output.put_line('In departamentul ' || v_nume|| ' lucreaza ' || v_nr || ' angajati');
        end if;
    end loop;
    close c;
end;

-- 2
declare
    type tab_nume is table of departments.department_name%type;
    type tab_nr is table of number(4);
    v_nume tab_nume;
    v_nr tab_nr;
    cursor c is
        select department_name nume, count(employee_id) nr
        from departments d, employees e
        where d.department_id = e.department_id(+)
        group by department_name;
begin
    open c;
    -- introduc toate liniile din cursor in colectii
    fetch c bulk collect into v_nume, v_nr;
    close c;
    -- parcurg colectiile
    for i in v_nume.first..v_nume.last loop
        if v_nr(i) = 0 then
            dbms_output.put_line('In departamentul ' || v_nume(i)|| ' nu lucreaza angajati');
        elsif v_nr(i) = 1 then
            dbms_output.put_line('In departamentul ' || v_nume(i)|| ' lucreaza un angajat');
        else
            dbms_output.put_line('In departamentul ' || v_nume(i)|| ' lucreaza ' || v_nr(i) || ' angajati');
        end if;
    end loop;
end;

-- 3 - ciclu cursor
declare
    cursor c is
        select department_name nume, count(employee_id) nr
        from departments d, employees e
        where d.department_id = e.department_id(+)
        group by department_name;
begin
    for i in c loop
        if i.nr = 0 then
            dbms_output.put_line('In departamentul ' || i.nume|| ' nu lucreaza angajati');
        elsif i.nr = 1 then
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza un angajat');
        else
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza ' || i.nr || ' angajati');
        end if;
    end loop;
end;

-- 4 - ciclu cursor cu subcereri
begin
    for i in (select department_name nume, count(employee_id) nr
              from departments d, employees e
              where d.department_id = e.department_id(+)
              group by department_name) loop
        if i.nr = 0 then
            dbms_output.put_line('In departamentul ' || i.nume|| ' nu lucreaza angajati');
        elsif i.nr = 1 then
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza un angajat');
        else
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza ' || i.nr || ' angajati');
        end if;
    end loop;
end;

-- 5
declare
    v_cod employees.employee_id%type;
    v_nume employees.last_name%type;
    v_nr number(4);
    cursor c is 
        select sef.employee_id cod, max(sef.last_name) nume, count(*) nr
        from employees sef, employees ang
        where ang.manager_id = sef.employee_id
        group by sef.employee_id
        order by nr desc;
        
begin
    open c;
    loop
        fetch c into v_cod, v_nume, v_nr;
        exit when c%rowcount > 3 or c%notfound;
        dbms_output.put_line('Managerul ' || v_cod || v_nume || ' conduce ' || 
                             v_nr || ' angajati.');
    end loop;
    -- eliberam memoria => inchidem cursorul
    close c;
end;  

-- in sql
with tabel_manageri as (
        select sef.employee_id cod, max(sef.last_name) nume, count(*) nr
        from employees sef, employees ang
        where ang.manager_id = sef.employee_id
        group by sef.employee_id
        order by nr desc
)
select cod, nume, nr
from tabel_manageri
where rownum <= 3;

-- 6
DECLARE
 CURSOR c IS
     SELECT sef.employee_id cod, MAX(sef.last_name) nume,
     count(*) nr
     FROM employees sef, employees ang
     WHERE ang.manager_id = sef.employee_id
     GROUP BY sef.employee_id
     ORDER BY nr DESC;
BEGIN
     FOR i IN c LOOP
     EXIT WHEN c%ROWCOUNT>3 OR c%NOTFOUND;
     DBMS_OUTPUT.PUT_LINE('Managerul '|| i.cod ||
     ' avand numele ' || i.nume ||
     ' conduce '|| i.nr||' angajati');
     END LOOP;
END;
/

-- 7
DECLARE
    top number(1):= 0;
BEGIN
     FOR i IN (SELECT sef.employee_id cod, MAX(sef.last_name) nume,
     count(*) nr
     FROM employees sef, employees ang
     WHERE ang.manager_id = sef.employee_id
     GROUP BY sef.employee_id
     ORDER BY nr DESC)
     LOOP
     DBMS_OUTPUT.PUT_LINE('Managerul '|| i.cod ||
     ' avand numele ' || i.nume ||
     ' conduce '|| i.nr||' angajati');
     Top := top+1;
     EXIT WHEN top=3;
     END LOOP;
END;
/

-- 8
-- varianta 1
declare
    v_x number(4) := &p_x;
    v_nr number(4);
    v_nume departments.department_name%type;
    -- folosim cursor parametrizat
    cursor c (par number) is 
        select department_name nume, count(employee_id) nr
        from departments d, employees e
        where d.department_id = e.department_id(+)
        group by department_name
        having count(employee_id) >= par;
begin
    -- cand deschidem cursorul trebuie sa ii dam si parametrul
    open c(v_x);
    loop
        fetch c into v_nume, v_nr;
        exit when c%notfound;
        dbms_output.put_line('In departamentul ' || v_nume|| ' lucreaza ' || v_nr || ' angajati');
    end loop;
    close c;
end;

-- varianta 2
declare
    v_x number(4) := &p_x;
    cursor c (par number) is 
        select department_name nume, count(employee_id) nr
        from departments d, employees e
        where d.department_id = e.department_id(+)
        group by department_name
        having count(employee_id) >= par;
begin
    -- deoarece folosesc ciclu cursor nu mai trebuie sa-l deschid
    for i in c(v_x) loop
        dbms_output.put_line('In departamentul ' || i.nume|| ' lucreaza ' || i.nr || ' angajati');
    end loop;
end;

-- varianta 3
declare
    v_x number(4) := &p_x;
begin
    for i in (select department_name nume, count(employee_id) nr
              from departments d, employees e
              where d.department_id = e.department_id(+)
              group by department_name
              having count(employee_id) >= v_x) loop
        dbms_output.put_line('In departamentul ' || i.nume|| ' lucreaza ' || i.nr || ' angajati');     
    end loop;   
    close c;
end;
-- 9
select last_name, hire_date, salary
from emp_aan
where to_char(hire_date, 'yyyy') = 2000;
rollback;
declare
    cursor c is
        select *
        from emp_aan
        where to_char(hire_date, 'YYYY') = 2000
        for update of salary nowait;
begin
    for i in c loop
        update emp_aan
        set salary = salary + 1000
        where current of c;
    end loop;
end;

-- 10
-- varianta 1
begin
    for v_dept in (select department_id, department_name
                   from departments
                   where department_id in (10, 20, 30, 40)) loop
        
        dbms_output.put_line('-----------------------------');
        dbms_output.put_line('department ' || v_dept.department_name);
        dbms_output.put_line('-----------------------------');
        for v_emp in (select last_name
                      from employees
                      where department_id = v_dept.department_id) loop
            dbms_output.put_line(v_emp.last_name);
        end loop;
            
    end loop;
end;

-- varianta 2 - expresii cursor
declare
    type refcursor is ref cursor;
    
    cursor c_dept is
        select department_name,
            cursor (select last_name
                    from employees e
                    where e.department_id = d.department_id)
        from departments d
        where department_id in (10, 20, 30, 40);
    
    v_nume_dept departments.department_name%type;
    v_cursor refcursor;
    v_nume_ang employees.last_name%type;
        
begin
    open c_dept;
    loop
        fetch c_dept into v_nume_dept, v_cursor;
        exit when c_dept%notfound;
        dbms_output.put_line('-----------------------------');
        dbms_output.put_line('department ' || v_dept.department_name);
        dbms_output.put_line('-----------------------------');
        loop
            fetch v_cursor into v_nume_ang;
            exit when v_cursor%notfound;
            dbms_output.put_line(v_nume_ang);
        end loop;
    end loop;
    close c_dept;
end;

-- 11 - cursor dinamic
declare
    type emp_tip is ref cursor return employees%rowtype;
    v_emp emp_tip;
    v_opt number := &p_opt;
    v_ang employees%rowtype;
begin
    if v_opt = 1 then
        open v_emp for select * from employees;
    elsif v_opt = 2 then
        open v_emp for select * 
                       from employees
                       where salary between 10000 and 20000;
    elsif v_opt = 3 then
        open v_emp for select * 
                       from employees
                       where to_char(hire_date, 'yyyy') = 2000;
    else
        dbms_output.put_line('Optiune incorecta');
    end if;    
    loop
        fetch v_emp into v_ang;
        exit when v_emp%notfound;
        dbms_output.put_line(v_ang.last_name);
    end loop;
    dbms_output.put_line('Au fost procesate ' || v_emp%rowcount || ' linii.');
    close v_emp;
end;


-- 12
select * from employees where salary > 10000;
declare
    type empref is ref cursor;
    v_emp empref;
    v_nr integer := &p_n;
    v_emp_cod employees.employee_id%type;
    v_salariu employees.salary%type;
    v_comision employees.commission_pct%type;
begin
    open v_emp for
        'select employee_id, salary, commission_pct ' ||
        'from employees where salary > :bind_var'
        using v_nr;
    loop
        fetch v_emp into v_emp_cod, v_salariu, v_comision;   
        exit when v_emp%notfound;
        if v_comision is null then
            dbms_output.put_line('Angajatul cu codul ' || v_emp_cod || ' are salariu ' || v_salariu || ' si nu are comision.');
        else
            dbms_output.put_line('Angajatul cu codul ' || v_emp_cod || ' are salariu ' || v_salariu || ' si comisionul de ' || v_comision);
        end if;
    end loop;
    close v_emp;
end;



-- Exercitii
-- pentru fiecare job(titlu) => se afiseaza lista angajatilor (nume si salariu)
select * from employees;
select * from jobs;
-- trebuie sa fac un join intre employees si jobs pentru a lua titlul
-- dupa care trebuie grupa dupa titlu
select job_title, last_name, salary
from employees e, jobs j
where e.job_id = j.job_id;

declare
    type refcursor is ref cursor;
    cursor c is 
        select job_title,
            cursor (select last_name, salary
                    from employees e
                    where e.job_id = j.job_id)
        from jobs j;
    v_cursor refcursor;
    v_job_nume jobs.job_title%type;
    v_nume_emp employees.last_name%type;
    v_salariu employees.salary%type;
begin
    open c;
    loop
        fetch c into v_job_nume, v_cursor;
        exit when c%notfound;
        dbms_output.put_line('-----------------');
        dbms_output.put_line(v_job_nume);
        dbms_output.put_line('-----------------');
        loop
            fetch v_cursor into v_nume_emp, v_salariu;
            exit when v_cursor%notfound;
            dbms_output.put_line(v_nume_emp || ' ' || v_salariu);
        end loop;
    end loop;

end;

-- 2
declare
    type refcursor is ref cursor;
    cursor c is 
        select job_title,
            cursor (select last_name, salary
                    from employees e
                    where e.job_id = j.job_id
                    order by salary desc)
        from jobs j;
    v_cursor refcursor;
    v_job_nume jobs.job_title%type;
    v_nume_emp employees.last_name%type;
    v_salariu employees.salary%type;
    v_index number(3) := 1;
    v_suma number(20) := 0;
    v_medie_sal number(20) := 0;
    v_total_sal number(20) := 0;
    v_all_medie number(20);
    v_nr_total_ang number(20) := 0;
begin
    open c;
    loop
        fetch c into v_job_nume, v_cursor;
        exit when c%notfound;
        dbms_output.put_line('-----------------');
        dbms_output.put_line(v_job_nume);
        dbms_output.put_line('-----------------');
        loop
            fetch v_cursor into v_nume_emp, v_salariu;
            exit when v_cursor%notfound;
            dbms_output.put(v_index || '. ');
            dbms_output.put_line(v_nume_emp || ' ' || v_salariu);
            v_index := v_index + 1;
            v_suma := v_suma + v_salariu;
        end loop;
        dbms_output.put_line('Salariul lunar pentru toti angajatii: ' || v_suma);
        v_medie_sal := v_suma / v_index;
        dbms_output.put_line('Salariul mediu este ' || v_medie_sal);
        -- numarul total de angajati
        v_nr_total_ang := v_index + v_nr_total_ang;
        -- valoarea totala lunara a salariilor
        v_total_sal := v_total_sal + v_suma;
        v_suma := 0;
        v_index := 1;
    end loop;
    -- valoarea medie a veniturilor
    v_all_medie := v_total_sal / v_nr_total_ang;
    dbms_output.put_line('------------------------------');
    dbms_output.put_line('Informatiile afisate indiferent de job: ');
    dbms_output.put_line('Numarul total de angajati este ' || v_nr_total_ang);
    dbms_output.put_line('Valoarea totala lunara a veniturilor este '|| v_total_sal);
    dbms_output.put_line('Valoarea medie a veniturilor angajatilor este ' || v_all_medie);
    
end;



-- 3 ?? nu inteleg bine cerinta



-- 4
declare
    type refcursor is ref cursor;
    cursor c is 
        select job_title,
            cursor (select last_name, salary
                    from employees e
                    where e.job_id = j.job_id
                    order by salary desc)
        from jobs j;
    v_cursor refcursor;
    v_job_nume jobs.job_title%type;
    v_nume_emp employees.last_name%type;
    v_salariu employees.salary%type;
    v_index number(3) := 1;
begin
    open c;
    loop
        fetch c into v_job_nume, v_cursor;
        exit when c%notfound;
        dbms_output.put_line('-----------------');
        dbms_output.put_line(v_job_nume);
        dbms_output.put_line('-----------------');
        loop
            fetch v_cursor into v_nume_emp, v_salariu;
            exit when v_cursor%rowcount > 5 or v_cursor%notfound;
            dbms_output.put(v_index || '. ');
            dbms_output.put_line(v_nume_emp || ' ' || v_salariu);
            v_index := v_index + 1;
        end loop;
        if v_index < 5 then
            dbms_output.put_line('Acest job are mai putin de 5 angajati');
        end if;
        v_index := 1;
    end loop;
end;


-- 5
declare
    type refcursor is ref cursor;
    cursor c is 
        select job_title,
            cursor (select last_name, salary
                    from employees e
                    where e.job_id = j.job_id
                    order by salary desc)
        from jobs j;
    v_cursor refcursor;
    v_job_nume jobs.job_title%type;
    v_nume_emp employees.last_name%type;
    v_salariu employees.salary%type;
    v_salariu_ant employees.salary%type;
    v_index number(3) := 1;
    top number(2) := 1;
begin
    open c;
    loop
        fetch c into v_job_nume, v_cursor;
        exit when c%notfound;
        dbms_output.put_line('-----------------');
        dbms_output.put_line(v_job_nume);
        dbms_output.put_line('-----------------');
        fetch v_cursor into v_nume_emp, v_salariu;
        v_salariu_ant := v_salariu;
        dbms_output.put(v_index || '. ');
        dbms_output.put_line(v_nume_emp || ' ' || v_salariu);
        v_index := v_index + 1;
        loop
            fetch v_cursor into v_nume_emp, v_salariu;
            exit when top >= 5 or v_cursor%notfound;
            if v_salariu_ant <> v_salariu then 
                top := top + 1;
                v_salariu_ant := v_salariu;
            end if;
            dbms_output.put(v_index || '. ');
            dbms_output.put_line(v_nume_emp || ' ' || v_salariu);
            
            v_index := v_index + 1;
        end loop;
        top := 1;
        if v_index < 5 then
            dbms_output.put_line('Acest job are mai putin de 5 angajati');
        end if;
        v_index := 1;
    end loop;
end;


