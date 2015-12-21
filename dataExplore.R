#### Grade Visualization/Filter/Refine/Predict Project ####

### PART 0: Data import and cleaning

old<-read.csv("./Grade_data/199908_to_201208.csv", header=FALSE)
new1<-read.csv("./Grade_data/201305.csv", header=TRUE)
new2<-read.csv("./Grade_data/201308_201402_201405.csv", header=TRUE)

## Normalizing column names for new datasets
colnames(new1)<-colnames(new2)
new0<-rbind(new1,new2)

## Reordering columns to align old and new datasets
oLev<-old[,12];oTerm<-old[,3]
old<-old[,-c(3,12)];old<-cbind(oTerm,old,oLev)

## Removing unnecessary columns (irrelevant to GPA, also to help combine datasets)
new1<-new0[,-c(4,11:15,17)]

## Assigning columnn manes to old dataset
colnames(old)<-colnames(new1)

### CLEANING COLUMNS ###

## Calculated GPA:
new1$Calculated.GPA<-as.numeric(as.character(new1$Calculated.GPA))
new2<-new1[!apply(new1, 1, function(x) any(is.na(x))),]

## Grade distributions (A,B,C,D,F,W)
new2[,5:10]<-apply(new2[,5:10],2,function(x) as.character(x))

new2$A[new2$A==""]<-"0%";new2$B[new2$B==""]<-"0%";new2$C[new2$C==""]<-"0%"
new2$D[new2$D==""]<-"0%";new2$F[new2$F==""]<-"0%";new2$W[new2$W==""]<-"0%"

new2[,5:10]<-apply(new2[,5:10],2,function(x) gsub("%","",x))

new2[,5:10]<-apply(new2[,5:10],2,function(x) as.numeric(x))

## Cleaning Term column to better format
new2$Term<-as.character(new2$Term)
adjTerm<-c("Summer 2013", "Fall 2013", "Spring 2014", "Summer 2014")
new2$Term<-gsub(levels(as.factor(new2$Term)), adjTerm[1], new2$Term)
new2$Term<-gsub(levels(as.factor(new2$Term)), adjTerm[2], new2$Term)
new2$Term<-gsub(levels(as.factor(new2$Term)), adjTerm[3], new2$Term)
new2$Term<-gsub(levels(as.factor(new2$Term)), adjTerm[4], new2$Term)

## Changing all remining columns to class "character" for easier manipulation
new2[,c(2:4,11,13)]<-apply(new2[,c(2:4,11,13)],2,function(x) as.character(x))
old[,c(1:4,11,13)]<-apply(old[,c(1:4,11,13)],2,function(x) as.character(x))

## Putting together datasets to finally get going somewhere!!
all<-rbind(old, new2)
rm("old","new0","new1","new2","oLev","oTerm","adjTerm")

### Continue CLEANING COLUMNS, feature creation

## Class Size (to prevent duplicates due to CaSe differences)
all$Class.Size<-tolower(all$Class.Size)

## Creating adjusted Total to account for removed columns (non-GPA factors, excluding W)
all$Total<-apply(all[,5:10],1,function(x) sum(x))

## Adding weights by Class Size
Class.Weight<-numeric()
Class.Weight[grep("^very small",all$Class.Size)]<-10
Class.Weight[grep("^small",all$Class.Size)]<-20
Class.Weight[grep("mid",all$Class.Size)]<-30
Class.Weight[grep("^large",all$Class.Size)]<-50
Class.Weight[grep("^very large",all$Class.Size)]<-100
all<-cbind(all,Class.Weight)

## Cleaning Name column, normalizing spacing to prevent dupilcates.
all$Name<-as.character(all$Name)
all$Name<-gsub(", ",",",all$Name)
all$Name<-gsub(",",", ",all$Name)

## Calculating grades given out relative to class size/weight to account for the magnitude factor.
all$wA<-round((all$A/all$Total)*all$Class.Weight,2)
all$wB<-round((all$B/all$Total)*all$Class.Weight,2)
all$wC<-round((all$C/all$Total)*all$Class.Weight,2)
all$wD<-round((all$D/all$Total)*all$Class.Weight,2)
all$wF<-round((all$F/all$Total)*all$Class.Weight,2)
all$wW<-round((all$W/all$Total)*all$Class.Weight,2)

## Creating "Field" feature for input filters
Field<-gsub("[0-9]", "",all$Course);Field<-gsub(" ", "",Field)

## Adjusting Term column to date formats, for time series plots and trends
Term.Mth<-character()
Term.Mth[grep("Fall",all$Term)]<-"-12-01"
Term.Mth[grep("Summer",all$Term)]<-"-07-01"
Term.Mth[grep("Spring",all$Term)]<-"-04-01"

Semester<-gsub("[0-9]","",all$Term)
Semester<-gsub(" ","",Semester)

Term.Yr<-gsub("[A-Za-z]","",all$Term)
Term.Yr<-gsub(" ","",Term.Yr)

Term.Date<-paste(Term.Yr,Term.Mth,sep="")

Term.Date<-as.POSIXct(Term.Date,"%Y-%m-%d")

all<-cbind(Term.Date,Term.Yr,Semester,Field,all)

## Final sweep to clean for NA values
all<-all[!apply(all, 1, function(x) any(is.na(x))),]

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
