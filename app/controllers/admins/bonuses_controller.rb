class Admins::BonusesController < AdminController
  before_action :set_user

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.genre = :bonus
    @order.user = @user
    if @order.save
      if @order.may_pay? && @order.pay!
        flash[:notice]= 'Successfully Added Coin!'
      else
        flash[:alert] = @order.errors.full_messages.join(', ')
        @order.cancel!
      end
      redirect_to new_admins_user_bonuse_path
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(:coin, :remarks)
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end