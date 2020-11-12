-- Exemple curs
declare
-- folosim un tablou indexat
    type dept_table_type is table of departments%rowtype index by varchar2(20);
    dept_table dept_table_type;
begin
    select * into dept_table(1) from departments
    where department_id = 10;
    dbms_output.put_line(dept_table(1).department_id || ' ' || dept_table(1).department_name || ' ' || 
                         dept_table(1).manager_id);
end;
-- Vectori
declare
    type secventa is varray(5) of varchar2(10);
    v_sec secventa := secventa('alb', 'negru', 'rosu', 'verde');
begin
    v_sec(3) := 'rosu';
    v_sec.extend; -- se adauga un element null
    v_sec(5) := 'albastru';
    -- extinderea la un alt element va genera o eroare deoarece am declarat vectorul ca fiind de 5 elemente

end;

-- INITIALIZARE SAU NU?
declare
--declar un tablou imbricat
    type alfa is table of varchar2(50);
    tab1 alfa; -- face un tablou (atomic) null
    tab2 alfa := alfa(); -- tabloul nu este nul, este initializat
begin
    if tab1 is null then
        dbms_output.put_line('tab1 este null');
    else
        dbms_output.put_line('tab1 este not null');
    end if;
    
    if tab2 is null then
        dbms_output.put_line('tab2 este null');
    else
        dbms_output.put_line('tab2 este not null');
    end if;
end;

-- Exercitii
-- 1
select * from emp_aan where employee_id = 150;
declare
    type t_rec is record (cod_ang emp_aan.employee_id%type,
                          nume emp_aan.last_name%type,
                          salariu emp_aan.salary%type,
                          cod_dept emp_aan.department_id%type);
    v_my_rec t_rec;                      
begin
    delete from emp_aan
    where employee_id = 150
    returning employee_id, last_name, salary, department_id into v_my_rec;
    dbms_output.put_line('angajatul sters este ' || v_my_rec.cod_ang || ' '|| 
                          v_my_rec.nume || ' '|| v_my_rec.salariu || ' '|| v_my_rec.cod_dept);
end;
rollback;

-- 2
desc emp_aan;
declare
    type t_rec is record (cod_ang emp_aan.employee_id%type,
                          prenume emp_aan.last_name%type,
                          nume emp_aan.last_name%type not null := 'Andronic',
                          email emp_aan.email%type not null := 'alexandra@email.com',
                          nr_telefon emp_aan.phone_number%type,
                          data_ang emp_aan.hire_date%type not null := sysdate,
                          cod_job emp_aan.job_id%type not null := 'SA_REP',
                          salariu emp_aan.salary%type,
                          comision emp_aan.commission_pct%type,
                          cod_manager emp_aan.manager_id%type,
                          cod_dept emp_aan.department_id%type);
                          
    v_my_rec t_rec; 
begin
    insert into emp_aan
    values v_my_rec;
end;
select * from emp_aan;

-- 2.b
declare
    type t_rec is record (cod_ang emp_aan.employee_id%type,
                          prenume emp_aan.last_name%type,
                          nume emp_aan.last_name%type not null := 'Andronic',
                          email emp_aan.email%type not null := 'alexandra@email.com',
                          nr_telefon emp_aan.phone_number%type,
                          data_ang emp_aan.hire_date%type not null := sysdate,
                          cod_job emp_aan.job_id%type not null := 'SA_REP',
                          salariu emp_aan.salary%type,
                          comision emp_aan.commission_pct%type,
                          cod_manager emp_aan.manager_id%type,
                          cod_dept emp_aan.department_id%type);
                          
    v_my_rec t_rec; 
begin
    v_my_rec.email := 'andronic@fmi.ro';
    update emp_aan
    set row = v_my_rec
    where upper(last_name) = upper(v_my_rec.nume);
end;
rollback;
-- 3
declare
    -- tablou indexat
    type tab_index is table of number index by binary_integer;
    -- tablou imbricat
    type tab_imbri is table of number;
    -- vector
    type vector is varray(15) of number;
    v_tab_index tab_index;
    v_tab_imbri tab_imbri;
    v_vector vector;
    i integer;
begin
    v_tab_index(1) := 72;
    v_tab_index(2) := 23;
    v_tab_imbri := tab_imbri(5, 3, 2, 8, 7);
    v_vector := vector(1, 2);
    i := v_tab_imbri.first;
    while i <= v_tab_imbri.last loop
        dbms_output.put_line('v_tab_imbri ' || v_tab_imbri(i));
        i := v_tab_imbri.next(i);
    end loop;
