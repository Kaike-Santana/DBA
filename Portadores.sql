
Use Thesys_Homologacao
Go

Drop Table If Exists #PortadoresMBM
Select *
Into #PortadoresMBM
From OpenQuery([Mbm_Poliresinas],'
Select 
  cod_portador, 
  cod_banco, 
  cod_tipocarteira, 
  descricao, 
  nro_agencia, 
  nro_conta, 
  cod_ocorrencia1, 
  cod_ocorrencia2, 
  agrupa_cr, 
  agrupa_cp, 
  nosso_numero, 
  nro_contrato, 
  nro_convenio, 
  prox_remessa, 
  nosso_numero2, 
  nro_diascredito, 
  path_arqconf_cnab, 
  path_arqimg_cnab, 
  cod_banco_layout, 
  sel_layout_envio, 
  ativo, 
  motivo_bloqueio, 
  dt_bloqueio, 
  codigo_mestre, 
  tipo_cobranca, 
  taxa_mora, 
  --mensagem_bloqueto, 
  especiedoctoboleto, 
  local_impressaoboleto, 
  tipo_layout, 
  tipo_layoutretorno, 
  nossonrodeoutroportador, 
  cod_portadornossonro, 
  dt_change, 
  taxa_boleto, 
  gerar_registrodetalhe1, 
  gerar_registrodetalhe2, 
  gerar_registrodetalhe3, 
  gerar_registrodetalhe4, 
  gerar_registrodetalhe5, 
  cobrebem_conf1, 
  cobrebem_conf2, 
  imp_goodmorning, 
  nro_contratope, 
  prox_remessape, 
  pagamento_eletronico, 
  sacador_avalista, 
  auxiliar_string1, 
  auxiliar_string2, 
  percentualmulta, 
  sacaval_tipoidentificacao, 
  sacaval_identificacao, 
  dt_inclusao, 
  dt_atualizacao, 
  imp_boletonfe, 
  cbx_tipolayoutboletoimpre, 
  cbx_tipolayoutboletoemail, 
  utiliza_portador_imp_boleto, 
  cod_portador_imp_boleto, 
  uso_banco, 
  --demonstrativo, 
  imprime_boleto_pv, 
  conf_sofisa, 
  portador_baixaaut, 
  utilizar_pagto_unicred, 
  banco_corresp, 
  --local_pagamento, 
  imp_enderecoemp, 
  tipo_compromisso, 
  codigo_compromisso, 
  parametro_transmissao, 
  pagfor_layout, 
  integracao_bancosifra, 
  layout_cnab444, 
  tipo_sacadormensagem, 
  sacador_foneclifor, 
  sacador_mensagem, 
  cobr_sofisa_codempresa, 
  geracao_cobranca, 
  padrao_retorno, 
  beneficiario_razao, 
  beneficiario_pessoa, 
  beneficiario_cnpjcpf, 
  beneficiario_banco, 
  pjbank, 
  pjbank_credencial, 
  pjbank_chave, 
  pjbank_chavewebhook, 
  pjbank_agenciavirtual, 
  pjbank_contavirtual, 
  pjbank_tipoambiente, 
  homopjbank, 
  homopjbank_credencial, 
  homopjbank_chave, 
  homopjbank_chavewebhook, 
  homopjbank_agenciavirtual, 
  homopjbank_contavirtual, 
  pjbank_tiporegistrobanco, 
  beneficiario_endereco, 
  beneficiario_bairro, 
  beneficiario_cidade, 
  beneficiario_cep, 
  beneficiario_uf, 
  beneficiario_complemento, 
  beneficiario_numero, 
  ca_antessequencial, 
  nro_diasmulta, 
  modelo_cnab, 
  cobr_faixasugestao, 
  cobr_valorinicial, 
  cobr_valorfinal, 
  sacador_telbradesco, 
  integracao_bancopremium, 
  operacao_cobranca, 
  tbank_repnome, 
  tbank_repcpf, 
  tbank_repemail, 
  tbank_reptelefone, 
  tbank_chaveid, 
  tbank_ambiente, 
  imp_endsacado, 
  tbank_token, 
  tbank_transactionkey, 
  cod_benefbol, 
  utiliza_dados_portador_imp_bol, 
  gera_segmentor, 
  comple_identificacao_empresa, 
  prefixo_remessa, 
  bancointer_tipoambiente, 
  path_certificado_inter, 
  path_key_inter, 
  bancointer_clientid, 
  bancointer_clientsecret, 
  homopath_certificado_inter, 
  homopath_key_inter, 
  homobancointer_clientid, 
  homobancointer_clientsecret, 
  cod_baixadevolucao, 
  integracao_bancosoma, 
  integracao_bancocredit, 
  integracao_bancodinari, 
  integracao_banconewtrade, 
  sacador_cep, 
  sacador_endereco, 
  sacador_numero, 
  sacador_complemento, 
  sacador_bairro, 
  sacador_cidade, 
  sacador_uf, 
  sacador_impend, 
  separador_nrodocumento, 
  env_carteira_outro_portador, 
  itau_integracao_api
  --tbank_reptoken 
From public.portador;
')

Declare @vEmpresa Int = (Select Id_Empresa_Grupo From Empresas_Grupos Where Nome = 'Poli Resinas')

Insert Into Portadores (
						 [id_empresa]
						,[id_empresa_grupo]
						,[id_banco_conta]
						,[cod_portador]
						,[descricao]
						,[cnab_bloqueado]
						,[ativo]
						,[taxa_mora]
						,[incl_data]
						,[incl_user]
						,[incl_device]
						,[modi_data]
						,[modi_user]
						,[modi_device]
						,[excl_data]
						,[excl_user]
						,[excl_device]
						,[pag_nro_contrato]
						,[pag_eletronico]
						,[pag_seq_remessa]
					   )
Select 
  [id_empresa]			=  4 --> Colocar Manual, n vem do MBM essa Coluna
, [id_empresa_grupo]	=  @vEmpresa
, [id_banco_conta]		=  Bancos_Contas.id_banco_conta
, [cod_portador]		=  Cod_Portador
, [descricao]			=  Descricao	
, [cnab_bloqueado]		=  Null
, [ativo]				=  Fato.Ativo
, [taxa_mora]			=  Taxa_Mora
, [incl_data]			=  GetDate()
, [incl_user]			=  'ksantana'
, [incl_device]			=  'PC/10.1.0.123'
, [modi_data]			=  Null
, [modi_user]			=  Null
, [modi_device]			=  Null
, [excl_data]			=  Null
, [excl_user]			=  Null
, [excl_device]			=  Null
, [pag_nro_contrato]	=  Null
, [pag_eletronico]		=  Null
, [pag_seq_remessa]		=  Null
From #PortadoresMBM Fato
Left Join Bancos_Contas On  Bancos_Contas.nro_conta   = Fato.Nro_Conta   Collate latin1_general_ci_ai
						And Bancos_Contas.nro_agencia = Fato.Nro_Agencia Collate latin1_general_ci_ai
						And Bancos_Contas.Cod_Banco   = Fato.Cod_Banco   Collate latin1_general_ci_ai