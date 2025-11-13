#!/bin/bash

#Funcion mostrar ayuda
function showHelp(){
    echo "Uso: $0 -origen <directorio_origen> -destino <directorio_destino>"
    echo "Ejemplo: $0 -origen /var/log -destino /backup_dir"
    echo "Este script genera un archivo .tar.gz con la fecha en formato YYYYMMDD."
    echo "El archivo se guarda en el directorio destino."
    exit 0
}

function validate_mount(){
    local dir="$1"
    if ! mountpoint -q "$dir"; then
        echo "Error: el directorio '$dir' no esta montado!"
        exit 1
    fi
}

if [[ "$1" == "-help" ]]; then
    showHelp
elif [[ "$1" == "-orgien" ]]; then
    origen = "$2"
    shift 2
    echo "$1"
    if [[ "$2" == "-destino" ]]; then
        destino = "$2"
	shift 2
        echo "$2"
    else
        echo "Argumento -destino obligatorio!"
    fi
else
    echo "Argumento desconocido"
    showHelp
fi

#Validar directorios
validate_mount "$origen"
validate_mount "$destino"

#Nonbre base archivo y fecha
base_name=$(basename "$origen")
fecha=$(date +%Y%m%d)
archivo="${base_name}_bkp_${fecha}.tar.gz"

#Ejecutar backup
echo "Generando backup de '$origen' en '$destino/$archivo'..."
tar -cpvzf "$destino/$archivo" -c "$(dirname "$origen") $base_name"

#confirmacion
if [[ $? -eq 0 ]]; then #chequeamos el valor de ejecucion del comando anterior, si es 0 es satisfactorio.
    echo "El backup se realizo con exito: $destino/$archivo"
else
    echo "Error al generar el backup."
    exit 1
fi
