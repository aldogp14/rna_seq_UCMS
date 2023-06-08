# Se cargan los paquetes
library("edgeR")
library("ggplot2")
library("limma")
library("pheatmap")

#Se crea el objeto RSE y se expanden sus atributos
rse_gene_SRP181622 <- expand_sra_attributes(rse_gene_SRP181622)

colData(rse_gene_SRP181622)[
  ,
  grepl("^sra_attribute", colnames(colData(rse_gene_SRP181622)))
]

# Se revisa que los atributos de interes tengan el formato adecuado
rse_gene_SRP181622$sra_attribute.tissue <- factor(tolower((rse_gene_SRP181622$sra_attribute.tissue)))
rse_gene_SRP181622$sra_attribute.group <- factor(tolower((rse_gene_SRP181622$sra_attribute.group)))

# Se revisa la calidad de las lecturas
rse_gene_SRP181622$assigned_gene_prop <- rse_gene_SRP181622$recount_qc.gene_fc_count_all.assigned/rse_gene_SRP181622$recount_qc.gene_fc_count_all.total

# Se revisan los datos mediante un histograma
hist(rse_gene_SRP181622$assigned_gene_prop, xlab = "Assigned gene proportion", main = 'Assigned gene proportion', col = 'lightblue')


summary(as.data.frame(colData(rse_gene_SRP181622)[
  ,
  grepl("^sra_attribute.[group|tissue]", colnames(colData(rse_gene_SRP181622)))
]))

summary(rse_gene_SRP181622$assigned_gene_prop)
## Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
## 0.3631  0.3788  0.6853  0.5936  0.7144  0.7454

# Obtener los niveles promedio de expresion
promedios_genes <- rowMeans(assay(rse_gene_SRP181622, "counts"))
summary(promedios_genes)
## Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
## 0.0      0.0      0.3    105.4     14.3 928284.9

# Eliminar los genes con bajos niveles de expresion
rse_gene_SRP181622_completo <- rse_gene_SRP181622
rse_gene_SRP181622 <- rse_gene_SRP181622[promedios_genes > 0.1, ]

# Se comprueba el procentaje de genes que se conservaron
round(nrow(rse_gene_SRP181622) / nrow(rse_gene_SRP181622_completo) * 100, 2)
## 57.23

#Normalizar los datos
DGE <- DGEList(
  counts = assay(rse_gene_SRP181622, "counts"),
  genes = rowData(rse_gene_SRP181622)
)

DGE <- calcNormFactors(DGE)

# Observamos la distribucio de la expresion por cada condicion de crecimiento
ggplot(as.data.frame(colData(rse_gene_SRP181622)), aes(y = assigned_gene_prop, x = sra_attribute.group)) +
  geom_boxplot() +
  theme_bw(base_size = 20) +
  ylab("Assigned Gene Prop") +
  xlab("Grupo")

# Generamos el modelo estadistico
mod <- model.matrix(~sra_attribute.group + assigned_gene_prop,
                    data = colData(rse_gene_SRP181622))

colnames(mod)
## "(Intercept)"             "sra_attribute.groupucms" "assigned_gene_prop"


vGenes <- voom(DGE, mod, plot = T)

eb_results <- eBayes(lmFit(vGenes))

de_results <- topTable(
  eb_results,
  coef = 2,
  number = nrow(rse_gene_SRP181622),
  sort.by = "p"
)


head(de_results)
dim(de_results)
## 31718    17

#Los genes no diferencialmente expresados cuantificados en FALSE
table(de_results$adj.P.Val<0.05)
## FALSE  TRUE 
## 29948  1770


plotMA(eb_results, coef = 2)
volcanoplot(eb_results, coef = 2, highlight = 3, names = de_results$gene_name)

# Obtener los 50 primeros genes
exprs_heatmap <- vGenes$E[rank(de_results$adj.P.Val) <= 50,]

rownames(exprs_heatmap) <- de_results[row.names(exprs_heatmap),"gene_name"]


df <- as.data.frame(colData(rse_gene_SRP181622)[, c("sra_attribute.group", "sra_attribute.tissue")])
colData(rse_gene_SRP181622)[, "sra_attribute.group", "sra_attribute.tissue"]


colnames(df) <- c("group", "tissue")

# Generar heatmap
pheatmap(
  exprs_heatmap,
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  show_rownames = FALSE,
  show_colnames = FALSE,
  annotation_col = df
)

