#Q1
baseline <- c(140,138,150,148,135)
week2 <- c(132,135,151,146,130)
t.test(baseline, week2, paired=TRUE)

#Q2
1100 + c(-1,1)*30*qt(0.975, 9-1)/sqrt(9)

#Q3
pbinom(2, size=4, prob=0.5, lower.tail=FALSE)

#Q4
p <- 1 / 100
pr <- 10 / 1787
n <- 1787
serror <- sqrt(p * (1-p) / n)
z <- (p-pr) / serror
pnorm(z, lower.tail = FALSE)

#Q5
sp <- sqrt(((9-1)*1.5*1.5+(9-1)*1.8*1.8)/(9+9-2))
t <- (-3 - 1) / sp / sqrt(1/9+1/9)
p <- 2 * pt(t, 9+9-2)

#Q7
power.t.test(100, 0.01, 0.04, type="one.sample", alternative="one.sided")$power

#Q8
z <- qnorm(1-0.05)
pnorm(0 + z*0.04/sqrt(140), 0.01, 0.04/sqrt(140), lower.tail=FALSE)