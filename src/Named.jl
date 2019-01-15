module Named

export Array, Matrix

import Base: size, getindex, setindex!, IndexStyle,
             randn, length, permutedims, iterate, eltype,
             ones

struct Array{T, N, S, A <: AbstractArray{T, N}} <: AbstractArray{T, N}
    data::A
end

Array(data::AbstractArray{T, N}, names::NTuple{N, Symbol}) where {T, N} =
    Array{T, N, NamedTuple{names}(size(data)), typeof(data)}(data)

const Matrix{T, S, A} = Array{T, 2, S, A}

const Vector{T, S, A} = Array{T, 1, S, A}

IndexStyle(::Type{<:Array{T, N, S, A}}) where {T, N, S, A} =
    IndexStyle(A)

size(array::Array{T, N, S}) where {T, N, S} = size(array.data)

size(array::Array{T, N, S}, n::Int) where {T, N, S} = size(array.data, n)

size(array::Array{T, N, S}, n::Symbol) where {T, N, S} =
    S[indexin([n], collect(keys(S)))[1]]

getindex(array::Array, i::Int) = array.data[i]

getindex(array::Array, I::Vararg{Int}) = array.data[I...]

setindex!(array::Array, v, i::Int) = array.data[i] = v

setindex!(array::Array, v, I::Vararg{Int}) = array.data[I...] = v

randn(dims::NamedTuple) = Array(randn(values(dims)...), keys(dims))

randn(T::Type, dims::NamedTuple) =
    Array(randn(T, values(dims)...), keys(dims))

ones(dims::NamedTuple) = Array(ones(values(dims)...), keys(dims))

ones(T::Type, dims::NamedTuple) = Array(ones(T, values(dims)...), keys(dims))

function permutedims(array::Array{T, N, S, A},
                     dims::NTuple{N, Symbol}) where {T, N, S, A}
    p = tuple(indexin(collect(dims), collect(keys(S)))...)
    Array(permutedims(array.data, p), dims)
end

end
