import Named

using Test

@test Named.Array(randn(2, 2), (:batch, :height)) isa Named.Matrix

@test Named.Array(randn(2), (:batch,)) isa Named.Vector

ims = rand(6, 96, 96, 3)

named_ims = Named.Array(ims, (:batch, :height, :width, :channels))

@test size(named_ims) == (6, 96, 96, 3)

@test size(named_ims, 1) == 6

@test size(named_ims, :width) == 96

@test size(named_ims, :channels) == 3

ex = randn((height=96, width=96, channels=3))

ex2 = randn(Float32, (height=96, width=96, channels=3))

ex3 = permutedims(ex, (:height, :channels, :width))

3named_ims.^2

ex[1, 2, :]

eltype(ex2)

x = randn((bedrooms = 3, bathrooms = 2, square_footage = 1000))

permutedims(x, (:square_footage, :bedrooms, :bathrooms))

permutedims(x, (1, 2, 3))

ones((a = 3, b = 5)) * ones(5, 4)
