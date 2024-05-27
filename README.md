# log_cutoff operator

##### Description

The `log_cutoff operator` Transforms data using a logarithmic function with an optional cut-off of value.

##### Usage

Input projection|.
---|---
`y-axis`        | numeric, y value, per cell 

Input parameters|.
---|---
`Treatment of negative values`          | How to handle negative values, options: 'Mask at cut-off','None'
`cut-off`                               | Cut-off
`logBase`                               | base value of the logarithmic function

Output relations|.
---|---
`logTransformed`          | numeric, value returned per data point

##### Details

Transforms data using a logarithmic function. The operation is performed based on the input parameters and the resulting value per data point is returned. The operator expects that there is at maximum 1 value per cell, if there are multiple values the operator will fail.
The "Mask at cut-off' option handles negative values by assigning 1 to values below a cut-off, which is 1 by default. In this way, peptides with S100 signals equal to or below 1 will have logtransformed values of 0.
