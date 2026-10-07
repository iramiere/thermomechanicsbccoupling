# example of a thermomechanical problem with a mechanical retroaction to the thermal BC.
# but 1D confinement effect here : eps_yy=eps_zz=0 (not free)

[Mesh]
  [block]
    type = GeneratedMeshGenerator
    dim = 1
    nx = 20
    ny = 4
    nz = 4
    xmin = 0
    xmax = 1   
  []
[]

[Variables]
  [disp_x]
  []
  [T]
#    initial_condition = 300
  []
[]

[Kernels]
  [heat_conduction]
    type = HeatConduction
    variable = T
  []
[]

[Physics/SolidMechanics/QuasiStatic]
  displacements = 'disp_x'
  [block]
    strain = SMALL
    displacements = 'disp_x'
    eigenstrain_names = 'thermal_expansion'
    temperature = T
  []
[]

[Materials]
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 150e9       # Cu, Pa
    poissons_ratio = 0.3
  []
  [thermal_eigenstrain]
    type = ComputeThermalExpansionEigenstrain
    temperature = T
    thermal_expansion_coeff = 2e-5
    stress_free_temperature = 300   # T_ref
    eigenstrain_name = thermal_expansion
  []
  [stress]
    type = ComputeLinearElasticStress
  []
  [conductivity]
    type = HeatConductionMaterial
    thermal_conductivity = 50     # Cu, W/(m.K)
  []
[]

[BCs]
  ## mechanics
  [disp_x_left]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value = 0
  []
  ## thermal
  [T_left]
    type = DirichletBC
    variable = T
    boundary = left
    value = 300        # T_ref
  []  
  # [T_right]
  #   type = DirichletBC
  #   variable = T
  #   boundary = right
  #   value = 320       
  # []
  [T_right_coupled]
    type = LinearCoupledDirichletBC
    variable = T
    boundary = right
    coupled_variable = disp_x
    T_off = 320
    slope = 0.1e5      # slope = L *1e5 
  []
[]

[Executioner]
  type = Steady
  solve_type = NEWTON
  # petsc_options = '-snes_test_jacobian'
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  line_search= NONE
  verbose=true
  nl_max_its = 5
  nl_rel_tol = 1e-08
  nl_abs_tol = 1e-8
  l_max_its = 30
  l_abs_tol = 1e-15
  l_tol = 1e-12
[]

[Postprocessors]
  [disp_right]
    type = PointValue
    point = '1 0 0'
    variable = disp_x
    execute_on = 'INITIAL TIMESTEP_BEGIN LINEAR NONLINEAR TIMESTEP_END'
  []
  [T_right]
    type = PointValue
    point = '1 0 0 '
    variable = T
    execute_on = 'INITIAL TIMESTEP_BEGIN LINEAR NONLINEAR TIMESTEP_END'
  []
[]

# [VectorPostprocessors]
#   [line_sample]
#     type = LineValueSampler
#     start_point = '0 0 0'
#     end_point = '1.0 0 0'
#     num_points = 101
#     variable = 'disp_x T'
#     sort_by = x
#   []
# []

[Outputs]
  exodus = true
  csv = true
  perf_graph = true
 [console]
    type = Console
    all_variable_norms = true
    # execute_postprocessors_on = 'nonlinear'
    execute_on = 'INITIAL TIMESTEP_BEGIN LINEAR NONLINEAR FAILED TIMESTEP_END'
  []
[]