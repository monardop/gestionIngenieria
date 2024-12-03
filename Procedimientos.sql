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
CREATE OR ALTER PROCEDURE Materia_Aprobada
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
					EXEC Materia_Aprobada @codMateria, @Nota;
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

GO 
CREATE OR ALTER PROCEDURE set_materia_en_curso
	@codMateria INT
AS
BEGIN
	IF NOT EXISTS ( SELECT 1 FROM [ingenieria_informatica].[materia] WHERE codigo_materia =  @codMateria)
		BEGIN
			RAISERROR ('Parámetros ingresados de forma errónea',12,1);
		END
	ELSE BEGIN
		UPDATE [ingenieria_informatica].[materia]
			SET id_estado = 3
			WHERE codigo_materia = @codMateria;
		
		INSERT INTO [ingenieria_informatica].[historia_academica]
			(fecha_log, codigo_materia, id_descripcion)
		VALUES
			(GETDATE(), @codMateria, 3);
	END
END

GO
CREATE OR ALTER PROCEDURE finalizar_materia_cursada
	@codMateria INT,
	@estado INT,
	@nota INT = 0,
	@FechaFinalizada DATE = NULL
AS
BEGIN
	IF NOT EXISTS (
		SELECT 1 
		FROM [ingenieria_informatica].[historia_academica] 
		WHERE codigo_materia = @codMateria
	)
	BEGIN
		RAISERROR('O no está en curso o no está bien el código de la materia.',12,1);
		RETURN;
	END
	IF @estado NOT IN (5,6,9,10)
	BEGIN
		RAISERROR('El estado ingresado es incorrecto',12,1);
		RETURN;
	END

	DECLARE @fecha DATE = GETDATE();
	IF @FechaFinalizada IS NULL 
		SET @FechaFinalizada = @fecha

	IF @estado = 5 -- Regularizada
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

	ELSE IF @estado = 6 -- Promocionada
		BEGIN
			BEGIN TRY
				EXEC Materia_Aprobada @codMateria, @nota;
			END TRY
			BEGIN CATCH
				RAISERROR('Los parametros ingresados fueron erróneos.',12,1);
				RETURN;
			END CATCH
		END
	
	ELSE 
		BEGIN
		UPDATE [ingenieria_informatica].[materia]
			SET 
				id_estado = 2
			WHERE 
				codigo_materia = @codMateria
		END

	UPDATE [ingenieria_informatica].[historia_academica]
		SET 
			fecha_log = @FechaFinalizada,
			id_descripcion = @estado
		WHERE 
			codigo_materia = @codMateria
END

GO
CREATE OR ALTER PROCEDURE ver_resumen_historial
AS
BEGIN
	SELECT 
		descripcion,
		COUNT(nombre) AS Cantidad
	FROM ver_historial_academico
	GROUP BY descripcion;
END

GO
CREATE OR ALTER PROCEDURE examen_rendido
	@codMateria INT,
	@nota INT,
	@fecha DATE
AS
BEGIN
	IF NOT EXISTS (
		SELECT 1 
		FROM [ingenieria_informatica].[materia] 
		WHERE codigo_materia = @codMateria 
			AND id_estado = 5
	)
	BEGIN
		RAISERROR('Esa materia no está registrada para rendir final.',12,1);
		RETURN;
	END

	IF  @nota >= 4
	BEGIN
		EXEC generar_registro_historial @codMateria, @fecha, 7, @nota;
	END
	ELSE 
	BEGIN
		EXEC generar_registro_historial @codMateria, @fecha, 8, @nota;
	END
END

GO
CREATE OR ALTER PROCEDURE recomendar_materias
AS
BEGIN
WITH MateriasHabilitadas AS (
    SELECT m.codigo_materia, m.nombre
    FROM ingenieria_informatica.materia m
    WHERE m.id_estado = 2
),
ImpactoCorrelativas AS (
    -- Calculo cuántas materias dependen de cada materia habilitada
    SELECT 
        mc.codigo_materia_correlativa AS MateriaHabilitada, 
        COUNT(mc.codigo_materia) AS MateriasDesbloqueadas
    FROM ingenieria_informatica.correlativa mc
    JOIN MateriasHabilitadas mh
        ON mc.codigo_materia_correlativa = mh.codigo_materia
    GROUP BY mc.codigo_materia_correlativa
)
-- Muestro las materias habilitadas ordenadas por impacto
SELECT 
    mh.codigo_materia AS CodigoMateria,
    mh.nombre AS Materia,
    COALESCE(ic.MateriasDesbloqueadas, 0) AS MateriasDesbloqueadas
FROM MateriasHabilitadas mh
LEFT JOIN ImpactoCorrelativas ic
    ON mh.codigo_materia = ic.MateriaHabilitada
ORDER BY MateriasDesbloqueadas DESC, mh.nombre;
END

GO 
CREATE OR ALTER PROCEDURE materia_que_habilita 
	@codMateria INT
AS
BEGIN
	WITH materias AS(
		SELECT codigo_materia 
		FROM ingenieria_informatica.correlativa
		WHERE codigo_materia_correlativa = @codMateria
	)
	SELECT iim.codigo_materia,iim.nombre
	FROM ingenieria_informatica.materia iim
	JOIN materias tam ON tam.codigo_materia = iim.codigo_materia
END

exec habilitar_materias;