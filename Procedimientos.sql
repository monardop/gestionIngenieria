USE Universidad;

GO
CREATE OR ALTER VIEW lista_materias
AS
	SELECT
		materia.codigo_materia AS Codigo,
		rc.nombre AS RamaCarrera ,
		materia.nombre,
		info.descripcion as EstadoMateria,
		materia.anio,
		materia.notaFinal
	FROM [ingenieria_informatica].[materia] materia
		JOIN [ingenieria_informatica].[rama_carrera] rc ON materia.id_rama_materia = rc.id
		JOIN [ingenieria_informatica].[Informacion] info ON materia.id_estado = info.id

GO
CREATE OR ALTER VIEW materias_aprobadas
AS
	SELECT codigo_materia, nombre, notaFinal, anio
	FROM [ingenieria_informatica].[materia]
	WHERE id_estado = 4;

GO
CREATE OR ALTER VIEW ver_historial_academico
AS
	SELECT 
		ha.fecha_log,
		m.nombre,
		info.descripcion,
		m.notaFinal
	FROM [ingenieria_informatica].[historia_academica] ha
	JOIN [ingenieria_informatica].[materia] m 
		ON ha.codigo_materia = m.codigo_materia
	JOIN [ingenieria_informatica].[Informacion] info 
		ON info.id = ha.id_descripcion

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
	IF NOT EXISTS (SELECT 1
		FROM [ingenieria_informatica].[materia]
		WHERE codigo_materia =  @codMateria)
		OR @nota NOT BETWEEN 4 AND 10
		BEGIN
		RAISERROR ('Parámetros ingresados de forma errónea',12,1);
	END
		ELSE BEGIN
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
		-- Habilito las materias correspondientes
		EXEC habilitar_materias;
	END
END

GO
CREATE OR ALTER PROCEDURE ver_progreso_por_ramas
AS
BEGIN
	WITH
		Ramas
		AS
		(
			SELECT
				id_rama_materia,
				CASE id_rama_materia
                WHEN 1 THEN 'Ciencias Básicas'
                WHEN 2 THEN 'Desarrollo de Software'
                WHEN 3 THEN 'Infraestructura'
                WHEN 4 THEN 'Programación'
                WHEN 5 THEN 'Calidad y seguridad de la Información'
                WHEN 6 THEN 'Gestión y complementarias'
                WHEN 7 THEN 'Transversales'
            END AS RamaCarrera
			FROM ingenieria_informatica.materia
			GROUP BY id_rama_materia
		)
	SELECT
		Ramas.RamaCarrera,
		AVG(m.notaFinal)        AS Promedio,
		COUNT(m.notaFinal)      AS MateriasAprobadas,
		COUNT(m.codigo_materia) AS CantidadMaterias,
		CONCAT(ROUND(COUNT(m.notaFinal) * 100 / COUNT(m.codigo_materia), 0), '%') AS Progreso
	FROM ingenieria_informatica.materia m
		INNER JOIN Ramas ON m.id_rama_materia = Ramas.id_rama_materia
	GROUP BY Ramas.RamaCarrera
END

GO
CREATE OR ALTER PROCEDURE ver_progreso_por_anio
AS
BEGIN
	WITH
		Anios
		AS
		(
			SELECT
				anio,
				CASE anio
                WHEN 1 THEN 'Primero'
                WHEN 2 THEN 'Segundo'
                WHEN 3 THEN 'Tercero'
                WHEN 4 THEN 'Cuarto'
                WHEN 5 THEN 'Quinto'
            END AS AnioCarrera
			FROM ingenieria_informatica.materia
			GROUP BY anio
		)
	SELECT
		Anios.AnioCarrera 		AS AñoCarrera,
		AVG(m.notaFinal)        AS Promedio,
		COUNT(m.notaFinal)      AS MateriasAprobadas,
		COUNT(m.codigo_materia) AS CantidadMaterias,
		CONCAT(ROUND(COUNT(m.notaFinal) * 100 / COUNT(m.codigo_materia), 0), '%') AS Progreso
	FROM ingenieria_informatica.materia m
		INNER JOIN Anios ON m.anio = anios.anio
	GROUP BY Anios.AnioCarrera
	ORDER BY
		CASE Anios.AnioCarrera
                WHEN 'Primero' THEN 1
                WHEN 'Segundo' THEN 2
                WHEN 'Tercero' THEN 3 
                WHEN 'Cuarto'  THEN 4
                WHEN 'Quinto'  THEN 5
    	END
