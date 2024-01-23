class DogsController < ApplicationController
  def index; end

  def create
    @response = Dogs::Api::ImageClient.new(breed_params[:breed]).by_breed unless breed_params.blank?

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def breed_params
    params.require(:dog).permit(:breed)
  end
end
