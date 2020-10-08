set
t     "Time periods" /t0001*t0007/
node  "Location"
unit  "Conversion units"
node__unit(node, unit) "Conversion unit in a specific location"
;

parameter
capacity(unit)  "Capacity of a particular unit"
var_cost(unit)  "Variable cost of a unit"
demand(node, t)      "Energy demand in particular node at particular time"
r_obj
r_balance_marg(node, t) "Marginal value of the balance equation"
r_flow(unit, t)    "Energy flow in unit"
;

$gdxin %input_data_file%
$Load node unit node__unit capacity var_cost demand
$gdxin

variable
v_obj   "Objective value"
;

positive variable
v_flow(unit, t)  "Flow"
;

equation
q_obj
q_balance(node, t)
q_capacity(unit, t)
;


q_obj ..
  v_obj
  =e=
  sum((unit, t), v_flow(unit, t) * var_cost(unit))
;

q_balance(node, t) ..
  sum(unit$node__unit(node, unit), v_flow(unit, t))
  =g=
  demand(node, t)
;

q_capacity(unit, t) ..
  v_flow(unit, t)
  =l=
  capacity(unit)
;

model schedule /
q_obj
q_balance
q_capacity
/;

solve schedule using lp minimizing v_obj;

r_obj = v_obj.l;
r_balance_marg(node, t) = q_balance.m(node, t);
r_flow(unit, t) = v_flow.l(unit, t);

execute_unload '%output_data_file%' node unit r_obj r_balance_marg r_flow;
