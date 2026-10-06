#include "ThermomechanicsbccouplingApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
ThermomechanicsbccouplingApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

ThermomechanicsbccouplingApp::ThermomechanicsbccouplingApp(const InputParameters & parameters) : MooseApp(parameters)
{
  ThermomechanicsbccouplingApp::registerAll(_factory, _action_factory, _syntax);
}

ThermomechanicsbccouplingApp::~ThermomechanicsbccouplingApp() {}

void
ThermomechanicsbccouplingApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAllObjects<ThermomechanicsbccouplingApp>(f, af, syntax);
  Registry::registerObjectsTo(f, {"ThermomechanicsbccouplingApp"});
  Registry::registerActionsTo(af, {"ThermomechanicsbccouplingApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
ThermomechanicsbccouplingApp::registerApps()
{
  registerApp(ThermomechanicsbccouplingApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
ThermomechanicsbccouplingApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ThermomechanicsbccouplingApp::registerAll(f, af, s);
}
extern "C" void
ThermomechanicsbccouplingApp__registerApps()
{
  ThermomechanicsbccouplingApp::registerApps();
}
