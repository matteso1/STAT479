d2 = read.csv('WLS_schooling_income.csv')


# idpub	# Public id from wls.
# gwiiq_bm	# Student's IQ
# edfa57q	# Father's education
# edmo57q	# Mother's education
# bmpin1	# Parent's income
# ocsf57	# occupation score
# ocpf57	# occupational prestige score
# incg400	# Parent's income in the top 1%
# incg250	# Parent's income in the top 5%
# relfml	# Catholic religion. TRUE = Catholic; FALSE = Non-Catholic
# res57	# A numeric code of area of residence of the graduate.
# hsdm57	# TRUE = Catholic schooling; FALSE = Public schooling.
# edfa57q.miss	# logical vector indicating whether edfa57q is missing.
# edmo57q.miss	# logical vectors indicating whether edmo57q is missing.
# bmpin1.miss	# logical vectors indicating whether bmpin1 is missing.
# ocsf57.miss	# logical vectors indicating whether ocsf57 is missing.
# ocpf57.miss	# logical vectors indicating whether ocpf57 is missing.
# res57Dic	# Urban or Rural. TRUE = Urban; FALSE = Rural.
# edfa57q.NoNA	# Father's education with NAs replaced by the average.
# edmo57q.NoNA	# Mother's education with NAs replaced by the average.
# bmpin1.NoNA	# Parent's income with NAs replaced by the average
# ocsf57.NoNA	# Occupation score with NAs replaced by the average.
# ocpf57.NoNA	# Occupational prestige score with NAs replaced by the average.
# yrwg74	# 1974 Graduate's wages and salaries in \$100's last year.


wages<-d2$yrwg74/10 # convert from hundreds to thousands
wages[wages<0]<-NA
d2<-cbind(d2,wages)
d2<-d2[!is.na(d2$wages),]
rm(wages)

d2$z = 1*(d2$school!='Public')

d2$l2bmpin1.NoNA<-log2(1+d2$bmpin1.NoNA)

attach(d2)
######################################
# Naive comparison
mean(wages[z==1])-mean(wages[z==0])

######################################
# imbalance
mean(gwiiq_bm[z==1])-mean(gwiiq_bm[z==0])


summarize_imbalance <- function(df, z, vars) {
  out <- lapply(vars, function(v) {
    x <- df[[v]]
    
    m1 <- mean(x[z == 1], na.rm = TRUE)
    m0 <- mean(x[z == 0], na.rm = TRUE)
    
    s1 <- var(x[z == 1], na.rm = TRUE)
    s0 <- var(x[z == 0], na.rm = TRUE)
    
    # standardized mean difference
    smd <- (m1 - m0) / sqrt((s1 + s0) / 2)
    
    data.frame(
      variable = v,
      mean_z1 = m1,
      mean_z0 = m0,
      diff = m1 - m0,
      smd = smd
    )
  })
  
  do.call(rbind, out)
}
vars <- c(
  "gwiiq_bm",
  "edfa57q.NoNA",
  "edmo57q.NoNA",
  "l2bmpin1.NoNA",
  "ocsf57.NoNA",
  "ocpf57.NoNA"
)

imbalance_table <- summarize_imbalance(d2, z, vars)
print(imbalance_table)



######################################
# Linear regression model
res = lm(wages~z+gwiiq_bm+edfa57q.miss+edmo57q.miss+bmpin1.miss+ocsf57.miss+
	edfa57q.NoNA+edmo57q.NoNA+l2bmpin1.NoNA+ocsf57.NoNA+ocpf57.NoNA, x=TRUE)

summary(res)

# Calculation using the FWL Theorem
ztilde = z-predict(lm(z~gwiiq_bm+edfa57q.miss+edmo57q.miss+bmpin1.miss+ocsf57.miss+
	edfa57q.NoNA+edmo57q.NoNA+l2bmpin1.NoNA+ocsf57.NoNA+ocpf57.NoNA))

coef(lm(wages~ztilde))

######################################
# Implied weights
theta = rep(NA, nrow(d2))
theta[z==1] = ztilde[z==1]/sum(ztilde^2)
theta[z==0] = -ztilde[z==0]/sum(ztilde^2)

sum((wages*theta)[z==1]) - sum((wages*theta)[z==0])
######################################
# Ploting the weights
par(mfrow=c(2,1))
for(id in 0:1){

	ord <- order(theta[z==id])          # indices that sort ztilde
	theta_sorted <- (theta[z==id])[ord]

	barplot(
  		theta_sorted,
  		names.arg = ord,
  		xlab = "Original index (sorted by theta)",
  		ylab = expression(theta),
  		main = paste("Sorted weights with original indices (for group z=",id,")"),
  		las = 2                     # rotate labels for readability
	)
	abline(h=1/sum(z==id), col='red')

}

summary(theta[z==1])
summary(theta[z==0])
sum(theta[z==1])
sum(theta[z==0])
#################
# difference in average wages after reweighting

######################################
# Global balance
sum((theta*gwiiq_bm)[z==1])-sum((theta*gwiiq_bm)[z==0])
sum((theta*edfa57q.NoNA)[z==1])-sum((theta*edfa57q.NoNA)[z==0])

######################################
# Misspecified variables may still be imbalanced

g = gwiiq_bm^2
sum((theta*g)[z==1])-sum((theta*g)[z==0])


