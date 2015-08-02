class OrderContent < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  validates_uniqueness_of :order_id, scope: :product_id
  validates_with OrderContentValidator


  def self.update_all(records)
    return if records.nil?
    records.each do |oc|
      order_content = OrderContent.find(oc[0])
      if order_content && oc[1][:quantity].to_i <= 0
        order_content.destroy
      else
        order_content.update(quantity: oc[1][:quantity])
      end
    end
  end

  def self.create_or_update_many(potential_contents)
    # The reason we use reject rather than placing this in validation
    # is so the user isn't forced to fill in all of the form.
    potential_contents.reject! { |p_oc| p_oc[:product_id] == "" ||
                                        p_oc[:quantity] == "" }
    begin
      ActiveRecord::Base.transaction do
        potential_contents.each do |potential_oc|
          if self.find_by(order_id: potential_oc[:order_id])
            create_or_update_record(potential_oc)
          end
        end
      end
    rescue
      return "There was an error in your form. No changes have been made."
    end
    return nil
  end

  def product_by_id(id)
    self.find_by(product_id: id)
  end

  def self.create_or_update_record(record)
    order_content = self.find_by(order_id: record[:order_id], product_id: record[:product_id])
    if order_content
      order_content.update!(quantity: record[:quantity])
    else
      self.create!(order_id: record[:order_id], product_id: record[:product_id], quantity: record[:quantity])
    end
  end



  def self.revenue(timeframe = nil)
    if timeframe.nil?
      OrderContent.select("ROUND(SUM(quantity * products.price), 2) AS total")
                  .joins("JOIN products ON order_contents.product_id=products.id")
                  .joins("JOIN orders ON order_contents.order_id=orders.id")
                  .where("checkout_date IS NOT NULL")
                  .first.total
    else
      OrderContent.select("ROUND(SUM(quantity * products.price), 2) AS total")
                  .joins("JOIN products ON order_contents.product_id=products.id")
                  .joins("JOIN orders ON order_contents.order_id=orders.id")
                  .where("checkout_date > ?", timeframe.days.ago)
                  .first.total
    end
  end
end
