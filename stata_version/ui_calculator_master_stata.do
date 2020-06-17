clear all
set more off
set trace off
prog drop _all
mac drop _all




******************
*** SET MACROS ***
******************
* set macros. always run this.
global home "C:\Users\aniba\Dropbox\Anahid\UI\stata_version\"
global source "${home}ui_calculator-master\source\"
global ui_calc "${home}ui_calculator-master\"
*save examplefile in the ui_calc folder
global examplefile "example_annual.csv"

***************************
*** IMPORT SOURCE FILES ***
***************************

do ${home}ui_import_source.do

*************************************
*** DEFINE UI CALCULATOR PROGRAMS ***
*************************************
do ${home}ui_calculator_stata.do

*******************
*** RUN EXAMPLE ***
*******************
do ${home}minimum_working_example_stata.do
