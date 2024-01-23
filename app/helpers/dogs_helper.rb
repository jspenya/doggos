module DogsHelper
  def dog_image_tag_url
    return "https://www.shutterstock.com/image-photo/dog-holding-teeth-magnifying-glass-260nw-252532990.jpg" unless @dog.persisted?

    @dog.images.sample
  end

  def dog_breed_label
    return "We can't seem to find that breed." unless @dog.persisted?

    @dog.breed.humanize
  end
end
