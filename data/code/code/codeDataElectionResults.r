library(jsonlite)

fileURL = '../rawData/electionResults/electionData.json'
jsonData = fromJSON(fileURL)

# Create one df with all data except Alaska (because Alaska doesn't have FIPS-level data)
resultsFIPS = c()
for (i in 2:51) {
        fips = as.data.frame(jsonData$counties[[i]])
        results = as.data.frame(fips$results)
        fips = fips[,c(1:3)]
        results = results[, c('trumpd', 'clintonh')]
        resultsFIPSState = cbind(fips, results)
        resultsFIPS = rbind(resultsFIPS, resultsFIPSState)
}

resultsFIPS$other = resultsFIPS$votes - resultsFIPS$trumpd - resultsFIPS$clintonh

# Add in Alaska data
fipsAlaska = as.data.frame(jsonData$counties[[1]])
resultsAlaska = as.data.frame(fipsAlaska$results)
resultsAlaska = resultsAlaska[, c('trumpd', 'clintonh')]
fipsAlaska = fipsAlaska[,c(1:3)]
resultsFIPSAlaska = cbind(fipsAlaska, resultsAlaska)
resultsFIPSAlaska$other = resultsFIPSAlaska$votes - resultsFIPSAlaska$trumpd - resultsFIPSAlaska$clintonh

results = rbind(resultsFIPS, resultsFIPSAlaska)

# Remove all files 
rm(fips, fipsAlaska, jsonData, 
   resultsAlaska, resultsFIPS, 
   resultsFIPSAlaska, resultsFIPSState, 
   fileURL, i)

# Calculate Trump, Clinton and Other Percentages
results$TrumpPCT = (results$trumpd / results$votes) * 100
results$ClintonPCT = (results$clintonh / results$votes) * 100
results$OtherPCT = (results$other / results$votes) * 100

# Rename columns
colnames(results)[1:6] = c('FIPS', 'CountyName', 'Votes', 'Trump', 'Clinton', 'Other')

# Calculate victory margins 
results$TrumpVClinton = results$Trump - results$Clinton
results$TrumpVClintonPCT = results$TrumpPCT - results$ClintonPCT

# Add in winner of county (FIPS)
results$FIPSWinner = ifelse(results$TrumpVClinton > 0, 'Trump', 'Clinton') 

# Create a state variable 
results$State = substring(results$FIPS, 1,2)

# Add state names
stateCode = read.table('../backup/states.tsv', sep = '\t', header = T, row.names = NULL)
stateCode = stateCode[,c(1:2)]
colnames(stateCode) = c('State', 'StateName')
results = merge(results, stateCode, by.results = 'State', stateCode = 'State')
rm(stateCode)

# Add in winner of each state
stateWinner = aggregate(TrumpVClinton ~ StateName, data = results, sum)
stateWinner$StateWinner = ifelse(stateWinner$TrumpVClinton > 0, 'Trump', 'Clinton') 
stateWinner = stateWinner[,c(1,3)]
results = merge(results, stateWinner, by.results = 'StateName', stateWinner = 'StateName')
rm(stateWinner)

# Remove state number
results = results[,c(1, 3:ncol(results))]

write.csv(results, '../../electionResults.csv', row.names = F)
