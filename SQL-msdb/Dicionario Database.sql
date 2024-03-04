
USE PostGreSQL
GO
 
SET NOCOUNT ON
 
DECLARE @htmlInicio VARCHAR(MAX)
DECLARE @tabela TABLE (column1 VARCHAR(MAX))
DECLARE @htmlFim VARCHAR(MAX)
DECLARE @string VARCHAR(MAX)
DECLARE @titulo VARCHAR(255)
 
SET @titulo = 'Dicionário de Dados - ' + (SELECT DB_NAME());
 
/*GERA INICIO DO CÓDIGO HTML*/
SET @htmlInicio =
'
<html>
<head>
<title>
</title>
</head>
<body>
<div>
Dicionário de dados do Banco: ' + (SELECT DB_NAME()) + '</div>
<div>
&nbsp;</div>
<div>
&nbsp;</div>
'
 
/*CRIA TABELA COM AS COLUNAS E REGISTROS EXISTENTES*/
INSERT INTO @tabela
SELECT DISTINCT
Html
FROM
(
SELECT
'
<div>
<strong>
Nome da Tabela: <span style="color:#0000FF;">'
+ obj.name +
'</span></strong></div>
<div>
<strong>
Descrição da Tabela:
</strong>' +
(SELECT
ISNULL (CONVERT(VARCHAR(1000), pro2.value), 'Não Informado') AS Comentario
FROM
sysobjects obj2
LEFT JOIN sys.extended_properties pro2 ON obj2.id = pro2.major_id
AND pro2.minor_id = 0
WHERE
obj2.xtype = 'U'
AND obj2.id = obj.id)
+
'</div>
<div>
&nbsp;</div>
<table border="2">
<tr>
<th>Schema</th>
<th>Coluna</th>
<th>Tipo de Dado</th>
<th>PK</th>
<th>Comentário</th>
<th>Aceita Nulo</th>
</tr>
' +
COALESCE(
(SELECT
'
<tr>'+
'
<td>' + OBJECT_SCHEMA_NAME(obj.id) + '</td>
<td>' + col.name + '</td>
<td>' + UPPER(TYPE_NAME(col.xusertype) + CASE WHEN TYPE_NAME(col.xusertype) = 'varchar' THEN '(' + CONVERT(VARCHAR, CONVERT(INT, prec)) + ')'
WHEN TYPE_NAME(col.xusertype) = 'nvarchar' THEN '(' + CONVERT(VARCHAR, CONVERT(INT, prec)) + ')'
WHEN TYPE_NAME(col.xusertype) = 'char' THEN '(' + CONVERT(VARCHAR, CONVERT(INT, prec)) + ')'
WHEN TYPE_NAME(col.xusertype) = 'nchar' THEN '(' + CONVERT(VARCHAR, CONVERT(INT, prec)) + ')'
WHEN TYPE_NAME(col.xusertype) = 'decimal'
THEN '(' + CONVERT(VARCHAR, CONVERT(INT, prec)) + ',' + CONVERT(VARCHAR, CONVERT(INT, xscale)) + ')'
ELSE CONVERT(VARCHAR, '')
END) + '</td>
<td>' + CASE
WHEN OBJECTPROPERTY(OBJECT_ID(u.CONSTRAINT_SCHEMA + '.' + u.CONSTRAINT_NAME), 'IsPrimaryKey') = 1 THEN 'Sim'
ELSE 'Não'
END + '</td>
<td>' + ISNULL(CONVERT(VARCHAR(1000), pro.value), 'Não Informado') + '</td>
<td>' + CASE col.IsNullable
WHEN 1 THEN 'Sim'
ELSE 'Não'
END + '</td>
</tr>
'
FROM
sysobjects obj1
INNER JOIN
syscolumns col ON obj1.id = col.id
LEFT JOIN
sys.extended_properties pro ON obj1.id = pro.major_id AND col.colorder = pro.minor_id AND pro.class = 1
LEFT JOIN
INFORMATION_SCHEMA.KEY_COLUMN_USAGE u ON obj1.name = u.TABLE_NAME AND u.COLUMN_NAME = col.name AND OBJECTPROPERTY(OBJECT_ID(u.CONSTRAINT_SCHEMA + '.' + u.CONSTRAINT_NAME), 'IsPrimaryKey') = 1
WHERE
obj1.xtype = 'U'
AND obj1.id = obj.id
ORDER BY
obj1.name
,col.colorder
FOR XML PATH(''), TYPE).value('.[1]', 'VARCHAR(MAX)'), '')
+
'</table>
<div>
&nbsp;</div>
'
AS Html
FROM
sysobjects obj
INNER JOIN
syscolumns col ON obj.id = col.id
LEFT JOIN
sys.extended_properties pro ON obj.id = pro.major_id AND col.colorder = pro.minor_id AND pro.class = 1
LEFT JOIN
INFORMATION_SCHEMA.KEY_COLUMN_USAGE u ON obj.name = u.TABLE_NAME AND u.COLUMN_NAME = col.name AND OBJECTPROPERTY(OBJECT_ID(u.CONSTRAINT_SCHEMA + '.' + u.CONSTRAINT_NAME), 'IsPrimaryKey') = 1
WHERE
obj.xtype = 'U'
) A
ORDER BY
Html
 
/*GERA FIM DO CÓDIGO HTML*/
SET @htmlFim =
'
<div>
 
<hr />
 
<em>Aviso: este e-mail foi enviado automaticamente por nosso sistema, favor n&atilde;o respond&ecirc;-lo.</em></div>
&nbsp;
 
</body>
</html>'
 
/*MONTA HTML COMPLETO CONCATENANDO AS VARIAVEIS @htmlInicio + @tabela + @htmlFim*/
SELECT DISTINCT
@string = @htmlInicio + ISNULL((SELECT
t2.column1 + ' ' AS [text()]
FROM
@tabela AS t2
WHERE
1 = 1
ORDER BY
t2.column1
FOR
XML PATH('')
,TYPE).value('.[1]', 'VARCHAR(MAX)'), '') + @htmlFim
FROM
@tabela AS t
 
--SELECT @string
 
/*EXECUTA PROCEDURE msdb.dbo.sp_send_dbmail PARA ENVIAR E-MAIL*/
EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'DBA',
@recipients = 'kaike.santana@atmatec.com.br',
@subject = @titulo,
@body = @string,
@body_format = 'HTML',
@query_result_width = 90,
@query_result_separator = ' ',
@query_result_header = 0,
@attach_query_result_as_file = 0,
@execute_query_database = 'master'