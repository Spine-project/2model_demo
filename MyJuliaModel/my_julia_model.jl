using SpineInterface
using JuMP
using Clp
#using Plots

db_url = ARGS[1]

using_spinedb(db_url)

optimizer = optimizer_with_attributes(Clp.Optimizer)
m = Model(optimizer)

@variable(m, flow[(n, u) in node__unit()])

@constraint(m, unit_capacity[(n, u) in node__unit()], 
            flow[(node=n, unit=u)] <= capacity(unit=u))
            
@constraint(m, nodal_balance[n in node()],
            sum(flow[(node=n, unit=u)] for u in node__unit(node=n)) == demand(node=n))

@objective(m, Min, 
           sum(op_cost(unit=u) * flow[(node=n, unit=u)] for (n, u) in node__unit()))
           
optimize!(m)

#bar(value.(flow).data, xticks=((1, 2), u.name for u in unit()), label="flow")
