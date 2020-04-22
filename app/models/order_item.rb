class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def subtotal
    discount = item.merchant.applicable_discount(quantity)
    if discount
      (quantity * price) * (100 - discount.percent)/100
    else
      quantity * price
    end
  end

  def fulfill
    update(fulfilled: true)
    item.update(inventory: item.inventory - quantity)
  end

  def fulfillable?
    item.inventory >= quantity
  end
end
