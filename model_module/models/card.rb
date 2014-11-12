# 出牌牌型
module CardType
  NONE                = 0  # 无效
  SINGLE              = 1  # 单张
  PAIRS               = 2  # 一对
  PAIRS_STRAIGHT      = 3  # 连对
  THREE               = 4  # 三张
  THREE_WITH_ONE      = 5  # 三带一
  THREE_WITH_PAIRS    = 6  # 三带一对
  THREE_STRAIGHT      = 7  # 三张的顺子
  FOUR_WITH_TWO       = 8  # 四带二
  FOUR_WITH_TWO_PAIRS = 9  # 四带二对
  PLANE               = 10 # 飞机
  PLANE_WITH_WING     = 11 # 飞机带翅膀(三张带一对的顺子)
  STRAIGHT            = 12 # 顺子
  BOMB                = 13 # 炸弹
  ROCKET              = 14  # 火箭(王炸)
end

class Card
  attr_accessor :card_type, :poke_cards, :max_poke_value, :card_length, :player,:card_value

  def initialize
    self.card_type = CardType::NONE
    self.poke_cards = []
    self.max_poke_value = 0
    self.card_length = 0
    self.card_value = 0
    self.player = nil
  end

  def self.get_card(poke_cards)
    CardUtility.get_card(poke_cards)
  end

  def poke_card_ids
    self.poke_cards.map(&:poke_id).join(",")
  end

  def is_valid?
    self.card_type != CardType::NONE
  end

  def is_bomb?
    self.card_type == CardType::BOMB
  end

  def is_rocket?
    self.card_type == CardType::ROCKET
  end

  def is_bigger_than?(card_b)
    CardUtility.compare(self, card_b)
  end

  def get_card_string_array
    s = []
    self.poke_cards.each do |poke|
       s.push  poke.poke_id
    end
    s
  end

end