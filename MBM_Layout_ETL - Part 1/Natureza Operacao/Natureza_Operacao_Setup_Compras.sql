
Use Thesys_Dev
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* Programador: Kaike Natan																		*/
/* Versao     : Data: 22/07/2024																*/
/* Descricao  : Script De ETL Da Tabela de Setup De Compras Do MBM Para o Thesys_Dev			*/
/*																								*/
/* Alteracao																					*/
/*        2. Programador:                                                  Data: __/__/____		*/        
/*           Descricao  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	Alter Procedure Prc_Etl_NatOper_SetupCompras as
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida Base Das 5 empresas Para Popular a Tabela Natureza_Setup_Compras		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Begin; 
  Set Nocount On;
Drop Table If Exists #SetupComprasMBM
Select 
	Empresa = 'PoliResinas'
,	* 
Into #SetupComprasMBM
From OpenQuery([Mbm_Poliresinas],'
Select 
	n.cod_empresa
,	n.cod_clifor
,	cf.fantasia
,	cf.cgc_cpf
,	emp.cod_estado as uf_origem
,	n.uf_clifor
,	n.nro_nfiscal
,	n.cod_pedidocompra
,	pc.tipo_compra
,	n.entrada_saida
,	n.dt_emissao
,   ni.cod_tributacao
,	ni.cod_classfiscal
,	ni.cod_natoperacao
,	ni.ind_sittrib
,	ni.cod_item
,	ni.codigo
,	ni.descricao
From nota_fiscal n 
join empresa emp        On  (emp.cod_empresa     = n.cod_empresa     )
Join item_notafiscal ni On  (ni.cod_clifor		 = n.cod_clifor 	 )
						And (ni.cod_empresa		 = n.cod_empresa 	 )
						And (ni.serie			 = n.serie 			 )
						And (ni.nro_nfiscal		 = n.nro_nfiscal	 )
Join item i				On  (i.cod_item			 = ni.cod_item		 )
Join clifor cf			On  (cf.cod_clifor		 = n.cod_clifor 	 )
Join nat_operacao nop	On  (nop.cod_natoperacao = ni.cod_natoperacao)
Join pedido_compra pc	On  (pc.cod_pedidocompra = n.cod_pedidocompra) 
						And (pc.cod_empresa		 = n.cod_empresa     )
Where pc.Tipo_Compra Is Not Null
And ni.cod_classfiscal Is Not Null
')

Union All

Select 
	Empresa = 'Rubberon'
,	* 
From OpenQuery([Mbm_Rubberon],'
Select 
	n.cod_empresa
,	n.cod_clifor
,	cf.fantasia
,	cf.cgc_cpf
,	emp.cod_estado as uf_origem
,	n.uf_clifor
,	n.nro_nfiscal
,	n.cod_pedidocompra
,	pc.tipo_compra
,	n.entrada_saida
,	n.dt_emissao
,   ni.cod_tributacao
,	ni.cod_classfiscal
,	ni.cod_natoperacao
,	ni.ind_sittrib
,	ni.cod_item
,	ni.codigo
,	ni.descricao
From nota_fiscal n 
join empresa emp        On  (emp.cod_empresa     = n.cod_empresa     )
Join item_notafiscal ni On  (ni.cod_clifor		 = n.cod_clifor 	 )
						And (ni.cod_empresa		 = n.cod_empresa 	 )
						And (ni.serie			 = n.serie 			 )
						And (ni.nro_nfiscal		 = n.nro_nfiscal	 )
Join item i				On  (i.cod_item			 = ni.cod_item		 )
Join clifor cf			On  (cf.cod_clifor		 = n.cod_clifor 	 )
Join nat_operacao nop	On  (nop.cod_natoperacao = ni.cod_natoperacao)
Join pedido_compra pc	On  (pc.cod_pedidocompra = n.cod_pedidocompra) 
						And (pc.cod_empresa		 = n.cod_empresa     )
Where n.Cod_Empresa != ''001''
And pc.Tipo_Compra Is Not Null
And ni.cod_classfiscal Is Not Null
')

Union All

Select 
	Empresa = 'Mg_Polimeros'
,	* 
From OpenQuery([Mbm_Mg_Polimeros],'
Select 
	n.cod_empresa
,	n.cod_clifor
,	cf.fantasia
,	cf.cgc_cpf
,	emp.cod_estado as uf_origem
,	n.uf_clifor
,	n.nro_nfiscal
,	n.cod_pedidocompra
,	pc.tipo_compra
,	n.entrada_saida
,	n.dt_emissao
,   ni.cod_tributacao
,	ni.cod_classfiscal
,	ni.cod_natoperacao
,	ni.ind_sittrib
,	ni.cod_item
,	ni.codigo
,	ni.descricao
From nota_fiscal n 
join empresa emp        On  (emp.cod_empresa     = n.cod_empresa     )
Join item_notafiscal ni On  (ni.cod_clifor		 = n.cod_clifor 	 )
						And (ni.cod_empresa		 = n.cod_empresa 	 )
						And (ni.serie			 = n.serie 			 )
						And (ni.nro_nfiscal		 = n.nro_nfiscal	 )
Join item i				On  (i.cod_item			 = ni.cod_item		 )
Join clifor cf			On  (cf.cod_clifor		 = n.cod_clifor 	 )
Join nat_operacao nop	On  (nop.cod_natoperacao = ni.cod_natoperacao)
Join pedido_compra pc	On  (pc.cod_pedidocompra = n.cod_pedidocompra) 
						And (pc.cod_empresa		 = n.cod_empresa     )
Where n.Cod_Empresa Not In (''001'',''300'')
And pc.Tipo_Compra Is Not Null
And ni.cod_classfiscal Is Not Null
')

Union All

Select 
	Empresa = 'Polirex'
,	* 
From OpenQuery([Mbm_Polirex],'
Select 
	n.cod_empresa
,	n.cod_clifor
,	cf.fantasia
,	cf.cgc_cpf
,	emp.cod_estado as uf_origem
,	n.uf_clifor
,	n.nro_nfiscal
,	n.cod_pedidocompra
,	pc.tipo_compra
,	n.entrada_saida
,	n.dt_emissao
,   ni.cod_tributacao
,	ni.cod_classfiscal
,	ni.cod_natoperacao
,	ni.ind_sittrib
,	ni.cod_item
,	ni.codigo
,	ni.descricao
From nota_fiscal n 
join empresa emp        On  (emp.cod_empresa     = n.cod_empresa     )
Join item_notafiscal ni On  (ni.cod_clifor		 = n.cod_clifor 	 )
						And (ni.cod_empresa		 = n.cod_empresa 	 )
						And (ni.serie			 = n.serie 			 )
						And (ni.nro_nfiscal		 = n.nro_nfiscal	 )
Join item i				On  (i.cod_item			 = ni.cod_item		 )
Join clifor cf			On  (cf.cod_clifor		 = n.cod_clifor 	 )
Join nat_operacao nop	On  (nop.cod_natoperacao = ni.cod_natoperacao)
Join pedido_compra pc	On  (pc.cod_pedidocompra = n.cod_pedidocompra) 
						And (pc.cod_empresa		 = n.cod_empresa     )
Where n.Cod_Empresa != ''001''
And pc.Tipo_Compra Is Not Null
And ni.cod_classfiscal Is Not Null
')

Union All

Select 
	Empresa = 'Nortebag'
,	* 
From OpenQuery([Mbm_Nortebag],'
Select 
	n.cod_empresa
,	n.cod_clifor
,	cf.fantasia
,	cf.cgc_cpf
,	emp.cod_estado as uf_origem
,	n.uf_clifor
,	n.nro_nfiscal
,	n.cod_pedidocompra
,	pc.tipo_compra
,	n.entrada_saida
,	n.dt_emissao
,   ni.cod_tributacao
,	ni.cod_classfiscal
,	ni.cod_natoperacao
,	ni.ind_sittrib
,	ni.cod_item
,	ni.codigo
,	ni.descricao
From nota_fiscal n 
join empresa emp        On  (emp.cod_empresa     = n.cod_empresa     )
Join item_notafiscal ni On  (ni.cod_clifor		 = n.cod_clifor 	 )
						And (ni.cod_empresa		 = n.cod_empresa 	 )
						And (ni.serie			 = n.serie 			 )
						And (ni.nro_nfiscal		 = n.nro_nfiscal	 )
Join item i				On  (i.cod_item			 = ni.cod_item		 )
Join clifor cf			On  (cf.cod_clifor		 = n.cod_clifor 	 )
Join nat_operacao nop	On  (nop.cod_natoperacao = ni.cod_natoperacao)
Join pedido_compra pc	On  (pc.cod_pedidocompra = n.cod_pedidocompra) 
						And (pc.cod_empresa		 = n.cod_empresa     )
Where n.Cod_Empresa != ''001''
And pc.Tipo_Compra Is Not Null
And ni.cod_classfiscal Is Not Null
')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Tabela Auxiliar Com os Estados e Suas Respectivas Regioes							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Regioes
Create Table #Regioes (
					   Cod_Estado Varchar(2),
					   Regiao     Varchar(20)
					  );

Insert Into #Regioes (Cod_Estado, Regiao) 
Values ('SP', 'Sudeste'),
	   ('RJ', 'Sudeste'),
	   ('MG', 'Sudeste'),
	   ('ES', 'Sudeste'),
	   ('PR', 'Sul'),
	   ('SC', 'Sul'),
	   ('RS', 'Sul'),
	   ('AM', 'Norte'),
	   ('RR', 'Norte'),
	   ('AP', 'Norte'),
	   ('PA', 'Norte'),
	   ('TO', 'Norte'),
	   ('AC', 'Norte'),
	   ('RO', 'Norte'),
	   ('AL', 'Nordeste'),
	   ('BA', 'Nordeste'),
	   ('CE', 'Nordeste'),
	   ('MA', 'Nordeste'),
	   ('PB', 'Nordeste'),
	   ('PE', 'Nordeste'),
	   ('PI', 'Nordeste'),
	   ('RN', 'Nordeste'),
	   ('SE', 'Nordeste'),
	   ('DF', 'Centro-Oeste'),
	   ('GO', 'Centro-Oeste'),
	   ('MT', 'Centro-Oeste'),
	   ('MS', 'Centro-Oeste'),
	   ('EX', 'Exterior')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Tabela Padrao Com o ID de Cada Regiao												*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Aux_Regiao 
Select *
Into #Aux_Regiao
From Tabela_Padrao
Where Cod_TabelaPadrao = 'Regiao_Nat_Operacao'

Create NonClustered Index Sku_Descricao On #Aux_Regiao (Descricao) Include (Id_Tabela_Padrao)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Inclui na Base do MBM, a Regiao e o Id da Empresa									*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #BaseFinal 
Select 
	Fato.*
,	Dim.Regiao
,	Emp.Id_Empresa
,	Emp.Id_Empresa_Grupo
Into #BaseFinal
From #SetupComprasMBM Fato
Inner Join #Regioes	  Dim  On Dim.Cod_Estado    = Fato.Uf_Clifor
Inner Join Empresas	  Emp  On Emp.Codigo_Antigo	= Fato.Cod_Empresa Collate Latin1_General_Ci_Ai
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Deixa a Ultima Nat de Operacao Por Empresa, Fornenedor e Item						*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #UltCompraClifor
Select *
Into #UltCompraClifor
From (
	   Select *
	   ,	Rw = Row_Number() Over (Partition By Id_Empresa_Grupo, Cod_NatOperacao, Cod_ClassFiscal, Tipo_Compra, Uf_Origem, Uf_CLifor  Order By Dt_Emissao Desc) 
	   From #BaseFinal
	 )SubQuery
Where Rw = 1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Check, Garantindo Que Nao Tenha ClassFiscal Para Mesma Uf de Destino por Empresa	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Final
Select *
Into #Final
From (
	   Select *
	   ,	Rn = Row_Number() Over ( Partition By Id_Empresa_Grupo, Cod_ClassFiscal, Uf_Origem, Uf_CLifor Order By Dt_Emissao Desc)
	   From #UltCompraClifor
	 )SubQuery
Where Rn = 1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Temporaria Para Guardar Possiveis Naturezas de Operacao Que Nao Existam na Tabela	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #Naturezas_Nao_Correspondidas;
Create Table #Naturezas_Nao_Correspondidas (
    Cod_NatOperacao Varchar(255),
    Id_Empresa_Grupo Int
);
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Temporaria Para Guardar Possiveis ClassFiscal Que Nao Existam na Tabela do Thesys	*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #ClassFiscal_Nao_Correspondida;
Create Table #ClassFiscal_Nao_Correspondida (
    Cod_ClassFiscal Varchar(255)
);
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Inseri Os Itens Que Nao Tem correspondencia Na Tabela								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into #ClassFiscal_Nao_Correspondida (Cod_ClassFiscal)
Select Distinct Fato.Cod_ClassFiscal
From #Final Fato
Left Join Class_Fiscal As Cf On  Cf.Cod_ClassFiscal	= Fato.Cod_ClassFiscal  Collate Latin1_General_Ci_Ai
Where Cf.id_clasfisc Is Null
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Inseri Os Itens Que Nao Tem correspondencia Na Tabela								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into #Naturezas_Nao_Correspondidas (Cod_NatOperacao, Id_Empresa_Grupo)
Select Distinct 
    Fato.Cod_NatOperacao,
    Fato.Id_Empresa_Grupo
From #Final Fato
Left Join Natureza_Operacao As Nat On  Nat.Cod_NatOperacao	= Fato.Cod_NatOperacao  Collate Latin1_General_Ci_Ai
								   And Nat.Id_Empresa_Grupo = Fato.Id_Empresa_Grupo
Where Nat.Cod_NatOperacao Is Null
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Verificar Se Ha ClassFiscais Nao Correspondidas e Envia o E-mail					*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
If Exists(
		  Select 1 From #ClassFiscal_Nao_Correspondida
		 )
Begin
    Declare @Body      Nvarchar(Max)
    Declare @Periodo   Nvarchar(Max)
    Declare @Frase     Nvarchar(Max) = 'as ClassFiscasis Abaixo, Precisam ser Preenchidas na Tabela: Class_Fiscal ';

    -- Definindo a saudacao com base na hora do dia
    If (DatePart(Hour, GetDate()) Between 0 And 12)
        Set @Periodo = 'Bom dia, ' + ' ' + @Frase
    Else If (DatePart(Hour, GetDate()) Between 13 AND 18)
        Set @Periodo = 'Boa Tarde, ' + ' ' + @Frase
    Else
        Set @Periodo = 'Boa Noite, ' + ' ' + @Frase

    -- Formatando o corpo do email em HTML
    Set @Body = 
        '<h3>' + @Periodo + '</h3>' +
        '<table border="1" width="100%">' +
        '<tr>' +
        '<th>Cod_ClassFiscal</th>' +
        '</tr>' +
        Cast((
            Select 
                Cod_ClassFiscal AS [TD], ''
            From #ClassFiscal_Nao_Correspondida
            For Xml Raw('tr'), Elements 
        ) As Nvarchar(Max)) +
        '</table>' +
        '<br><br>Informa  o extra da em: ' + Convert(Nvarchar, GetDate(), 113);

    Begin Try
        Exec Msdb.Dbo.Sp_Send_DbMail 
            @profile_name = 'MSSQLServer',
            @recipients = 'kaike.santana@atrpservices.com.br;thanner.almeida@atrpservices.com.br',
            @subject = 'Alerta: Class_Fiscal Nao Correspondida Encontrada',
            @body = @Body,
            @body_format = 'HTML';
    End Try
    Begin Catch
        Print 'Erro ao enviar email.';
    End Catch
End;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Verificar Se Ha Itens Nao Correspondidos e Envia o E-mail							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
If Exists(
		  Select 1 From #Naturezas_Nao_Correspondidas
		 )
Begin
    Set @Frase   = 'as CFOP Abaixo, Precisam ser Preenchidas na Tabela: Natureza_Operacao ';

    -- Definindo a saudacao com base na hora do dia
    If (DatePart(Hour, GetDate()) Between 0 And 12)
        Set @Periodo = 'Bom dia, ' + ' ' + @Frase
    Else If (DatePart(Hour, GetDate()) Between 13 AND 18)
        Set @Periodo = 'Boa Tarde, ' + ' ' + @Frase
    Else
        Set @Periodo = 'Boa Noite, ' + ' ' + @Frase

    -- Formatando o corpo do email em HTML
    Set @Body = 
        '<h3>' + @Periodo + '</h3>' +
        '<table border="1" width="100%">' +
        '<tr>' +
        '<th>Cod_NatOperacao</th><th>Id_Empresa</th>' +
        '</tr>' +
        Cast((
            Select 
                Cod_NatOperacao AS [TD], '', 
                id_empresa_grupo AS [TD], ''
            From #Naturezas_Nao_Correspondidas
            For Xml Raw('tr'), Elements 
        ) As Nvarchar(Max)) +
        '</table>' +
        '<br><br>Informa  o extra da em: ' + Convert(Nvarchar, GetDate(), 113);

    Begin Try
        Exec Msdb.Dbo.Sp_Send_DbMail 
            @profile_name = 'MSSQLServer',
            @recipients = 'kaike.santana@atrpservices.com.br;thanner.almeida@atrpservices.com.br',
            @subject = 'Alerta: CFOP Nao Correspondida Encontrada',
            @body = @Body,
            @body_format = 'HTML';
    End Try
    Begin Catch
        Print 'Erro ao enviar email.';
    End Catch
End;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida Base Das 5 empresas Para Popular a Tabela Natureza_Setup_Compras		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [dbo].[Natureza_Operacao_Setup_Compras]
           ([Id_Empresa]
           ,[Id_Empresa_Grupo]
           ,[Id_Tipo_Pedido_Compra]
           ,[Id_UF_Origem]
           ,[Id_Regiao_Tab_Padrao]
           ,[Id_UF_Destino]
           ,[Optante_SN]
           ,[Contribuinte]
           ,[Tipo_Pessoa]
           ,[Id_Item]
           ,[Cod_Item]
           ,[Id_Class_Fiscal]
           ,[Cod_Class_Fiscal]
           ,[Id_Subgrupo_Estoque]
           ,[Cod_Subgrupo_Estoque]
           ,[Id_Grupo_Estoque]
           ,[Cod_Grupo_Estoque]
           ,[Id_NaturezaOperacao]
           ,[Cod_NaturezaOperacao]
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
	[Id_Empresa]			= Null
,	[Id_Empresa_Grupo]		= Fato.Id_Empresa_Grupo
,	[Id_Tipo_Pedido_Compra] = Ctp.Id_Compras_Tipos_Pedido
,	[Id_UF_Origem]			= Ufs.Codigo
,	[Id_Regiao_Tab_Padrao]  = #Aux_Regiao.id_tabela_padrao
,	[Id_UF_Destino]		    = Uf_2.Codigo
,	[Optante_SN]			= Null
,	[Contribuinte]			= Null
,	[Tipo_Pessoa]			= Iif(Len(Fato.Cgc_Cpf) = 18, 'J', 'F')
,	[Id_Item]				= Null
,	[Cod_Item]				= Null
,	[Id_Class_Fiscal]		= Clf.Id_ClasFisc
,	[Cod_Class_Fiscal]		= Fato.Cod_ClassFiscal
,	[Id_Subgrupo_Estoque]   = Null
,	[Cod_Subgrupo_Estoque]  = Null
,	[Id_Grupo_Estoque]		= Null
,	[Cod_Grupo_Estoque]		= Null
,	[Id_NaturezaOperacao]   = Nat.Id_NaturezaOperacao
,	[Cod_NaturezaOperacao]  = Fato.Cod_NatOperacao
,	[incl_data]				= GetDate()
,	[incl_user]				= 'ksantana'
,	[incl_device]			= 'PC/10.1.0.123'
,	[modi_data]				= Null
,	[modi_user]				= Null
,	[modi_device]			= Null
,	[excl_data]				= Null
,	[excl_user]				= Null
,	[excl_device]			= Null
From #Final Fato 
Inner Join Natureza_Operacao As Nat		On  Nat.Cod_NatOperacao	  = Fato.Cod_NatOperacao  Collate Latin1_General_Ci_Ai
										And Nat.Id_Empresa_Grupo  = Fato.Id_Empresa_Grupo
Left  Join Compras_Tipos_Pedido	As Ctp	On  Ctp.Descricao		  = Fato.Tipo_Compra      Collate Latin1_General_Ci_Ai
Left  Join Ufs							On  Ufs.Uf				  = Fato.Uf_Origem        Collate Latin1_General_Ci_Ai
Left  Join Ufs As Uf_2					On  Uf_2.Uf				  = Fato.Uf_Clifor        Collate Latin1_General_Ci_Ai
Left  Join #Aux_Regiao					On  #Aux_Regiao.descricao = Fato.regiao		      Collate Latin1_General_Ci_Ai
Left  Join Class_Fiscal	As Clf			On  Clf.Cod_ClassFiscal	  = Fato.Cod_ClassFiscal  Collate Latin1_General_Ci_Ai


--> Dropa Tabelas Temporarias da Procedure
Begin
	Drop Table If Exists #SetupComprasMBM
	Drop Table If Exists #Regioes
	Drop Table If Exists #Aux_Regiao
	Drop Table If Exists #BaseFinal
	Drop Table If Exists #UltCompraClifor
	Drop Table If Exists #Final
	Drop Table If Exists #Naturezas_Nao_Correspondidas
	Drop Table If Exists #ClassFiscal_Nao_Correspondida
End

End;