
INSERT INTO THESYS_HOMOLOGACAO..[SysBasicTables]
SELECT 
       [TableName]
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
  FROM [THESYS_DEV].[dbo].[SysBasicTables] FATO
  WHERE NOT EXISTS (
					 SELECT *
					 FROM THESYS_HOMOLOGACAO..[SysBasicTables] DIM
					 WHERE DIM.TableID = FATO.TableID
				   )