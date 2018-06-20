# this contains type definition for MaterialImage objects

import Base: eltype, size, length, unique
import Base: +, /, mean, ==, !=, normalize!

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
  return MaterialImage(img, dims, min(discs, unique(img)))
end
MaterialImage(img::Array{T<:AbstractFloat, 2}, discs::Int) = MaterialImage(reshape(img, length(img), 1), size(img), discs)
size(img::MaterialImage) = img.dims
length(img::MaterialImage) = prod(size(img))
unique(img::MaterialImage) = img.discs
eltype(img::MaterialImage) = eltype(img.states)
segmented(img::MaterialImage) = (unique(img) == unique(img.states))

# math operations
function normalize!(img::MaterialImage)
  mn = minimum(img.states)
  for i=1:length(img)
    img.states[i] = img.states[i] - mn
  end
  mx = maximum(img.states)
  for i=1:length(img.states)
    img.states[i] = img.states ./ mx
  end
  return nothing
end
normal(img::MaterialImage) = (maximum(img.states) == 1.0 & minimum(img.states) == 0.0)

==(img1::MaterialImage, img2::MaterialImage) = ((img1.dims == img2.dims) & (img1.discs == img2.discs))
!=(img1::MaterialImage, img2::MaterialImage) = !(img1 == img2)
+(img1::MaterialImage, img2::MaterialImage) = begin
  if img1 != img2
    throw(InexactError())
  end
  normalize!(img1); normalize!(img2)
  return MaterialImage(img1.states + img2.states, img1.dims, img1.discs)
end
/(img::MaterialImage, N::Int) = begin
  for i=1:length(img)
    img.states[i] = img.states[i] / N
  end
end
mean(ens::Vector{MaterialImage}) = begin
  ret = reduce(+, ens)
  ret = ret / length(ens)
  return ret
end
function normal_mean(ens::Vector{MaterialImage})
  ret = mean(ens)
  normalize!(ret)
  return ret
end
