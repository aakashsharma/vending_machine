module Item

  attr_accessor :item_list

  def initialize_item_list
    @item_list = [    ['orange', 2, 0],
                      ['apple',4,0],
                      ['mango',6,0],
                      ['kiwi', 10, 0]      ]
  end


  # initial filling of items
  def update_stock(item, quantity)
    @item_list[find(item)][2] += quantity
  end

  # Updates item inventory after every transaction
  def update_stock_on_transaction(item, quantity)
    @item_list[find(item)][2] -= quantity
  end

  def find(item_name)
    @item_list.index{|item| item[0] ==item_name}
  end

end