require './coin'
describe 'Coin' do

  class TestClass
  end

  before(:each) do
    @test_coin = TestClass.new
    @test_coin.extend(Coin)
    @test_coin.initialize_coin_list
  end

  it 'when created the number of 1 rs coin is 0' do
    expect(@test_coin.coin_list["1"]).to eq 0
  end

  it 'when created the number of 2 rs coin is 0' do
    expect(@test_coin.coin_list["2"]).to eq 0
  end

  it 'when created the number of 5 rs coin is 0' do
    expect(@test_coin.coin_list["5"]).to eq 0
  end

  it 'when created the number of 10 rs coin is 0' do
    expect(@test_coin.coin_list["10"]).to eq 0
  end

  context 'update the coin inventory' do

    before(:each) do
      @test_coin.update_coin("1", 5)
    end

    context 'update_coin' do
      it 'update_coin adds coin in coin_list' do
        @test_coin.update_coin("1", 2)
        expect(@test_coin.coin_list["1"]).to be 7
      end
    end

    context 'update_coin_on_transaction' do
      it 'update_coin_on_transaction updates coin_list after a transaction' do
        @test_coin.update_coin_on_transaction([1,2,1,1,5,10])
        expect(@test_coin.coin_list["1"]).to be 8
      end
    end
  end

end