end;

-- 4
declare
    type tabl is table of number index by pls_integer;
    my_tablou tabl;
begin
-- adaugam 20 de elemente in tablou
    for i in 1..20 loop
        my_tablou(i) := i;
    end loop;
-- afisam acele elemente
    for i in my_tablou.first..my_tablou.last loop
        dbms_output.put_line('Elementul cu indexul ' || i || ' este ' || my_tablou(i));
    end loop;
    -- stergem tabloul
    my_tablou.delete;
end;

-- 5
select * from dept_aan;
declare
    type dept is table of dept_aan%rowtype index by binary_integer;
    v_dept dept;
begin
    v_dept(1).department_id := 280;
    v_dept(1).department_name := 'Agricultura';
    v_dept(1).manager_id := 100;
    v_dept(1).location_id := 2000;
    insert into dept_aan
    values v_dept(1);
    v_dept.delete;
end;

-- 7
create or replace type proiect as varray(50) of varchar2(15);
/
create table test_aan (cod_ang number(4),
                       proiecte_alocate proiect);
/
declare
    v_proiect proiect := proiect('DAW', 'SGBD', 'PD', 'CP');
begin
    insert into test_aan
    values (100, v_proiect);
end;
select * from test_aan;

-- 8
declare
    type t_cod_ang is varray(100) of emp_aan.employee_id%type;
    v_cod_ang t_cod_ang := t_cod_ang();
begin
    for e in (select * from emp_aan) loop
        if e.department_id = 50 and e.salary < 5000 then
            -- adaug in vector
            v_cod_ang.extend;
            v_cod_ang(v_cod_ang.count) := e.employee_id;
        end if;
    end loop;
    
    -- maresc salariul
    for i in v_cod_ang.first..v_cod_ang.last loop
        update emp_aan
        set salary = salary * 1.1
        where employee_id = v_cod_ang(i);
    end loop;
end;
rollback;
-- alta metoda
declare
    type t_cod_ang is varray(100) of emp_aan.employee_id%type;
    v_cod_ang t_cod_ang := t_cod_ang();
begin
    for e in (select * from emp_aan) loop
        if e.department_id = 50 and e.salary < 5000 then
            -- adaug in vector
            v_cod_ang.extend;
            v_cod_ang(v_cod_ang.count) := e.employee_id;
        end if;
    end loop;
    
    forall i in v_cod_ang.first..v_cod_ang.last
        update emp_aan
        set salary = salary * 1.1
        where employee_id = v_cod_ang(i);
end;

-- 9
DECLARE
    TYPE chartab IS
        TABLE OF CHAR(1);
    v_characters   chartab := chartab('M', 'a', 'd', 'a', 'm',
        ',', ' ', 'I', '''', 'm',
        ' ', 'A', 'd', 'a', 'm');
    v_index        INTEGER;
BEGIN
    v_index := v_characters.first;
    WHILE v_index <= v_characters.last LOOP
        dbms_output.put(v_characters(v_index));
        v_index := v_characters.next(v_index);
    END LOOP;

    dbms_output.new_line;
    v_index := v_characters.last;
    WHILE v_index >= v_characters.first LOOP
        dbms_output.put(v_characters(v_index));
        v_index := v_characters.PRIOR(v_index);
    END LOOP;

    dbms_output.new_line;
END;

-- 10

-- 11
declare
    type alfa is table of varchar2(50);
    tab1 alfa;
    tab2 alfa := alfa();
begin
    if tab1 is null then
        dbms_output.put_line('tab1 este null');
    else
        dbms_output.put_line('tab1 este not null');
    end if;
    if tab2 is null then
        dbms_output.put_line('tab2 este null');
    else
        dbms_output.put_line('tab2 este not null');
    end if;
end;

-- 12
declare
    type numar is table of integer;
    alfa numar;
begin
    -- declanseaza exceptia collection is null
    -- alfa(1) := 77;
    alfa := numar(15, 26, 37);
    alfa(1) := ascii('X');
    alfa(2) := 10 * alfa(1); 
    -- indicele nu se poate converti la intreg
    --alfa('P') := 77;
    -- indicele se refera la un element neinitializat
    --alfa(4) := 33;
end;

-- Exercitii
-- 13
create or replace type list_ang as varray(10) of number;
/
create table job_emp (cod_job number(3),
                      titlu_job varchar2(25),
                      info list_ang);
declare
    list1 list_ang := list_ang();
    list2 list_ang := list_ang();
    list_tip job_emp.info%type;
    v_id_job job_emp.cod_job%type;
    
begin
    
    
end;