set more off
clear all 
discard 

* just some fake example data that has the county_fips identifier
local maptile_dir "~/ado/personal/maptile_geographies/"
use county_fips using `maptile_dir'county1940_database, clear 
gen fake_outcome = rnormal()

* the actual example
maptile fake_outcome, geo(county1940)
graph export example_county1940.pdf, replace
