# Asesor académico en Prolog

Sistema experto sencillo hecho en SWI-Prolog que, a partir de una base de conocimiento con alumnos, materias y prerrequisitos, decide **qué materias puede cursar cada alumno**, **qué requiere cada materia** (de forma directa o indirecta) y **qué le falta a un alumno** para llegar a una materia.

## Contexto académico
Proyecto integrador de la **Unidad 4 · Modelo de programación lógica** de la materia **Programación Lógica y Funcional**, 7.º semestre de **Ingeniería en Sistemas Computacionales**.

## Conceptos de la unidad que aplica

| Concepto (tema) | Dónde se usa |
|---|---|
| Hechos y reglas (4.1, 4.3) | `materia/3`, `prerrequisito/2`, `estudiante/1`, `aprobo/2` y todas las reglas |
| Consultas con variables y compuestas (4.4) | Consultas 1 a 10, por ejemplo `puede_cursar(Quien, programacion_oo)` |
| Búsqueda en profundidad y backtracking (4.5) | `puede_cursar/2` recorre todas las materias; `requiere/2` sigue la cadena de requisitos |
| Recursividad (4.6) | `requiere/2`: caso base (requisito directo) y caso recursivo (requisito de un requisito) |
| Listas (4.6) | `materias_disponibles/2` junta resultados en una lista con `findall/3` |
| Negación por fallo `\+` (4.7) | `puede_cursar/2` (no aprobada) y `le_falta/3` (requisito no aprobado) |
| Mundo cerrado (4.2) | Lo que no está en la base se considera no aprobado |

## Base de conocimiento
- `materia(Nombre, Semestre, Creditos)`: 10 materias en 5 semestres.
- `prerrequisito(Materia, Requisito)`: para llevar *Materia* hay que haber aprobado *Requisito*.
- `estudiante(Nombre)`: ana, luis, sam (recién ingresado), rex (avanzado) y cristian (irregular).
- `aprobo(Alumno, Materia)`: materias aprobadas por cada alumno.

## Reglas y su explicación

**`puede_cursar(X, M)`**: X puede inscribir M.
```prolog
puede_cursar(X, M) :-
    estudiante(X),
    materia(M, _, _),
    \+ aprobo(X, M),
    forall(prerrequisito(M, R), aprobo(X, R)).
```
X es estudiante, M es una materia, X **no** la ha aprobado (`\+`) y **todos** sus requisitos están aprobados (`forall`). Si M no tiene requisitos, el `forall` se cumple solo; por eso aparecen las materias de 1.er semestre. A diferencia de la base del profe, no exige `prerrequisito(M, _)`, que dejaba fuera las materias sin requisitos.

**`requiere(M, R)`** (recursiva): M necesita R directa o indirectamente.
```prolog
requiere(M, R) :- prerrequisito(M, R).
requiere(M, R) :- prerrequisito(M, Z), requiere(Z, R).
```
Caso base: R es requisito directo. Caso recursivo: M tiene un requisito Z y Z requiere R. Tiene la misma forma que `camino/2` o `ancestro/2`.

**`le_falta(X, M, R)`**: R es una materia que M requiere y X todavía no aprobó.
```prolog
le_falta(X, M, R) :-
    estudiante(X),
    requiere(M, R),
    \+ aprobo(X, R).
```
Primero `requiere` le da valor a R y después se niega; si se invierte el orden, `\+` recibe R sin valor y la regla no da respuestas.

**`materias_disponibles(X, Lista)`**: todas las materias que X puede cursar, en una sola lista.
```prolog
materias_disponibles(X, Lista) :-
    findall(M, puede_cursar(X, M), Lista).
```
`findall` ejecuta `puede_cursar(X, M)`, guarda cada M encontrada y, al terminar, entrega la lista.

## Requisitos
- SWI-Prolog estable para Windows (`swipl-win`), versión 9 o superior.

## Ejecución

### Windows
1. Doble clic en `main.pl` (se abre swipl-win con el archivo cargado), **o** en swipl-win:
   ```prolog
   ?- consult('C:/proyects/uni/semestre_7/Programacion_Logica_y_Funcional/unidad_4/asesor_academico/main.pl').
   ```
2. Después de editar el archivo, recargar con `make.`

### Linux / macOS
```bash
swipl main.pl
```

## Ejemplos de uso (las 10 consultas)
Después de cada respuesta, `;` pide la siguiente. El `false.` al final solo significa que ya no hay más respuestas.

```prolog
1)  ?- puede_cursar(ana, M).
    M = estructuras_datos ; M = probabilidad.
2)  ?- puede_cursar(sam, M).
    M = fundamentos_programacion ; M = calculo_diferencial ; M = matematicas_discretas.
3)  ?- puede_cursar(cristian, M).
    M = fundamentos_programacion ; M = matematicas_discretas ; M = probabilidad.
4)  ?- puede_cursar(ana, inteligencia_artificial).
    false.
5)  ?- puede_cursar(Quien, programacion_oo).
    Quien = luis.
6)  ?- requiere(programacion_logica, R).
    R = inteligencia_artificial ; R = estructuras_datos ; R = probabilidad ;
    R = programacion_oo ; R = matematicas_discretas ;
    R = fundamentos_programacion ; R = calculo_integral ; R = calculo_diferencial.
7)  ?- le_falta(luis, inteligencia_artificial, R).
    R = estructuras_datos ; R = probabilidad ; R = programacion_oo ;
    R = matematicas_discretas ; R = calculo_integral.
8)  ?- le_falta(rex, programacion_logica, R).
    R = inteligencia_artificial ; R = probabilidad.
9)  ?- materias_disponibles(rex, L).
    L = [probabilidad, bases_datos].
10) ?- materias_disponibles(cristian, L).
    L = [fundamentos_programacion, matematicas_discretas, probabilidad].
```

Caso interesante para la demo: cristian puede cursar `probabilidad` (3.er semestre) sin haber aprobado `fundamentos_programacion` (1.er semestre), porque las reglas solo revisan los prerrequisitos, no el semestre.

> Simplificación didáctica: no equivale a un sistema real de control escolar (no hay cupos, horarios ni límite de créditos).

## Estructura del proyecto
```
asesor_academico/
├── main.pl      # base de conocimiento, reglas y las 10 consultas de prueba
└── README.md    # este documento
```

## Autor
Rey Elijah Morales Pérez · Programación Lógica y Funcional · Unidad 4 · 7.º semestre
