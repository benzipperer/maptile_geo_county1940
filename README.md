# use 1940 county outlines with Stata's maptile

## simple installation
just unzip `geo_county1940.zip` into your maptile geographies directory (e.g., `~/ado/personal/maptile_geographies`) and then use it with a dataset that has a numeric `county_fips` variable
```
maptile my_outcome, geo(county1940)
```

## building from scratch
The underlying shapefiles are the 1940 county files from IPUMS NHGIS based on the US Census 2008 TIGER/Line shapefiles from https://www.nhgis.org/. 

Download those and run/modify `build_county1940.do` and `county1940_maptile.ado` appropriately.

`install_county1940.do` unzips the package into its specified maptile geographies directory.

`example_county1940.do` is an example maptile figure.
