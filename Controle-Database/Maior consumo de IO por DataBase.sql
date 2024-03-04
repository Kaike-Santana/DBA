
SELECT 
DB_NAME(database_id) AS [Database],
  [file_id],
  [io_stall_read_ms],
  [io_stall_write_ms],
  [io_stall]
FROM sys.Dm_io_virtual_file_stats(NULL, NULL)
ORDER BY [io_stall_read_ms] DESC