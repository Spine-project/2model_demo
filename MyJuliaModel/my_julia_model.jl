using SpineInterface
using JuMP
using Clp
using Plots

db_url = ARGS[1]

using_spinedb(db_url)
m = Model(optimizer)

@variable(m, flow[(pp, gn) in powerplant__grid_node()])