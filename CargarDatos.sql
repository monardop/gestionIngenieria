USE Universidad;

GO
INSERT INTO [ingenieria_informatica].[rama_carrera]
VALUES
    ('Ciencias Básicas'),-- 1
    ('Desarrollo de Software'),-- 2
    ('Infraestructura'),-- 3
    ('Programación'),-- 4
    ('Calidad y seguridad de la Información'),-- 5
    ('Gestión y complementarias'),-- 6
    ('Transversales') -- 7

GO
INSERT INTO [ingenieria_informatica].[Informacion]
VALUES
    ('Correlativas pendientes'), --1
    ('Habilitada'),              --2
    ('En Curso'),                --3
    ('Aprobada'),                --4
    ('Regularizada'),            --5
    ('Promocionada'),            --6
    ('Final Aprobado'),          --7
    ('Final Desaprobado'),       --8
    ('Materia Desaprobada'),     --9
    ('Materia Abandonada')       --10
GO
INSERT INTO [ingenieria_informatica].[materia]
    (codigo_materia, nombre, id_rama_materia, id_estado, anio)
VALUES
    -- Transversales
    (901, 'Inglés Transversal Nivel I', 7, 1, 1),
    (902, 'Inglés Transversal Nivel II', 7, 1, 2),
    (903, 'Inglés Transversal Nivel III', 7, 1, 3),
    (904, 'Inglés Transversal Nivel IV', 7, 1, 4),
    (911, 'Computación Transversal Nivel I', 7, 1, 1),
    (912, 'Computación Transversal Nivel II', 7, 1, 2),
    --Ciencias Básicas
    (3621, 'Matemática Discreta', 1, 1, 1),
    (3622, 'Análisis Matemático I', 1, 1, 1),
    (3627, 'Álgebra y Geometría analítica I', 1, 1, 1),
    (3628, 'Física I', 1, 1, 1),
    (3633, 'Análisis Matemático II', 1, 1, 2),
    (3634, 'Física II', 1, 1, 2),
    (3639, 'Análisis Matemático III', 1, 1, 2),
    (3645, 'Álgebra y Geometría analítica II', 1, 1, 3),
    (3651, 'Probabilidad y Estadística', 1, 1, 3),
    (3656, 'Estadística aplicada', 1, 1, 4),
    (3662, 'Matemática aplicada', 1, 1, 4),
    -- Infraestructura
    (3625, 'Sistemas de numeración', 3, 1, 1),
    (3631, 'Fundamentos de sistemas embebidos', 3, 1, 1),
    (3638, 'Arquitectura de computadoras', 3, 1, 2),
    (3643, 'Redes de computadoras', 3, 1, 2),
    (3649, 'Sistemas operativos', 3, 1, 3),
    (3654, 'Virtualización de Hardware', 3, 1, 3),
    (3658, 'Programación recurrente', 3, 1, 4),
    (3660, 'Sistemas Operativos avanzados', 3, 1, 4),
    -- Programación
    (3623, 'Programación inicial', 4, 1, 1),
    (3629, 'Programación estructurada Básica', 4, 1, 1),
    (3635, 'Tópicos de Programación', 4, 1, 2),
    (3636, 'Bases de datos', 4, 1, 2),
    (3640, 'Algoritmos y estructuras de datos', 4, 1, 2),
    (3641, 'Bases de Datos Aplicadas', 4, 1, 2),
    (3646, 'Paradigmas de la Programación', 4, 1, 3),
    (3652, 'Programación avanzada', 4, 1, 3),
    (3657, 'Autómatas y gramática', 4, 1, 4),
    (3663, 'Lenguajes y compiladores', 4, 1, 4),
    -- calidad y seguridad 5
    (3626, 'Principios de calidad de Software', 5, 1, 1),
    (3650, 'Seguridad de la información', 5, 1, 3),
    (3655, 'Auditoría y legislación', 5, 1, 3),
    (3666, 'Seguridad aplicada y Forensia', 5, 1, 4),
    (3667, 'Gestión de la calidad en procesos de sistemas', 5, 1, 4),
    -- Gestión 6
    (3632, 'Introducción a los proyectos informáticos', 6, 1, 1),
    (3644, 'Gestión de las organizaciones', 6, 1, 2),
    (3676, 'Responsabilidad Universitaria', 6, 1, 2),
    (3675, 'Práctica profesional supervisada', 6, 1, 3),
    (3661, 'Gestión de proyectos', 6, 1, 4),
    (3670, 'Innovación y Emprendedorismo', 6, 1, 5),
    -- Desarrollo 2
    (3624, 'Introducción a los sistemas de información', 2, 1, 1),
    (3630, 'Introducción a la gestión de requisitos', 2, 1, 1),
    (3637, 'Análisis de sistemas', 2, 1, 2),
    (3642, 'Principios de diseños de sistemas', 2, 1, 2),
    (3647, 'Requisitos avanzados', 2, 1, 3),
    (3648, 'Diseño de software', 2, 1, 3),
    (3653, 'Arquitecturas de sistemas software', 2, 1, 3),
    (3659, 'Gestión aplicada al desarrollo de Software I', 2, 1, 4),
    (3664, 'Inteligencia Artificial', 2, 1, 4),
    (3665, 'Gestión aplicada al desarrollo de Software II', 2, 1, 4),
    (3668, 'Inteligencia Artificial Aplicada', 2, 1, 5),
    (3669, 'Ciencia de datos', 2, 1, 5),
    (3671, 'Proyecto final de carrera', 2, 1, 5),
    (3677, 'Lenguaje orientado a negocios', 2, 1, 5),
    (3678, 'Tecnologías en seguridad', 2, 1, 5),
    (3679, 'Visión Artificial', 2, 1, 5)
             
GO
INSERT INTO [ingenieria_informatica].[correlativa]
VALUES
    (3628, 3622), (3629, 3623), (3630, 3624), (3631, 3625), (3633, 3622),
    (3634, 3628), (3635, 3629), (3625, 3621), (3636, 3629), (3636, 3621),
    (3637, 3630), (3638, 3631), (3676, 3626), (3639, 3633), (3640, 3635),
    (3641, 3636), (3642, 3637), (3642, 3626), (3643, 3638), (3643, 3634),
    (3644, 3632), (3645, 3627), (3646, 3640), (3646, 3633), (3647, 3642),
    (3648, 3642), (3648, 3636), (3649, 3638), (3650, 3643), (3650, 3638),
    (3650, 3635), (3675, 3642), (3651, 3645), (3651, 3639), (3651, 3621),
    (3652, 3641), (3652, 3646), (3653, 3648), (3654, 3649), (3654, 3645),
    (3654, 3640), (3655, 3650), (3656, 3651), (3656, 3641), (3657, 3646),
    (3658, 3654), (3658, 3646), (3659, 3653), (3659, 3647), (3659, 3644),
    (3660, 3654), (3661, 3651), (3661, 3650), (3661, 3644), (3662, 3651),
    (3663, 3657), (3664, 3651), (3664, 3646), (3665, 3659), (3665, 3652),
    (3666, 3655), (3666, 3652), (3666, 3649), (3667, 3647), (3668, 3664),
    (3668, 3656), (3669, 3661), (3670, 3664), (3670, 3656), (3671, 3667),
    (3671, 3661), (3671, 3660), (3671, 3659), (3671, 3656), (3677, 3658),
    (3677, 3661), (3677, 3663), (3678, 3662), (3678, 3666), (3679, 3664),
    (3679, 3665), (902, 901),   (903, 902),   (904, 903),   (912, 911)
