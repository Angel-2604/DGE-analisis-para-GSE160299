# Pipeline de Expresión Diferencial Bulk RNA-Seq: GSE160299

Este repositorio contiene un flujo de trabajo computacional robusto y modularizado en R para el análisis de expresión diferencial de datos de secuenciación de ARN masivo (Bulk RNA-Seq), tomando como base el dataset público **GSE160299** de NCBI Gene Expression Omnibus.

El pipeline replica el estilo de análisis visual de GEO2R pero implementa el rigor estadístico de grado de publicación utilizando **DESeq2**. Modela la variación biológica entre muestras control de tipo Normal (NC) frente a la condición de la Enfermedad de Parkinson (PD) en muestras de plasma/suero humano.

## 🚀 Estructura del Repositorio

El script original ha sido dividido en módulos secuenciales para facilitar el control de calidad, la depuración paso a paso y la reproducibilidad de la bioinformática:

```text
├── run_all.R                            # Script maestro para ejecutar secuencialmente todo el pipeline
├── 0_Configuration.R                     # Variables de diseño globales (GSE_ID, ALPHA, LFC_CUTOFF, etc.)
├── 1_Packages.R                          # Carga y gestión automatizada de dependencias de CRAN y Bioconductor
├── 2_Plot_helpers.R                      # Funciones auxiliares para estandarización gráfica y exportación de PDFs/PNGs
├── 3_GEO_download.R                      # Descarga automatizada y conexión con GEOquery para la matriz de conteos
├── 4_Metadata_parsing.R                  # Parseo y limpieza de metadatos clínicos asociados al dataset
├── 5_Count_matrix_parsing.R              # Formateo y reestructuración de la matriz de expresión génica
├── 6_Metadata_and_library_QC.R           # Gráficos de distribución (Boxplots, densidad) y control de tamaño de librerías
├── 7_DESeq2_model.R                      # Inicialización del objeto DESeqDataSet, filtrado bajo y modelado lineal
├── 8_GEO2R_like_QC_plots.R               # Gráficos de diagnóstico (Histograma de P-valores, Q-Q plots, tendencias)
├── 9_Differential_expression.R           # Umbrales estadísticos, tablas finales de DEGs, Volcano y MA plots
├── 10_Heatmaps_and_gene_profiles.R       # Mapa de calor de genes con pheatmap (Z-score VST) y perfiles individuales
└── 11_Run_manifest_and_session_info.R    # Generación de manifiesto, resumen de la corrida e información de sesión (sessionInfo)
```

## 🛠️ Requisitos de Instalación

El entorno requiere R (versión ≥ 4.0) y los managers de paquetes estándar de bioinformática. Las dependencias principales se instalarán automáticamente al correr el pipeline:

- **Bioconductor**: `DESeq2`, `GEOquery`, `limma`, `edgeR`, `BiocManager`.
- **CRAN / Tidyverse**: `tidyverse` (`dplyr`, `ggplot2`, `tidyr`, `readr`, `tibble`), `pheatmap`, `umap`.

## 💻 Instrucciones de Uso

1. Clona este repositorio o descarga los archivos en una carpeta local.
2. Abre RStudio y establece el directorio de trabajo en la ruta donde se encuentran los scripts.
3. Ejecuta el script maestro **`run_all.R`**:

```R
source("run_all.R")
```

El script maestro llamará de manera ordenada a cada archivo, compartiendo el espacio de nombres global y controlando fallos intermedios mediante bloques estructurados de captura de errores (`tryCatch`).

## 📊 Salidas del Pipeline

Una vez finalizada la ejecución completa, el pipeline creará automáticamente dos directorios raíz en tu espacio de trabajo local:
- `results/`: Contiene el manifiesto de salida (`output_manifest.csv`), matrices de conteos normalizados por tamaño de librería, tablas completas de genes significativos evaluados y el resumen estadístico global (`run_summary.csv`).
- `figures/`: Almacena todos los gráficos de diagnóstico y publicación generados (gráficos PCA, distribuciones, volcano plots, perfiles génicos y heatmaps) exportados simultáneamente en formatos vectoriales de alta fidelidad (`.pdf`) y mapas de bits de alta resolución (`.png`).
