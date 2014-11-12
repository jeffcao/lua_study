module PokeCardValue
  # 扑克牌的取值对照
  NONE        = 0   # 无效
  THREE       = 3   # 3
  FOUR        = 4   # 4
  FIVE        = 5   # 5
  SIX         = 6   # 6
  SEVEN       = 7   # 7
  EIGHT       = 8   # 8
  NINE        = 9   # 9
  TEN         = 10  # 10
  JACK        = 11  # J
  QUEEN       = 12  # Q
  KING        = 13  # K
  ACE         = 14  # A
  TWO         = 15  # 2
  SMALL_JOKER = 16  # 小王
  BIG_JOKER   = 17  # 大王
end

class PokeCard
  @@all_poke_cards = []
  @@all_poke_cards_map = {}

  attr_accessor :poke_value, :poke_card_type, :poke_index, :poke_id, :state, :picked

  def self.all_poke_cards
    @@all_poke_cards.size > 0 || self.init

    @@all_poke_cards
  end

  def self.init
    return if @@all_poke_cards.size > 0

    poke_card_indexes = [3,4,5,6,7,8,9,10,11,12,13,1,2]
    poke_card_types = ["d", "c", "b", "a"]
    ci = 1
    tmp_poke_cards = []
    poke_card_indexes.each_index do |poke_card_index|
      poke_card_types.each do |poke_card_type|
        poke_card = PokeCard.new
        poke_card.poke_index = ci
        poke_card.poke_value = poke_card_index + 3
        poke_card.poke_id = poke_card_type + format("%02d", poke_card_indexes[poke_card_index] )
        tmp_poke_cards << poke_card
        @@all_poke_cards_map[poke_card.poke_id] = poke_card
        ci = ci + 1
      end
    end

    poke_card = PokeCard.new
    poke_card.poke_index = ci
    poke_card.poke_value = PokeCardValue::SMALL_JOKER
    poke_card.poke_id = "w01"
    tmp_poke_cards << poke_card
    @@all_poke_cards_map[poke_card.poke_id] = poke_card

    ci = ci + 1
    poke_card = PokeCard.new
    poke_card.poke_index = ci
    poke_card.poke_value = PokeCardValue::BIG_JOKER
    poke_card.poke_id = "w02"
    tmp_poke_cards << poke_card
    @@all_poke_cards_map[poke_card.poke_id] = poke_card

    @@all_poke_cards = tmp_poke_cards
  end

  def self.get_by_poke_id(poke_card_id)
    return all_poke_cards_map[poke_card_id]
  end

  private
  def self.all_poke_cards_map
    @@all_poke_cards.size > 0 || self.init
    @@all_poke_cards_map
  end

end