class PackOfCards
  attr_accessor :pokes, :hand_count, :pack_value,
                :single_cards, :pairs_cards, :three_cards,  :four_cards,  :rocket,
                :single_straight,  :pairs_straight, :three_straight,  :four_straight,
                :three_with_single, :three_with_pair,
                :three_straight_with_single, :three_straight_with_pair,
                :four_with_single, :four_with_pair,
                :single_cards_with_cardType, :pairs_cards_with_cardType, :three_cards_with_cardType,  :four_cards_with_cardType,  :rocket_with_cardType,
                :single_straight_with_cardType,  :pairs_straight_with_cardType, :three_straight_with_cardType,  :four_straight_with_cardType,
                :three_with_single_with_cardType, :three_with_pair_with_cardType,
                :three_straight_with_single_with_cardType, :three_straight_with_pair_with_cardType,
                :four_with_single_with_cardType, :four_with_pair_with_cardType


  def initialize(pokes)
    self.pokes = pokes
    self.single_cards = []
    self.pairs_cards = []
    self.three_cards = []
    self.four_cards = []
    self.rocket = []
    self.single_straight = []
    self.pairs_straight = []
    self.three_straight = []
    self.four_straight = []
    self.three_with_single = []
    self.three_with_pair = []
    self.three_straight_with_single = []
    self.three_straight_with_pair = []
    self.four_with_single = []
    self.four_with_pair = []

    self.single_cards_with_cardType = []
    self.pairs_cards_with_cardType = []
    self.three_cards_with_cardType = []
    self.four_cards_with_cardType = []
    self.rocket_with_cardType = []
    self.single_straight_with_cardType = []
    self.pairs_straight_with_cardType = []
    self.three_straight_with_cardType = []
    self.four_straight_with_cardType = []
    self.three_with_single_with_cardType = []
    self.three_with_pair_with_cardType = []
    self.three_straight_with_single_with_cardType = []
    self.three_straight_with_pair_with_cardType = []
    self.four_with_single_with_cardType = []
    self.four_with_pair_with_cardType = []

  end

end