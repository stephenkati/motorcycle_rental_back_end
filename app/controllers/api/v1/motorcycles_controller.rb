class Api::V1::MotorcyclesController < ApplicationController
  def index
    @motorcycles = Motorcycle.all

    if @motorcycles
      render json: { status: 'Success', message: 'Motorcycles fetched successfully', data: @motorcycles }, status: :ok
    else
      render json: { status: 'Error', message: 'Failed to fetch list of motorcycles!' }, status: :bad_request
    end
  end

  def show
    @motorcycle = Motorcycle.find(params[:id])
    render json: { status: 'Success', message: 'Motorcycle fetched successfully', data: @motorcycle }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { status: 'Error', message: 'Failed to fetch motorcycle!', data: nil }, status: :not_found
  end

  def create
    @motorcycle = Motorcycle.new(motorcycle_params)

    if @motorcycle.save
      render json: { status: 'Success', message: 'Motorcycle created successfully', data: @motorcycle }, status: :ok
    else
      render json: { status: 'Error', message: 'Failed to create motorcycle!', data: @motorcycle.errors },
             status: :unprocessable_entity
    end
  end

  def update
    @motorcycle = Motorcycle.find(params[:id])

    if @motorcycle.update(motorcycle_params)
      render json: { status: 'Success', message: 'Motorcycle updated successfully', data: @motorcycle }, status: :ok
    else
      render json: { status: 'Error', message: 'Failed to update motorcycle!', data: @motorcycle.errors },
             status: :unprocessable_entity
    end
  end

  def destroy
    @motorcycle = Motorcycle.find_by(id: params[:id])

    if @motorcycle.nil?
      render json: { status: 'Error', message: 'Motorcycle not found!', data: nil }, status: :not_found
    elsif @motorcycle.destroy
      render json: { status: 'Success', message: 'Motorcycle deleted successfully', data: @motorcycle }, status: :ok
    else
      render json: { status: 'Error', message: 'Failed to delete motorcycle!', data: @motorcycle.errors },
             status: :unprocessable_entity
    end
  end

  private

  def motorcycle_params
    params.require(:motorcycle).permit(:name, :photo, :purchase_price, :rental_price, :description)
  end
end
