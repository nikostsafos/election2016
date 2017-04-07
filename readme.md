# Red vs. Blue: Visualizing the Fault Lines

Web version: https://nikostsafos.github.io/afterManufacturing/

The 2016 presidential election underscored the enduring fault lines between red and blue America. Typically, the result is explained in these terms: Donald Trump did better in places that were rural, white, less educated, and less well off. That narrative is, more or less, borne by the data. But these broad strokes only tell part of the story. In fact, if we change the question&mdash;can I look at a place and predict whether it will be red or blue&mdash;the answer is less clear and there is a lot more noise. Sometimes, a place that looks red votes blue; and sometimes, a place that should be overwhelmingly blue voted blue by only a small maring. So where exactly are these fault lines, and how well do they capture the split between red and blue America?.

### In this repository

**css**: CSS style for the page. 

**img**: Open graph image for link sharing

**js**: D3.js script for graphics. 

**data**: Clean CSV data files for web rendering. There are four separate CSV files: 

- electionResults: Results by county. 

- electionResultsVariables: Results by county together with input variables (urbanization, race, income, poverty, etc.).

- electionResultsCumulativeMargin: Results by county, aggregated by cumulative margin within each state (in effect: subset each state, sort by a given variable, calculate a running total margin).

- electionResultsCumulativeCountryMargin: Results by county, aggregated by cumulative margin at the country level (in effect: sort by a given variable, calculate a running total margin).

The file also contains three R scripts:

- codeDataElectionResults: Process the raw election results in JSON and render a clean CSV file with results by variable. 

- codeDataAggregated: Merge the election results with the various input variables. 

- codeDataCumulative: Calculate the cumulative margins. 

Below is a complete list of the data used: 

**Geographic information**

- FIPS: County code.

- CountyName: County name.

- StateName: State name

*Source: U.S. Census Bureau, 2010 FIPS Codes for Counties and County Equivalent Entities.*
*URL: https://www.census.gov/geo/reference/codes/cou.html*

**Election results**

- Votes: Total votes cast in 2016 election. 

- Trump: Votes cast for Donald Trump for president in 2016 election. 

- Clinton: Votes cast for Hillary Clinton for president in 2016 election. 

- Other: Votes cast for other candidates (i.e. not Trump or Clinton) for president in 2016 election. 

- TrumpPCT: Votes for Donald Trump as share of total votes. 

- ClintonPCT: Votes for Hillary Clinton as share of total votes.

- OtherPCT: Votes cast for other candidates (i.e. not Trump or Clinton) as share of total votes. 

- TrumpVClinton: Votes cast for Donald Trump minus votes cast for Hillary Clinton (positive: more Trump votes) 

- TrumpVClintonPCT: Votes cast for Donald Trump minus votes cast for Hillary Clinton as share of total votes (positive: more Trump votes) 

- FIPSWinner: Binary variable with the candiate who won more votes in that county. 

- StateWinner: Binary variable with the candiate who won more votes in that state. 

*Source: Associated Press (via New York Times)*
*URL: http://www.nytimes.com/elections/results/president*

**Variables**

- UrbanPCT: Urban population as percent of total population by county. 
*Source: U.S. Census Bureau, 2010 Census, Table P2, URBAN and RURAL.*
*URL: Retrieved from American Fact Finder, https://factfinder.census.gov/faces/nav/jsf/pages/index.xhtml*

- MedianAge: Median age in years (HC01_EST_VC35) 
*Source: U.S. Census Bureau, 2011-2015 American Community Survey 5-Year Estimates, Table S0101, AGE AND SEX.*
*URL: Retrieved from American Fact Finder, https://factfinder.census.gov/faces/nav/jsf/pages/index.xhtml*

- WhiteAlonePCT: White alone, HD01_VD02/HD01_VD01 in B02001 RACE
- Black of African American alone, HD01_VD03/HD01_VD01 in B02001 RACE
- HispanicPCT: Hispanic or Latino origin, HD01_VD03/HD01_VD01 in B03003 HISPANIC OR LATINO ORIGIN 
*Source: U.S. Census Bureau, 2011-2015 American Community Survey 5-Year Estimates*
*URL: Retrieved from American Fact Finder, https://factfinder.census.gov/faces/nav/jsf/pages/index.xhtml*

- Income2015: Estimate of median household income.
- Poverty2015: Estimated percent of people of all ages in poverty.
*Source: U.S. Census Bureau, State and County Estimates for 2015.*
*URL: https://www.census.gov/did/www/saipe/data/statecounty/data/2015.html*

- EmplPopRatio16Over: Employment/Population Ratio; Estimate; Population 16 years and over (HC03_EST_VC01)
*Source: U.S. Census Bureau, 2011-2015 American Community Survey 5-Year Estimates, Table S2301, EMPLOYMENT STATUS.*
*URL: Retrieved from American Fact Finder, https://factfinder.census.gov/faces/nav/jsf/pages/index.xhtml*

- HighSchoolorHigherPCT: Percent high school graduate or higher (HC02_EST_VC17)
- BAorHigherPCT: Percent bachelor's degree or higher (HC02_EST_VC18)
*Source: U.S. Census Bureau, 2011-2015 American Community Survey 5-Year Estimates, Table S1501, EDUCATIONAL ATTAINMENT.*
*URL: Retrieved from American Fact Finder, https://factfinder.census.gov/faces/nav/jsf/pages/index.xhtml*

Results for Alaska reported state-wide; input variables are also state-wide from the same sources. 
