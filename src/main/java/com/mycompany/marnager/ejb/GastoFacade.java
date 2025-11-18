package com.mycompany.marnager.ejb;

import com.mycompany.marnager.model.Gasto;
import com.mycompany.marnager.model.Usuario;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;

/**
 *
 * @author marce
 */
@Stateless
public class GastoFacade extends AbstractFacade<Gasto> {

    @PersistenceContext(unitName = "com.mycompany_marnager_war_1.0-SNAPSHOTPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public GastoFacade() {
        super(Gasto.class);
    }
    
    public List<Gasto> findByUser(Usuario usuario) {
        TypedQuery<Gasto> query = em.createQuery("SELECT g FROM Gasto g WHERE g.usuario = :usuario", Gasto.class);
        query.setParameter("usuario", usuario);
        return query.getResultList();
    }
    
    public List<Gasto> findByUserAndMonth(Usuario usuario, int year, int month) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(year, month - 1, 1, 0, 0, 0);
        Date startDate = calendar.getTime();

        calendar.add(Calendar.MONTH, 1);
        calendar.add(Calendar.DAY_OF_MONTH, -1);
        calendar.set(Calendar.HOUR_OF_DAY, 23);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        Date endDate = calendar.getTime();

        TypedQuery<Gasto> query = em.createQuery(
            "SELECT g FROM Gasto g WHERE g.usuario = :usuario AND g.fecha BETWEEN :startDate AND :endDate", Gasto.class);
        query.setParameter("usuario", usuario);
        query.setParameter("startDate", startDate);
        query.setParameter("endDate", endDate);
        return query.getResultList();
    }
    
    public java.math.BigDecimal getSumaTotalHastaFecha(Usuario usuario, Date fecha) {
        TypedQuery<java.math.BigDecimal> query = em.createQuery(
            "SELECT COALESCE(SUM(g.monto), 0.0) FROM Gasto g WHERE g.usuario = :usuario AND g.fecha < :fecha", java.math.BigDecimal.class);
        query.setParameter("usuario", usuario);
        query.setParameter("fecha", fecha);
        return query.getSingleResult();
    }
}
