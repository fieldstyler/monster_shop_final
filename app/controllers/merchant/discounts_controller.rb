class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def new
  end

  def edit
    @discount = Discount.find(params[:id])
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
      flash[:alert] = "Please fill in all fields completely and with correct input to create discount. Percent Off and Minimum Items must be integers."
      flash[:alert] = @discount.errors.full_messages.to_sentence #from Brian
      redirect_to "/merchant/discounts/new"
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to '/merchant/discounts'
  end

  def update
    discount = Discount.find(params[:id])
    if discount.update(discount_params)
      redirect_to "/merchant/discounts"
    end
  end

  private

  def discount_params
    params.permit(:name, :percent_off, :minimum_items)
  end
end
