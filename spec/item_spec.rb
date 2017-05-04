require './item'
describe 'Item' do

  class TestClass
  end

  before(:each) do
    @test_item = TestClass.new
    @test_item.extend(Item)
    @test_item.initialize_item_list
  end

  it 'when created the amount of item is zero' do
    expect(@test_item.item_list[0][2]).to be 0
  end

  it 'first item should have a price' do
    expect(@test_item.item_list[0][1]).to eq 2
  end

  it 'second item should have a price' do
    expect(@test_item.item_list[1][1]).to eq 4
  end

  it 'third item should have a price' do
    expect(@test_item.item_list[2][1]).to eq 6
  end

  it 'fourth item should have a price' do
    expect(@test_item.item_list[3][1]).to eq 10
  end

  context 'update the stock' do

    before(:each) do
      @test_item.update_stock("orange", 5)
    end

    context 'update_stock' do
      it 'update_stock adds item in stock' do
        @test_item.update_stock("orange", 2)
        expect(@test_item.item_list[0][2]).to be 7
      end
    end

    context 'update_stock_on_transaction' do
      it 'update_stock_on_transaction updates item after a transaction' do
        @test_item.update_stock_on_transaction("orange", 2)
        expect(@test_item.item_list[0][2]).to be 3
      end
    end
  end

end