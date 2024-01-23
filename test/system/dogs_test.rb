require "application_system_test_case"

class DogsTest < ApplicationSystemTestCase
  setup do
    @dog = dogs(:first)
    @invalid = dogs(:invalid)
  end

  test "querying a valid dog breed" do
    visit dogs_url

    assert_selector "h1", text: "Doggos"

    fill_in "dog_breed", with: @dog.breed
    click_on "Submit"

    assert_selector "img[alt='#{@dog.breed}']"
  end

  test "querying an invalid dog breed" do
    visit dogs_url

    assert_selector "h1", text: "Doggos"

    fill_in "dog_breed", with: @invalid.breed
    click_on "Submit"

    assert_selector "img[alt='#{@invalid.breed}']"
  end
end
