:- encoding(utf8).
% Proyecto Unidad 4 - Asesor académico
% Autor: Rey Elijah Morales Pérez

% ===================== HECHOS =====================

% materia(Nombre, Semestre, Creditos)
materia(fundamentos_programacion, 1, 5).
materia(calculo_diferencial,      1, 5).
materia(matematicas_discretas,    1, 5).
materia(programacion_oo,          2, 5).
materia(calculo_integral,         2, 5).
materia(estructuras_datos,        3, 5).
materia(probabilidad,             3, 4).
materia(inteligencia_artificial,  4, 4).
materia(bases_datos,              4, 5).
materia(programacion_logica,      5, 4).

% prerrequisito(Materia, Requisito)
prerrequisito(programacion_oo,         fundamentos_programacion).
prerrequisito(calculo_integral,        calculo_diferencial).
prerrequisito(estructuras_datos,       programacion_oo).
prerrequisito(estructuras_datos,       matematicas_discretas).
prerrequisito(probabilidad,            calculo_integral).
prerrequisito(inteligencia_artificial, estructuras_datos).
prerrequisito(inteligencia_artificial, probabilidad).
prerrequisito(bases_datos,             estructuras_datos).
prerrequisito(programacion_logica,     inteligencia_artificial).

% ana y luis // sam (nuevo), rex (avanzado), cristian (irregular)
estudiante(ana).
estudiante(luis).
estudiante(sam).
estudiante(rex).
estudiante(cristian).

aprobo(ana,  fundamentos_programacion).
aprobo(ana,  calculo_diferencial).
aprobo(ana,  matematicas_discretas).
aprobo(ana,  programacion_oo).
aprobo(ana,  calculo_integral).

aprobo(luis, fundamentos_programacion).
aprobo(luis, calculo_diferencial).

aprobo(rex,  fundamentos_programacion).
aprobo(rex,  calculo_diferencial).
aprobo(rex,  matematicas_discretas).
aprobo(rex,  programacion_oo).
aprobo(rex,  calculo_integral).
aprobo(rex,  estructuras_datos).

aprobo(cristian, calculo_diferencial).
aprobo(cristian, calculo_integral).

% ===================== REGLAS =====================

% X puede cursar M si no la ha aprobado y aprobó todos sus requisitos
puede_cursar(X, M) :-
    estudiante(X),
    materia(M, _, _),
    \+ aprobo(X, M),
    forall(prerrequisito(M, R), aprobo(X, R)).

% requiere(M, R): M necesita R directa o indirectamente (recursiva)
requiere(M, R) :- prerrequisito(M, R).
requiere(M, R) :- prerrequisito(M, Z), requiere(Z, R).

%  le_falta(X, M, R): R lo requiere M y X no lo ha aprobado
le_falta(X, M, R) :-
    estudiante(X),
    requiere(M, R),
    \+ aprobo(X, R).

% materias_disponibles(X, Lista): todas las que X puede cursar
materias_disponibles(X, Lista) :-
    findall(M, puede_cursar(X, M), Lista).
