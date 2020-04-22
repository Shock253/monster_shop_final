class Merchant::DiscountsController < ApplicationController
  def index
    @discounts = Discount.where(merchant_id: current_user.merchant.id)
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new; end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to "/merchant/discounts"
    else
      generate_flash(discount)
      redirect_to "/merchant/discounts/new"
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      redirect_to "/merchant/discounts"
    else
      generate_flash(@discount)
      redirect_to "/merchant/discounts/#{params[:id]}/edit"
    end
  end

  def destroy
    item = Discount.find(params[:id])
    item.destroy
    redirect_to "/merchant/discounts"
  end

  private

  def discount_params
    params.permit(:name, :threshold, :percent)
  end
end
