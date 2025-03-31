# FFI-QAQC
QAQC for ROMO FFI data

Edited: Christina Fossum 3/31/2025

Contents
A. Overview and Use
B. Error Queries
    1. 2024 Rapid Assessment Plots
    2. 2024 Allenspark Plots
    3. FMH PIPO plots





~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
B. Error Queries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*Outliers detected using Rosner's statistical test ('EnvStats' R package)

1. 2024 Rapid Assessment Plots
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Surface Fuels - Fine (metric)
  1. # of transects = 2
  2. Transect Length = 20m (for 1hr, 10hr, 100hr)
  3. FWD constant = 'Ponderosa pine'
  4. Transect 1 azimuth = 0; Transect 2 azimuth = 270
  5. 2 'hits' (2x transect data) per plot
  6. Outlier values flagged for 1hr, 10hr, 100hr fuel counts
Surface Fuels - 100Hr (metric)
  1. # of transects = 2
  2. Transect length = 20m
  3. CWD constant = 'Ponderosa pine'
  4. Outlier values flagged for 1000Hr fuel diameters
  5. Decay class = 3 or 4
Surface Fuels - Duff/Litter (metric)
  1. # of transects = 2
  2. Sample locations = 0.5, 3.5, 6.5, 13.5, 16.5, 19.5
  3. # samples per transect = 6
  4. DL fuel constant = 'Ponderosa pine'
  5. Outlier values flagged for Litter, Duff, & Fuelbed depths
Trees - Individuals (metric)
  1. Subplot = 1 or 2
  2. Quarter = 1, 2, 3, or 4
  3. Subplot = 1 if DBH >= 15; subplot = 2 if DBH < 15
  4. Species = PIPO
  5. Outlier values flagged for DBH, Char Ht, Schorch Ht, Scorch %
  6. Correct Crown Class Status
Cover - Points (metric)
  1. # of transects = 2
  2. Transect length = 20m
  3. Points per transect = 20
  4. 'Point' = 'tape'
  5. NumPts = 20 (minimum of 1 obvservation per point)
  6. Height value should be present for 1st hit plants only
  7. Outlier values flagged for height
  8. Outlier values flagged for species
Post Burn Severity (metric)
1. # of transects = 2
2. Transect length = 20m
3. Points per transect = 6
4. Each transect has 6 rows of data
5. Sample locations = 0.5, 3.5, 6.5, 13.5, 16.5, 19.5
Density - Quadrats (metric)
1. # transects = 1
2. # quadrats per transect = 4
3. Quad length = 10m
4. Quad width = 10m
5. Quad area = 78.5m
6. Transect = 1
7. Quadrat = 1, 2, 3, or 4
8. Status = L
9. Height = 1, 2, 3, 4, 5, 6, or 7







































