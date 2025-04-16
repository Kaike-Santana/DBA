
Drop Table If Exists #Base
Select 
	itens_embalagens.*
,	Itens.descricao
into #Base
From itens_embalagens
Left Join Itens On Itens.id_item = itens_embalagens.id_item


drop table if exists #final
Select fato.*, dim.id_item, dim2.id_embalagem 
into #final
From Emb_Padrao_Itens Fato
Left Join #Base dim on dim.descricao = fato.descr_item
Left Join embalagens dim2 on dim2.codigo = fato.emb_padrao
Where fato.emb_padrao in ('SC','B2','BB')
and dim.id_item is not null


begin tran
update fato
set emb_padrao = 'S'
from [itens_embalagens] fato
join #final dim on  dim.id_item = fato.id_item
				and dim.id_embalagem = fato.id_embalagem

where Fato.emb_padrao is null
commit




update [itens_embalagens]
set emb_padrao = 'N'
where emb_padrao is null





Insert Into [dbo].[itens_embalagens]
           ([id_item]
           ,[id_embalagem]
           ,[qtd_por_emb]
           ,[emb_padrao]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device])
Select 
	[id_item]      
,	[id_embalagem] 
,	[qtd_por_emb]  
,	[emb_padrao]   
,	[incl_data]	   
,	[incl_user]	   
,	[incl_device]  
,	[modi_data]	   
,	[modi_user]	   
,	[modi_device]  
,	[excl_data]	   
,	[excl_user]	   
,	[excl_device]  
From (
Select 
	[id_item]      = Fato.id_item
,	[id_embalagem] = Emb.id_embalagem
,	[qtd_por_emb]  = Fato.fator_conversao
,	[emb_padrao]   = Null
,	[incl_data]	   = GetDate()
,	[incl_user]	   = 'ksantana'
,	[incl_device]  = 'PC/10.1.0.123'
,	[modi_data]	   = Null
,	[modi_user]	   = Null
,	[modi_device]  = Null
,	[excl_data]	   = Null
,	[excl_user]	   = Null
,	[excl_device]  = Null
From Itens_Conv_Unidades Fato
--Join itens_embalagens    Dim  On Dim.id_item    = Fato.id_item
Join Unidades            Uni  On Uni.id_unidade = Fato.id_unidade_Conversao  
Join Embalagens			 Emb  On Emb.codigo     = Uni.codigo Collate Latin1_General_Ci_As
)SubQuery
Where Not Exists (
			       Select *
				   From Itens_Embalagens Dim
				   Where Dim.id_item	  = SubQuery.id_item
				   And   Dim.id_embalagem = SubQuery.id_embalagem
				 )