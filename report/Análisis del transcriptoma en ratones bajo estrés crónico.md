# Análisis del transcriptoma en ratones bajo estrés crónico

###### Aldo García Prado

### Resumen

En este proyecto se hace el análisis de expresión diferencial utilizando datos de un proyecto utilizando el transcriptoma de células del cerebro y de sangre de ratón a través de . En el proyecto original se cuantificaron variables de sueño, físicas, endocrinas y conductuales, así como el transcriptoma cerebral y sanguíneo en ratones expuestos a 9 semanas de estrés crónico leve impredecible (UCMS, por sus siglas en inglés).

### Objetivo

Obtener genes diferencialmente expresados en ratón bajo estrés crónico leve impredecible.

### Justificación

El estrés crónico es una experiencia común en la vida diaria y se ha demostrado que puede tener efectos negativos en la salud física y mental. Sin embargo, los detalles precisos de cómo el estrés crónico afecta la expresión génica y los procesos moleculares en el organismo no están completamente comprendidos. Mediante el análisis de genes diferencialmente expresados en ratones expuestos a estrés crónico leve impredecible, este proyecto busca identificar cambios moleculares y genéticos asociados con esta condición. 

### Análisis de expresión diferencial

El análisis se llevó a cabo utilizando distintos paquetes de Bioconductor. 

Se utilizaron datos obtenidos a través de recount3 con el identifricador SRP181622, con los cuales se generó un objeto RSE para comenzar con el análisis exploratorio de los datos. Al finalizar el análisis exploratorio se eliminaron ciertas lecturas que no cumplían con los niveles de expresión mayores a 0.1. Los datos fueron normalizados para generar un modelo estadístico adecuado con los atributos de interés. Finalmente se realizó el análisis de expresión diferencial utilizando el paquete limma. 

### Resultados

##### Exploración

En la exploración se vieron los atributos del objeto, esto fue necesario para determinar cuáles se usarían para el análisis: condición y tejido.

##### Parámetros de calidad

La proporción de lecturas asignadas a genes iba desde 0.37 hasta 0.74. En lo que se refiere a este parámetro, la calidad era baja, por lo que se hizo un ajuste de las lecturas mayores a 0.7 de proporción. Este parámetro se obtuvo mediante la relación del atributo con las cuentas totales asignadas a genes y el atributo con las cuentas totales.             

<img src="C:\Users\Aldo Garcia Prado\Desktop\ciencias_genomicas\semestre_4\rna_seq\plots\hist.png" alt="hist" style="zoom:75%;" />

Además, se eliminaron aquellas lecturas con un nivel de expresión menor a 0.1. Al final se retuvo el 57.23% de las lecturas. La siguiente tabla muestra el summary de los niveles de expresión.

| Min. | 1st Qu. | Median | Mean  | 3rd Qu. | Max.     |
| ---- | ------- | ------ | ----- | ------- | -------- |
| 0.0  | 0.0     | 0.3    | 105.4 | 14.3    | 928284.9 |

##### Análisis de expresión diferencial

Una vez hecha la limpieza se estableció el modelo estadístico para la comparación de datos. Se utilizó el diagnóstico de Voom-Limma para evaluar la relación entre la media y varianza de los datos de expresión génica. En general, los datos si se distribuyen alrededor de la línea esperada. No obstante, existe una desviación que indica una baja calidad de los datos.

<img src="C:\Users\Aldo Garcia Prado\Desktop\ciencias_genomicas\semestre_4\rna_seq\plots\Rplot.png" alt="Rplot" style="zoom:75%;" />

En el análisis de expresión diferencial se seleccionaron aquellos genes con un valor P ajustado inferior a 0.05. Para visualizar genes con una expresión diferenciada se realizaron gráfiicas de MA y de volcán, en los que se aprecia que hay genes con logFC altos y p valores bajos. Lo anterior indica la existencia de lecturas diferencialmente expresadas.

<img src="C:\Users\Aldo Garcia Prado\Desktop\ciencias_genomicas\semestre_4\rna_seq\plots\MA.png" alt="MA" style="zoom:75%;" /><img src="C:\Users\Aldo Garcia Prado\Desktop\ciencias_genomicas\semestre_4\rna_seq\plots\volcano.png" alt="volcano" style="zoom:75%;" />

Para el mapa de calor, se utilizaron los 50 genes con una mayor expresión diferenciada. Además se clasificó por tejido y por grupo. Realmente no parece haber una relación en cuanto a grupo (control y UCMS) y genes expresados. Por otro lado, si se ve una tendencia de expresión en los tejidos, sobre todo si se generaliza a tejidos del cerebro contra sangre. Esto es algo bastante esperado, pues el cerebro está relacionado con el control del sueño. 

<img src="C:\Users\Aldo Garcia Prado\Desktop\ciencias_genomicas\semestre_4\rna_seq\plots\heatmap.png" alt="heatmap" style="zoom:75%;" />

### Conclusiones

Los resultados obtenidos con el presente análisis no resalta genes diferencialmente expresados bajo la condición de interés. Los resultados sugieren que la expresión génica no muestra una clara relación con los grupos de control y UCMS. Sin embargo, se observa una tendencia en la expresión génica entre los tejidos, especialmente entre los tejidos cerebrales y la sangre. Esta observación es consistente con la idea de que el cerebro desempeña un papel importante en el control del sueño.

El estudio no menciona cuantos replicas se utilizaron, puede suceder que el número no sea lo suficientemente grande para arrojar resultados robustos. Si fuera el caso, propongo aumentar el número de réplicas dado la relevancia que puede tener el estudio.