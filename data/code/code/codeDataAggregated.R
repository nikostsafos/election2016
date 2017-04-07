dat = read.csv('../../electionResults.csv', header = T, stringsAsFactors = F)
dat$FIPS = formatC(dat$FIPS, width = 5, flag = 0)

# Split between Alaska and non Alaska (no FIPS-level election results in Alaska)
ak = dat[ dat$FIPS == '02000',]
dat = dat[ !dat$FIPS == '02000',]

# Add in variable data: Urbanization ####
datVariable = read.csv('../rawData/urbanrural/DEC_10_SF1_P2_with_ann.csv',
                       header = T,
                       stringsAsFactors = F,
                       skip = 1)

datVariable$Total = gsub('((r[0-9]+))|[^0-9]', '', 
                         datVariable$Total) ## remove everything inside parentheses and parentheses

datVariable$Total = as.numeric(datVariable$Total)

datVariable$UrbanPCT = (datVariable$Urban. / datVariable$Total)*100
datVariable$Id2 = formatC(datVariable$Id2, width = 5, flag = 0)
datVariable = subset(datVariable, select = c('Id2', 'UrbanPCT'))
colnames(datVariable)[1] = 'FIPS'
datVariable$FIPS = gsub('46113', '46102', datVariable$FIPS)

dat = merge(dat, datVariable,
            by.dat = 'FIPS',
            by.datVariable = 'FIPS')

rm(datVariable)

# Add in variable data: Age ####
datVariable = read.csv('../rawData/age/ACS_15_5YR_S0101_with_ann.csv', 
                       header = T, 
                       stringsAsFactors = F)
datVariable = subset(datVariable, select= c(GEO.id2,
                                            HC01_EST_VC35)) # Total; Estimate; SUMMARY INDICATORS - Median age (years)
datVariable = datVariable[2:nrow(datVariable),]
colnames(datVariable) = c('FIPS', 'MedianAge')
datVariable$FIPS = formatC(datVariable$FIPS, width = 5, flag = 0)

dat = merge(dat, datVariable,
            by.dat = 'FIPS',
            by.datVariable = 'FIPS')

rm(datVariable)

# Add in variable data: Race ####
datVariable = read.csv('../rawData/race/ACS_15_5YR_B02001_with_ann.csv', header = T, stringsAsFactors = F)
datVariable = subset(datVariable, select= c(GEO.id2,
                                            HD01_VD01,  # Estimate; Total:
                                            HD01_VD02,  # Estimate; Total: - White alone
                                            HD01_VD03)) # Estimate; Total: - Black or African American alone
datVariable = datVariable[2:nrow(datVariable),]
datVariable$GEO.id2 = gsub('46113', '46102', datVariable$GEO.id2)
datVariable[, c(2:ncol(datVariable))] <- sapply(datVariable[, c(2:ncol(datVariable))], as.numeric) # convert to numeric
datVariable$WhiteAlonePCT = (datVariable$HD01_VD02 / datVariable$HD01_VD01) * 100
datVariable$BlackAlonePCT = (datVariable$HD01_VD03 / datVariable$HD01_VD01) * 100
datVariable = subset(datVariable, select= c(GEO.id2,
                                            WhiteAlonePCT, 
                                            BlackAlonePCT))

colnames(datVariable)[1] = 'FIPS'

dat = merge(dat, datVariable,
            by.dat = 'FIPS',
            by.datVariable = 'FIPS')

rm(datVariable)

# Add in variable data: Hispanic origin ####
datVariable = read.csv('../rawData/hispanicOrigin/ACS_15_5YR_B03003_with_ann.csv', header = T, stringsAsFactors = F)
datVariable = subset(datVariable, select= c(GEO.id2,
                                            HD01_VD01,  # Estimate; Total:
                                            HD01_VD03)) # Estimate; Total: - Hispanic or Latino
datVariable = datVariable[2:nrow(datVariable),]
datVariable$GEO.id2 = gsub('46113', '46102', datVariable$GEO.id2)
datVariable[, c(2:ncol(datVariable))] <- sapply(datVariable[, c(2:ncol(datVariable))], as.numeric) # convert to numeric
datVariable$HispanicPCT = (datVariable$HD01_VD03 / datVariable$HD01_VD01) * 100
datVariable = subset(datVariable, select= c(GEO.id2,
                                            HispanicPCT))

colnames(datVariable)[1] = 'FIPS'

dat = merge(dat, datVariable,
            by.dat = 'FIPS',
            by.datVariable = 'FIPS')

rm(datVariable)

# Add in variable data: Income and poverty ####
datVariable = read.fwf('../rawData/povertyIncome/est15ALL.txt', 
                       widths = c(2, # FIPS State
                              4, # FIPS County
                              9, 9, 9, 5, 5, 5, # All ages
                              9, 9, 9, 5, 5, 5, # ages 0-17
                              9, 9, 9, 5, 5, 5, # ages 5-17
                              7, 7, 7, # Median household
                              8, 8, 8, # Under 5 in poverty
                              5, 5, 5, # Percent under 5 in poverty 
                              46, 3, 23), # Location data
                       strip.white = T, 
                       stringsAsFactors = F)
