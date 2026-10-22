# Laboratorio 5 – Cálculo simbólico con Java + Prolog (tuProlog)

Interfaz en Java Swing que envía una expresión a Prolog (`calculo.pl`) y muestra el resultado.
Operaciones: **Derivar**, **Integrar**, **Sumar** y **Restar** (simplificando términos semejantes).

## Estructura

```
prolog-example/
├── pom.xml
└── src/main/
    ├── java/org/example/
    │   ├── screen/
    │   │   ├── components/
    │   │   │   ├── Buttons.java
    │   │   │   ├── PanelResult.java
    │   │   │   └── TextField.java
    │   │   ├── Theme.java
    │   │   └── Window.java
    │   ├── Main.java
    │   └── Connection.java
    └── resources/
        └── calculo.pl
```

## Cómo ejecutarlo

**IntelliJ IDEA:** File → Open → seleccioná la carpeta `prolog-example` (se importa como proyecto Maven
y descarga tuProlog). Luego ejecutá `Main.java`.

**Consola (requiere JDK 17+ y Maven):**

```bash
mvn compile exec:java
```

## Corrección aplicada al Main.java de la guía

En la guía aparecía `MotorSimbolico` y `VentanaPrincipal`; se reemplazaron por las clases ya creadas
`Connection` y `Window`:

```java
Connection motor = new Connection();
SwingUtilities.invokeLater(() -> new Window(motor).setVisible(true));
```

## Ejercicio: Sumar y Restar expresiones algebraicas

- **Window.java**: se agregaron los botones **Sumar** (ámbar) y **Restar** (rojo), que llaman a los
  predicados `sumar` y `restar` de Prolog, y una fila de ejemplos para probarlos.
- **Connection.java**: la misma consulta `pred(x, expresion, R).` sirve para los nuevos predicados.
  Además el resultado se muestra en notación normal (`6*x^2`) en vez de la forma interna de tuProlog
  (`'*'(6,'^'(x,2))`).
- **calculo.pl**: reglas `sumar/3` y `restar/3`. Cada término se pasa a la forma `m(Coef, Exp)`, se
  agrupan los de igual exponente sumando coeficientes, se eliminan los que dan 0, se ordenan de mayor a
  menor exponente y se reconstruye la expresión.

| Botón  | Entrada          | Resultado |
|--------|------------------|-----------|
| Sumar  | `x^2 + 5*x^2`    | `6*x^2`   |
| Restar | `7*x^3 - 3*x^3`  | `4*x^3`   |
| Sumar  | `4*x + 2*x`      | `6*x`     |
| Restar | `8*x^2 - 5*x^2`  | `3*x^2`   |

Otros casos que también resuelve:

| Botón  | Entrada                 | Resultado         |
|--------|-------------------------|-------------------|
| Sumar  | `3*x^2 + 2*x + x^2`     | `4*x^2 + 2*x`     |
| Restar | `5*x - 5*x`             | `0`               |
| Restar | `2*x^2 - 5*x^2`         | `-3*x^2`          |

**Sumar** espera una expresión de la forma `A + B` y **Restar** una de la forma `A - B`.
Los coeficientes se escriben con `*` (`5*x`, no `5x`).

Consultas directas en Prolog:

```prolog
?- sumar(x, x^2 + 5*x^2, R).     % R = 6*x^2
?- restar(x, 7*x^3 - 3*x^3, R).  % R = 4*x^3
```
