
Use THESYS_HOMOLOGACAO
Go

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*																								*/
/* Programador: Kaike Natan																		*/
/* Versao     : Data: 16/07/2024																*/
/* Descricao  : Script De ETL Da Tabela Usuarios e Usuarios Departamentos do MBM Para o Thesys	*/
/*																								*/
/* Alteracao																					*/
/*        2. Programador:                                                  Data: __/__/____		*/        
/*           Descricao  :																		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Consolida as 5 Bases de Usuários do MBM											*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #UsuariosMBM
Select *
Into #UsuariosMBM
From OpenQuery([Mbm_Polirex],'
Select 
  cod_usuario, 
  nome, 
  cod_repres, 
  cod_empresa, 
  senha, 
  ativo, 
  altera_empresa, 
  ve_serieespecial, 
  senha_login, 
  operador_caixa, 
  motivo_bloqueio, 
  log_simultaneo, 
  dt_cadastro, 
  dt_atualizacao, 
  liberar_permissoes, 
  menu_personalizado, 
  dt_iniliberado, 
  dt_fimliberado, 
  ms_smtp, 
  ms_email, 
  ms_conta, 
  ms_senha, 
  cast(ms_assinatura as varchar(3000)) as ms_assinatura, 
  ms_confirmacaoleitura, 
  dt_change, 
  repres_visualizacliente, 
  login_web, 
  repres_visualizafornec, 
  tipo_enviaemail, 
  smtp_tipoidentificacao, 
  tipo_exibicaomenu, 
  tipo_favoritos, 
  ms_usarssl, 
  ms_porta, 
  nro_cracha, 
  senha_md5, 
  cod_usuariomaker, 
  repres_particomissao, 
  auxiliar_string1, 
  auxiliar_string2, 
  login_pedidooffline, 
  pkcodpv, 
  log_mesmaestacao, 
  area, 
  cargo, 
  telefone, 
  celular, 
  ms_usartsl, 
  atualiza_versaosistema, 
  visualiza_centralmbm, 
  visualiza_cartaatualizacao, 
  sup_corcomentario, 
  sup_corbordacomentario, 
  permite_desconectar, 
  acesso_simultaneomodulo, 
  pref_cor_desabilitados, 
  sup_relaciona_ch, 
  email_nf, 
  email_bol, 
  email_mkt, 
  email_sup, 
  ms_codificacao, 
  visualiza_itemsemcliente, 
  visualiza_dashboardlogin, 
  permite_deslogarlogsimultaneo 
From usuario
')
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Tabela Temporaria Com a Normalização dos Departamentos							*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #AreasNormalizadas
Create Table #AreasNormalizadas (
    Area_Original Varchar(255),
    Area_Normalizada Varchar(255)
);

Insert Into #AreasNormalizadas (Area_Original, Area_Normalizada)
Values 
    ('NULL', 'INDEFINIDO'),
    ('ADMINISTRATIVO', 'ADMINISTRATIVO'),
    ('ALMOXARIFADO', 'ALMOXARIFADO'),
    ('ALTA ADMINISTRAÇÃO', 'ALTA ADMINISTRACAO'),
    ('COBRANÇA', 'COBRANCA'),
    ('comecial', 'COMERCIAL'),
    ('COMERCIAL', 'COMERCIAL'),
    ('COMERCIAL POLIREX', 'COMERCIAL POLIREX'),
    ('COMPRAS', 'COMPRAS'),
    ('COMPRAS/IMPORTAÇÃO', 'COMPRAS/IMPORTACAO'),
    ('CONTABIL', 'CONTABIL'),
    ('CONTABIL / FISCAL', 'CONTABIL / FISCAL'),
    ('CONTABILIDADE', 'CONTABIL'),
    ('CONTAS A RECEBER', 'CONTAS A RECEBER'),
    ('CONTROLADORIA', 'CONTROLADORIA'),
    ('CREDITO / COBRANÇA', 'CREDITO / COBRANCA'),
    ('CUSTOS', 'CUSTOS'),
    ('DIRETOR', 'DIRETORIA'),
    ('DIRETORA', 'DIRETORIA'),
    ('DIRETORIA', 'DIRETORIA'),
    ('esligados', 'DESLIGADOS'),
    ('fabrica', 'FABRICA'),
    ('FACILITES', 'FACILITIES'),
    ('FACILITIES', 'FACILITIES'),
    ('FATURAMENTO', 'FATURAMENTO'),
    ('FICAL', 'FISCAL'),
    ('financeiro', 'FINANCEIRO'),
    ('FISCAL', 'FISCAL'),
    ('GESNTE & GESTAO', 'GENTE & GESTAO'),
    ('GESTE & GESTAO', 'GENTE & GESTAO'),
    ('IMOBILIARI', 'IMOBILIARIA'),
    ('IMPLANTAÇÃO', 'IMPLANTACAO'),
    ('LOGISRIC', 'LOGISTICA'),
    ('logist', 'LOGISTICA'),
    ('LOGISTIC', 'LOGISTICA'),
    ('logistica', 'LOGISTICA'),
    ('MANAUS', 'MANAUS'),
    ('MANUTENÇÃO', 'MANUTENCAO'),
    ('MARKETING', 'MARKETING'),
    ('MASTER', 'MASTER'),
    ('MASTERDATA', 'CADASTRO'),
    ('NFE', 'NFE'),
    ('PCP', 'PCP'),
    ('QUALIDADE', 'QUALIDADE'),
    ('REGULATÓRIO', 'REGULATORIO'),
    ('REP. VENDAS', 'REPRESENTANTE DE VENDAS'),
    ('RH', 'RH'),
    ('RH / JURIDICO', 'RH / JURIDICO'),
    ('RH JURIDICO', 'RH / JURIDICO'),
    ('SESMET', 'SESMT'),
    ('SESMT', 'SESMT'),
    ('SISTEMAS', 'SISTEMAS'),
    ('SQL', 'SQL'),
    ('STRECH', 'STRETCH'),
    ('SUPORTE TI', 'TI'),
    ('T.I', 'TI'),
    ('T.I MANAUS', 'TI'),
    ('T.I.', 'TI'),
    ('TI', 'TI'),
    ('VENDAS', 'VENDAS');
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Popula Somente o Diferencial na Tabela Fisica	do Thesys_Dev						*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [dbo].[Usuarios_Departamentos]
           ([nome]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device])

Select Distinct 
	Nome = Area_Normalizada
,	GetDate()
,	'ksantana'
,	'PC/10.1.0.123'
,	Null
,	Null
,	Null
,	Null
,	Null
,	Null
From #AreasNormalizadas Fato
Where Not Exists (
				  Select *
				  From Usuarios_Departamentos Dim
				  Where Dim.Nome = Fato.Area_Normalizada Collate latin1_general_ci_ai 
				 )
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Identificar Àreas Que Não Estão na Tabela de DexPara								*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Declare @NewAreas Table (
						 Area Varchar(255)
						);
Delete From @NewAreas
Insert Into @NewAreas (Area)

Select Distinct U.area
From #UsuariosMBM U
Left Join #AreasNormalizadas A On (U.area = A.Area_Original)
Where A.Area_Original Is Null
And U.Area Is Not Null
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Verificar Se Existem Novas Areas e Envia o E-mail	de Alerta						*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
If Exists (
		   Select 1 From @newAreas
		  )
Begin
    Declare @body Nvarchar(1000)
    Set @body = 'Novas áreas encontradas que não estão na tabela de Usuarios_Departamentos: ' + Char(13) + Char(10) + (Select String_Agg(Area, ', ') From @NewAreas);

    Begin Try
        Exec msdb.dbo.sp_send_dbmail 
            @profile_name = 'MSSQLServer',
            @recipients = 'kaike.santana@atrpservices.com.br',
            @subject = 'Alerta: Novas Áreas Encontradas',
            @body = @body,
            @body_format = 'Text';
    End Try
    Begin Catch
        Print 'Erro ao enviar email.';
    End Catch
End;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Deixa Apenas o Cod_Usuario Com Data de Atualizacao Mais Recente 					*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Drop Table If Exists #BaseUniq
Select *
Into #BaseUniq
From (
		Select * 
		, Rw = Row_Number() Over ( Partition By Cod_Usuario Order By Ativo, Dt_Atualizacao Desc)
		From #UsuariosMBM
	 )SubQuery
Where Rw = 1
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Atualiza na Base do MBM o Nome da Area do Funcionario Para o Nome Normalizado		*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Update Fato
Set Area = Dim.Area_Normalizada

From #BaseUniq Fato
Join #AreasNormalizadas Dim On (Dim.Area_Original = Fato.Area)
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Cria Function Para a Tabela Usuaros Que Nâo Possui Identity						*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
--Create Sequence dbo.UsuariosSequence
--As Int
--Start With 1
--Increment By 1;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Seta a Sequence Para o Max da Própria Tabela										*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Declare @MaxID Int;
Declare @Sql Nvarchar(Max);

Select @MaxID = Max(Codigo) From dbo.Usuarios;

If (
	@MaxID Is Not Null
   )
Begin
    Set @Sql = 'Alter Sequence dbo.UsuariosSequence Restart With ' + Cast(@MaxID + 1 As Nvarchar(10));
    Exec Sp_ExecuteSql @Sql;
End;
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/* Descricao: Depois de Atualiza a Tabela Filha, Atualiza a Usuarios do Thesys					*/
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
Insert Into [dbo].[Usuarios]
           ([codigo]
           ,[nome]
           ,[senha]
           ,[administrador]
           ,[ID_EMPRESA]
           ,[externo]
           ,[ip_conexao]
           ,[email]
           ,[master]
           ,[confsenha]
           ,[codifunc]
           ,[senha_antiga]
           ,[senha_anterior]
           ,[id_grupo]
           ,[avatar]
           ,[login]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device]
           ,[Ultimo_Acesso]
           ,[Transportadora]
           ,[Ativo]
           ,[Ativado_Desativado_DataHora]
           ,[id_departamento])

