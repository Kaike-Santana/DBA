if object_id('usp_resultset_html') is not null drop proc usp_resultset_html
go
create proc dbo.usp_resultset_html (@consulta nvarchar(max), @titulo_tabela nvarchar(300) = '', @css nvarchar(max) = 'default')
as begin
    begin transaction
    set nocount on
    set xact_abort on
    declare @colunas varchar(max)
    declare @html_final nvarchar(max)
    declare @html_parcial nvarchar(max)
    declare @sql nvarchar(max)
    -- Obtem colunas do select original e converte para TDs
    set @colunas = stuff((select ', [' + name + '] as td' from sys.dm_exec_describe_first_result_set(@consulta, null, 0) for xml path('')), 1, 1, '')
 
    -- Define nome da tabela temporária com newid para permitir execução simultanea por diversos terminais
    declare @table_name varchar(50)
    set @table_name = 'tb' + convert(varchar, abs(checksum(newid())))
 
    -- Altera query original para salvar o resultado da query na tabela temporária
    -- Ex: DE: "select * from produtos" PARA: "select * into tb123456 from produtos"
    if charindex('from', @consulta) = 0
        begin
            -- selects sem "from tabela", exemplo: select 1, 2
            set @consulta = @consulta + ' into ' + @table_name
        end
    else
        begin
            -- Selects normais, com tabelas
            set @consulta = replace(@consulta, 'from', ' into ' + @table_name + ' from ')
        end
    execute (@consulta)
 
    -- Cria html a partir da tabela temporária salva
    set @html_final = '<table class="sql_tabela">'
    if @titulo_tabela <> '' set @html_final = @html_final + '<caption>' + @titulo_tabela + '</caption>'
    set @html_final = @html_final + '<thead><tr>'
    set @sql = 'set @html_parcial= (select column_name as th from information_schema.columns where table_name = ''' + @table_name + ''' for xml path(''''))'
    execute sp_executesql @sql, N'@html_parcial varchar(max) out', @html_parcial out
    set @html_final = @html_final + @html_parcial
    set @html_final = @html_final + '</tr></thead>'
    set @html_final = @html_final + '<tbody>'
    set @sql = 'set @html_parcial= (select ' + @colunas + ' from ' + @table_name + ' for xml raw(''tr''), elements)'
    execute sp_executesql @sql, N'@html_parcial nvarchar(max) out', @html_parcial out
    set @html_final = @html_final + @html_parcial
    set @html_final = @html_final + '</tbody></table>'
 
    -- Adiciona CSS:
    if @css is null set @css = ''
    if @css = 'default'
        set @css = '
            <style>
                .sql_tabela {
                    border-spacing: 0px;
                }
                .sql_tabela caption {
                    padding: 5px;
                    border: 1px solid #F0F0F0;
                    text-align: center;
                }
                .sql_tabela thead {
                    background: #FCFCFC;
                }
                .sql_tabela th {
                    padding: 1px 10px 1px 5px;
                    border: 1px solid #F0F0F0;
                    font-weight: normal;    
                    text-align: left;
                    word-wrap: break-word;
                    max-width: 200px;
                }
                .sql_tabela body {
                }
                .sql_tabela td {
                    padding: 1px 10px 1px 5px;
                    border: 1px solid #F0F0F0;
                    word-wrap: break-word;
                    max-width: 200px;
                }
            </style>'
    if @css = 'default_inline'
        begin
            set @css = ''
            set @html_final = replace(@html_final, '<table class="sql_tabela">', '<table style="border-spacing: 0px;">')
            set @html_final = replace(@html_final, '<caption>', '<caption style="padding: 5px; border: 1px solid #F0F0F0; text-align: center;">')
            set @html_final = replace(@html_final, '<thead>', '<thead style="background: #FCFCFC;">')
            set @html_final = replace(@html_final, '<th>', '<th style="padding: 1px 10px 1px 5px; border: 1px solid #F0F0F0; font-weight: normal; text-align: left; word-wrap: break-word; max-width: 200px;">')
            set @html_final = replace(@html_final, '<td>', '<td style="padding: 1px 10px 1px 5px; border: 1px solid #F0F0F0; word-wrap: break-word; max-width: 200px;">')
        end
    set @html_final = @css + @html_final
     
    -- Mostra HTML
    select @html_final
 
    -- Exclui tabela temporária
    execute ('drop table ' + @table_name)
    rollback transaction
end
go
 
 
--------------------------------------------------
-- Exemplos de uso
--------------------------------------------------
-- Execução direta
execute usp_resultset_html 'select * from operadores'
 
-- Execução exportando para arquivo (ative o comando abaixo em Query -> SQLCMD mode)
-- DICA: Para resultados grandes SEMPRE use esse comando
!!bcp "exec curso.dbo.usp_resultset_html 'select * from operadores', 'Tabela Produtos'" queryout "\\polaris\NectarServices\Administrativo" -c -t, -T -S -C ACP
 
 
--------------------------------------------------
-- Excluir dados de teste
--------------------------------------------------
use master
go
drop database curso
go