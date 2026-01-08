# Descripción de Repositorio
Este repositorio contiene scripts útiles para la simplificacion de tareas frecuentes en el entorno de servicios de Correo de iRedAdmin.

# Scripts iRedAdmin

## Agregar Mail a Listado
- **Script:** `add_email_to_list.sh`
- **Uso:** `bash add_email_to_list.sh lista.correo@dominio.com usuario@dominio.com`
- **Descripción:** Nos sirve para agregar correos a listados de reenvio de correos EJ: `listado@dominio.com` reenvia a `usuario@dominio.com` y todos los correos de `listado@dominio.com` serian reenviados a todos los usuarios que esten agregados a ese listado.

## Eliminar Cola de Correos
- **Script:** `delete_mails_queue.sh`
- **Uso:** `bash delete_mails_queue.sh usuario@dominio.com`
- **Descripción:** Nos sirve para eliminar colas de correos problematicas, EJ: Correos que ocupen todo el ancho de banda del servidor.