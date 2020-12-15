select * from pacienti;

select prs.id_salariat, prs.nume, prs.prenume, t.id_pacient, p.nume, p.prenume, data_internare, data_externare
from personal prs, trateaza t, pacienti p
where prs.id_salariat = t.id_salariat and t.id_pacient = p.id_pacient
order by t.id_pacient;

-- Subprogram care prime?te ca parametru un cod de angajat ?i returneaz? lista pacien?ilor de  
-- care  acesta  a  avut grij?,  împreun?  cu  num?rul  de  zile  de  internare  pentru  fiecare pacient (indiferent de angajat)
select id_pacient
from trateaza
where id_salariat = 22;
