class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def new
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def create
    merchant = Merchant.find(current_user.merchant_id)
    @discount = merchant.discounts.new(discount_params)
    if @discount.save
      redirect_to "/merchant/discounts"
    elsif
      flash[:alert] = "Please fill in all fields to create discount"
      redirect_to "/merchant/discounts/new"
    end
  end

  def destroy
    discount = Discount.find(params[:discount_id])
    discount.destroy
    redirect_to '/merchant/discounts'
  end

  private

  def discount_params
    params.permit(:name, :percent_off, :minimum_items)
  end
end