END	

GO
CREATE OR ALTER PROCEDURE ver_promedio
AS
BEGIN
			SELECT
			'Técnico Universitario en Desarrollo de Software' AS Titulo,
			AVG(notaFinal) AS Promedio
		FROM [ingenieria_informatica].[materia]
		WHERE anio < 4
	UNION ALL
		SELECT
			'Ingeniero Informático' AS Titulo,
			AVG(notaFinal) AS Promedio
		FROM [ingenieria_informatica].[materia]
END

GO
CREATE OR ALTER PROCEDURE ver_avance_segun_titulo
AS
BEGIN
			SELECT
			'Técnico Universitario en Desarrollo de Software' AS Titulo,
			CONCAT(COUNT(codigo_materia), ' de 42') AS Avance,
			CONCAT(ROUND(COUNT(codigo_materia) * 100 / 42, 2) , '% finalizado') AS Porcentaje
		FROM materias_aprobadas
		WHERE anio < 4
	UNION ALL
		SELECT
			'Ingeniero Informático' AS Titulo,
			CONCAT(COUNT(codigo_materia), ' de 62') AS Avance,
			CONCAT(ROUND(COUNT(codigo_materia) * 100 / 62, 2), '% finalizado') AS Porcentaje
		FROM materias_aprobadas
END

GO
CREATE OR ALTER PROCEDURE ver_materias_adeudadas
AS
BEGIN
	SELECT
		Codigo,
		RamaCarrera ,
		nombre,
		EstadoMateria,
		anio AS Año
	FROM lista_materias
	WHERE codigo NOT IN (SELECT codigo_materia
	FROM materias_aprobadas)
	ORDER BY anio
END

GO
CREATE OR ALTER PROCEDURE generar_registro_historial
	@codMateria INT,
	@Fecha DATE = NULL,
	@Condicion INT,
	@Nota INT = 0
AS
BEGIN
	IF NOT EXISTS (
		SELECT 1
		FROM [ingenieria_informatica].[materia]
		WHERE codigo_materia =  @codMateria
	) OR @Condicion NOT BETWEEN 5 AND 9
	BEGIN
		RAISERROR('Ingreso de datos incorrectos',12,1);
	END
	ELSE BEGIN
		-- En caso de que no cargue fecha
		DECLARE @FechaHoy DATE = GETDATE();
		IF @Fecha IS NULL
		SET @Fecha = @FechaHoy;

		-- Casos especiales
		IF @Condicion = 5 -- Regularizada
			BEGIN
				UPDATE [ingenieria_informatica].[materia]
				SET
					id_estado = 5
				WHERE 
					codigo_materia = @codMateria;
				-- Elimino la materia como correlativa.
				DELETE [ingenieria_informatica].[correlativa]
					WHERE codigo_materia_correlativa = @codMateria;
				-- Habilito las materias correspondientes
				EXEC habilitar_materias;
			END
		ELSE IF @Condicion = 6 or @Condicion = 7
		BEGIN
				BEGIN TRY
					EXEC MateriaAprobada @codMateria, @Nota;
				END TRY
				BEGIN CATCH
					RAISERROR('Los parametros ingresados fueron erróneos.',12,1);
					RETURN;
				END CATCH
		END

		-- Para todos los casos
		INSERT INTO [ingenieria_informatica].[historia_academica]
			(fecha_log, codigo_materia, id_descripcion)
		VALUES
			(@Fecha, @codMateria, @Condicion);
	END
END

GO
CREATE OR ALTER PROCEDURE ver_historial
AS
BEGIN
	SELECT 
		fecha_log, nombre, descripcion,
		COALESCE(CAST(notaFinal AS CHAR(3)), '---') AS Nota	
	FROM ver_historial_academico
	ORDER BY descripcion, fecha_log;
END

exec habilitar_materias;