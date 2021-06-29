set more off

* to run this you will need to download the 1940 county shapefiles
* from IPUMS NHGIS https://www.nhgis.org/

* build shapefiles downloaded from IPUMS NHGIS
* first simplify them
!mapshaper US_county_1940_conflated.shp auto-snap -simplify 2.5% -o force US_county_1940_conflated_simplified.shp
!cp US_county_1940_conflated.dbf US_county_1940_conflated_simplified.dbf

spshape2dta US_county_1940_conflated_simplified.shp, saving(county1940) replace
!mv county1940.dta county1940_database.dta
!mv county1940_shp.dta county1940_coords.dta

* keep only states. this will exclude AK and HI.
use county1940_database, clear

gen state_fips = real(substr(STATE, 1, 2))
drop if state_fips == .

* perhaps not the best choice, but it simplifies things:
* exclude counties that NHGIS defines as "historical" 
drop if substr(COUNTY, 4, 1) == "5"
assert substr(COUNTY, 4, 1) == "0"
assert real(COUNTY) != .

gen county_fips = real(string(state_fips) + substr(COUNTY, 1, 3))

keep _ID _CX _CY state_fips county_fips
sort _ID
save county1940_database, replace

* some data cleaning
use county1940_coords.dta, clear 
merge m:1 _ID using county1940_database, keep(3) nogenerate 
keep _ID _X _Y
sort _ID
save county1940_coords.dta, replace

* create maptile package
!zip - county1940_coords.dta county1940_database.dta county1940_maptile.ado > geo_county1940.zip


