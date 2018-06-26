# this contains segmentation processes for MaterialImage objects

# perform modified otsu thresholding for non-binary discs

using StatsBase

function imagehist(img::MaterialImage)
  normalize!(img)
  freqs = fweights(zeros(Int, 256))
  for i=1:length(img)
    @inbounds freqs[Int(floor(img.states[i] * 255))+1] += 1
  end
  return freqs
end

function intervar(hist::FrequencyWeights, thresh::Int)
  μ_T = mean(vec(1:256), hist)
  μ_k = mean(vec(1:thresh), fweights(hist[1:thresh]))
  ω_k = fweights(hist[1:thresh]).sum / hist.sum
  return ((μ_T*ω_k-μ_k)^2)/(ω_k*(1-ω_k))
end

function otsu_thresh(img::MaterialImage)
  unique(img) != 2 && throw(ArgumentError("Thresholding for the number of unique states is not supported."))
  hist = imagehist(img)
  μ_T = Int(floor(mean(vec(1:256), hist)))
  μ_0 = Int(floor(mean(vec(1:μ_T-1), fweights(hist[1:μ_T-1]))))
  μ_1 = Int(ceil(mean(vec((μ_T+1):256), fweights(hist[μ_T+1:end]))))
  return subrange(hist, μ_0, μ_T, μ_1)
end

function subrange(hist::FrequencyWeights, bounds::Int...)
  if bounds[1] == bounds[2] == bounds[3] return bounds[2] end
  if intervar(hist, bounds[1]) > intervar(hist, bounds[2])
    return subrange(hist, bounds[1], div(bounds[1]+bounds[2], 2), bounds[2])
  elseif intervar(hist, bounds[3]) > intervar(hist, bounds[2])
    return subrange(hist, bounds[2], div(bounds[2]+bounds[3], 2), bounds[3])
  else
    return bounds[2]
  end
end
