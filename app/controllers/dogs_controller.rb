class DogsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: breed_names }
    end
  end

  def create
    @response = Dogs::Api::ImageClient.new(breed: breed_params[:breed]).by_breed unless breed_params.blank?

    respond_to do |format|
      format.turbo_stream
    end
  end

  def search
    @names = []
    unless params[:breed].blank?
      @names = breed_names.select{ |name| name.match?(/#{params[:breed].downcase}/) }
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "search_results",
          partial: "dogs/search_results",
          locals: { breed_names: @names }
        )
      end
    end
  end

  private

  def breed_names
    @breed_names ||= Dogs::Api::ImageClient.new.breed_names
  end

  def breed_params
    params.require(:dog).permit(:breed)
  end
end
