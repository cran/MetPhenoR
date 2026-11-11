## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----graphic_logo, echo = FALSE, fig.align="left", out.width='40%'------------
knitr::include_graphics("../man/figures/README-logo.png")

## ----workflow, echo = FALSE, fig.align="left", out.width='100%'---------------
knitr::include_graphics("../man/figures/MetPhenoR_workflow_flowchart.png")

## -----------------------------------------------------------------------------
library(MetPhenoR)
data("RawRead") # load example RawRead file stored in MetPhenoR

## -----------------------------------------------------------------------------
head(RawRead)

## -----------------------------------------------------------------------------
data("PlateInfo") # loads PlateInfo example file from MetPhenoR
head(PlateInfo) # shows first few rows of PlateInfo dataframe

## -----------------------------------------------------------------------------
head(PlateInfo$Sample) # shows first few rows of column storing experimental information

## -----------------------------------------------------------------------------
# data <- read_folder(data_path = "A:/metabolic_phenotyping", # folder path
#                    sample_column = "Sample", # which column in PlateInfo contains experimental information
#                    variables = c("cell.line","condition","time.h") # sets the variable names for the following workflow)

## -----------------------------------------------------------------------------
data("processed_data") # load example output of read_folder() function

head(processed_data$data) # show first lines of element "data" in object "processed_data"

## -----------------------------------------------------------------------------
processed_data$meta # display meta information: folder path, sample column, variables

## ----fig.width=8,fig.height=4-------------------------------------------------
qc_data(processed_data) # execute function qc_data() on read in data stored in object "processed_data" to create plot

## ----fig.width=8, fig.height=6------------------------------------------------
plot_latest_timepoint(processed_data)

## -----------------------------------------------------------------------------
data("PM_M01_M02") # load annotation file for PM-M01 and PM-M02
head(PM_M01_M02) # inspect for few rows
processed_data <- annotate_chemical(processed_data, annotation = PM_M01_M02) # annotate Chemical Information
head(processed_data$data)

## -----------------------------------------------------------------------------
# write.csv(processed_data$data,  # just stores the dataframe but not meta information about original file path
#          file = "A:\results")  # your file path

## -----------------------------------------------------------------------------
# save(processed_data$data,
#     file = "A:\results")

## -----------------------------------------------------------------------------
# install needed package
# if (!require("readr", quietly = TRUE)) {
#  install.packages("readr")
# }

# load custom annotation
# custom <- read_csv("A:/myfile.csv")
# processed_data <- annotate_chemical(processed_data, annotation = custom)

## -----------------------------------------------------------------------------
processed_data <- classify_growth_curve_types(processed_data) # classify growth curves
head(processed_data$classification)

## ----fig.width=8,fig.height=6-------------------------------------------------
plot_growth_curve(processed_data)

## ----fig.width=8,fig.height=6-------------------------------------------------
processed_data <- plot_growth_curve(processed_data) # store plots
processed_data$growth_curve_plots$`A_treatment_inhibitor_2h_PM-M01` # just show one plot

## ----fig.width=8,fig.height=4-------------------------------------------------
# qc_plot for overview of plate types
qc_data(processed_data)

## -----------------------------------------------------------------------------
processed_data <- filter_data(processed_data,
  plate_type = "PM-M01",
  filters = list(
    cell.line = "A",
    treatment = "treatment",
    inhibitor = "inhibitor",
    time = "2h"
  )
)

## ----fig.width=8,fig.height=4-------------------------------------------------
# qc_plot for overview of plate types
qc_data(processed_data)

## -----------------------------------------------------------------------------
processed_data <- compute_auc_ci(processed_data,
  target_curve_type = c( # keep these curve types for AUC calculation
    "growing",
    "flat_low",
    "slow_growing"
  ), 
  n_boot = 10 # low number of bootstraps for vignette
)
head(processed_data$auc_results)

## -----------------------------------------------------------------------------
# write.csv(processed_data$auc_results,file="A:\results")

## ----fig.width=8,fig.height=8-------------------------------------------------
plot_controls_tween_all_plate(processed_data)

## ----fig.width=8,fig.height=8-------------------------------------------------
plot_controls_tween_per_plate(processed_data,
  selected_plate = "PM-M01"
) # which Plate Type to compare

## ----fig.width=10, fig.height=12----------------------------------------------
plot_auc(processed_data,
  selected_plate = "PM-M02", # Plate Type to display
  facet_vars = c("treatment") # which two biological conditions should be compared, first variable goes on y-axis panel, second on x-axis panel
)

## -----------------------------------------------------------------------------
processed_data <- compute_auc_ratio(processed_data)
head(processed_data$auc_ratio)

## -----------------------------------------------------------------------------
# write.csv(processed_data$auc_ratio)

## ----fig.width=10,fig.height=12-----------------------------------------------
plot_auc_ratio_heatmap(processed_data,
  plate_type = "PM-M01", # which plate type to visualize
  x_var = "treatment"  # which variable should go on x-axis, all other go in x-axis panels
) 

## ----fig.width=10,fig.height=12-----------------------------------------------
plot_auc_ratio_heatmap(processed_data,
  plate_type = "PM-M01",
  x_var = "treatment",
  scale_type = "log10" # switch from natural to log10 scale
)

## -----------------------------------------------------------------------------
head(PM_M01_M02)

## -----------------------------------------------------------------------------
processed_data <- annotate_metadata(processed_data, annotation = PM_M01_M02)

## ----fig.width=10,fig.height=10-----------------------------------------------
plot_auc_ratio_by_group(processed_data,
  group_var = "middle_hierarchy", # column in metadata
  x_var = "treatment",
  group_filter = c(
    "Nucleotide metabolism", #  which entries in 'group_var' to display
    "Amino acid metabolism"
  )
)

## ----fig.width=10,fig.height=10-----------------------------------------------
plot_auc_ratio_violin(processed_data,
  group_var = "middle_hierarchy",
  color_var = "treatment"
) # which variable should be displayed on color scale

## ----fig.width=10,fig.height=10-----------------------------------------------
plot_auc_ratio_violin(processed_data,
  group_var = "middle_hierarchy",
  color_var = "inhibitor", # switch color variable
  scale_type = "log10" # log 10
)

## -----------------------------------------------------------------------------
sessionInfo()

