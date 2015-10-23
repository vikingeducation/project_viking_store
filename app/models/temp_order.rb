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

  def self.merge(session, order)
    order.save unless order.persisted?
    existing_items = []
    new_items = []
    session_to_attributes(session).each do |item|
      order_item = order.items.where('product_id = ?', item[:product_id])
      item[:order_id] = order.id
      if order_item.present?
        order_content = order_item.first
        item[:quantity] += order_content.quantity
        item[:id] = order_content.id
        existing_items << item
      else
        new_items << item
      end
    end
    session[:cart] = nil
    order.update_items(existing_items)
    order.create_items(new_items)
    order
  end

  def self.session_to_attributes(session)
    return [] unless session[:cart]
    attrs = {}
    session[:cart].map do |item|
      if attrs[item['product_id']]
        attrs[item['product_id']][:quantity] += item['quantity'].to_i
      else
        attrs[item['product_id']] = {
          :quantity => item['quantity'].to_i,
          :product_id => item['product_id']
        }
      end
    end
    attrs.map {|key, value| value}
  end
end





