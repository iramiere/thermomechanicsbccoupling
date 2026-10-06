//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "ThermomechanicsbccouplingTestApp.h"
#include "ThermomechanicsbccouplingApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
ThermomechanicsbccouplingTestApp::validParams()
{
  InputParameters params = ThermomechanicsbccouplingApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

ThermomechanicsbccouplingTestApp::ThermomechanicsbccouplingTestApp(const InputParameters & parameters) : MooseApp(parameters)
{
  ThermomechanicsbccouplingTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

ThermomechanicsbccouplingTestApp::~ThermomechanicsbccouplingTestApp() {}

void
ThermomechanicsbccouplingTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  ThermomechanicsbccouplingApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"ThermomechanicsbccouplingTestApp"});
    Registry::registerActionsTo(af, {"ThermomechanicsbccouplingTestApp"});
  }
}

void
ThermomechanicsbccouplingTestApp::registerApps()
{
  registerApp(ThermomechanicsbccouplingApp);
  registerApp(ThermomechanicsbccouplingTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
ThermomechanicsbccouplingTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ThermomechanicsbccouplingTestApp::registerAll(f, af, s);
}
extern "C" void
ThermomechanicsbccouplingTestApp__registerApps()
{
  ThermomechanicsbccouplingTestApp::registerApps();
}
