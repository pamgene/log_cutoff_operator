# log_cutoff operator

##### Description

The `log_cutoff operator` Transforms data using a logarithmic function with an optional cut-off of values.

##### Usage

Input projection|.
---|---
`y-axis`        | numeric, y values, per cell 

Input parameters|.
---|---
`Treatment of negative values`          | How to handle negative values, options: 'Mask at cut-off','None'
`cut-off`                               | Cut-off
`logBase`                               | base value of the logarithmic function

Output relations|.
---|---
`value`          | numeric, value returned per data point

##### Details

Transforms data using a logarithmic function. The operation is performed based on the input parameters and the resulting value per data point is returned. The operator expects that there is at maximum 1 value per cell, if there are multiple values the operator will fail.
