#!/bin/bash



CONFIG_FILE="$HOME/.monitor_config.conf"




# 1. Defino la ruta que quiero monitorizar directamente aquí en el código
recurso_nuevo="/PRUEBA_FIM30"




# 2. Si el archivo de configuración ya existe, lo cargo
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi




# 3. Compruebo si el archivo de configuración NO existe O si he cambiado de ruta en el código
if [ ! -f "$CONFIG_FILE" ] || [ "$recurso_monitorizar" != "$recurso_nuevo" ]; then
    echo "Detectado cambio de archivo o primera ejecución. Reconfigurando..."
    
    recurso_monitorizar="$recurso_nuevo"
    
    if ls -ls "$recurso_monitorizar" >/dev/null 2>&1; then
        hash_referencia=$(sha256sum "$recurso_monitorizar" | awk '{print $1}')
    else
        echo "Error: No se encuentra el archivo $recurso_monitorizar."
        exit 1
    fi 
    
    correo_electronico_emisor="INTRODUCE_TU_CORREO_EMISOR"
    contrasena_aplicacion="INTRODUCE_CONTRASENA_APLICACION_EMISOR"
    correo_electronico_destinatario="INTRODUCE_TU_CORREO_RECEPTOR"
    
    # Guardo los datos iniciales en el archivo de configuración
    echo "recurso_monitorizar=\"$recurso_monitorizar\"" > "$CONFIG_FILE"
    echo "hash_referencia=\"$hash_referencia\"" >> "$CONFIG_FILE"
    echo "correo_electronico_emisor=\"$correo_electronico_emisor\"" >> "$CONFIG_FILE"
    echo "contrasena_aplicacion=\"$contrasena_aplicacion\"" >> "$CONFIG_FILE"
    echo "correo_electronico_destinatario=\"$correo_electronico_destinatario\"" >> "$CONFIG_FILE"
    
    echo "Configuración actualizada correctamente para: $recurso_monitorizar"
else
    echo "Cargando configuración previa..."
fi




# 4.Compruebo la integridad del archivo actual contra la referencia guardada
hash_actual="$(sha256sum "$recurso_monitorizar" | awk '{print $1}')"

echo "Archivo monitorizado:       $recurso_monitorizar"
echo "Hash de referencia guardado: $hash_referencia"
echo "Hash actual del archivo:    $hash_actual"

if [ "$hash_referencia" != "$hash_actual" ]; then 
    echo "¡ALERTA! El hash del archivo ha cambiado. Enviando correo..."
    
    # Envío el correo de alerta
    curl --url 'smtps://smtp.gmail.com:465' \
    --ssl-reqd \
    --mail-from "$correo_electronico_emisor" \
    --mail-rcpt "$correo_electronico_destinatario" \
    --user "$correo_electronico_emisor:$contrasena_aplicacion" \
    --upload-file <(echo -e "Subject: ALERTA: Cambio detectado en archivo critico\r\n\r\nEl archivo $recurso_monitorizar ha sido modificado.") >/dev/null 2>&1

    # AUTOUPDATE: Actualizo el hash de referencia en el archivo de configuración para no enviar más alertas en la próxima ejecución
    hash_referencia="$hash_actual"
    echo "recurso_monitorizar=\"$recurso_monitorizar\"" > "$CONFIG_FILE"
    echo "hash_referencia=\"$hash_referencia\"" >> "$CONFIG_FILE"
    echo "correo_electronico_emisor=\"$correo_electronico_emisor\"" >> "$CONFIG_FILE"
    echo "contrasena_aplicacion=\"$contrasena_aplicacion\"" >> "$CONFIG_FILE"
    echo "correo_electronico_destinatario=\"$correo_electronico_destinatario\"" >> "$CONFIG_FILE"
    
    echo "Línea base actualizada automáticamente con el nuevo hash."
else
    echo "El archivo está íntegro. Todo en orden."
fi
