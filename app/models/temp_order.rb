class TempOrder
  include ActiveModel::Validations
  validates_with TempOrderValidator

  attr_accessor :session,
                :items

  def initialize(session)
    @session = session
    @session[:cart] = [] unless @session[:cart]
  end

  def create_items(attrs)
    @items = attrs
    is_valid = valid?
    if is_valid
      @items.each do |a|
        @session[:cart] << a
      end
    end
    is_valid
  end

  def update_items(attrs)
    @items = attrs
    is_valid = valid?
    @session[:cart] = @items if is_valid
    is_valid
  end

  def destroy
    # destroy individual item
  end

  def to_order
    # change to Order
  end
end





