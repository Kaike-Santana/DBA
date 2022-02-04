
/* MANEIRA DE DECLARAR VARIALVEL NO POSTGRES */

set session my.vars.id = '1';

select *
from mmp_pre_dossie 
where id = current_setting('my.vars.id')::INT;

