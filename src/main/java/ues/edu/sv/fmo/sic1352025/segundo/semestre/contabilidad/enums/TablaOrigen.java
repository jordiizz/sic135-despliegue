package ues.edu.sv.fmo.sic1352025.segundo.semestre.contabilidad.enums;

public enum TablaOrigen {
    CREDITO("credito"),
    TARJETA_BANCARIA("tarjeta_bancaria"),
    CUENTA_BANCARIA("cuenta_bancaria");

    private final String tablaOrigen;

    TablaOrigen(String tablaOrigen){
        this.tablaOrigen = tablaOrigen;
    }

    public String getTablaOrigen(){
        return tablaOrigen;
    }
}
