require './machine'
# require './spec/coin_spec'
# require './spec/item_spec'

describe 'machine' do

  let(:machine) {Machine.new}

  describe '#instructions' do
    it 'prints the initial instructions' do
      expect(machine).to receive(:puts).with("Welcome, machine is ready to load items & coins.")
      expect(machine).to receive(:puts).with("Please load items, and coins in the machine")
      machine.instructions
    end
  end

  describe '#load_items' do
    it 'it loads item' do
      expect(machine).to receive(:puts).once.with("Load the number of orange in machine")
      expect(machine).to receive(:gets).and_return("2")
      expect(machine).to receive(:puts).once.with("Load the number of apple in machine")
      expect(machine).to receive(:gets).and_return("2")
      expect(machine).to receive(:puts).once.with("Load the number of mango in machine")
      expect(machine).to receive(:gets).and_return("2")
      expect(machine).to receive(:puts).once.with("Load the number of kiwi in machine")
      expect(machine).to receive(:gets).and_return("2")
      machine.load_items
    end
  end

  describe '#input_item' do
    it 'it gets the user input for an item' do
      expect(machine).to receive(:gets).and_return("2")
      machine.input_item("orange")
    end

    # it 'it gets the user input for an item and update stock' do
    #   @test_item.update_stock("orange", 5)
    #   expect(machine).to receive(:input_item).with("orange", 2)
    #   machine.input_item("orange")
    #   @test_item.item_list[0][2].should == 7
    # end
  end

  describe '#load_coins' do
    it 'it loads coin' do
      expect(machine).to receive(:puts).with("Load the number of 1 rs denomination coin in machine")
      expect(machine).to receive(:gets).and_return("1")
      expect(machine).to receive(:puts).with("Load the number of 2 rs denomination coin in machine")
      expect(machine).to receive(:gets).and_return("4")
      expect(machine).to receive(:puts).with("Load the number of 5 rs denomination coin in machine")
      expect(machine).to receive(:gets).and_return("6")
      expect(machine).to receive(:puts).with("Load the number of 10 rs denomination coin in machine")
      expect(machine).to receive(:gets).and_return("8")
      machine.load_coins
    end
  end

  describe '#input_coin' do
    it 'it gets the user input for a coin' do
      expect(machine).to receive(:gets).and_return("1")
      machine.input_coin("1")
    end
  end

  describe '#operate_machine' do
    it 'it triggers the machine operation for a user' do
      expect(machine).to receive(:take_item_input)
      machine.operate_machine
    end
  end

  describe '#take_item_input' do
    it 'it gets the user input for a coin' do
      expect(machine).to receive(:print_stock)
      expect(machine).to receive(:order)
      expect(machine).to receive(:quantity)
      expect(machine).to receive(:validate_order)
      machine.take_item_input
    end
  end

  describe '#print_stock' do
    it 'it prints the stock with quantity for user' do
      expect(machine).to receive(:puts).with("Here is the stock for your selection")
      expect(machine).to receive(:puts).with("Item Amount Number_in_stock")
      expect(machine).to receive(:puts).with("orange      2     0")
      expect(machine).to receive(:puts).with("apple      4     0")
      expect(machine).to receive(:puts).with("mango      6     0")
      expect(machine).to receive(:puts).with("kiwi      10     0")
      expect(machine).to receive(:puts).with("We accept coin in denominations of 1, 2 ,5 ,10")
      machine.print_stock
    end
  end

  describe '#order' do
    it 'it takes item as input and if input is correct it moves forward' do
      machine.instance_variable_set("@wrong_item", 0)
      machine.instance_variable_set("@wrong_item", 0)
      expect(machine).to receive(:puts).once.with("Enter the name of the product")
      expect(machine).to receive(:gets).once.and_return("orange")
      machine.order
    end

    it 'it roll back and exits after 3 failed attempt of item name' do
      machine.instance_variable_set("@wrong_item", 0)
      expect(machine).to receive(:puts).at_least(2).with("Enter the name of the product")
      expect(machine).to receive(:puts).once.with("Rolling back your transaction due to 3 failed attemps. Please enter valid item,quantity, exact and real coin.")
      expect(machine).to receive(:gets).at_least(2).times.and_return("banana")
      machine.order
    end
  end

  describe '#quantity' do
    it 'it takes quantity of item as input and if input is correct it moves forward' do
      machine.instance_variable_set("@wrong_quantity", 0)
      expect(machine).to receive(:puts).once.with("Enter the valid quantity in numbers")
      expect(machine).to receive(:gets).once.and_return("1")
      machine.quantity
    end

    it 'it roll back and exits after 3 failed attempt for correct order quantity' do
      machine.instance_variable_set("@wrong_quantity", 0)
      expect(machine).to receive(:puts).at_least(2).with("Enter the valid quantity in numbers")
      expect(machine).to receive(:puts).once.with("Rolling back your transaction due to 3 failed attemps. Please enter valid item,quantity, exact and real coin.")
      expect(machine).to receive(:gets).at_least(2).times.and_return("banana")
      machine.quantity
    end
  end

  describe '#validate_order' do
    it 'it validates order from stock and delivers you the item on success' do
      expect(machine).to receive(:gets).and_return("2")
      machine.input_item("orange")
      machine.instance_variable_set("@customer_input", "orange")
      machine.instance_variable_set("@order_quantity", 2)
      expect(machine).to receive(:puts).once.with("We have items to serve you, please input money")
      expect(machine).to receive(:puts).at_least(1).with("Please enter coins to process the order of amount 4")
      expect(machine).to receive(:puts).once.with("Pls colllect 2 orange as you requested.")
      expect(machine).to receive(:puts).once.with("Your order is complete. Thank you! See you soon :)")
      expect(machine).to receive(:puts).once.with("updated coin list ---> {\"1\"=>0, \"2\"=>1, \"5\"=>0, \"10\"=>0}")
      machine.validate_order
    end

    it 'it validates order from stock and gives message when running short of quantity' do
      expect(machine).to receive(:gets).and_return("1")
      machine.input_item("orange")
      machine.instance_variable_set("@customer_input", "orange")
      machine.instance_variable_set("@order_quantity", 2)
      expect(machine).to receive(:puts).once.with("We are running out of stock at the moment with no of items chosen by you, please select again after having a look into our inventory below")
      machine.validate_order
    end
  end

  describe '#ask_for_coins' do
    it 'it takes coin as input for your order and delivers your order if correct money is provided' do
      machine.instance_variable_set("@customer_input", "orange")
      machine.instance_variable_set("@order_quantity", 2)
      expect(machine).to receive(:order_cost).and_return(4)
      expect(machine).to receive(:puts).at_least(1).times.with("Please enter coins to process the order of amount 4")
      expect(machine).to receive(:gets).and_return("2")
      machine.instance_variable_set("@coin_values", [])
      expect(machine).to receive(:puts).with("Pls colllect 2 orange as you requested.")
      expect(machine).to receive(:puts).with("Your order is complete. Thank you! See you soon :)")
      expect(machine).to receive(:puts).with("updated coin list ---> {\"1\"=>0, \"2\"=>1, \"5\"=>0, \"10\"=>0}")
      machine.ask_for_coins
    end

    it 'it roll back and exits after 3 failed attempt for wrong coins' do
      machine.instance_variable_set("@customer_input", "orange")
      machine.instance_variable_set("@order_quantity", 2)
      expect(machine).to receive(:order_cost).and_return(4)
      expect(machine).to receive(:puts).at_least(2).times.with("Please enter coins to process the order of amount 4")
      expect(machine).to receive(:gets).and_return("3")
      machine.instance_variable_set("@fake_coin", 0)
      expect(machine).to receive(:puts).at_least(2).with("Enter valid coin")
      expect(machine).to receive(:puts).once.with("Rolling back your transaction due to 3 failed attemps. Please enter valid item,quantity, exact and real coin.")
      machine.ask_for_coins
    end
  end

  describe '#process_order' do
    before(:all) do
      @item_list = [    ['orange', 2, 0],
                        ['apple',4,0],
                        ['mango',6,0],
                        ['kiwi', 10, 0]      ]
      @coin_list = { "1" => 0, "2" => 0, "5" => 0, "10" => 0 }
    end

    it 'it takes coin as input for your order and delivers your order if correct money is provided and updates order & coin inventory as well' do
      machine.instance_variable_set("@coin_values" , [1,2,1])
      machine.instance_variable_set("@order_quantity", 2)
      machine.instance_variable_set("@customer_input", "orange")
      expect(machine).to receive(:puts).with("Pls colllect 2 orange as you requested.")
      expect(machine).to receive(:puts).with("Your order is complete. Thank you! See you soon :)")
      expect(machine).to receive(:puts).with("updated coin list ---> {\"1\"=>2, \"2\"=>1, \"5\"=>0, \"10\"=>0}")
      machine.process_order
    end
  end

end