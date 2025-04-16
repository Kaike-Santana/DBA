
USE [THESYS_DEV]
GO

-- Criação da tabela temporária
DROP TABLE IF EXISTS #TempClientes
CREATE TABLE #TempClientes (
    NOME NVARCHAR(100),
    CPF NVARCHAR(20)
);

-- Inserção dos dados na tabela temporária
INSERT INTO #TempClientes (NOME, CPF)
VALUES 
('Alisson Andrade Silva', '306.424.838-33'),
('Carlos Syrayama Junior', '107.142.088-76'),
('Claudemir Alves Pereira', '131.626.728-80'),
('Cleber De Oliveira Xavier', '317.645.988-22'),
('Clodoaldo Jardim Bastos', '22.247.664.830'),
('Edilson De Sousa Costa', '491.191.845-49'),
('Erivaldo Duraes Ferreira', '334.912.325-20'),
('Everton Rodrigo Barbosa', '329.426.048-24'),
('Fernado De Jesus Costa', '218.855.078-10'),
('Flavio Antonio Dantas', '473.982.053-68'),
('Francisco Prado Braz', '283.124.948-12'),
('Irineu Torres', '124.530.438-03'),
('Jose Aldo', '284.625.588-16'),
('Jose Eder De Menezes', '334.298.348-56'),
('Josias Cotrim De Almeida', '288.421.183-07'),
('Rafael De Almeida Ferreira', '230.387.558-77'),
('Tiago Pereira De Franca', '388.582.658-58'),
('Carlos Alberto Da Silva', '308.626.078-50'),
('Orlando Alves Barros', '909.610.485-49'),
('Juscelio Aparecido Silva', '270.046.458-35');


INSERT INTO [dbo].[frete_motoristas]
           ([nome]
           ,[data_nascimento]
           ,[data_admissao]
           ,[cpf]
           ,[observacoes]
           ,[incl_data]
           ,[incl_user]
           ,[incl_device]
           ,[modi_data]
           ,[modi_user]
           ,[modi_device]
           ,[excl_data]
           ,[excl_user]
           ,[excl_device])
select
	[nome]
,	[data_nascimento]	= Null
,	[data_admissao]		= Null
,	[cpf]				= dbo.Fn_Limpa_NoNum(Cpf)
,	[observacoes]		= Null
,	[incl_data]			= GetDate()
,	[incl_user]			= 'ksantana'
,	[incl_device]		= 'PC/10.1.0.123'
,	[modi_data]			= Null
,	[modi_user]			= Null
,	[modi_device]		= Null
,	[excl_data]			= Null
,	[excl_user]			= Null
,	[excl_device]		= Null
from #TempClientes