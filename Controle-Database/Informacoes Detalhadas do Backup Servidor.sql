SELECT 
@@SERVERNAME AS ServerName,
bs.database_name,
    CASE bs.type
WHEN 'D' THEN 'Full'
WHEN 'I' THEN 'Differential'
WHEN 'L' THEN 'Log'
WHEN 'F' THEN 'File or filegroup' 
WHEN 'G' THEN 'Differential file'
WHEN 'P' THEN 'Partial'
WHEN 'Q' THEN 'Differential partial'
END Backup_Type,
    Max(bs.backup_start_date) AS backup_start_date,
  physical_device_name,
  CASE device_type
WHEN '2' THEN 'Disk'
WHEN '5' THEN 'Tape'
WHEN '7' THEN 'Virtual device'
WHEN '9' THEN 'Azure Storage'
WHEN '105' THEN 'A permanent backup device'
END device_type
FROM  master..sysdatabases sd
    LEFT JOIN msdb..backupset bs
       ON bs.database_name = sd.NAME
    LEFT JOIN msdb..backupmediafamily bmf
       ON bs.media_set_id = bmf.media_set_id
--WHERE
-- backup_start_date BETWEEN '20221101' AND '20221130'
GROUP BY sd.NAME,
     bs.type,
     bs.database_name,
 physical_device_name,
 device_type
ORDER BY backup_start_date ASC,
     bs.database_name,
     bs.type 