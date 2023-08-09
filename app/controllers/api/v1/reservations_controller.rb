class Api::V1::ReservationsController < ApplicationController
  before_action :authorize

  def index    
    return render_unauthorized unless @user

    @reservations = @user.reservations.includes(:user)
    render json: { status: 'Success', message: 'Reservations fetched successfully', data: @reservations }, status: :ok
  end

  def show
    return render_unauthorized unless @user

    @reservation = @user.reservations.find_by(id: params[:id])
    return render_reservation_not_found unless @reservation

    render json: { status: 'Success', message: 'Reservation fetched successfully', data: @reservation }, status: :ok
  end

  def create
    return render_unauthorized unless @user

    @reservation = @user.reservations.build(reservation_params)

    if @reservation.save
      render json: { status: 'Success', message: 'Reservation created successfully', data: @reservation}, status: :ok
    else
      render json: { status: 'Error', message: 'Failed to create reservation', errors: @reservation.errors }, status: :unprocessable_entity
    end
  end  

  def update
    return render_unauthorized unless @user
  
    @reservation = @user.reservations.find_by(id: params[:id])
    return render_reservation_not_found unless @reservation
  
    if @reservation.update(reservation_params)
      render json: { status: 'Success', message: 'Reservation updated successfully', data: @reservation }, status: :ok
    else
      render json: { status: 'Error', message: 'Failed to update reservation', errors: @reservation.errors }, status: :unprocessable_entity
    end
  end     

  def destroy
    return render_unauthorized unless @user
      
    @reservation = @user.reservations.find_by(id: params[:id])
    return render_reservation_not_found unless @reservation

    if @reservation.destroy
      render json: { status: 'Success', message: 'Reservation deleted successfully', data: @reservation }, status: :ok
    else
      render json: { status: 'Error', message: 'Failed to delete reservation', errors: @reservation.errors }, status: :unprocessable_entity
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:reserve_date, :city, :motorcycle_id)
  end

  def render_unauthorized
    render json: { status: 'Error', message: 'Unauthorized' }, status: :unauthorized
  end
  
  def render_reservation_not_found
    render json: { status: 'Error', message: 'Reservation not found' }, status: :not_found
  end
end
