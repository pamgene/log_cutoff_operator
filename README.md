# log_cutoff operator

##### Description

The `log_cutoff operator` Transforms data using a logarithmic function with an optional cut-off of values.

##### Usage

Input projection|.
---|---
`x-axis`        | numeric, x values, per cell 

Input parameters|.
---|---
`Treatment of negative values`          | How to handle negative values, options: 'Mask at cut-off','None', 'Quantile Shift'
`shift by quantile`                     | Shift by quantile
`shift offset`                          | Shift offset
`cut-off`                               | Cut-off
`logBase`                               | base value of the logarithmic function
`Treatment of multiple values per cell` | How to handle multiple values per cell, options: 'Fail','None', 'Average'

Output relations|.
---|---
`value`          | numeric, value returned per data point

##### Details

Transforms data using a logarithmic function. The operation is performed based on the input parameters and the resulting values per data point are returned.
