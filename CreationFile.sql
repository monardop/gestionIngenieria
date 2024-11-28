USE master

GO
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'Universidad')
BEGIN
    CREATE DATABASE Universidad
    COLLATE Latin1_General_CI_AI
END

GO
USE Universidad;

GO 
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name="ingenieria_informatica")
BEGIN 
    EXEC('CREATE SCHEMA ingenieria_informatica')
END 

GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
    TABLE_SCHEMA = 'ingenieria_informatica' AND TABLE_NAME = 'rama_carrera')
BEGIN
    CREATE TABLE [ingenieria_informatica].[rama_carrera]
    (
        id 					INT 		NOT NULL 	IDENTITY,
        branch_description 	VARCHAR(70) NOT NULL,
        CONSTRAINT PK_id_rama_carrera
            PRIMARY KEY(id)
    );
END


GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
    TABLE_SCHEMA = 'ingenieria_informatica' AND TABLE_NAME = 'Informacion')
BEGIN
    CREATE TABLE [ingenieria_informatica].[Informacion]
    (
        id 				INT 		NOT NULL IDENTITY,
        descripcion 	VARCHAR(25) NOT NULL,
        CONSTRAINT PK_id_informacion 
            PRIMARY KEY(id)
    );
END


GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
    TABLE_SCHEMA = 'ingenieria_informatica' AND TABLE_NAME = 'materia')
BEGIN
    CREATE TABLE [ingenieria_informatica].[materia]
    (
        codigo_materia 		INT 			NOT NULL,
        nombre 				VARCHAR(100) 	NOT NULL,
        id_rama_materia 	INT 			NOT NULL,
        id_estado 			INT 			NOT NULL,
        anio 				TINYINT 		NOT NULL,
        notaFinal 			INT,
        CONSTRAINT PK_course_codigo_materia 
            PRIMARY KEY(codigo_materia),
        CONSTRAINT FK_estado_materia
            FOREIGN KEY(id_estado) 
            REFERENCES [ingenieria_informatica].[Informacion](id),
        CONSTRAINT FK_rama_materia
            FOREIGN KEY(id_rama_materia) 
            REFERENCES [ingenieria_informatica].[rama_carrera](id)
    );
END


GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
    TABLE_SCHEMA = 'ingenieria_informatica' AND TABLE_NAME = 'correlativa')
BEGIN
    CREATE TABLE [ingenieria_informatica].[correlativa]
    (
        codigo_materia 				INT		NOT NULL,
        codigo_materia_correlativa 	INT 	NOT NULL,
        CONSTRAINT PK_correlativa 
                PRIMARY KEY(codigo_materia, codigo_materia_correlativa),
        CONSTRAINT FK_materia 
            FOREIGN KEY (codigo_materia) 
            REFERENCES [ingenieria_informatica].[materia](codigo_materia),
        CONSTRAINT FK_correlativa 
            FOREIGN KEY (codigo_materia_correlativa)
            REFERENCES [ingenieria_informatica].[materia](codigo_materia)
    );
END


GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE
    TABLE_SCHEMA = 'ingenieria_informatica' AND TABLE_NAME = 'historia_academica')
BEGIN
    CREATE TABLE [ingenieria_informatica].[historia_academica]
    (
        id 				INT 	IDENTITY,
        fecha_log 		DATE 	NOT NULL,
        codigo_materia 	INT 	NOT NULL,
        id_descripcion 	INT 	NOT NULL,
        CONSTRAINT PK_historial_academico
            PRIMARY KEY(id),
        CONSTRAINT FK_Descripcion 
            FOREIGN KEY(id_descripcion) 
            REFERENCES [ingenieria_informatica].[Informacion](id),
        CONSTRAINT FK_materia_historial
            FOREIGN KEY (codigo_materia) 
            REFERENCES [ingenieria_informatica].[materia](codigo_materia)
    );
END 