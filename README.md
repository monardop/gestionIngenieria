# Gestión de la carrera Ingeniería Informática, UNLaM

Aplicación para gestionar y visualizar el progreso académico en la carrera "Ingeniería Informática" en la Universidad Nacional de La Matanza. La finalidad de esto es practicar consultas y gestión básica de la base de datos para posteriormente hacer un proyecto que incluya una API y complementar usando Python con una interfaz gráfica. 

---

## **Índice**

1. [Descripción General](#descripci%C3%B3n-general)
2. [Características](#caracter%C3%ADsticas)
3. [Requisitos Previos](#requisitos-previos)
4. [Instalación](#instalaci%C3%B3n)
5. [Uso](#uso)
6. [Estructura del Proyecto](#estructura-del-proyecto)
7. [Tecnologías Utilizadas](#tecnolog%C3%ADas-utilizadas)
8. [Contribuciones](#contribuciones)

---

## Descripción General

El propósito de este proyecto es gestionar la carrera. Se permitirá agregar materias a un historial académico, además de visualizar materias aprobadas, porcentaje de la carrera terminado, porcentaje restante, promedio y otros datos interesantes para gestionar información referida a la carrera universitaria. De momento, la base de datos está hecha exclusivamente con la carrera de la Universidad de La Matanza, dado que es el plan de estudio que conozco.  

---

## **Características**

- Gestión de materias y sus correlatividades.
- Cálculo automático de promedios.
- Stored Procedures descriptivos que se pueden ejecutar para obtener información. 

---

## **Requisitos Previos**

Lista de herramientas y dependencias necesarias para ejecutar el proyecto:

- Microsoft SQL Server Express versión 20.3

---

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

---
## **Uso**

- `EXEC ver_promedio;`: devuelve una tabla donde puedes ver el promedio según el título intermedio y el título final.
- `EXEC ver_avance_segun_titulo;`: devuelve una tabla donde muestra el porcentaje de materias aprobadas según el título, además de las materias restantes y totales.
- 

---

## **Estructura del Proyecto**

Desglosa los archivos y carpetas principales del proyecto:

```plaintext
gestorIngenieria/ 
├── Documentacion
|   ├── DER.jpg
├── CreationFile.sql
├── CargarDatos.sql
├── Procedimientos.sql
├── Readme.md
```

---

## **Tecnologías Utilizadas**

- **Base de Datos:** Microsoft SQL Server
- **Control de Versiones:** Git

---

## **Contribuciones**

Explica cómo otras personas pueden contribuir al proyecto. Por ejemplo:

1. Haz un fork del repositorio.
2. Crea una rama para tu feature: `git checkout -b mi-nueva-feature`.
3. Sube los cambios y haz un pull request.

---

## **Créditos y Autoría**

Este proyecto es de mi autoría, utilicé la lista de materias mostrada en [Departamento de Ingeniería e Investigaciones Tecnológicas -](https://ingenieria.unlam.edu.ar/index.php?seccion=3&idArticulo=565)
