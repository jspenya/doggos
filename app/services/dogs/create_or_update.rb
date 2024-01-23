module Dogs
  class CreateOrUpdate
    def initialize(breed, client: nil)
      @breed  = breed.downcase
      @client = Dogs::Api::ImageClient.new(@breed)
    end

    def call
      return NullDog.new if invalid_dog_breed?

      find_or_create_dog_by_breed!

      return @dog unless @dog.recently_updated?

      @dog.images.purge_later
      attach_image_urls_to_dog
    end

    private

    def invalid_dog_breed?
      image_urls.blank?
    end

    def find_or_create_dog_by_breed!
      @dog = Dog.where(breed: @breed).first_or_initialize

      unless @dog.persisted?
        @dog.save!

        attach_image_urls_to_dog
      end

      @dog
    end

    def attach_image_urls_to_dog
      image_urls.each do |image_url|
        @dog.attach_image(image_url)
      end

      @dog
    end

    def image_urls
      @image_urls ||= @client.multiple_images_by_breed
    end

    class NullDog < Dog
      def breed
        'Invalid'
      end
    end
  end
end