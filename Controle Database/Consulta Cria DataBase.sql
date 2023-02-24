CREATE DATABASE [Teste]
ON PRIMARY
(
    NAME = N'Teste',
    FILENAME = N'E:\planejamento\Teste.mdf',
    SIZE = 100MB,
    FILEGROWTH = 500MB
)
LOG ON
(
    NAME = N'Teste_log',
    FILENAME = N'E:\planejamento\Teste_log.ldf',
    SIZE = 100MB,
    FILEGROWTH = 500MB
);
GO

ALTER DATABASE Reports SET RECOVERY FULL
GO
