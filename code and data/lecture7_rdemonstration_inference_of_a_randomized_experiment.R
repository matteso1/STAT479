### Randomization based inference of a simple random 
###	experiment

## Observed resonposes
Yobs <- c(30, 25, 24, 25, 22, 28, 26, 20)
treatment <- c('Yes', 'No', 'No', 'Yes', 'No', 'Yes', 'Yes', 'No')

# average response for treatment
avgY = mean( Yobs[ treatment == 'Yes' ] )
avgY
# average response for control
avgN = mean( Yobs[ treatment == 'No' ] )
avgN
# difference
Tobs = avgY - avgN

####  Hypothesis  Y_1i = Y_0i   ###
## Potential outcomes when the NULL hypothesis is true
Y1 <- c(30, 25, 24, 25, 22, 28, 26, 20)
Y0 <- c(30, 25, 24, 25, 22, 28, 26, 20)

## Enumerate all 70 possible ways to pick 4 participants to the program
all_treatment_assignments <- combn(8,4)
all_treatment_assignments # Each column gives you the units that will get Treatment


## Calculate the statistic for all 70 possible assignments
statistic <- NULL

for(i in 1:70){	
	units_assigned_to_Y <- all_treatment_assignments[,i]

	# Imput response based on this treatment assignment
	Yobsi = Y0
	Yobsi[units_assigned_to_Y] = Y1[units_assigned_to_Y]

	#Calculate the statistic
	avgY = mean( Yobsi[ units_assigned_to_Y ] )
	avgN = mean( Yobsi[ - units_assigned_to_Y ] )
	statistic <- c(statistic, avgY - avgN )
}

## Table of all the values of the statistic
table(statistic)
hist(statistic) ## Histogram

## Notice that the value we observed (4.5) is the most extreme value. 

sum(statistic>=Tobs)/length(statistic)
## 	CONCLUSION	##
## Thus, either the hypothesis is false, in that the effect of the 
##	treatment must be much larger to produce this value of the 
##	statistic, or the hypothesis is true and we drew one unlikely 
##	randomization that gave us this extreme value. 


###########################################

###########################################
### CI under constant additive treatment effect


tau = 1

Z = 1*(treatment=='Yes')

####  Hypothesis  Y_1i = Y_0i + tau  ###
## Potential outcomes when the NULL hypothesis is true
Y1 <- Yobs + (1-Z)*tau
Y0 <- Yobs - Z*tau

## Enumerate all 70 possible ways to pick 4 participants to the program
all_treatment_assignments <- combn(8,4)
all_treatment_assignments # Each column gives you the units that will get Treatment


## Calculate the statistic for all 70 possible assignments
statistic <- NULL

for(i in 1:70){	
  units_assigned_to_Y <- all_treatment_assignments[,i]
  
  # Imput response based on this treatment assignment
  Yobsi = Y0
  Yobsi[units_assigned_to_Y] = Y1[units_assigned_to_Y]
  
  #Calculate the statistic
  avgY = mean( Yobsi[ units_assigned_to_Y ] )
  avgN = mean( Yobsi[ - units_assigned_to_Y ] )
  statistic <- c(statistic, avgY - avgN )
}

## Table of all the values of the statistic
table(statistic)
hist(statistic) ## Histogram

## Notice that the value we observed (4.5) is the most extreme value. 

sum(statistic>=Tobs)/length(statistic)
