using SpineInterface
using JuMP
using Clp

db_url = ARGS[1]

using_spinedb(db_url)

optimizer = optimizer_with_attributes(Clp.Optimizer)
m = Model(optimizer)

# Get time indices
time = sort(collect(keys(demand(node=node()[1]).mapping)))
node__time = [(node=n, time=t) for n in node() for t in time]
node__unit__time = [(node=n, unit=u, time=t) for (n, u) in node__unit() for t in time]

@variable(m, flow[[(node=n, unit=u, time=t) for (n, u, t) in node__unit__time]])

@constraint(m, unit_capacity[(n, u, t) in node__unit__time], 
            flow[(node=n, unit=u, time=t)] <= capacity(unit=u))
            
@constraint(m, nodal_balance[(n, t) in node__time],
            sum(flow[(node=n, unit=u, time=t)] 
                for u in node__unit(node=n)) 
            == demand(node=n, time=t))

@objective(m, Min, 
           sum(op_cost(unit=u) * flow[(node=n, unit=u, time=t)] 
               for (n, u, t) in node__unit__time))
           
optimize!(m)

# TODO
#output_db_url = ARGS[2]
#write_parameters(, output_db_url)
