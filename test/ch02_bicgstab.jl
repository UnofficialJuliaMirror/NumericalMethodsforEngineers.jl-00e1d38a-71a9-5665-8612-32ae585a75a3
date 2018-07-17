using NumericalMethodsforEngineers

N = 8
tol = 1.0e-10
limit = 1000

a = float(rand(1:10 * N, N, N))
x = float(rand(1:10, N))
b = a * x
x0 = ones(N)
(iters, converged, r2) = NumericalMethodsforEngineers.bicgstab(a, b, x0; tol=tol, limit=limit)

@assert round.(a\b, 5) == round.(r2, 5)

