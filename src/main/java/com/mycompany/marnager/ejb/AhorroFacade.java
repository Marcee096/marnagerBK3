package com.mycompany.marnager.ejb;

import com.mycompany.marnager.model.Ahorro;
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
public class AhorroFacade extends AbstractFacade<Ahorro> {

    @PersistenceContext(unitName = "com.mycompany_marnager_war_1.0-SNAPSHOTPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public AhorroFacade() {
        super(Ahorro.class);
    }
    
    public List<Ahorro> findByUser(Usuario usuario) {
        TypedQuery<Ahorro> query = em.createQuery("SELECT a FROM Ahorro a WHERE a.usuario = :usuario", Ahorro.class);
        query.setParameter("usuario", usuario);
        return query.getResultList();
    }
    
    public List<Ahorro> findByUserAndMonth(Usuario usuario, int year, int month) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(year, month - 1, 1, 0, 0, 0);
        Date startDate = calendar.getTime();

        calendar.add(Calendar.MONTH, 1);
        calendar.add(Calendar.DAY_OF_MONTH, -1);
        calendar.set(Calendar.HOUR_OF_DAY, 23);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        Date endDate = calendar.getTime();

        TypedQuery<Ahorro> query = em.createQuery(
            "SELECT a FROM Ahorro a WHERE a.usuario = :usuario AND a.fecha BETWEEN :startDate AND :endDate", Ahorro.class);
        query.setParameter("usuario", usuario);
        query.setParameter("startDate", startDate);
        query.setParameter("endDate", endDate);
        return query.getResultList();
    }
}
