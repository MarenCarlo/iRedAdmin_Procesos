#!/bin/bash
#
# Author: Mario Carbajal.
# Fecha: 5/09/2025
# Propósito: Eliminar Colas de Correos Bugueadas en iRedMail DB.
#
# Uso: bash delete_mails_queue.sh correo@dominio.com
#
EMAIL="$1"
if [ -z "$EMAIL" ]; then
    echo "Usage: $0 <email-address>"
    exit 1
fi

postqueue -p | grep "$EMAIL" | awk '{print $1}' | xargs -I {} postsuper -d {}
echo "All queued mails for $EMAIL have been deleted."
~                                                      