# Gestión de la carrera Ingeniería Informática, UNLaM

Aplicación para gestionar y visualizar el progreso académico en la carrera "Ingeniería Informática" en la Universidad Nacional de La Matanza. La finalidad de esto es practicar consultas y gestión básica de la base de datos para posteriormente hacer un proyecto que incluya una API y complementar usando Python con una interfaz gráfica. 

## **Índice**

1. [Descripción General](#descripci%C3%B3n-general)
2. [Características](#caracter%C3%ADsticas)
3. [Requisitos Previos](#requisitos-previos)
4. [Instalación](#instalaci%C3%B3n)
5. [Uso](#uso)
6. [Estructura del Proyecto](#estructura-del-proyecto)
7. [Tecnologías Utilizadas](#tecnolog%C3%ADas-utilizadas)
8. [Contribuciones](#contribuciones)

## Descripción General

El propósito de este proyecto es gestionar la carrera. Se permitirá agregar materias a un historial académico, además de visualizar materias aprobadas, porcentaje de la carrera terminado, porcentaje restante, promedio y otros datos interesantes para gestionar información referida a la carrera universitaria. De momento, la base de datos está hecha exclusivamente con la carrera de la Universidad de La Matanza, dado que es el plan de estudio que conozco.  

## **Características**
- Gestión de materias y sus correlatividades.
- Cálculo automático de promedios.
- Stored Procedures descriptivos que se pueden ejecutar para obtener información. 

## **Requisitos Previos**
Lista de herramientas y dependencias necesarias para ejecutar el proyecto:
- Microsoft SQL Server Express versión 20.3

## **Instalación**
Guía paso a paso para instalar y ejecutar el proyecto:
1. Clona este repositorio
2. Ejecuta los archivos en el orden correspondiente 
```powershell
git clone https://github.com/monardop/gestionIngenieria
cd gestor-academico
CreationFile.sql
CargarDatos.sql
Procedimientos.sql
```

## **Uso**

> [!important]
> Asegurarse de ejecutar primero `USE Universidad` para poder usar los comandos.

### Vistas y resúmenes
- `EXEC ver_promedio;`: devuelve una tabla donde puedes ver el promedio según el título intermedio y el título final.
- `EXEC ver_avance_segun_titulo;`: devuelve una tabla donde muestra el porcentaje de materias aprobadas según el título, además de las materias restantes y totales.
- `EXEC ver_progreso_por_ramas` Separa por ramas las estadísticas
- `EXEC ver_progreso_por_anio`  Separa por años las estadísticas
- `EXEC ver_materias_adeudadas` Muestra las materias que no figuren como aprobadas
- `EXEC ver_historial` Muestra una vista del historial académico
- `EXEC ver_resumen_historial` Devuelve un resumen agrupado por estados del historial académico (Cantidad de finales aprobados, desaprobados, promociones, etc)
-  `EXEC recomendar_materias` Devuelve una tabla ordenada con base a cuántas materias habilitaría si curso alguna de las habilitadas. Es decir, ordena las materias habilitadas priorizando las que desbloquean más para la próxima cursada.
- `EXEC ver_materias_disponibles` Me muestra las materias regularizadas o habilitadas ordenadas por año.
- `EXEC ver_resumen_anual` Me muestra cada una de las categorías resumidas de forma anual. Esto puede ser útil para ver un progreso y hacer una comparativa de otros años.

### Funciones
> [!important]
> - Las fechas van en formato ISO, es decir yyyy-mm-dd. Ejemplo (22 de julio del 1997 -> 1997-07-22)
> - La nota no puede ser menor que 4 (cuatro) ni mayor que 10 (diez)
> - Condición / estado cumplen con lo siguiente:
>    - Materia a final                 = 5
>    - Promoción                       = 6
>    - Final Aprobado                  = 7
>    - Final desaprobado               = 8
>    - Materia recursada / desaprobada = 9
>    - Materia Abandonada              = 10


1. `EXEC generar_registro_historial codMateria, fecha, condicion, nota`
  -  Fecha es un parámetro opcional, de no ponerlo se asigna la fecha del día del ingreso. Con nota pasa lo mismo, cabe destacar que si la condición es de final aprobado (7) o promoción (6), esta función no tendrá validez.
  -  Esta función guarda en el historial académico una entrada, de ser necesario guarda en la planilla principal. Los estados que modifican la planilla principal serán (5,6,7), dado que son los que dan por aprobada la materia o regularizan. Que la materia figure como regularizada/aprobada permite que las correlativas sean eliminadas y quienes dependan de esta materia puedan figurar como "Habilitadas"
2. `EXEC set_materia_en_curso codMateria`
  - Esta función me permite establecer una materia con el estado "En curso", es decir, establecer que actualmente estoy cursando la materia. 
3. `EXEC finalizar_materia_cursada codMateria, estado, nota, fecha`
  - Puedo no pasar la nota de no ser necesario, solo aplica en caso de que registre el estado 6
  - Como indica el nombre, esta función buscará una materia que haya sido registrada previamente como "en curso" utilizando la función anterior (2), por lo que, en caso de no haberlo hecho, usar directamente la función 1. Una vez encontrada la entrada, la modificará y establecerá el nuevo estado. En caso de ser aprobada, actualizará la planilla principal también.
4. `EXEC examen_rendido codMateria, nota, fecha`
  - Si la materia no figura como regularizada, no podrá ejecutarse esta función.
  - Genera un registro en el historial académico y, si fue aprobado, registra la materia como aprobada
5. `EXEC materia_que_habilita @codigoMateria`
  - Me muestra las materias que habilita la materia que ingreso. Es una función pensada para complementar a `EXEC recomendar_materias`.

## **Estructura del Proyecto**
```plaintext
gestorIngenieria/ 
├── Documentacion
|   ├── DER.jpg
├── CreationFile.sql
├── CargarDatos.sql
├── Procedimientos.sql
├── Readme.md
```
### Estructura de la base de datos Universidad
![](https://github.com/monardop/gestionIngenieria/blob/main/Documentacion/DER.jpg)

## **Tecnologías Utilizadas**
- **Base de Datos:** Microsoft SQL Server
- **Control de Versiones:** Git

## **Contribuciones**
1. Haz un fork del repositorio.
2. Crea una rama para tu feature: `git checkout -b mi-nueva-feature`.
3. Sube los cambios y haz un pull request.

## **Créditos y Autoría**
Este proyecto es de mi autoría, utilicé la lista de materias mostrada en [Departamento de Ingeniería e Investigaciones Tecnológicas -](https://ingenieria.unlam.edu.ar/index.php?seccion=3&idArticulo=565)
