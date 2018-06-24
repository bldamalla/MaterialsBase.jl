# this contains segmentation processes for MaterialImage objects

# perform modified otsu thresholding for non-binary discs

function imagehist(img::MaterialImage)
  normalize!(img)
  freqs = zeros(Int, 256)
  for i=1:length(img)
    freqs[Int(floor(img.states[i] * 255))+1] += 1
  end
  return freqs
end
