Pasos para ejecutar y usar esta herramienta:


1. Clona o descarga el repositorio en tu máquina ejecutando este comando:

```
git clone https://github.com/Doral-Ciberseguridad/FIM-Monitorizacion-Archivos-Bash.git
```



2. Instala las dependencias necesarias:

```
sudo apt update && sudo apt install curl coreutils
```



3. Edita el código del archivo y escribe la ruta del archivo que quieres monitorizar

```
nano 4.FIM_Montitorizacion_archivos.sh
```

<img width="645" height="236" alt="image" src="https://github.com/user-attachments/assets/c2aed73c-b4bb-41a0-9844-718be435dc9b" />


También debes de configurar estas variables para configurar el envio de alerta por correo electronico:

correo_electronico_emisor

contrasena_aplicacion

correo_electronico_destinatario



4. Dale permisos de ejecución y lanza el script ejecutando en tu terminal:

```
chmod +x FIM_Montitorizacion_archivos.sh
```

```
./FIM_Montitorizacion_archivos.sh
```

La primera vez que ejecutes el script, el programa guardara el hash del archivo que quieres monitorizar:

<img width="1058" height="137" alt="image" src="https://github.com/user-attachments/assets/e8b5e0e5-ac90-49cc-aac5-034422d5dd4c" />





5. Para que el script se ejecute en segundo plano de manera silenciosa debes de añadir esta tarea cron al final del archivo /etc/crontab:

```
* * * * * root /ruta/absoluta/a/FIM_Montitorizacion_archivos.sh >/dev/null 2>&1
```



6.Cada vez que el archivo sea modificado recibirás una alerta a tu correo electronico (Recuerda configurar bien las variables del archivo).
