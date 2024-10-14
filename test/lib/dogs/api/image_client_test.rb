require 'test_helper'
require 'webmock/minitest'

module Dogs
  module Api
    class ImageClientTest < ActiveSupport::TestCase
      setup do
        @breed = dogs(:first).breed
        @client = Dogs::Api::ImageClient.new(breed: @breed)
        @api_url = "https://dog.ceo/api/breed/#{@breed}/images/random"
      end

      test 'returns a random dog image for a valid breed' do
        stub_request(:get, @api_url)
          .to_return(
            status: 200,
            body: '{"message":"https://images.dog.ceo/breeds/malamute/n02110063_14327.jpg","status":"success"}'
          )

        response = @client.by_breed

        assert_equal 'malamute', response['breed']
        assert_match /https:\/\/images.dog.ceo\/breeds\/malamute\/n02110063_14327.jpg/, response['message']
      end

      test 'handles invalid breed with a default image and message' do
        stub_request(:get, @api_url)
          .to_return(
            status: 404,
            body: '{"status":"error","message":"Breed not found (master breed does not exist)","code":404}'
          )

        response = @client.by_breed

        assert_equal 'https://www.shutterstock.com/image-photo/dog-holding-teeth-magnifying-glass-260nw-252532990.jpg', response['message']
        assert_equal "Woof! We can't seem to find that breed.", response['missing']
      end
    end
  end
end
