# example of a thermomechanical problem with a mechanical retroaction to the thermal BC.
[GlobalParams]
[]

l_bar = 1
sec_dim = 0.005

[Mesh]
  [block]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 20
    ny = 1
    nz = 1
    xmin = 0
    xmax = ${l_bar} 
    ymin = 0
    ymax = ${sec_dim}
    zmin = 0
    zmax = ${sec_dim}
    elem_type = HEX8
  []
[]

[Variables]
  [disp_x]
    # order = SECOND
  []
  [disp_y]
    # order = SECOND
  []
  [disp_z]
    # order = SECOND
  []
  [T]
    initial_condition = 300
  []
[]

[Kernels]
  [heat_conduction]
    type = HeatConduction
    variable = T
  []
[]

[Physics/SolidMechanics/QuasiStatic]
  displacements = 'disp_x disp_y disp_z'
  [block]
    strain = SMALL
    displacements = 'disp_x disp_y disp_z'
    eigenstrain_names = 'thermal_expansion'
    temperature = T
  []
[]

[Materials]
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 150e9       
    poissons_ratio = 0.3
  []
  [thermal_eigenstrain]
    type = ComputeThermalExpansionEigenstrain
    temperature = T
    thermal_expansion_coeff = 2.e-5
    stress_free_temperature = 300   # T_ref
    eigenstrain_name = thermal_expansion
  []
  [stress]
    type = ComputeLinearElasticStress
  []
  [conductivity]
    type = HeatConductionMaterial
    thermal_conductivity = 50     # W/(m.K)
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

  #Displacements in the y-direction are fixed on all the boundary (axial displavcement only)
  [fix_disp_y] 
    type = DirichletBC
    variable = disp_y
    boundary = left
    #boundary = 'front back top bottom left right'
    value = 0
  []
  #Displacements in the z-direction are fixed on all the boundary (axial displavcement only)
  [fix_disp_z] 
    type = DirichletBC
    variable = disp_z
    boundary = left
    #boundary = 'front back top bottom left right'
    value = 0
  [] 

  ## thermal
  [T_left]
    type = DirichletBC
    variable = T
    boundary = left
    value = 300        # T_ref
  []
  [T_right_coupled]
    type = LinearCoupledDirichletBC
    variable = T
    boundary = right
    coupled_variable = disp_x
    T_off = 320
    slope = -1.e5      # slope = L *1e5 
  []
[]

[Executioner]
  type = Steady
  solve_type = NEWTON
  automatic_scaling = false
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  # petsc_options_iname = '-pc_type -pc_hypre_type'
  # petsc_options_value = 'hypre boomeramg'
  # for conditioning analysis (with Newton solve)
  # petsc_options = '-pc_svd_monitor'
  # petsc_options_iname = '-pc_type'
  # petsc_options_value = 'svd' 
  line_search= 'none'
  verbose=true
  nl_max_its = 10
  nl_rel_tol = 1e-08
  nl_abs_tol = 1e-10
  l_max_its = 30
  l_abs_tol = 1e-15
  l_tol = 1e-12
[]

[Preconditioning]
  [smp]
    type=SMP
    full= true
  []
[]  

[Postprocessors]
  [disp_right]
    type = PointValue
    point = '${l_bar} ${fparse sec_dim/2} ${fparse sec_dim/2}'
    variable = disp_x
  []
  [T_right]
    type = PointValue
    point = '${l_bar} ${fparse sec_dim/2} ${fparse sec_dim/2}'
    variable = T
  []
[]

# [VectorPostprocessors]
#   [line_sample]
#     type = LineValueSampler
#     start_point = '0 0. 0.'
#     end_point = '1.0 0. 0.'
#     num_points = 101
#     variable = 'disp_x T'
#     sort_by = x
#   []
# []

[Outputs]
  exodus = true
  csv = true
  perf_graph = true
[]