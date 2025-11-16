package com.mycompany.marnager.ejb;

import com.mycompany.marnager.model.Ahorro;
import com.mycompany.marnager.model.Usuario;
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
}
