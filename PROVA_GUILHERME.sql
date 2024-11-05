--------CRIAÇÂO DO BANCO DE DADOS DE UMA ESCOLA FÌCTICIA< QUE POSSUI ALGUNS CURSOS TÈCNICOS--------------
CREATE DATABASE ColegioRegina;
USE ColegioRegina

--------------------------INICIO DA ESTRUTURA DO BANCO DE DADOS-----------------------------
--------------------------CRIAÇÂO DAS TABELAS--------------------------


CREATE TABLE Alunos (
IdAluno INT PRIMARY KEY NOT NULL,
NomeAluno VARCHAR(100),
IdProfessor INT NOT NULL,
CPF VARCHAR(14),
Sexo BIT,
Data_Nascimento DATE,
Data_Matricula DATE,
FOREIGN KEY (IdProfessor) REFERENCES Professor(IdProfessor)
)

CREATE TABLE Professor (
IdProfessor INT PRIMARY KEY NOT NULL,
NomeProfessor VARCHAR(100),
CPF VARCHAR(14),
Sexo BIT,
Data_Nascimento DATE,
Data_Contrato DATE,
salario MONEY
)

CREATE TABLE Materia(
IdMateria INT PRIMARY KEY NOT NULL,
IdProfessor INT,
FOREIGN KEY (IdProfessor) REFERENCES Professor(IdProfessor),
NomeMateria VARCHAR(50)
)

--------------------------INSERÇÂO DE DADOS NAS TABELAS--------------------------

INSERT INTO Alunos(IdAluno, NomeAluno,IdProfessor, CPF, Sexo,Data_Nascimento,Data_Matricula) 
VALUES
(1, 'Lucas Moura',1,'111.111.111-11', 1 , '11/11/2001' , '19/06/2021'),
(2, 'Raul Gil',2,'222.222.222-22', 1 , '26/05/2004' , '20/03/2022'),  
(3, 'Silvio Santos',3,'333.333.333-33', 1 , '07/02/2004' , '25/12/2019'); 

INSERT INTO Professor(IdProfessor, NomeProfessor,CPF, Sexo,Data_Nascimento,Data_Contrato,salario) 
VALUES
(1, 'Maria Silva','123.456.789-10', 0 , '01/10/1978' , '21/08/2010',6000),
(2, 'João Santos','987.654.321-10', 1 , '05/05/1975' , '14/07/2020', 4200),  
(3, 'Ana Costa','111.222.333-10', 0 , '17/03/2000' , '13/01/2017', 5000); 


INSERT INTO Materia(IdMateria, IdProfessor,NomeMateria) 
VALUES
(1, 1 ,'Logística'),
(2, 2 , 'Engenharia Elétrica'),  
(3, 3 , 'Desenvolvimento de Sistemas'); 
--------------------------FIM DA ESTRUTURA DO BANCO DE DADOS----------------------------


-------------------------Implementação das Funcionalidades------------------------------

--------VIEW: Essa view foi criada com a intenção de relacionar os professores com suas respectivas matérias.
CREATE VIEW Materia_Professor 
AS
SELECT
NomeProfessor AS 'Nome do professor',
NomeMateria AS 'Nome da matéria'
FROM Materia INNER JOIN Professor ON Materia.IdProfessor = Professor.IdProfessor

SELECT * FROM Materia_Professor




--------CTE'S: Essa CTE'S relaciona os alunos com os cursos que eles estão fazendo.
WITH CursoAluno
AS (
SELECT
NomeAluno AS 'Nome do aluno',
NomeMateria AS 'Nome da matéria'
FROM Materia 
INNER JOIN Alunos ON Alunos.IdProfessor = Materia.IdProfessor
)

SELECT * FROM CursoAluno




---------PROCEDURES: Essa procedure tem o intuito de facilitar a inserção de dados na criação de um novo aluno.
CREATE PROCEDURE AddAluno
	  @IdAluno INT,
      @NomeAluno VARCHAR(100),
      @IdProfessor INT,
      @CPF VARCHAR(14),
      @Sexo BIT,
      @Data_Nascimento DATE,
      @Data_Matricula DATE

AS
INSERT INTO Alunos(IdAluno,NomeAluno,IdProfessor,CPF,Sexo,Data_Nascimento,Data_Matricula)
VALUES (@IdAluno,@NomeAluno,@IdProfessor,@CPF,@Sexo,@Data_Nascimento,@Data_Matricula)

EXEC AddAluno 5,'Pedro Odake', 2 ,'555.555.555-55', 1 , '15/05/2007','05/11/2024' 

SELECT * FROM Alunos


---------PROCEDURE: Mostra somente os alunos do curso que for inserido
CREATE PROCEDURE TURMA
	  @Materia VARCHAR(50)
AS
BEGIN
SELECT *
FROM ALUNOS INNER JOIN Materia ON Alunos.IdProfessor = Materia.IdProfessor
WHERE NomeMateria = @Materia
END;

EXEC TURMA 'Desenvolvimento de sistemas' 



--------TRIGGER: O gatilho será acionado após a inserção de um dado na tabela ALUNOS, onde mandará uma mensagem de confirmação do processo
CREATE TRIGGER AlunoAdicionado
ON Alunos
AFTER INSERT 
AS
BEGIN
	DECLARE @ultimo_nome VARCHAR(100);
	SELECT @ultimo_nome = NomeAluno FROM Alunos ORDER BY IdAluno ASC;

	PRINT @ultimo_nome + ' adicionado com sucesso'
END
GO

-----------FUNCTION:
CREATE FUNCTION CalcularIdade (@dataNascimento DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @dataNascimento, GETDATE());
END;

SELECT NomeAluno, dbo.CalcularIdade(Data_Nascimento) AS Idade
FROM Alunos;


-----------SUBQUERY:
SELECT
NomeAluno
FROM Alunos
WHERE IdAluno IN(
SELECT IdAluno
FROM Professor
WHERE IdProfessor = (SELECT IdProfessor FROM Materia WHERE IdMateria = 3)
)


-----------LOOP'S
