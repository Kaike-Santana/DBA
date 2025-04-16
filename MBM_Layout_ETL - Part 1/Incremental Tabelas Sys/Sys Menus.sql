

insert into THESYS_HOMOLOGACAO..[Sys_Menus]
SELECT 
       [CodMenu]
      ,[SeqNumber]
      ,[MenuName]
      ,[GroupName]
      ,[FunctionName]
      ,[FormName]
      ,[Unlocked]
      ,[Level]
      ,[TableName]
      ,[RestrictionField]
      ,[Icon]
      ,[IconCssColor]
      ,[Modal]
      ,[Hidden]
      ,[AskNewAfterPost]
      ,[GenNextID_OnNew]
      ,[CloseButton]
      ,[DoNotShow]
      ,[Master]
      ,[Permissions]
      ,[AdditionalPermissionList]
      ,[GroupRoleID]
      ,[HttpLink]
      ,[HttpLinkOpenType]
      ,[TableNameInternalAlias]
      ,[incl_data]
      ,[incl_user]
      ,[incl_device]
      ,[modi_data]
      ,[modi_user]
      ,[modi_device]
      ,[excl_data]
      ,[excl_user]
      ,[excl_device]
      ,[Transportadora]
  FROM [THESYS_DEV].[dbo].[Sys_Menus] FATO
  WHERE NOT EXISTS (
				     SELECT *
					 FROM THESYS_HOMOLOGACAO..[Sys_Menus] DIM
					 WHERE DIM.MenuID = FATO.MenuID
				   )
