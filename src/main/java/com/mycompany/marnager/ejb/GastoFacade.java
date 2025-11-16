package com.mycompany.marnager.ejb;

import com.mycompany.marnager.model.Gasto;
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
}
