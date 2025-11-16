package com.mycompany.marnager.ejb;

import com.mycompany.marnager.model.Ingreso;
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
public class IngresoFacade extends AbstractFacade<Ingreso> {

    @PersistenceContext(unitName = "com.mycompany_marnager_war_1.0-SNAPSHOTPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public IngresoFacade() {
        super(Ingreso.class);
    }
    
    public List<Ingreso> findByUser(Usuario usuario) {
        TypedQuery<Ingreso> query = em.createQuery("SELECT i FROM Ingreso i WHERE i.usuario = :usuario", Ingreso.class);
        query.setParameter("usuario", usuario);
        return query.getResultList();
    }
}
