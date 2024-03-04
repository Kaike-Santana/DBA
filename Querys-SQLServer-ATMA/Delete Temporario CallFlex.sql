


select min(data), max(data) from tb_ds_callflex_mes_renner
select min(data), max(data) from tb_ds_callflex_mes_picpay
select min(data), max(data) from tb_ds_replica_atmsp6b1_mes
select min(data), max(data) from tb_ds_callflex_mes

Delete From Tb_Ds_CallFlex_Mes         Where Data Between '2023-12-01' And '2023-12-31'

Delete From tb_ds_callflex_mes_renner  Where Data Between '2023-12-01' And '2023-12-31'

Delete From tb_ds_callflex_mes_picpay  Where Data Between '2023-12-01' And '2023-12-31'

Delete From tb_ds_replica_atmsp6b1_mes Where Data Between '2023-12-01' And '2023-12-31'