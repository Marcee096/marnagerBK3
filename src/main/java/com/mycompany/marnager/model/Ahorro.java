package com.mycompany.marnager.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 *
 * @author marce
 */
@Entity
@Table(name = "ahorro")
@NamedQueries({
    @NamedQuery(name = "Ahorro.findAll", query = "SELECT a FROM Ahorro a")})
public class Ahorro implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "idahorro")
    private Integer idahorro;
    
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 45)
    @Column(name = "categoria")
    private String categoria;
    
    @Size(max = 45)
    @Column(name = "subcategoria")
    private String subcategoria;
    
    @Basic(optional = false)
    @NotNull
    @Column(name = "fecha")
    @Temporal(TemporalType.DATE)
    private Date fecha;
    
    @Basic(optional = false)
    @NotNull
    @Column(name = "monto")
    private BigDecimal monto;
    
    @JoinColumn(name = "usuario_idusuario", referencedColumnName = "idusuario")
    @ManyToOne(optional = false)
    private Usuario usuario;

    public Ahorro() {
    }

    public Ahorro(Integer idahorro) {
        this.idahorro = idahorro;
    }

    public Ahorro(Integer idahorro, String categoria, Date fecha, BigDecimal monto) {
        this.idahorro = idahorro;
        this.categoria = categoria;
        this.fecha = fecha;
        this.monto = monto;
    }

    public Integer getIdahorro() {
        return idahorro;
    }

    public void setIdahorro(Integer idahorro) {
        this.idahorro = idahorro;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getSubcategoria() {
        return subcategoria;
    }

    public void setSubcategoria(String subcategoria) {
        this.subcategoria = subcategoria;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public BigDecimal getMonto() {
        return monto;
    }

    public void setMonto(BigDecimal monto) {
        this.monto = monto;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (idahorro != null ? idahorro.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof Ahorro)) {
            return false;
        }
        Ahorro other = (Ahorro) object;
        if ((this.idahorro == null && other.idahorro != null) || (this.idahorro != null && !this.idahorro.equals(other.idahorro))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "com.mycompany.marnager.model.Ahorro[ idahorro=" + idahorro + " ]";
    }
    
}
