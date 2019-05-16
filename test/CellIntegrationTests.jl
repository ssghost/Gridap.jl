module CellIntegrationTests

using Test
using Gridap
using Gridap.FieldValues
using Gridap.CellValues
using Gridap.CellMaps
using Gridap.CellQuadratures
using Gridap.CellIntegration
using Gridap.Quadratures
using Gridap.Geometry
using Gridap.Geometry.Cartesian

grid = CartesianGrid(partition=(3,3))
trian = triangulation(grid)

@testset "Geomap" begin

  phi = geomap(trian)

  @test isa(phi,CellGeomap{2,2})

end

 @testset "Integrate" begin

 basis = cellbasis(trian)

 quad = quadrature(trian,order=2)

 m = varinner(basis,basis)

 mmat = integrate(m,trian,quad)

 @test isa(mmat,CellArray{Float64,2})

 ufun(x::Point{2}) = 1.0

 cellvol = integrate(ufun,trian,quad)

 @test isa(cellvol,CellValue{Float64})

 for vi in cellvol
   @assert vi ≈ (2.0/3)^2
 end

 end

@testset "Cellfield" begin

  ufun(x::Point{2}) = 2*x[1]+x[2]

  u = cellfield(trian,ufun)

  νfun(x::Point{2},u::Float64) = TensorValue(x[1], u*x[2], 0.0, u)

  ν(u) = cellfield(trian,νfun,u)

  @test isa(u,CellField{2,Float64})
  @test isa(ν(u),CellField{2,TensorValue{2,4}})

end

end # module CellIntegrationTests
