using SpineInterface
using JuMP
using Clp

db_url = ARGS[1]

using_spinedb(db_url)

optimizer = optimizer_with_attributes(Clp.Optimizer)
m = Model(optimizer)

# Get time indices
time = collect(demand(node=first(node())).indexes)
node__time = [(node=n, time=t) for n in node() for t in time]
node__unit__time = [(node=n, unit=u, time=t) for (n, u) in node__unit() for t in time]
node__node__time = [(node1=n1, node2=n2, time=t) for (n1, n2) in node__node() for t in time]

@variable(m, flow[[(node=n, unit=u, time=t) for (n, u, t) in node__unit__time]] >= 0)
#@variable(m, transfer[[(node1=n1, node2=n2, time=t) for (n1, n2, t) in node__node__time]])

@constraint(m, unit_capacity[(n, u, t) in node__unit__time], 
            flow[(node=n, unit=u, time=t)] <= capacity(unit=u))
            
@constraint(m, nodal_balance[(n, t) in node__time],
            sum(flow[(node=n, unit=u, time=t)] 
                for u in node__unit(node=n)) 
            == demand(node=n, time=t))

@constraint(m, transfer_righward[(n1,n2, t) in node__node__time],
            transfer[(node1=n1, node2=n2, time=t)] 
            <= transfer_capacity(node1=n1, node2=n2))

@objective(m, Min, 
           sum(op_cost(unit=u) * flow[(node=n, unit=u, time=t)] 
               for (n, u, t) in node__unit__time))
           
optimize!(m)

# Write results
output_db_url = ARGS[2]

parameters_1D = Dict(
    "objective" =>
    Dict(
        (model=:MyJuliaModel,) => objective_value(m)
    )
)
write_parameters(parameters_1D, output_db_url)

parameters_3D = Dict(
    "flow" =>
    Dict(
        (node=n, unit=u) => SpineInterface.Map(time, [value(flow[(node=n, unit=u, time=t)]) for t in time])
        for (n, u) in node__unit()
    )
)
write_parameters(parameters_3D, output_db_url)

parameters_2D = Dict(
    "price" =>
    Dict(
        (node=n,) => SpineInterface.Map(time, [dual(nodal_balance[(node=n, time=t)]) for t in time])
        for n in node()
    )
)
write_parameters(parameters_2D, output_db_url)

