class RestaurantsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = current_user.restaurants.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    if current_user.id != @restaurant.user_id
      flash[:notice] = 'You cannot edit that, if you did not add the restaurant'
      redirect_to restaurants_path
    end
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)

    redirect_to restaurants_path
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if current_user.id != @restaurant.user_id
      flash[:notice] = 'You cannot edit that, if you did not add the restaurant'
      redirect_to restaurants_path
    else
      @restaurant.destroy
      flash[:notice] = 'Restaurant deleted successfully'
      redirect_to restaurants_path
    end
  end
end
