USE Universidad;

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
		code = @codMateria;
-- Elimino la materia como correlativa.
	DELETE [ingenieria_informatica].[correlativa]
	WHERE codigo_materia_correlativa = @codMateria;

END