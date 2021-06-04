library(tercen)
library(dplyr)
library(reshape)

log.cutoff <- function(df, treatment_negative_values, shift_offset, cut_off, log_base) {
  count = cast(df, .ri~.ci, value = ".y", fun.aggregate = length)
  if (any(count[,-1] > 1)) {
    stop("Error: multiple values per technical replication have been found.")
  }
  
  treatment_negative_values <- "None"
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
shift_offset              <- ifelse(is.null(ctx$op.value('shift offset')), 1, as.double(ctx$op.value('shift offset')))
cut_off                   <- ifelse(is.null(ctx$op.value('cut-off')), 1, as.double(ctx$op.value('cut-off')))
log_base                  <- ifelse(is.null(ctx$op.value('logBase')), 2, as.double(ctx$op.value('logBase')))

ctx %>% 
  select(.ci, .ri, .y) %>%
  log.cutoff(., treatment_negative_values, shift_offset, cut_off, log_base) %>%
  ctx$addNamespace() %>%
  ctx$save()
