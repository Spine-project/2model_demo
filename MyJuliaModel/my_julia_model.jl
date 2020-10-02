using SpineInterface
using JuMP
using Clp
using Plots

db_url = ARGS[1]

using_spinedb(db_url)

optimizer = optimizer_with_attributes(Clp.Optimizer)
m = Model(optimizer)

@variable(m, flow[(u, n) in unit__node()])

@constraint(m, unit_capacity[(u, n) in unit__node()], 
            flow[(unit=u, node=n)] <= capacity(unit=u))
            
@constraint(m, nodal_balance[n in node()],
            sum(flow[(unit=u, node=n)] for u in unit__node(node=n)) == demand(node=n))

@objective(m, Min, 
           sum(op_cost(unit=u) * flow[(unit=u, node=n)] for (u, n) in unit__node()))
           
optimize!(m)

bar(value.(flow).data, xticks=((1, 2), u.name for u in unit()), label="flow")
