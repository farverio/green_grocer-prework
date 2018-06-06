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
  output_hash = {}
  previous_coupon = ""
  
  if coupons.length != 0
    coupon_num = 0
    coupons.each do |coupon| 
      if coupon[:]
      cart.each do |cart_item, details|
        
        
        clearance_flag = true
        output_hash[cart_item] = details
        
        if coupon[:item] == cart_item
          if coupon[:num] > details[:count]
            coupon_count = details[:count]
          elsif coupon[:num] < details[:count]
            coupon_count = coupon[:num]
            clearance_flag = false
          else
            coupon_count = coupon[:num]
          end
          
          output_hash["#{cart_item} W/COUPON"] = {
            price: coupon[:cost],
            clearance: clearance_flag,
            count: coupon_num += 1
          }
          
          output_hash[cart_item][:count] -= coupon_count
        end
      end
    end
  else
    output_hash = cart
  end
  
  output_hash
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
