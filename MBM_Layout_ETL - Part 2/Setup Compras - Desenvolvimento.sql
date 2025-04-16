
Use Thesys_Dev
Go

Drop Table If Exists #Base_ItemNF
Select *
Into #Base_ItemNF
From OpenQuery([Mbm_Poliresinas],'
Select
  n.cod_empresa,
  n.cod_clifor, 
  cf.fantasia, 
  cf.cgc_cpf, 
  Empresa.Cod_Estado As Uf_Vendedor,
  n.uf_clifor, 
  n.nro_nfiscal, 
 -- n.cod_pedidocompra, 
 -- pc.tipo_compra, 
  n.entrada_saida, 
  n.dt_emissao, 
  ni.cod_tributacao, 
  --ni.cod_classfiscal, 
  ni.cod_natoperacao, 
  ni.ind_sittrib, 
  ni.cod_item, 
  ni.codigo, 
  ni.descricao, 
  ni.tipo_produto, 
 -- ni.cod_unidadevenda, 
 -- ni.cod_unidade, 
 -- ni.quantidade, 
 -- ni.peso, 
 -- ni.aliq_icms, 
  ni.valor_bruto, 
  ni.valor_unitario, 
  ni.qtd_venda, 
  ni.preco_unitvenda, 
  ni.valor_total 
--  ni.aliq_ipi, 
--  ni.aliq_pis, 
--  ni.aliq_cofins, 
--  ni.aliq_ir, 
--  ni.aliq_inss, 
--  ni.iss_retidofonte, 
--  ni.cofins_retidofonte, 
--  ni.valor_zonafranca, 
--  ni.aliq_importacao, 
--  ni.aliq_icms_sub, 
--  ni.valor_icms_sub, 
--  ni.substituicao_tributaria, 
--  ni.perc_icms_subst, 
--  ni.tipo_substtrib, 
--  i.cod_grupoestoque 
From 
  Nota_Fiscal n 
  join Empresa			  On  (empresa.cod_empresa =  n.cod_empresa     )
  join Item_NotaFiscal ni On  (ni.cod_empresa	   =  n.cod_empresa 	)
						  And (ni.cod_clifor	   =  n.cod_clifor  	)
						  And (ni.serie			   =  n.serie 			)
						  And (ni.nro_nfiscal	   =  n.nro_nfiscal 	)
  join Item i			  On  (i.cod_item		   =  ni.cod_item 		)
  join Clifor cf		  On  (cf.cod_clifor	   =  n.cod_clifor 		)
  join Nat_Operacao nop   On  (nop.cod_natoperacao =  ni.cod_natoperacao) 
--  join Pedido_Compra pc	  On  (pc.cod_pedidocompra =  n.cod_pedidocompra) 
--  					      And (pc.cod_empresa	   =  n.cod_empresa     )
Where n.Dt_Cancelado Is Null
And n.Cod_TipoNatureza = ''018'' --> Serviço
And Left(Rtrim(Ltrim(ni.cod_natoperacao)),1) In (''1'',''2'')
')


Select *
,	Id_NatOper_Compra_Outra_Uf = Case 
                                    When Uf_Clifor = Uf_Vendedor Then 
																	  (
																	   Case 
																	      When Substring(Cod_NatOperacao, 1, 1) = '1' Then Stuff(Cod_NatOperacao, 1, 1, '2')
																	      When Substring(Cod_NatOperacao, 1, 1) = '2' Then Stuff(Cod_NatOperacao, 1, 1, '1')
																	      Else Cod_NatOperacao
																	   End
																	  )
                                    Else Cod_NatOperacao 
                                 End
From (
Select *
,   Id_NatOper_Compra_Mesma_Uf = Case 
                                    When Uf_Clifor != Uf_Vendedor Then 
																	  (
																	   Case 
																	      When Substring(Cod_NatOperacao, 1, 1) = '1' Then Stuff(Cod_NatOperacao, 1, 1, '2')
																	      When Substring(Cod_NatOperacao, 1, 1) = '2' Then Stuff(Cod_NatOperacao, 1, 1, '1')
																	      Else Cod_NatOperacao
																	   End
																	  )
                                    Else Cod_NatOperacao 
                                 End
,	Rw = Row_Number() Over ( Partition By Cod_clifor Order By Cod_clifor, Dt_Emissao Desc)
From #Base_ItemNF
)SubQuery
Where Rw = 1



select distinct cod_natoperacao
from #Base_ItemNF

CLIFOR_NATOPER