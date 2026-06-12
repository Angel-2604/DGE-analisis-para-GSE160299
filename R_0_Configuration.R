#!/usr/bin/env Rscript
# =============================================================================
# Bulk RNA-seq differential expression from GEO: GSE160299
# GEO2R-style + publication-grade DESeq2 workflow
# Revision: namespace-safe + scales-compatible + palette-safe version; avoids dplyr masking, removed defunct label_number_si(), and prevents empty fill/color scales.
#
# Dataset default:
#   GSE160299: human plasma/serum RNA-seq, NC vs Parkinson's disease (PD)
#   Samples expected: Plasma NC1-NC4 and Plasma PD1-PD4
#
# Main outputs:
#   results/   DESeq2 tables, normalized counts, sample metadata, manifest
#   figures/   PDF + PNG plots for QC, metadata, batch effects and DE results
#
# Notes:
#   - Uses raw gene count matrix provided as GEO supplementary file.
#   - Adjusts for batch only if a usable, non-confounded batch field is detected.
#   - For GSE160299 no explicit batch column is expected, so batch assessment is QC-only.
#   - GEO2R-like plots included: volcano, MD/MA, UMAP, boxplot, density,
#     adjusted P-value histogram, q-q plot analogue, mean-variance trend,
#     gene profile plot, and Venn diagram support for multi-contrast analyses.
# =============================================================================

# ----------------------------- 0) Configuration ------------------------------
GSE_ID      <- "GSE160299"
TEST_LEVEL  <- "PD"
REF_LEVEL   <- "NC"
ALPHA       <- 0.05
LFC_CUTOFF  <- 1.0
MIN_COUNT   <- 10
MIN_SAMPLES <- 2
ADJUST_FOR_BATCH_IF_POSSIBLE <- TRUE
TOP_HEATMAP_GENES <- 50
TOP_PROFILE_GENES <- 12
SEED <- 160299

OUTDIR <- file.path(getwd(), paste0(GSE_ID, "_DESeq2_analysis"))
RAWDIR <- file.path(OUTDIR, "data_raw")
RESDIR <- file.path(OUTDIR, "results")
FIGDIR <- file.path(OUTDIR, "figures")
DIRS <- c(OUTDIR, RAWDIR, RESDIR, FIGDIR)
invisible(lapply(DIRS, dir.create, recursive = TRUE, showWarnings = FALSE))

set.seed(SEED)
options(stringsAsFactors = FALSE)