### CHECKLIST

## Basic plots: Total distribution and Time Series DONE (basic unweighted-ish)

## Combine old and new data. Remove irrelevant columns(from new). Clean data column classes using apply() DONE
## (Refinement possible. Consider further feature creation, reduction, column ordering)

## ggplot2 tutorial. Add regressor lines to scatter plots, distribution curves instead of blocky hists. WORKING (nearly there)
## Add grade weights (like class weights) to work around the discrete var problem with hist to density. (DONE)

## shiny package install + tutorial. Mess with selector options to replace a and b in p1 and m1 selections. WORKING (progress good)
## Work UI until it's a thing of beauty.

## Combine selction filers using && (relearn &&) (Maybe irrelevant)

## Investigate ML (regression) models to predict next semester GPA, with categorical considerations for semester.
## Install caret package, ref slides from reg + ML

## Please finish before 2016!!!!

### IDEAS AND STUFF ###

## Lets build some UI functionality, to set up the selector, codename Babymaker.

## Babymaker design:
## Major "handle"/Field of Study selector (ME, CS, etc.)[Dropdown/scroller, single select]
## Course selector (ME 2110, etc.)[Dropdown/scroller, single select] REACTIVE
## Prof selector [Dropdown/scroller, multi-select] REACTIVE
## Term filter [Year: slider multi/select, Term: checkbox filters (fall, spring, summer)]
## Plot type selector (if statement backend),(scatter, hist, single and head-to-head)

## Plot Dev:
## Density plots, convert wA lables to arbitrary % thresholds (standard grading curve) DONE
## Use grade boundaries to weight the data for scatter (avg by class by prof by term, compared by avg class weight for said parameters)

## Later update
## ML/Prediction featurettes based on lm line on plot (i.e. Predicted GPA next semester, based on parameters selected)

#### watch for changing lm gradients as year span changes (flatter for long?), figure out what is the optimal
#### number of years to be selected for good estimate plus low data usage.

## head-to-head comparisons (prof v prof, color-coded density plots lm plots.) (DONE, some refinement possible)