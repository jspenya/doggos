module Dogs
  module Api
    class ImageClient
      BASE_URI = "https://dog.ceo/api/breed/".freeze

      attr_reader :breed, :conn

      def initialize(breed: nil)
        @breed  = breed&.downcase
        @conn ||= Faraday.new(
          url: BASE_URI
        )
      end

      def by_breed
        response = conn.get("#{breed}/images/random")

        raise InvalidBreedError unless response.success?

        JSON.parse(response.body).merge!({"breed" => breed})
      rescue URI::InvalidURIError, InvalidBreedError
        NullBreed.new.body
      end

      def breed_names
        response = Faraday.get("https://dog.ceo/api/breeds/list/all")

        JSON.parse(response.body).fetch("message", {}).keys
      end

      private

      class InvalidBreedError < StandardError; end

      class NullBreed
        def body
          {
            message: "https://www.shutterstock.com/image-photo/dog-holding-teeth-magnifying-glass-260nw-252532990.jpg",
            missing: "Woof! We can't seem to find that breed."
          }.with_indifferent_access
        end
      end
    end
  end
end
