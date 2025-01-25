// Load Data
use "C:\Users\hilmi\Desktop\Quanti\data.dta"

preserve

// Drop unwanted rows based on marital status
drop if single == 1 | widow == 1 | separd == 1 | unkqual == 1

// Keep Selecteed Variables
keep pserial A005 Satis Worth Happy Anxious married cohab disios childs selfemp empee inactiv edgvttr unemp rlondon rneu rner rnwu rnwr ryorksu ryorksr remidu remidr rwmidu rwmidr reu rer rseu rser rswu rswr rwalesu rwalesr rscotu rscotr deg lhed alev onc_btec gcsepass gcsefail othqual noqual

// Data Cleansing
// a. Data types
destring Satis, replace force
destring Worth, replace force
destring Happy, replace force
destring Anxious, replace force

// b. Handling missing value
drop if missing(Satis) | missing(Worth) | missing(Happy) | missing(Anxious)

// c. Exclude outlier

// Data Formatting
// a. Education Data
gen education_level = .
replace education_level = 3 if deg == 1
replace education_level = 2 if lhed == 1 | alev == 1 | onc_btec == 1
replace education_level = 1 if gcsepass == 1 | gcsefail == 1 | othqual == 1
replace education_level = 0 if noqual == 1

// label define edu_label 1 "High Education" 2 "Low Education" 3 "No Education"
/* label values education_level edu_label */

// b. Urban vs Rural
gen is_urban = .
replace is_urban = 1 if rlondon == 1 | rneu == 1 | rnwu == 1 | ryorksu == 1 | remidu == 1 | rwmidu == 1 | reu == 1 | rseu == 1 | rswu == 1 | rwalesu == 1 | rscotu == 1
replace is_urban = 0 if rner == 1 | rnwr == 1 | ryorksr == 1 | remidr == 1 | rwmidr == 1 | rer == 1 | rser == 1 | rswr == 1 | rwalesr == 1 | rscotr == 1
// label define urb_label 1 "Urban" 2 "Rural"
/* label values is_urban urb_label */

// c. Employment Status
replace empee = 1 if selfemp == 1

// Descriptive Statistics
summarize Satis Worth Happy Anxious A005 childs disios

// labeling the marital status
label define marital_status 0 "Cohabit" 1 "Married"
label values married marital_status

// Summary for Categorical Variables
tabulate married
graph pie, over (married) plabel(_all percent) legend(label(1 "cohabit" 0 "married"))
graph bar (count), over (married) legend(label(1 "cohabit" 0 "married"))

tabulate education_level married
graph pie, over(education_level) plabel(_all percent) by(married)
tabulate is_urban
graph pie, over(is_urban) plabel(_all percent) by(married)


// Histograms for Wellbeing Variables
// for married
histogram Satis, bin(10) percent normal title("Histogram of Satisfaction") by(married)
histogram Worth, bin(10) percent normal title("Histogram of Worth") by(married)
histogram Happy, bin(10) percent normal title("Histogram of Happy") by(married)
histogram Anxious, bin(10) percent normal title("Histogram of Anxious") by(married)

// Bar Graphs for Wellbeing Variables
graph bar (mean) Satis Worth Happy Anxious, over(married) title("Mean by Marital Status")
tabstat Satis Worth Happy Anxious, by(married)

// Box plot
/* graph box Satis, over(married)
graph box Happy, over(married)
graph box Worth, over(married)
graph box Anxious, over(married) */

// age for married
histogram A005, normal
histogram A005, by(married) normal
tabstat A005, by(married) stat(mean sd min max)

// number of childs
tabulate childs
tabulate childs if married == 1
tabulate childs if married == 0

// dispos
histogram disios, normal
histogram disios, by(married) normal
tabstat disios, by(married) stat(mean sd min max)

// employment status
graph pie, over (empee) plabel(_all percent)
graph pie, over (empee) plabel(_all percent) by(married) legend(label(1 "unemployed" 0 "employed"))

// level of education
graph pie, over (education_level) plabel(_all percent)
graph pie, over (education_level) plabel(_all percent) by(married)

// urban and rural
graph pie, over (is_urban) plabel(_all percent)
graph pie, over (is_urban) plabel(_all percent) by(married)

// label back the marital status
* Create a new variable "married_binary" and recode values
generate married_binary = .

* Assign 1 for married and 0 for cohabit
replace married_binary = 1 if married == "married"
replace married_binary = 0 if married == "cohabit"

* Check if the new variable was created correctly
tab married_binary


// t-test for Cohabitation vs Marriage
ttest Satis, by(married_binary)
ttest Worth, by(married_binary)
ttest Happy, by(married_binary)
ttest Anxious, by(married_binary)

// Multivariate analysis nya BELUM YAKIN hwehae sorry i'll do it
correlate Satis Worth Happy Anxious A005 married_binary disios childs empee education_level is_urban

// Basic Comparison (married_binary vs. Cohabitation)
reg Satis married_binary A005 disios childs empee education_level is_urban
reg Worth married_binary A005 disios childs empee education_level is_urban
reg Happy married_binary A005 disios childs empee education_level is_urban
reg Anxious married_binary A005 disios childs empee education_level is_urban
