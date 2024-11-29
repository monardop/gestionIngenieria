USE Universidad;

GO
CREATE OR ALTER VIEW lista_materias AS
	SELECT 
		rc.nombre AS RamaCarrera ,
		materia.nombre, 
		info.descripcion as EstadoMateria, 
		materia.anio, 
		materia.notaFinal
	FROM [ingenieria_informatica].[materia] materia
		JOIN [ingenieria_informatica].[rama_carrera] rc ON materia.id_rama_materia = rc.id
		JOIN [ingenieria_informatica].[Informacion] info ON materia.id_estado = info.id

GO
CREATE OR ALTER VIEW materias_aprobadas AS
	SELECT codigo_materia, nombre, notaFinal
	FROM [ingenieria_informatica].[materia]
	WHERE id_estado = 4;


GO 
CREATE OR ALTER PROCEDURE habilitar_materias
AS 
BEGIN
	UPDATE [ingenieria_informatica].[materia] 
	SET id_estado = 2
	WHERE codigo_materia NOT IN (
		SELECT codigo_materia
		FROM [ingenieria_informatica].[correlativa]
	) AND id_estado = 1;
END

GO
CREATE OR ALTER PROCEDURE MateriaAprobada
	@codMateria INT,
	@nota		INT
AS
BEGIN

-- Pongo la nota y cambio el estado a Aprobado
	UPDATE [ingenieria_informatica].[materia]
	SET
		id_estado = 4,
		notaFinal = @nota
	WHERE 
		codigo_materia = @codMateria;
-- Elimino la materia como correlativa.
	DELETE [ingenieria_informatica].[correlativa]
	WHERE codigo_materia_correlativa = @codMateria;

	EXEC habilitar_materias;
END

GO
CREATE OR ALTER PROCEDURE ver_progreso_por_ramas
AS
BEGIN
	SELECT * FROM lista_materias 
	ORDER BY RamaCarrera
END

GO
CREATE OR ALTER PROCEDURE ver_progreso_por_anio
AS
BEGIN
	SELECT * FROM lista_materias 
	ORDER BY anio;
END	

GO
CREATE OR ALTER PROCEDURE ver_promedio
AS 
BEGIN
	SELECT 	
		'Técnico Universitario en Desarrollo de Software' AS Titulo,
		AVG(notaFinal) AS Promedio
	FROM [ingenieria_informatica].[materia] 
	WHERE anio < 3
	UNION ALL
	SELECT 
		'Ingeniero Informático' AS Titulo,
		AVG(notaFinal) AS Promedio
	FROM [ingenieria_informatica].[materia]
END


exec habilitar_materias;