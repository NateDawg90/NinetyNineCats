class CatRentalRequestsController < ApplicationController

  def show
    @request = CatRentalRequest.find_by(id: params[:id])
    render :show
  end

  def new
    @request = CatRentalRequest.new
    render :new
  end

  def create
    @request = CatRentalRequest.new(request_params)

    if @request.save
      redirect_to cat_rental_request_url(@request)
    else
      render :new
    end
  end

  def approve
    @request = CatRentalRequest.find_by(id: params[:id])
    @request.approve!
    redirect_to cat_url(@request.cat_id)
  end

  def deny
    @request = CatRentalRequest.find_by(id: params[:id])
    @request.deny!
    redirect_to cat_url(@request.cat_id)
  end

  private

  def request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

end
