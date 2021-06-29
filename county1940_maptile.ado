*! 29june2021, Ben Zipperer, benzipperer@gmail.com

/* Template source: https://michaelstepner.com/maptile/geographies/ */

program define _maptile_county1940 /*XX change "demo" to your chosen geoname. ex: _maptile_state */
	syntax , [  geofolder(string) ///
				mergedatabase ///
				map spmapvar(varname) var(varname) binvar(varname) clopt(string) legopt(string) min(string) clbreaks(string) max(string) mapcolors(string asis) ndfcolor(string) ///
					savegraph(string) replace resolution(string) map_restriction(string) spopt(string) ///
			 ]
	
	if ("`mergedatabase'"!="") {
		/* XX make sure the geographic ID variable you choose is contained in geoname_database.dta */
		novarabbrev merge 1:m county_fips /*XX change geoid to the geographic ID variable, ex: province*/ ///
			using `"`geofolder'/county1940_database.dta"', nogen /*XX change "geoname_database.dta" to the name of your shapefile database file*/
		exit
	}
	
	if ("`map'"!="") {
		/* XX make sure the polygon ID variable in your geoname_database.dta matches the variable name in id() */
		spmap `spmapvar' using `"`geofolder'/county1940_coords.dta"' `map_restriction', id(_ID) /// /*XX change "geoname_coords.dta" to the name of your shapefile coordinates file*/
			`clopt' ///
			`legopt' ///
			legend(pos(7) size(*1)) /// /*XX change the default placement and size of the legend as appropriate for your map*/
			fcolor(`mapcolors') ndfcolor(`ndfcolor') ///
			oc(black ...) ndo(black) ///
			os(vthin ...) nds(vthin) ///
			`spopt'

		* Save graph
		if (`"`savegraph'"'!="") __savegraph_maptile, savegraph(`savegraph') resolution(`resolution') `replace'
		
	}
	
end

* Save map to file
cap program drop __savegraph_maptile
program define __savegraph_maptile

	syntax, savegraph(string) resolution(string) [replace]
	
	* check file extension using a regular expression
	if regexm(`"`savegraph'"',"\.[a-zA-Z0-9]+$") local graphextension=regexs(0)
	
	* deal with different filetypes appropriately
	if inlist(`"`graphextension'"',".gph","") graph save `"`savegraph'"', `replace'
	else if inlist(`"`graphextension'"',".ps",".eps") graph export `"`savegraph'"', mag(`=round(100*`resolution')') `replace'
	else if (`"`graphextension'"'==".png") graph export `"`savegraph'"', width(`=round(3200*`resolution')') `replace'
	else if (`"`graphextension'"'==".tif") graph export `"`savegraph'"', width(`=round(1600*`resolution')') `replace'
	else graph export `"`savegraph'"', `replace'

end

