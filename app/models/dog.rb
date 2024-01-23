require 'open-uri'

class Dog < ApplicationRecord
  has_many_attached :images

  def attach_image(image_url)
    image = URI.open(image_url)
    images.attach(io: image, filename: File.basename(URI.parse(image_url).path))
  end

  # Used for caching
  def recently_updated?
    updated_at.before? 3.minutes.ago
  end
end
