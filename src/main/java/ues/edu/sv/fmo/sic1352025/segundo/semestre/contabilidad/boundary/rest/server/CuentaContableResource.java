package ues.edu.sv.fmo.sic1352025.segundo.semestre.contabilidad.boundary.rest.server;

import jakarta.inject.Inject;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.UriBuilder;
import jakarta.ws.rs.core.UriInfo;

import java.io.Serializable;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.List;
import java.util.UUID;
import ues.edu.sv.fmo.sic1352025.segundo.semestre.contabilidad.control.CuentaContableBean;
import ues.edu.sv.fmo.sic1352025.segundo.semestre.contabilidad.entity.CuentaContable;

/**
 *
 * @author jordi
 */
@Path("cuentas-contables")
public class CuentaContableResource implements Serializable{
    
    @Inject
    CuentaContableBean cuentaContableBean;
    
    @GET
    @Produces({MediaType.APPLICATION_JSON})
    public Response findAll(){
        List<CuentaContable> listCuentasContables = cuentaContableBean.findAll();
        if(listCuentasContables == null){
            return Response.serverError().build();
        }
        return Response.ok(listCuentasContables).build();
    }
    

    @POST
    @Consumes({MediaType.APPLICATION_JSON})
    @Produces({MediaType.APPLICATION_JSON})
    public Response crearCuentaContable (CuentaContable cuentaContable, @Context UriInfo uriInfo){
        try {
            UUID idCuentaContable = UUID.randomUUID();                             
            cuentaContable.setIdCuentaContable(idCuentaContable);
            cuentaContableBean.persistEntity(cuentaContable);
            UriBuilder uriBuilder = uriInfo.getAbsolutePathBuilder().path(idCuentaContable.toString());
            return Response.created(uriBuilder.build()).build();

        } catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, e.getMessage(), e);
            return Response.serverError().build();
        }
    }
}
