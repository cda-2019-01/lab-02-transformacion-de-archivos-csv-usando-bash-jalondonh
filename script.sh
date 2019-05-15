##codigo estaciones
cd estaciones

##lectura y concatenado de los archivos
csvstack -g Estacion-1,Estacion-2,Estacion-3,Estacion-4 -n "ESTACION" estacion1.csv estacion2.csv estacion3.csv estacion4.csv > estaciones.csv

##limpieza del archivo para quedar en formato correcto para csvkit
awk '{sub(/\,/,"\;");sub(/\,/,"\.");gsub(/\;/,"\,");print}' estaciones.csv > out.csv
##archivos listos para los 3 puntos
csvcut -c ESTACION,FECHA,VEL out.csv > out1y2.csv
csvcut -c ESTACION,HHMMSS,VEL out.csv > out3.csv

##base para velocidad por mes
awk '{print gensub(/([0-9]+)\/([0-9]+)\/([0-9]+)/,"\\2",1)}' out1y2.csv > punto1.csv

##base para velocidad por año
awk '{print gensub(/([0-9]+)\/([0-9]+)\/([0-9]+)/,"\\3",1)}' out1y2.csv > punto2.csv

##base para velocidad por hora
awk '{print gensub(/([0-9]+)\:([0-9]+)\:([0-9]+)/,"\\1",1)}' out3.csv > punto3.csv

##velocidad-por-mes.csv
csvsql --query "select ESTACION,FECHA AS MES,AVG(VEL) AS VELOCIDAD_PROMEDIO from 'punto1' group by ESTACION,MES" punto1.csv > velocidad-por-mes.csv

##velocidad-por-ano.csv
csvsql --query "select ESTACION,FECHA AS ANIO,AVG(VEL) AS VELOCIDAD_PROMEDIO from 'punto2' group by ESTACION,ANIO" punto2.csv > velocidad-por-ano.csv

##velocidad-por-hora.csv
csvsql --query "select ESTACION,HHMMSS AS HORA,AVG(VEL) AS VELOCIDAD_PROMEDIO from 'punto3' group by ESTACION,HORA" punto3.csv > velocidad-por-hora.csv

##se remueven archivos temporales
rm estaciones* out* punto*
