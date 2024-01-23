class DogsController < ApplicationController
  def index; end

  def create
    @dog = Dogs::CreateOrUpdate.new(breed_params[:breed]).call unless breed_params.blank?

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def breed_params
    params.require(:dog).permit(:breed)
  end
end
