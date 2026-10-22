package org.example;

import alice.tuprolog.Prolog;
import alice.tuprolog.SolveInfo;
import alice.tuprolog.Struct;
import alice.tuprolog.Term;
import alice.tuprolog.Theory;

import java.io.InputStream;

public class Connection {
    private final Prolog engine = new Prolog();

    public Connection() throws Exception {
        try (InputStream in = getClass().getResourceAsStream("/calculo.pl")) {
            if (in == null) throw new IllegalStateException("No se encontró calculo.pl");
            engine.setTheory(new Theory(in));
        }
    }

    public String consultar(String predicado, String expresion) throws Exception {
        SolveInfo info = engine.solve(predicado + "(x, " + expresion + ", R).");
        return info.isSuccess() ? formatear(info.getTerm("R"))
                : "Sin solución para esa expresión";
    }

    // ------------------------------------------------------------------
    //  Formato: convierte '*'(6,'^'(x,2)) en 6*x^2
    // ------------------------------------------------------------------
    private static String formatear(Term t) {
        return formatear(t.getTerm(), 1200);
    }

    private static String formatear(Term t, int maximo) {
        if (t instanceof Struct) {
            Struct s = (Struct) t;
            String op = s.getName();
            int p = precedencia(op);

            if (s.getArity() == 2 && p > 0) {
                boolean derecha = op.equals("^"); // ^ asocia a la derecha
                String izq = formatear(s.getArg(0).getTerm(), derecha ? p - 1 : p);
                String der = formatear(s.getArg(1).getTerm(), derecha ? p : p - 1);
                String sep = (op.equals("+") || op.equals("-")) ? " " + op + " " : op;
                String txt = izq + sep + der;
                return p > maximo ? "(" + txt + ")" : txt;
            }
            if (s.getArity() == 1 && op.equals("-")) {
                String txt = "-" + formatear(s.getArg(0).getTerm(), 400); // -3*x^2
                return 200 > maximo ? "(" + txt + ")" : txt;
            }
        }
        return t.toString();
    }

    private static int precedencia(String op) {
        switch (op) {
            case "+":
            case "-":
                return 500;
            case "*":
            case "/":
                return 400;
            case "^":
                return 200;
            default:
                return 0;
        }
    }
}
