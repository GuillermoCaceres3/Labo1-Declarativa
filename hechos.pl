% ---------------------
% Personajes
% ---------------------
personaje(eric).
personaje(timmy).
personaje(kelvin).
personaje(virginia).

protagonista(eric).
edad(eric, 30).

aliado(kelvin).
capturado(kelvin).
no_habla(kelvin).

mutante_potencial_aliado(virginia).

% ---------------------
% Inventario / habilidades
% ---------------------
tiene_item(eric, hacha).
tiene_item(eric, encendedor).

habilidad(kelvin, cargar_troncos).
habilidad(kelvin, construir).
requiere_orden(kelvin, cargar_troncos).
requiere_orden(kelvin, construir).

% ---------------------
% Zonas del mapa
% ---------------------
zona(superficie).
zona(cuevas).
zona(bunkeres).

% ---------------------
% Enemigos y su ubicacion
% ---------------------
enemigo(canibales).
enemigo(mutantes).

aparece_en(canibales, superficie).
aparece_en(mutantes, superficie).
aparece_en(mutantes, cuevas).

sin_enemigos(bunkeres).
requiere_llave(bunkeres).

% Ejemplo: Eric ya consiguio una llave para el bunker
tiene_llave(eric, bunkeres).

% ---------------------
% Niveles de peligro
% ---------------------
% peligro_valor(NombreNivel, ValorNumerico)
peligro_valor(bajo, 1).
peligro_valor(medio, 2).
peligro_valor(alto, 3).

% nivel_peligro(Zona, Nivel)               
% nivel_peligro(Zona, Nivel, Momento)       
nivel_peligro(cuevas, alto).
nivel_peligro(bunkeres, bajo).

nivel_peligro(superficie, medio, dia).
nivel_peligro(superficie, alto, noche).

% ---------------------
% Necesidades de supervivencia
% ---------------------
necesidad(eric, refugio).
necesidad(eric, comida).
necesidad(eric, agua).

% ---------------------
% Materiales y su ubicacion
% ---------------------
material(troncos).
material(piedras).

encuentra_en(troncos, superficie).
encuentra_en(piedras, superficie).