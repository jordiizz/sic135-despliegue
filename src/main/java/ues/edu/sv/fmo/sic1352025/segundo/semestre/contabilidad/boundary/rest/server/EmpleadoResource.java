package ues.edu.sv.fmo.sic1352025.segundo.semestre.contabilidad.boundary.rest.server;

import java.util.List;

import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import ues.edu.sv.fmo.sic1352025.segundo.semestre.contabilidad.control.EmpleadoBean;
import ues.edu.sv.fmo.sic1352025.segundo.semestre.contabilidad.entity.Empleado;

@Path("empleados")
public class EmpleadoResource {

    @Inject
    EmpleadoBean empleadoBean;

    @GET
    @Produces({MediaType.APPLICATION_JSON})
    public Response findAll(){
        List<Empleado> listEmpleados = empleadoBean.findAll();
        if(listEmpleados == null){
            return Response.serverError().build();
        }
        return Response.ok(listEmpleados).build();
    }
}
