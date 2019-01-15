import Named

using Test, CuArrays

ims = rand(6, 96, 96, 3)

named_ims = Named.Array(ims, (:batch, :height, :width, :channels))

@test size(named_ims) == (6, 96, 96, 3)

@test size(named_ims, named=true) == (batch=6, height=96, width=96, channels=3)

@test size(named_ims, 1) == 6

@test size(named_ims, :width) == 96

@test size(named_ims, :channels) == 3

@test named_ims == ims

@test named_ims !== ims

ex = randn((height=96, width=96, channels=3))

ex_permuted = permutedims(ex, (:height, :channels, :width))

@test size(ex_permuted, named=true) == (height = 96, channels = 3, width = 96)

ones((a = 3, b = 5))

zeros((a = 3, b = 5))

trues((a = 3, b = 5))

falses((a = 3, b = 5))

x = fill(100, (a = 3, b = 5))

fill!(x, 1)

similar(x, 1, 2)

length(x)

eachindex(x)

@test size(reshape(x, 5, 3), named=true) == (a = 5, b = 3)

@test cu(x) isa Named.Array


X = Named.Array(
    [10 9 8
     7 6 5
     4 3 2],
    (:a, :b))


sort(X, dims=1)

@test sort(X, :a) isa Named.Array

@test 3 * X isa Named.Array

@test X * 3 isa Named.Array

@test X + X isa Named.Array
