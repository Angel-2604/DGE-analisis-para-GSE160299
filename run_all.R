#!/usr/bin/env Rscript
# =============================================================================
# Script Maestro: Ejecución Automática del Pipeline GSE160299
# =============================================================================

# Configura automáticamente el directorio de trabajo donde está guardado este archivo
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

cat("=========================================================\n")
cat("Iniciando el pipeline de análisis para GSE160299\n")
cat("Directorio de trabajo:", getwd(), "\n")
cat("=========================================================\n\n")

# Lista ordenada de los módulos a ejecutar
modulos <- c(
  "0_Configuration.R",
  "1_Packages.R",
  "2_Plot_helpers.R",
  "3_GEO_download.R",
  "4_Metadata_parsing.R",
  "5_Count_matrix_parsing.R",
  "6_Metadata_and_library_QC.R",
  "7_DESeq2_model.R",
  "8_GEO2R_like_QC_plots.R",
  "9_Differential_expression.R",
  "10_Heatmaps_and_gene_profiles.R",
  "11_Run_manifest_and_session_info.R"
)

# Bucle para correr cada script uno por uno
for (script in modulos) {
  if (file.exists(script)) {
    cat("---------------------------------------------------------\n")
    cat("Ejecutando:", script, "\n")
    cat("---------------------------------------------------------\n")
    
    # Ejecuta el script en el entorno global compartido
    tryCatch({
      source(script, local = FALSE)
      cat("Finalizado con éxito:", script, "\n\n")
    }, error = function(e) {
      cat("¡ERROR CRÍTICO en el script:", script, "!\n")
      cat("Mensaje de error:", e$message, "\n")
      stop("El pipeline se detuvo debido a un error en el módulo anterior.")
    })
    
  } else {
    stop(paste("Error: No se encontró el archivo", script, 
               "\nAsegúrate de guardar este script maestro en la misma carpeta."))
  }
}

cat("=========================================================\n")
cat("¡Pipeline completado con éxito de punta a punta!\n")
cat("Revisa las carpetas 'results/' y 'figures/' generadas.\n")
cat("=========================================================\n")