Select	
	[codigo]					  = Next Value For dbo.UsuariosSequence
,	[nome]						  = Fato.Nome			  
,	[senha]						  = Null
,	[administrador]				  = Null
,	[ID_EMPRESA]				  = 1 --> Default
,	[externo]					  = Null
,	[ip_conexao]				  = Null
,	[email]						  = ms_email
,	[master]					  = 'N'
,	[confsenha]					  = Null
,	[codifunc]					  = cod_usuariomaker
,	[senha_antiga]				  = Null
,	[senha_anterior]			  = Null
,	[id_grupo]					  = Null
,	[avatar]					  = Null
,	[login]						  = cod_usuario
,	[incl_data]					  = GetDate()
,	[incl_user]					  = 'ksantana'
,	[incl_device]				  = Null
,	[modi_data]					  = Null
,	[modi_user]					  = Null
,	[modi_device]				  = Null
,	[excl_data]					  = Null
,	[excl_user]					  = Null
,	[excl_device]				  = Null
,	[Ultimo_Acesso]				  = Null
,	[Transportadora]			  = Null
,	[Ativo]			 
,	[Ativado_Desativado_DataHora] = GetDate()
,	[id_departamento]			  = UsuDep.id_departamento
From #BaseUniq Fato
Left Join Usuarios_Departamentos As UsuDep On UsuDep.Nome = Fato.Area Collate latin1_general_ci_ai 
Where Not Exists (
				  Select *
				  From Usuarios Dim
				  Where Dim.Login = Fato.Cod_Usuario Collate latin1_general_ci_ai 
				 )