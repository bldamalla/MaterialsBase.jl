# this contains type definition for MaterialImage objects

import Base: eltype, size, length, unique
import Base: +, /, mean, ==, !=, normalize, normalize!

"""
MaterialImage

Construct a material image data structure given arrays of states, array
dimensions and the number of considered discrete local states.
"""
struct MaterialImage
  states::Vector{T<:AbstractFloat}
  dims::Tuple{Int64,Int64}
  discs::Int64
end

# constructors and some operations
MaterialImage(img::Vector{T<:AbstractFloat}, dims::Tuple{Int,Int}, discs=2::Int) = begin
  if length(img) != prod(dims)
    throw(InitError())
  end
  if minimum(img) < 0.0
    throw(InitError())
  end
  if discs < 2
    throw(InitError())
  end
  return MaterialImage(img, dims, discs)
end
MaterialImage(img::Array{T<:AbstractFloat, 2}, discs::Int) = MaterialImage(reshape(img, length(img), 1), size(img), discs)
size(img::MaterialImage) = img.dims
length(img::MaterialImage) = prod(size(img))
unique(img::MaterialImage) = img.discs
eltype(img::MaterialImage) = eltype(img.states)
segmented(img::MaterialImage) = (unique(img) == unique(img.states))
