# ---------------------------------------------------------
# 1. Imagen base con Maven + JDK 21 para compilar el backend
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
FROM icr.io/appcafe/open-liberty:full-java21-openj9-ubi

ENV SERVER_NAME=sic135_contabilidad
ENV WLP_INSTALL_DIR=/opt/ol/wlp
ENV APP_DIR=${WLP_INSTALL_DIR}/usr/servers/${SERVER_NAME}

# Crear carpeta de drivers
RUN mkdir -p ${APP_DIR}/drivers

# Copiar driver de PostgreSQL
COPY liberty/drivers/postgresql-42.7.4.jar ${APP_DIR}/drivers/

# Copiar configuración del servidor
COPY src/main/liberty/config/server.xml ${APP_DIR}/server.xml

# Copiar la aplicación
COPY --from=builder /app/target/*.war ${APP_DIR}/dropins/app.war

EXPOSE 9080
EXPOSE 9443

CMD ["/opt/ol/wlp/bin/server", "run", "sic135_contabilidad"]
