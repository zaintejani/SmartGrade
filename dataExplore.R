#### Grade Data Visualization Project ####

### Part 1: Data Exploration and Basic Plots

## Import final grade table
all<-read.csv("./Grade_data/final.csv", header=TRUE)

## Create UG dataframe with only Undergrad classes (to un-skew GPAs, class freqs)
UG<-all[grep("Undergraduate",all$Level),]

###########################

## all1 structure created to give smaller sample size to play around with.
## all1<-all[-grep("^very small",all$Class.Size),]

## a creates a table of professors by order of most data entries (classes taught with submitted grades)
a<-as.data.frame(table(UG$Name));a<-a[order(a$Freq, decreasing=TRUE),]

## b does the same as a, for course numbers
b<-as.data.frame(table(UG$Course));b<-b[order(b$Freq, decreasing=TRUE),]

## p1 creates a dataframe with the first (most frequent) prof's grade data
p1<-UG[UG$Name==a[1,1]|UG$Name==a[2,1],]

## m1 do the same as p1, for b instead of a
m1<-UG[UG$Course==b[1,1]|UG$Course==b[2,1],]

## Focus on p1, m1, try to start building basic plots
xvec<-apply(p1[,20:25],2,function(x) {mean(x)/mean(p1$Class.Weight)})
xvec<-cbind(c("A","B","C","D","F","W"),c(90,80,70,60,50,40),xvec)
xvec<-as.data.frame(xvec)
colnames(xvec)<-c("grade","weight","distribution")
xvec$weight<-as.numeric(as.character(xvec$weight));xvec$distribution<-as.numeric(as.character(xvec$distribution))

x2vec<-apply(m1[,20:25],2,function(x) {mean(x)/mean(m1$Class.Weight)})
x2vec<-cbind(c("A","B","C","D","F","W"),c(90,80,70,60,50,40),x2vec)
x2vec<-as.data.frame(x2vec)
colnames(x2vec)<-c("grade","weight","distribution")
x2vec$weight<-as.numeric(as.character(x2vec$weight));x2vec$distribution<-as.numeric(as.character(x2vec$distribution))

## Head-to-head versions of xvec
p1vec<-apply(p1[p1$Name==levels(as.factor(p1$Name))[1],20:25],2,function(x) {mean(x)/mean(p1$Class.Weight)})
p2vec<-apply(p1[p1$Name==levels(as.factor(p1$Name))[2],20:25],2,function(x) {mean(x)/mean(p1$Class.Weight)})
pvec<-cbind(c("A","B","C","D","F","W"),c(90,80,70,60,50,40),p1vec,p2vec)
pvec<-as.data.frame(pvec)
colnames(pvec)<-c("grade","weight","dist.P1", "dist.P2")
pvec$weight<-as.numeric(as.character(pvec$weight))
pvec$dist.P1<-as.numeric(as.character(pvec$dist.P1));pvec$dist.P2<-as.numeric(as.character(pvec$dist.P2))

m1vec<-apply(m1[m1$Name==levels(as.factor(m1$Name))[1],20:25],2,function(x) {mean(x)/mean(m1$Class.Weight)})
m2vec<-apply(m1[m1$Name==levels(as.factor(m1$Name))[2],20:25],2,function(x) {mean(x)/mean(m1$Class.Weight)})
mvec<-cbind(c("A","B","C","D","F","W"),c(90,80,70,60,50,40),m1vec,m2vec)
mvec<-as.data.frame(mvec)
colnames(mvec)<-c("grade","weight","dist.M1", "dist.M2")
mvec$weight<-as.numeric(as.character(mvec$weight))
mvec$dist.M1<-as.numeric(as.character(mvec$dist.M1));mvec$dist.M2<-as.numeric(as.character(mvec$dist.M2))

## Basic histogram showing weighted grade distribution
## By Professor
qplot(grade,distribution,data=xvec,geom="histogram",stat="identity", main=p1$Name[1])

## By Course
qplot(grade,distribution,data=x2vec,geom="histogram",stat="identity", main=m1$Course[1])

## Same as above, but density geometry instead for numeric relations, updated with new DF format
## By Professor
qplot(weight,distribution,data=xvec,geom="density",stat="identity", main=p1$Name[1])

## By Course
qplot(weight,distribution,data=x2vec,geom="density",stat="identity", main=m1$Course[1])

## Basic scatter plots for Calculated.GPA (unweighted) vs time (Term.Date), color-coded by Class.Size
## By Professor:
qplot(x=p1$Term.Date,y=p1$Calculated.GPA, color=as.factor(p1$Class.Size), main=p1$Name[1])
## By Course:
qplot(x=m1$Term.Date,y=m1$Calculated.GPA, color=as.factor(m1$Class.Size), main=m1$Course[1])

## Scatter plots for Calculated.GPA (unweighted) vs time (Term.Date) with regression lines
## By Professor (h2h)
qplot(x=p1$Term.Date,y=p1$Calculated.GPA, color=p1$Name, geom=c("point","smooth"), method="lm")
## By Course (h2h)
qplot(x=m1$Term.Date,y=m1$Calculated.GPA, color=m1$Course, geom=c("point","smooth"), method="lm")

## Head-to-head density plots (rudimentary, labels need adjusting)
## By Professor:
ggplot(pvec, aes(weight)) + 
  geom_line(aes(y = dist.P1, colour = "dist.P1")) + 
  geom_line(aes(y = dist.P2, colour = "dist.P2"))
## By Course:
ggplot(mvec, aes(weight)) + 
  geom_line(aes(y = dist.M1, colour = "dist.M1")) + 
  geom_line(aes(y = dist.M2, colour = "dist.M2"))