module Coin

  attr_accessor :coin_list

  def initialize_coin_list
    @coin_list = { "1" => 0, "2" => 0, "5" => 0, "10" => 0 }
  end

  # initial filling of coins
  def update_coin(denomination, no_of_coins)
    @coin_list[denomination] += no_of_coins
  end

  # Updates coin inventory after every transaction
  # converts coin_value_array in hash with summed values against key
  # add coin_hash values in coin_list and updates values
  def update_coin_on_transaction(coin_value_array)
    coin_hash = Hash.new(0)
    coin_value_array.each { | v | coin_hash.store(v, coin_hash[v]+1)}

    coin_hash = coin_hash.inject({}){|memo,(k,v)| memo[k.to_s] = v; memo}
    @coin_list.update(coin_hash) { |k, v1, v2| v1 + v2 }
  end

end