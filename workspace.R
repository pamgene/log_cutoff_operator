library(tercen)
library(plyr)
library(dplyr)
library(reshape)

# Set appropriate options
#options("tercen.serviceUri"="http://tercen:5400/api/v1/")
#options("tercen.workflowId"= "4133245f38c1411c543ef25ea3020c41")
#options("tercen.stepId"= "2b6d9fbf-25e4-4302-94eb-b9562a066aa5")
#options("tercen.username"= "admin")
#options("tercen.password"= "admin")


cellMean <- function(df){
  return(c(.ri = df$.ri[1], .ci = df$.ci[1], y = mean(df$.y)))
}

log.cutoff <- function(df, treatment_multiple_values, treatment_negative_values, shift_by_quantile, shift_offset, cut_off, log_base) {
  
  if (treatment_multiple_values == 'Fail') {
    # TODO
    #check(MultipleValuesPerCell, data)
  } else {
    count = cast(df, .ri~.ci, value = ".y", fun.aggregate = length)
    if (any(count[,-1] > 1)){
      print(message = "Multiple values per technical replication have been found. Averaging after log transformation!")
      df = ddply(df, .ri~.ci, .fun = cellMean)
    }
  }
  
  if (treatment_negative_values == "Quantile Shift"){
    shift =  quantile(df$.y, shift_by_quantile, na.rm = TRUE)
  } 
  else{
    shift_by_quantile <- NaN
    shift_offset      <- 0
  }
  
  if (treatment_negative_values == "None"){
    shift_offset <- 0
    cut_off      <- 0
  }
  
  if (log_base >= 0){
    df$.y <- df$.y + shift_offset
    bCut  <- df$.y < cut_off
    df$.y[bCut] = cut_off
    result = data.frame(.ri = df$.ri, .ci = df$.ci, logTransformed = log(df$.y, log_base))
  } else {
    result = data.frame(.ri = df$.ri, .ci = df$.ci, logTransformed = df$.y)
  }
  result
}

ctx = tercenCtx()

treatment_negative_values <- ifelse(is.null(ctx$op.value('Treatment of negative values')), 'Mask at cut-off', ctx$op.value('Treatment of negative values'))
shift_by_quantile         <- ifelse(is.null(ctx$op.value('shift by quantile')), 0.01, ctx$op.value('shift by quantile'))
shift_offset              <- ifelse(is.null(ctx$op.value('shift offset')), 1, ctx$op.value('shift offset'))
cut_off                   <- ifelse(is.null(ctx$op.value('cut-off')), 1, ctx$op.value('cut-off'))
log_base                  <- ifelse(is.null(ctx$op.value('logBase')), 2, ctx$op.value('logBase'))
treatment_multiple_values <- ifelse(is.null(ctx$op.value('Treatment of multiple values per cell')), 'Fail', ctx$op.value('Treatment of multiple values per cell'))

ctx %>% 
  select(.ci, .ri, .y) %>%
  log.cutoff(., treatment_multiple_values, treatment_negative_values, shift_by_quantile, shift_offset, cut_off, log_base) %>%
  ctx$addNamespace() %>%
  ctx$save()
