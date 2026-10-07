// LinearCoupledDirichletBC.h
#pragma once
#include "DirichletBCBase.h"

class LinearCoupledDirichletBC : public DirichletBCBase
{
public:
  static InputParameters validParams();
  LinearCoupledDirichletBC(const InputParameters & parameters);

protected:
  virtual Real computeQpValue() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned int jvar) override;

  const VariableValue & _coupled_var;
  const unsigned int _coupled_var_num;
  const Real _T_off;
  const Real _slope;
};