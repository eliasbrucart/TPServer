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

while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -origen)
                origen="$2"
                shift 2
                #echo "Error: Falta el valor para -origen"
                #showHelp
            #fi
            ;;
        -destino)
            #if [[ -n "$2" && "$2" != -* ]]; then
                destino="$2"
                shift 2
            #else
               # echo "Error: Falta el valor para -destino"
               # showHelp
            #fi
            ;;
        -help)
            showHelp
            ;;
        *)
            echo "Argumento desconocido: $1"
            showHelp
            ;;
    esac
done


#Validar directorios
#validate_mount "$origen"
validate_mount "$destino"

#Nonbre base archivo y fecha
base_name=$(basename "$origen")
fecha=$(date +%Y%m%d)
archivo="${base_name}_bkp_${fecha}.tar.gz"

#Ejecutar backup
echo "Generando backup de '$origen' en '$destino/$archivo'..."

/bin/tar -cpvzf "$destino/$archivo" -C "$(dirname "$origen")" "$(basename "$origen")"

#confirmacion
if [[ $? -eq 0 ]]; then #chequeamos el valor de ejecucion del comando anterior (tar), si es 0 es satisfactorio.
    echo "El backup se realizo con exito: $destino/$archivo"
else
    echo "Error al generar el backup."
    exit 1
fi
