:- consult('hechos.pl').
% (equivalente a :- [hechos].)

% -----------------------------------------------------
% REGLA 1: zona_peligro_valor/3
% Proposito: obtener el valor numerico de peligro de una
% zona, considerando el momento del dia cuando aplica
% (usa OR ';' porque la superficie puede recibir un valor
%  distinto dependiendo del momento consultado)
% -----------------------------------------------------
zona_peligro_valor(Zona, _Momento, Valor) :-
    nivel_peligro(Zona, Nivel),
    peligro_valor(Nivel, Valor).

zona_peligro_valor(superficie, Momento, Valor) :-
    ( Momento == dia ; Momento == noche ),
    nivel_peligro(superficie, Nivel, Momento),
    peligro_valor(Nivel, Valor).

% Prueba en swipl:
% ?- zona_peligro_valor(cuevas, noche, V).
% ?- zona_peligro_valor(superficie, dia, V).
% ?- zona_peligro_valor(superficie, noche, V).


% -----------------------------------------------------
% REGLA 2: zona_segura/2 y zona_letal/2
% Proposito: clasificar si una zona es segura o letal en
% un momento dado, usando comparacion numerica (=<, >=)
% -----------------------------------------------------
zona_segura(Zona, Momento) :-
    zona_peligro_valor(Zona, Momento, Valor),
    Valor =< 2.

zona_letal(Zona, Momento) :-
    zona_peligro_valor(Zona, Momento, Valor),
    Valor >= 3.

% Prueba en swipl:
% ?- zona_segura(superficie, dia).      % true
% ?- zona_letal(cuevas, dia).           % true
% ?- zona_segura(cuevas, noche).        % false


% -----------------------------------------------------
% REGLA 3: hay_enemigo_en/1
% Proposito: verificar si existe al menos un enemigo en
% una zona determinada (usa AND al combinar con enemigo/1)
% -----------------------------------------------------
hay_enemigo_en(Zona) :-
    enemigo(Enemigo),
    aparece_en(Enemigo, Zona).

% Prueba en swipl:
% ?- hay_enemigo_en(cuevas).            % true
% ?- hay_enemigo_en(bunkeres).          % false


% -----------------------------------------------------
% REGLA 4: puede_recolectar/4
% Proposito: determinar si un personaje puede recolectar
% un material en una zona y momento dado, combinando
% varias condiciones con AND (,)
% -----------------------------------------------------
puede_recolectar(Personaje, Material, Zona, Momento) :-
    personaje(Personaje),
    material(Material),
    encuentra_en(Material, Zona),
    zona_segura(Zona, Momento).

% Prueba en swipl:
% ?- puede_recolectar(eric, troncos, superficie, dia).   % true
% ?- puede_recolectar(eric, troncos, superficie, noche). % false


% -----------------------------------------------------
% REGLA 5: kelvin_disponible_para/1
% Proposito: verificar que una accion de Kelvin es valida
% (usa OR ';' para aceptar cualquiera de las dos acciones
%  conocidas que Kelvin puede ejecutar bajo orden)
% -----------------------------------------------------
kelvin_disponible_para(Accion) :-
    habilidad(kelvin, Accion),
    requiere_orden(kelvin, Accion),
    ( Accion == cargar_troncos ; Accion == construir ).

% Prueba en swipl:
% ?- kelvin_disponible_para(construir).       % true
% ?- kelvin_disponible_para(cocinar).         % false


% -----------------------------------------------------
% REGLA 6: acceso_bunker/1
% Proposito: determinar si un personaje puede entrar a un
% bunker (zona sin enemigos, pero requiere llave)
% -----------------------------------------------------
acceso_bunker(Personaje) :-
    sin_enemigos(bunkeres),
    requiere_llave(bunkeres),
    tiene_llave(Personaje, bunkeres).

% Prueba en swipl:
% ?- acceso_bunker(eric).       % true
% ?- acceso_bunker(timmy).      % false (no tiene llave registrada)


% -----------------------------------------------------
% REGLA 7: es_adulto/1
% Proposito: comprobar mayoria de edad usando comparacion
% numerica (>=)
% -----------------------------------------------------
es_adulto(Personaje) :-
    edad(Personaje, Edad),
    Edad >= 18.

% Prueba en swipl:
% ?- es_adulto(eric).           % true


% -----------------------------------------------------
% REGLA 8: refugio_construible/2
% Proposito: verificar si es posible construir refugio en
% una zona/momento: se requiere que la zona sea segura Y
% que exista alguien capaz de construir (Eric con hacha
% O Kelvin con la habilidad correspondiente)
% -----------------------------------------------------
refugio_construible(Zona, Momento) :-
    zona_segura(Zona, Momento),
    ( tiene_item(eric, hacha) ; habilidad(kelvin, construir) ).

% Prueba en swipl:
% ?- refugio_construible(superficie, dia).    % true
% ?- refugio_construible(cuevas, dia).        % false