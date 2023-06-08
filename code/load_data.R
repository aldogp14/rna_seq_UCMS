# importar libreria
library("recount3")

# cambiar al url
options(recount3_url = "https://recount-opendata.s3.amazonaws.com/recount3/release")

# cargar el id del estudio, SRP181622	
proj_info <- subset(
  available_projects(organism = 'mouse'),
  project == "SRP181622" & project_type == "data_sources"
)

# Se crea el rse
rse_gene_SRP181622 = create_rse(proj_info)

# convertir las cuentas de nucleotido a cuentas por lectura
assay(rse_gene_SRP181622, "counts") <- compute_read_counts(rse_gene_SRP181622)

# guardar el objeto
save(rse_gene_SRP181622, file = 'data/rse_gene_SRP181622.RData')

