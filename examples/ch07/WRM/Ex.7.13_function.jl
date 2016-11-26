using NMfE
using Base.Test

#=
@sym begin
  ClearAll(xi, yi, Y, R, sol, ytilde)
  xi = [0, 1//2, 1]
  yi = [0, a, 1]
  Y(x_) := LagrangePolynomial(xi, yi)
  #
  # Can be formulated as ytile(x) = F(x) + C1(a) * Ψ(x)
  #
  # F(x_) := 2*x^2 - x
  # C(a_) := -4a
  # Ψ(x_) := x^2 - x
  #
  #Y(x_) := F(x) + C(a)*Ψ(x)
  #
  R(x_) = Simplify(D(Y(x), x, 2) - 3*x - 4*Y(x))
  R(x_) = Simplify(R(x) ./ (a => -C1/4))
  SetJ(r, ToString(Simplify(R(x))))
end
=#

@sym begin
  CollocationWeightedResidualMethod(xi_, yi_) := Module(
    [Y, R, ytilde],
    begin
      Y(x_) := LagrangePolynomial(xi, yi)
      #
      # Can be formulated as ytile(x) = F(x) + C1(a) * Ψ(x)
      #
      # F(x_) := 2*x^2 - x
      # C(a_) := -4a
      # Ψ(x_) := x^2 - x
      #
      #Y(x_) := F(x) + C(a)*Ψ(x)
      #
      R(x_) = Simplify(D(Y(x), x, 2) - 3*x - 4*Y(x))
      R(x_) = Simplify(R(x) ./ (a => -C1/4))
      SetJ(r, ToString(Simplify(R(x))))
      Return(Simplify(R(x)))
    end
  )
end

function wrmcollocation(x1,y1)
    setsymata(:xin, List(x1...))
    setsymata(:yin, List(y1...))
    symeval(parse("Compile(Evaluate(CollocationWeightedResidualMethod(xin,yin)))"))
end

f1 = wrmcollocation([0.0,0.5,1.0], [0.0,0.6,1.0])

println("\n\nExample 7.13: y'' = 3x + 4y, y(0)=0, y(1)=1")
println("Residual for Weighted Residual Method using 1 point Lagragian Polynomial")
@sym Println("\nY(x) = ", Y(x), "\n")
@sym Println("R(x) = ", R(x), "\n")
println("( Example 7.14 gives: R = -4x^2*(2 + C1) + x*(1 + 4C1) + 2*(2 + C1) )", "\n")

@assert r == "4.0 + 2.0C1 - 3x - 4x*(-1.0 + 2.0x + C1*(-1 + x))"