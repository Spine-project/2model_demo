set
t     "Time periods" /t0001*t0007/
node  "Location"
unit  "Conversion units"
node__unit(node, unit) "Conversion unit in a specific location"
node__node(node, node) "Transfer connection between two nodes"
;

alias (node, node_left, node_right);

parameter
capacity(unit)  "Capacity of a particular unit"
var_cost(unit)  "Variable cost of a unit"
ramp_up(unit)   "Upward ramp limit in p.u."
demand(node, t)      "Energy demand in particular node at particular time"
transfer_capacity(node, node) "Transfer capacity between two nodes"
r_obj
r_balance_marg(node, t) "Marginal value of the balance equation"
r_flow(unit, t)    "Energy flow in unit"
r_transfer(node, node, t) "Transfer between nodes"
;

$gdxin %input_data_file%
$Load node unit node__unit capacity var_cost ramp_up demand node__node transfer_capacity
$gdxin

variable
v_obj   "Objective value"
v_transfer(node, node, t) "Transfer"
;

positive variable
v_flow(unit, t)  "Flow"
;

v_transfer.up(node__node(node_left, node_right), t) = transfer_capacity(node_left, node_right);
v_transfer.lo(node__node(node_left, node_right), t) = -transfer_capacity(node_left, node_right);


equation
q_obj
q_balance(node, t)
q_capacity(unit, t)
q_ramp_up_constraint(unit, t)
;


q_obj ..
  v_obj
  =e=
  sum((unit, t), v_flow(unit, t) * var_cost(unit))
;

q_balance(node, t) ..
  + sum(unit$node__unit(node, unit), v_flow(unit, t))
  + sum(node_left$(node__node(node_left, node)), v_transfer(node_left, node, t))
  =e=
  + sum(node_right$(node__node(node, node_right)), v_transfer(node, node_right, t))
  + demand(node, t)
;

q_capacity(unit, t) ..
  v_flow(unit, t)
  =l=
  capacity(unit)
;

q_ramp_up_constraint(unit, t)$ramp_up(unit)..
  v_flow(unit, t)
  =l=
  v_flow(unit, t-1)
  + ramp_up(unit) * capacity(unit)
;

model schedule /
q_obj
q_balance
q_capacity
q_ramp_up_constraint
/;

solve schedule using lp minimizing v_obj;

r_obj = v_obj.l;
r_balance_marg(node, t) = q_balance.m(node, t);
r_flow(unit, t) = v_flow.l(unit, t);
r_transfer(node__node(node, node), t) = v_transfer.l(node, node, t);

execute_unload '%output_data_file%' node unit r_obj r_balance_marg r_flow r_transfer;
