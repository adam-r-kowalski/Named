module Named

export Array, Matrix

import CuArrays: cu

import Base: size, getindex, setindex!, IndexStyle,
             randn, length, permutedims, iterate, eltype,
             ones, zeros, trues, falses, fill, reshape, sort,
             *, +

struct Array{T, N, S, A <: AbstractArray{T, N}} <: AbstractArray{T, N}
    data::A
end

Array(data::AbstractArray{T, N}, names::NTuple{N, Symbol}) where {T, N} =
    Array{T, N, NamedTuple{names}(size(data)), typeof(data)}(data)

const Matrix{T, S, A} = Array{T, 2, S, A}

const Vector{T, S, A} = Array{T, 1, S, A}

IndexStyle(::Type{<:Array{T, N, S, A}}) where {T, N, S, A} =
    IndexStyle(A)

size(array::Array{T, N, S}; named=false) where {T, N, S} =
    named ? S : size(array.data)

size(array::Array{T, N, S}, n::Int) where {T, N, S} = size(array.data, n)

symbol_index(::Array{T, N, S}, s::Symbol) where {T, N, S} =
    indexin([s], collect(keys(S)))[1]

size(array::Array{T, N, S}, n::Symbol) where {T, N, S} =
    S[symbol_index(array, n)]

getindex(array::Array, i::Int) = array.data[i]

getindex(array::Array, I::Vararg{Int}) = array.data[I...]

setindex!(array::Array, v, i::Int) = array.data[i] = v

setindex!(array::Array, v, I::Vararg{Int}) = array.data[I...] = v

randn(dims::NamedTuple) = Array(randn(values(dims)...), keys(dims))

randn(T::Type, dims::NamedTuple) =
    Array(randn(T, values(dims)...), keys(dims))

ones(dims::NamedTuple) = Array(ones(values(dims)...), keys(dims))

ones(T::Type, dims::NamedTuple) = Array(ones(T, values(dims)...), keys(dims))

zeros(dims::NamedTuple) = Array(zeros(values(dims)...), keys(dims))

zeros(T::Type, dims::NamedTuple) = Array(zeros(T, values(dims)...), keys(dims))

trues(dims::NamedTuple) = Array(trues(values(dims)...), keys(dims))

falses(dims::NamedTuple) = Array(falses(values(dims)...), keys(dims))

fill(x, dims::NamedTuple) = Array(fill(x, values(dims)...), keys(dims))

function permutedims(array::Array{T, N, S, A},
                     dims::NTuple{N, Symbol}) where {T, N, S, A}
    p = tuple(indexin(collect(dims), collect(keys(S)))...)
    Array(permutedims(array.data, p), dims)
end

reshape(array::Array{T, N, S}, dims::NTuple{N, Int}) where {T, N, S} =
    Array(reshape(array.data, dims), keys(S))

sort(array::Array{T, N, S}, dims::Symbol) where {T, N, S} =
    Array(sort(array.data, dims=symbol_index(array, dims)), keys(S))

cu(array::Array{T, N, S}) where {T, N, S} = Array(cu(array.data), keys(S))

*(x::Number, array::Array{T, N, S}) where {T, N, S} =
    Array(x * array.data, keys(S))

*(array::Array{T, N, S}, x::Number) where {T, N, S} =
    Array(array.data * x, keys(S))

+(a1::Array{T1, N, S}, a2::Array{T2, N, S}) where {T1, T2, N, S} =
    Array(a1.data + a2.data, keys(S))

end
