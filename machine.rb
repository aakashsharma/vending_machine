require_relative 'item'
require_relative 'coin'

class Machine

  include Item
  include Coin

  attr_reader :customer_input, :order_quantity, :coin, :coin_values
  MAX_FAILED_ATTEMPTS = 3

  def initialize
    initialize_item_list
    initialize_coin_list
  end

  def start
    @fake_coin = 0
    @wrong_item = 0
    @wrong_quantity = 0
    instructions
    load_items
    load_coins
    operate_machine
  end

  def instructions
    puts "Welcome, machine is ready to load items & coins."
    puts "Please load items, and coins in the machine"
  end

  def load_items
    @item_list.each do |item|
      puts "Load the number of #{item[0]} in machine"
      input_item(item[0])
    end
  end

  def input_item(item)
    quantity = gets.chomp.to_i
    update_stock(item, quantity)
  end

  def load_coins
    @coin_list.each do |coin|
      puts "Load the number of #{coin[0]} rs denomination coin in machine"
      input_coin(coin[0])
    end
  end

  def input_coin(denomination)
    no_of_coins = gets.chomp.to_i
    update_coin(denomination, no_of_coins)
  end

  def operate_machine
    take_item_input
  end

  def take_item_input
    print_stock
    order
    quantity
    validate_order
  end

  def print_stock
    puts "Here is the stock for your selection"
    puts "Item Amount Number_in_stock"
    @item_list.each do |item|
      puts "#{item[0]}      #{item[1]}     #{item[2]}"
    end
    puts "We accept coin in denominations of 1, 2 ,5 ,10"
  end

  def order
    puts "Enter the name of the product"
    @customer_input = gets.chomp.downcase
    wrong_product? ? @wrong_item+=1 : @wrong_item=0
    wrong_item? unless @wrong_item == 0
  end

  def quantity
    puts "Enter the valid quantity in numbers"
    @order_quantity = gets.chomp.to_i
    wrong_input_for_quantity? ? @wrong_quantity += 1 : @wrong_quantity=0
    wrong_quantity? unless @wrong_quantity == 0
  end

  def validate_order
    if @order_quantity <= @item_list[find(@customer_input)][2]
      puts "We have items to serve you, please input money"
      @coin_values = []
      ask_for_coins
    else
      puts "We are running out of stock at the moment with no of items chosen by you, please select again after having a look into our inventory below"
      take_item_input
    end
  end

  def ask_for_coins
    puts "Please enter coins to process the order of amount #{order_cost}"
    @coin = gets.chomp.to_i
    validate_coin
  end

  def validate_coin
    if not [1,2,5,10].include?(@coin)
      @fake_coin += 1
      puts "Enter valid coin"
      fake_coin? if @fake_coin == MAX_FAILED_ATTEMPTS
      ask_for_coins
    else
      @coin_values << @coin
      coin_weight
      if coin_sum > 0 && coin_sum == order_cost
        process_order
      else
        ask_for_coins
      end

    end
  end

  def process_order
    update_coin_on_transaction(@coin_values)
    puts "Pls colllect #{@order_quantity} #{@customer_input} as you requested."
    update_stock_on_transaction(@customer_input ,@order_quantity)
    puts "Your order is complete. Thank you! See you soon :)"
    puts "updated coin list ---> #{@coin_list}"
    exit(1)
  end

  private

  def wrong_product?
    (@customer_input.empty? or !@item_list.map{|x| x[0]}.include?(@customer_input))
  end

  def wrong_input_for_quantity?
    @order_quantity <= 0 or !@order_quantity.is_a?(Integer)
  end

  def order_cost
    (@item_list[find(@customer_input)][1]*@order_quantity)
  end

  def coin_sum
    @coin_values.sum
  end

  def coin_weight
    if coin_sum > order_cost
      puts "You have put higher value coin than order. Returing your money back. Kindly tender exact amount."
      order_again?
    end
  end

  def order_again?
    sleep 2
    puts "***************** We are ready to serve you! *******************"
    take_item_input
  end

  def fake_coin?
    cancel_transaction
  end

  def wrong_item?
    (@wrong_item == MAX_FAILED_ATTEMPTS)? cancel_transaction : order
  end

  def wrong_quantity?
    (@wrong_quantity == MAX_FAILED_ATTEMPTS)? cancel_transaction : quantity
  end

  def cancel_transaction
    puts "Rolling back your transaction due to 3 failed attemps. Please enter valid item,quantity, exact and real coin."
    @fake_coin = 0
    @wrong_item = 0
    @wrong_quantity = 0
    exit(1)
    #order_again?
  end

 end