datVariable = datVariable[,c(1,2,6,21)]

colnames(datVariable) = c('StateFIPS',
                          'CountyFIPS',
                          'PovertyPCT',
                          'MedianHouseholdIncome')

datVariable[, c(3:4)] <- sapply(datVariable[, c(3:4)], as.numeric) # convert to numeric

datVariable$FIPS = paste0(formatC(datVariable$StateFIPS, width = 2, flag = 0),
                          formatC(datVariable$CountyFIPS, width = 3, flag = 0))

datVariable$FIPS = gsub('46113', '46102', datVariable$FIPS)

datVariable = subset(datVariable, select= c(FIPS,
                                            PovertyPCT,
                                            MedianHouseholdIncome))

datVariable$MedianHouseholdIncome = datVariable$MedianHouseholdIncome/1000

dat = merge(dat, datVariable,
            by.dat = 'FIPS',
            by.datVariable = 'FIPS')

rm(datVariable)

# Add in variable data: Employment/population ratio ####
datVariable = read.csv('../rawData/laborForce/ACS_15_5YR_S2301_with_ann.csv', 
                       header = T,
                       stringsAsFactors = F)

datVariable = subset(datVariable, select= c(GEO.id2,
                                            HC03_EST_VC01))  # Employment/Population Ratio; Estimate; Population 16 years and over
datVariable = datVariable[2:nrow(datVariable),]

colnames(datVariable) = c('FIPS', 'EmplPopRatio16Over')
datVariable$EmplPopRatio16Over = as.numeric(datVariable$EmplPopRatio16Over)

dat = merge(dat, datVariable,
            by.dat = 'FIPS',
            by.datVariable = 'FIPS')

rm(datVariable)

# Add in variable data: Educational attainment ####
datVariable = read.csv('../rawData/education/ACS_15_5YR_S1501_with_ann.csv', 
                       header = T,
                       stringsAsFactors = F)
datVariable = subset(datVariable, select= c(GEO.id2,
                                            HC02_EST_VC17,  # Percent; Estimate; Percent high school graduate or higher
                                            HC02_EST_VC18)) #	Percent; Estimate; Percent bachelor's degree or higher

datVariable = datVariable[2:nrow(datVariable),]

datVariable[, c(2:ncol(datVariable))] = sapply(datVariable[, c(2:ncol(datVariable))], as.numeric) # convert to numeric

colnames(datVariable) = c('FIPS', 'HighSchoolorHigherPCT', 'BAorHigherPCT')

dat = merge(dat, datVariable,
            by.dat = 'FIPS',
            by.datVariable = 'FIPS')

rm(datVariable)

# ALASKA ####

# Add in variable data: Urbanization ####
datVariable = read.csv('../rawData/ak/DEC_10_SF1_P2_with_ann.csv',
               header = T,
               stringsAsFactors = F,
               skip = 1)

datVariable$Total = gsub('((r[0-9]+))|[^0-9]', '', 
                         datVariable$Total) ## remove everything inside parentheses and parentheses

datVariable$Total = as.numeric(datVariable$Total)
datVariable$UrbanPCT = datVariable$Urban. / datVariable$Total
datVariable$FIPS = '02000'
datVariable = subset(datVariable, select = c('FIPS', 'UrbanPCT'))

ak = merge(ak, datVariable,
            by.ak = 'FIPS',
            by.datVariable = 'FIPS')

rm(datVariable)

# Add in variable data: Age ####
datVariable = read.csv('../rawData/ak/ACS_15_5YR_S0101_with_ann.csv', 
                       header = T,
                       stringsAsFactors = F)

datVariable = datVariable[2:nrow(datVariable),]

datVariable = subset(datVariable, select= c(GEO.id2,
                            HC01_EST_VC35)) # Total; Estimate; SUMMARY INDICATORS - Median age (years)
datVariable$FIPS = '02000'
colnames(datVariable)[2] = 'MedianAge'
datVariable = subset(datVariable, select = c('FIPS', 'MedianAge'))

ak = merge(ak, datVariable,
           by.ak = 'FIPS',
           by.datVariable = 'FIPS')

rm(datVariable)

## Add in Alaska // Race
datVariable = read.csv('../rawData/ak/ACS_15_5YR_B02001_with_ann.csv', header = T, stringsAsFactors = F)
datVariable = subset(datVariable, select= c(GEO.id2,
                                            HD01_VD01,  # Estimate; Total:
                                            HD01_VD02,  # Estimate; Total: - White alone
                                            HD01_VD03)) # Estimate; Total: - Black or African American alone
datVariable = datVariable[2:nrow(datVariable),]
datVariable = datVariable[datVariable$GEO.id2 == '02',]
datVariable[, c(2:ncol(datVariable))] <- sapply(datVariable[, c(2:ncol(datVariable))], as.numeric) # convert to numeric
datVariable$WhiteAlonePCT = (datVariable$HD01_VD02 / datVariable$HD01_VD01) * 100
datVariable$BlackAlonePCT = (datVariable$HD01_VD03 / datVariable$HD01_VD01) * 100
datVariable = subset(datVariable, select= c(GEO.id2,
                                            WhiteAlonePCT, 
                                            BlackAlonePCT))
