// LinearCoupledDirichletBC.C
#include "LinearCoupledDirichletBC.h"

registerMooseObject("ThermomechanicsbccouplingApp", LinearCoupledDirichletBC);

InputParameters
LinearCoupledDirichletBC::validParams()
{
  InputParameters params = DirichletBCBase::validParams();
  params.addRequiredCoupledVar("coupled_variable",
                               "Displacement field u used in T = T_off + slope*u");
  params.addRequiredParam<Real>("T_off", "Constant term in T = T_off + slope*u");
  params.addRequiredParam<Real>("slope", "Coupling slope relating T to the displacement u");
  params.addClassDescription("Imposes T = T_off + slope*u as a Dirichlet condition, "
                             "with an exact, hand-coded off-diagonal Jacobian.");
  return params;
}

LinearCoupledDirichletBC::LinearCoupledDirichletBC(const InputParameters & parameters)
  : DirichletBCBase(parameters),
    _coupled_var(coupledValue("coupled_variable")),
    _coupled_var_num(coupled("coupled_variable")),
    _T_off(getParam<Real>("T_off")),
    _slope(getParam<Real>("slope"))
{
}

Real
LinearCoupledDirichletBC::computeQpValue()
{
  return _T_off + _slope * _coupled_var[_qp];
}

Real
LinearCoupledDirichletBC::computeQpJacobian()
{
  return 1.0;
}

Real
LinearCoupledDirichletBC::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (jvar == _coupled_var_num)
    return -_slope;
  return 0.0;
}