#!/bin/bash
#
# Author: Mario Carbajal.
# Fecha: 5/09/2025
# Propósito: Crear listado de reenvío de correos desde un listado virtual a una direccion de mail en iRedMail DB.
#
# Uso: bash add_email_to_list.sh lista.correo@dominio.com usuario@dominio.com
#
#!/bin/bash
# Configuración de conexión a MySQL
DB_USER="root"
DB_NAME="vmail"

# Leer parámetros
address="$1"
forwardToEmail="$2"


# Modulo Help
if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "/h" ] || [ $# -ne 2 ]; then
    echo "Uso: bash $0 lista.correo@dominio.com usuario@dominio.com"
    exit 0
fi

# Extraer dominios
addressDomain=$(echo "$address" | cut -d'@' -f2)
forwardToEmailDomain=$(echo "$forwardToEmail" | cut -d'@' -f2)

# Buscar si ya existen reenvíos hacia ese correo
existing_count=$(mysql -N -u"$DB_USER" "$DB_NAME" -e "
SELECT COUNT(*) FROM forwardings WHERE forwarding = '$forwardToEmail' AND is_list = 1;
")

if [ "$existing_count" -gt 0 ]; then
    echo "Ya existen $existing_count reenvíos para la dirección: $forwardToEmail"
    echo "------------------------------------------------------------"
    mysql -u"$DB_USER" "$DB_NAME" -e "
    SELECT id as id, address as lista, forwarding as usuario FROM forwardings WHERE forwarding = '$forwardToEmail' AND is_list = 1;
    "
    echo "------------------------------------------------------------"
    read -p "¿Deseas agregar este nuevo reenvío de todos modos? (s/n): " respuesta

    if [[ ! "$respuesta" =~ ^[Ss]$ ]]; then
        echo "Operación cancelada por el usuario."
        exit 0
    fi
fi

# Verificar si ya existe ese mismo forwarding exacto
duplicate_check=$(mysql -N -u"$DB_USER" "$DB_NAME" -e "
SELECT COUNT(*) FROM forwardings 
WHERE address = '$address' AND forwarding = '$forwardToEmail';
")

if [ "$duplicate_check" -gt 0 ]; then
    echo "Ese reenvío exacto $address -> $forwardToEmail ya existe. No se agregó duplicado."
    exit 0
fi

# Insertar el nuevo registro
mysql -u"$DB_USER" "$DB_NAME" -e "
INSERT INTO forwardings (address, forwarding, domain, dest_domain, is_maillist, is_list, is_forwarding, is_alias, active)
VALUES ('$address', '$forwardToEmail', '$addressDomain', '$forwardToEmailDomain',0,1,0,0,1);
"

if [ $? -eq 0 ]; then
    echo "Reenvío agregado: $address -> $forwardToEmail"
    exit 0
else
    echo "Error al insertar: $address -> $forwardToEmail"
    exit 1
fi
