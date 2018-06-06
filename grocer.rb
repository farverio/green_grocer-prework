require 'pry'

def consolidate_cart(cart)
  output_hash = {}
  
  cart.each do |el|
    el.each do |name, values|
      if !output_hash[name]
        output_hash[name] = values
        output_hash[name].merge!(count: 1)
      else
        output_hash[name][:count] += 1
      end
    end
  end
  output_hash
end

def apply_coupons(cart, coupons)
  result = {}
  cart.each do |food, info|
    coupons.each do |coupon|
      if food == coupon[:item] && info[:count] >= coupon[:num]
        info[:count] =  info[:count] - coupon[:num]
        if result["#{food} W/COUPON"]
          result["#{food} W/COUPON"][:count] += 1
        else
          result["#{food} W/COUPON"] = {:price => coupon[:cost], :clearance => info[:clearance], :count => 1}
        end
      end
    end
    result[food] = info
  end
  result
end

def apply_clearance(cart)
  cart.map do |item, details|
    if details[:clearance]
      details[:price] = details[:price] * 8 / 10
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupon_step = apply_coupons(consolidated_cart, coupons)
  clearance_step = apply_clearance(coupon_step)
  
  sum_of_items = 0
  
  clearance_step.each {|name, details| sum_of_items += details[:count] * details[:price]}
  
  if sum_of_items > 100
    sum_of_items * 9 / 10
  else
    sum_of_items
  end
end