colnames(datVariable)[1] = 'FIPS'

datVariable$FIPS = gsub('02', '02000', datVariable$FIPS)

ak = merge(ak, datVariable,
           by.ak = 'FIPS',
           by.datVariable = 'FIPS')

rm(datVariable)

# Add in variable data: Hispanic origin ####
datVariable = read.csv('../rawData/ak/ACS_15_5YR_B03003_with_ann.csv', header = T, stringsAsFactors = F)
datVariable = subset(datVariable, select= c(GEO.id2,
                                            HD01_VD01,  # Estimate; Total:
                                            HD01_VD03)) # Estimate; Total: - Hispanic or Latino
datVariable = datVariable[2:nrow(datVariable),]
datVariable = datVariable[datVariable$GEO.id2 == '02',]
datVariable[, c(2:ncol(datVariable))] <- sapply(datVariable[, c(2:ncol(datVariable))], as.numeric) # convert to numeric
datVariable$HispanicPCT = (datVariable$HD01_VD03 / datVariable$HD01_VD01) * 100
datVariable = subset(datVariable, select= c(GEO.id2,
                                            HispanicPCT))

colnames(datVariable)[1] = 'FIPS'
datVariable$FIPS = gsub('02', '02000', datVariable$FIPS)

ak = merge(ak, datVariable,
           by.ak = 'FIPS',
           by.datVariable = 'FIPS')

rm(datVariable)

# Add in variable data: Income and poverty ####
datVariable = read.fwf('../rawData/povertyIncome/est15ALL.txt', 
                       widths = c(2, # FIPS State
                                  4, # FIPS County
                                  9, 9, 9, 5, 5, 5, # All ages
                                  9, 9, 9, 5, 5, 5, # ages 0-17
                                  9, 9, 9, 5, 5, 5, # ages 5-17
                                  7, 7, 7, # Median household
                                  8, 8, 8, # Under 5 in poverty
                                  5, 5, 5, # Percent under 5 in poverty 
                                  46, 3, 23), # Location data
                       strip.white = T, 
                       stringsAsFactors = F)
datVariable = datVariable[,c(1,2,6,21)]

colnames(datVariable) = c('StateFIPS',
                          'CountyFIPS',
                          'PovertyPCT',
                          'MedianHouseholdIncome')

datVariable[, c(3:4)] <- sapply(datVariable[, c(3:4)], as.numeric) # convert to numeric

datVariable$FIPS = paste0(formatC(datVariable$StateFIPS, width = 2, flag = 0),
                          formatC(datVariable$CountyFIPS, width = 3, flag = 0))

datVariable = datVariable[datVariable$FIPS == '02000',]

datVariable = subset(datVariable, select= c(FIPS,
                                            PovertyPCT,
                                            MedianHouseholdIncome))

datVariable$MedianHouseholdIncome = datVariable$MedianHouseholdIncome/1000

ak = merge(ak, datVariable,
           by.ak = 'FIPS',
           by.datVariable = 'FIPS')

rm(datVariable)

## Add in Alaska // Labor force
datVariable = read.csv('../rawData/ak/ACS_15_5YR_S2301_with_ann.csv', 
               header = T,
               stringsAsFactors = F)

datVariable = subset(datVariable, select= c(GEO.id2, HC03_EST_VC01))
datVariable = datVariable[2:nrow(datVariable),]
datVariable$FIPS = '02000'
colnames(datVariable)[2] = 'EmplPopRatio16Over'
datVariable = subset(datVariable, select = c('FIPS', 
                                             'EmplPopRatio16Over'))
ak = merge(ak, datVariable,
           by.ak = 'FIPS',
           by.datVariable = 'FIPS')

## Add in Alaska // education
datVariable = read.csv('../rawData/ak/ACS_15_5YR_S1501_with_ann.csv', 
               header = T,
               stringsAsFactors = F)

datVariable = subset(datVariable, select= c(GEO.id2,
                            GEO.display.label,
                            HC02_EST_VC17,  # Percent; Estimate; Percent high school graduate or higher
                            HC02_EST_VC18)) #	Percent; Estimate; Percent bachelor's degree or higher

datVariable = datVariable[2:nrow(datVariable),]
datVariable$FIPS = '02000'
colnames(datVariable)[3:4] = c('HighSchoolorHigherPCT','BAorHigherPCT')
datVariable = subset(datVariable, select = c('FIPS', 
                                             'HighSchoolorHigherPCT',
                                             'BAorHigherPCT'))
ak = merge(ak, datVariable,
           by.ak = 'FIPS',
           by.datVariable = 'FIPS')

rm(datVariable)

dat = rbind(dat, ak); rm(ak)

dat$CountyName = gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(dat$CountyName), perl=TRUE)
dat$CountyName = paste0(dat$CountyName, ', ', state.abb[match(dat$StateName, state.name)])

write.csv(dat, '../../electionResultsVariables.csv', row.names = F)
