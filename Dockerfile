# ---------------------------------------------------------
# 1. Imagen base con Maven + JDK 17 para compilar el backend
# ---------------------------------------------------------
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn -q dependency:go-offline

COPY src/ ./src/

RUN mvn -q clean package -DskipTests


# ---------------------------------------------------------
# 2. Imagen final con Open Liberty
# ---------------------------------------------------------
# CAMBIO AQUÍ: Usamos la versión UBI que sí existe
FROM icr.io/appcafe/open-liberty:full-java21-openj9-ubi-minimal


ENV SERVER_NAME=sic135_contabilidad
# Nota: En las imagenes UBI modernas, a veces la ruta base cambia,
# pero /opt/ol/wlp suele ser un symlink valido.
ENV WLP_INSTALL_DIR=/opt/ol/wlp
ENV APP_DIR=${WLP_INSTALL_DIR}/usr/servers/${SERVER_NAME}

# Crear carpeta del servidor (USER root es necesario a veces para mkdir en UBI, 
# pero probemos sin cambiar usuario primero para no romper permisos)
USER root
RUN mkdir -p ${APP_DIR}/dropins
RUN mkdir -p ${APP_DIR}/lib
# Volvemos al usuario default de Open Liberty por seguridad
USER 1001

# Copiar configuración
COPY src/main/liberty/config/server.xml ${APP_DIR}/server.xml

# Copiar JDBC driver
COPY liberty/drivers/postgresql-42.7.4.jar ${APP_DIR}/lib/postgresql-42.7.4.jar

# Copiar WAR generado
COPY --from=builder /app/target/*.war ${APP_DIR}/dropins/app.war

EXPOSE 9080
EXPOSE 9443

CMD ["/opt/ol/wlp/bin/server", "run", "sic135_contabilidad"]