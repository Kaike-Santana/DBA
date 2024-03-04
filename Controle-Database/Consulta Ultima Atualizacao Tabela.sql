SELECT DISTINCT
     T.Name        
    ,User_Seeks     
    ,User_Scans     
    ,User_Lookups       
    ,User_Updates       
    ,Last_User_Seek     
    ,Last_User_Scan     
    ,Last_User_Lookup   
    ,Last_User_Update   
FROM
    sys.dm_db_index_usage_stats I 
JOIN
    sys.tables T 
ON
    T.Object_ID = I.Object_ID
WHERE
    Database_ID = DB_ID()
ORDER BY
    Last_User_Scan DESC