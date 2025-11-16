package com.mycompany.marnager.dto;

import java.math.BigDecimal;
import java.util.Date;

public class TransaccionDTO {
    private String tipo;
    private String categoria;
    private BigDecimal monto;
    private Date fecha;

    public TransaccionDTO(String tipo, String categoria, BigDecimal monto, Date fecha) {
        this.tipo = tipo;
        this.categoria = categoria;
        this.monto = monto;
        this.fecha = fecha;
    }

    // Getters y Setters
    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public BigDecimal getMonto() {
        return monto;
    }

    public void setMonto(BigDecimal monto) {
        this.monto = monto;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }
}
