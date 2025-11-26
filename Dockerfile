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
# 2. Imagen final con Open Liberty (desde Docker Hub, compatible con Render)
# ---------------------------------------------------------
FROM openliberty/open-liberty:kernel-slim-java21-openj9



ENV SERVER_NAME=sic135_contabilidad
ENV WLP_INSTALL_DIR=/opt/ol/wlp
ENV APP_DIR=${WLP_INSTALL_DIR}/usr/servers/${SERVER_NAME}

# Crear carpeta del servidor
RUN mkdir -p ${APP_DIR}/dropins
RUN mkdir -p ${APP_DIR}/lib

# Copiar configuración
COPY src/main/liberty/config/server.xml ${APP_DIR}/server.xml

# Copiar JDBC driver
COPY liberty/drivers/postgresql-42.7.4.jar ${APP_DIR}/lib/postgresql-42.7.4.jar

# Copiar WAR generado
COPY --from=builder /app/target/*.war ${APP_DIR}/dropins/app.war

EXPOSE 9080
EXPOSE 9443

CMD ["/opt/ol/wlp/bin/server", "run", "sic135_contabilidad"]
