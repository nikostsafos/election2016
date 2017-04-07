dat = read.csv('../../electionResultsVariables.csv', header = T, stringsAsFactors = F)
dat$FIPS = formatC(dat$FIPS, width = 5, flag = 0)

stateTotals = aggregate(Votes ~ StateName, data = dat, sum)
colnames(stateTotals)[2] = 'StateTotalVotes'
dat = merge(dat, stateTotals,
            by.dat = 'StateName',
            by.stateTotals = 'StateName')

cumulativeVotes = function (variable, state) {
        df = dat[dat$StateName == state,]
        df = cbind(df[order(df[[variable]]), ],
                   cumsum(df[order(df[[variable]]), 'TrumpVClinton']))
        varIndex = match(variable, colnames(df))
        colnames(df) [varIndex] = 'VariableValue'
        df = df[,c(2, 1, 3, 13:14, ncol(df)-1, varIndex, 11, 12, ncol(df))]
        colnames(df) [ncol(df)] = 'CumTrumpVClinton'
        df$CumTrumpVClinton = (df$CumTrumpVClinton / df$StateTotalVotes)*100
        df$VariableName = variable
        df = df[,c(1:5, ncol(df), 7:(ncol(df)-1))]
        return (df)
} 

variables = colnames(dat)[16:ncol(dat)-1]
df = c()
for (i in unique(dat$StateName)) {
        for (j in variables) {
                df = rbind(df, cumulativeVotes(j, i))
        }
}

df = subset(df, select = c('StateName',
                           'CountyName',
                           'FIPSWinner',
                           'VariableName',
                           'VariableValue', 
                           'TrumpVClinton',
                           'TrumpVClintonPCT',
                           'CumTrumpVClinton'))

write.csv(df, '../../electionResultsCumulativeMargin.csv', row.names = F)

## Manual way for troubleshooting
# df = dat[dat$StateName == 'Michigan',]
# df = cbind(df[order(df$UrbanPCT), ],
#            cumsum(df[order(df$UrbanPCT), 'TrumpVClinton']))
# varIndex = match('UrbanPCT', colnames(df))
# colnames(df) [varIndex] = 'VariableValue'
# df = df[,c(2, 1, 3, 13:14, ncol(df)-1, varIndex, 11, 12, ncol(df))]
# colnames(df) [ncol(df)] = 'CumTrumpVClinton'
# df$CumTrumpVClinton = (df$CumTrumpVClinton / df$StateTotalVotes)*100
# df$VariableName = 'UrbanPCT'
# df = df[,c(1:5, ncol(df), 7:(ncol(df)-1))]
# return (df)

countrytotal = sum(dat$Votes)

cumulativeVotesCountry = function (variable) {
        df = dat
        df = cbind(df[order(df[[variable]]), ],
                   cumsum(df[order(df[[variable]]), 'TrumpVClinton']))
        varIndex = match(variable, colnames(df))
        colnames(df) [varIndex] = 'VariableValue'
        df = df[,c(2, 1, 3, 13:14, varIndex, 11, 12, ncol(df))]
        colnames(df) [ncol(df)] = 'CumTrumpVClinton'
        df$CumTrumpVClinton = (df$CumTrumpVClinton / countrytotal) * 100
        df$VariableName = variable
        df = df[,c(1:5, ncol(df), 6:(ncol(df)-1))]
        return (df)
} 

variables = colnames(dat)[16:ncol(dat)-1]
df = c()
for (i in variables) {
        df = rbind(df, cumulativeVotesCountry(i))
        }

df = subset(df, select = c('StateName',
                           'CountyName',
                           'FIPSWinner',
                           'VariableName',
                           'VariableValue', 
                           'TrumpVClinton',
                           'TrumpVClintonPCT',
                           'CumTrumpVClinton'))

write.csv(df, '../../electionResultsCumulativeCountryMargin.csv', row.names = F)

## Manual way for troubleshooting
# df = dat
# df = cbind(df[order(df$UrbanPCT), ],
#            cumsum(df[order(df$UrbanPCT), 'TrumpVClinton']))
# varIndex = match('UrbanPCT', colnames(df))
# colnames(df) [varIndex] = 'VariableValue'
# df = df[,c(2, 1, 3, 13:14, varIndex, 11, 12, ncol(df))]
# colnames(df) [ncol(df)] = 'CumTrumpVClinton'
# df$CumTrumpVClinton = (df$CumTrumpVClinton / countrytotal)*100
# df$VariableName = 'UrbanPCT'
# df = df[,c(1:5, ncol(df), 6:(ncol(df)-1))]
# return (df)
