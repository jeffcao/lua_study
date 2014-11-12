#encoding: utf-8

class CardUtility
  @@all_poke_cards ||= lambda {
    tmp_cards = [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 1, 2].collect do |card_index|
      card_value = format("%02d", card_index)
      ["d", "c", "b", "a"].collect { |card_type| "#{card_type}#{card_value}" }
    end.flatten

    tmp_cards << "w01"
    tmp_cards << "w02"
  }.call

  def self.get_card(poke_cards)
    poke_count = poke_cards.length
    card = Card.new
    card.card_type = CardType::NONE # 无效牌型
    card.poke_cards = poke_cards

    return card if poke_cards.nil? || poke_cards.length == 0

    if poke_count == 1
      card.card_type = CardType::SINGLE
      card.max_poke_value = poke_cards[0].poke_value
      card.card_length = 1

      return card
    end

    # 2张, 可能是对子或火箭(王炸)
    if poke_count == 2
      CardUtility.check_pairs(card) || CardUtility.check_rocket(card)
      return card
    end

    # 可能是3张
    if poke_count == 3
      CardUtility.check_three(card)
      return card
    end

    # 4张, 可能是炸弹或三带一
    if poke_count == 4
      CardUtility.check_bomb(card) || CardUtility.check_three_with_one(card)
      return card
    end

    # 5张 是否为三带一对
    return card if poke_count == 5 && CardUtility.check_three_with_pairs(card)

    # 5张以上, 判断是否单顺
    if poke_count >= 5
      if CardUtility.check_straight(card.poke_cards)
        card.card_type = CardType::STRAIGHT
        card.max_poke_value = poke_cards[poke_count - 1].poke_value
        card.card_length = card.poke_cards.length

        return card
      end
    end

    # 六张, 可能牌型 4带2单张
    return card if (poke_count == 6) && CardUtility.check_four_with_two(card)

    # 六张以上, 可能双顺, 三顺, 飞机
    return card if (poke_count >= 6) && (CardUtility.check_pairs_straight(card) || CardUtility.check_three_straight(card))

    # 当牌数大于等于8,且能够被4整除时,判断是不是飞机, 或4带2对子
    return card if (poke_count >=8 && poke_count % 4 == 0) && (CardUtility.check_plane(card) || CardUtility.check_four_with_two_pairs(card))

    # 当牌数大于等于10,且能够被5整除时,判断是不是飞机带翅膀
    return card if (poke_count >=10 && poke_count % 5 == 0) && CardUtility.check_plane_with_wing(card)

    # 返回无效牌型
    card
  end


  def self.compare(card_a, card_b)
    return false if card_a.nil? || card_b.nil?

    # 火箭最大
    return true if card_a.is_rocket?
    return false if card_b.is_rocket?

    # 必须都是有效牌型
    return false unless (card_a.is_valid? && card_b.is_valid?)

    # 牌型不同，则判断 A 是否为炸弹
    return card_a.is_bomb? if (card_a.card_type != card_b.card_type)

    # 牌型相同，且牌数也必须相同，才能比较
    return false if (card_a.poke_cards.length != card_b.poke_cards.length)

    # 比较最大牌值
    card_a.max_poke_value > card_b.max_poke_value
  end


  # 检查牌是否为顺牌, 不判断牌数，不同于判断顺子(顺子要求至少5张)
  def self.check_straight(poke_cards)
    # 顺牌的最大牌值不能大于A
    return false if poke_cards[poke_cards.length-1].poke_value > PokeCardValue::ACE

    # 取第一张牌的值，
    start_poke_value = poke_cards[0].poke_value

    # 循环检查所有牌，每张牌必须比前一张大1
    index = 1
    while index < poke_cards.length
      return false if start_poke_value != poke_cards[index].poke_value - 1
      start_poke_value = poke_cards[index].poke_value
      index = index + 1
    end

    # 符合顺牌规则
    return true
  end

  def self.get_poke_count(poke_cards, index)
    poke_card = poke_cards[index]
    poke_cards.count { |p| p.poke_value == poke_card.poke_value }
  end

  # 检查对子
  def self.check_pairs(card)
    # 取出牌
    poke_cards = card.poke_cards
    # 牌数必须为2
    return false if poke_cards.length != 2

    # 牌值必须相同
    if poke_cards[0].poke_value == poke_cards[1].poke_value
      # 符合条件，标设为对子，和最大牌值
      card.card_type = CardType::PAIRS
      card.max_poke_value = poke_cards[0].poke_value
      card.card_length = 1

      return true
    end

    # 不是对子
    false
  end

  #/* 检查火箭 */
  def self.check_rocket(card)
    # 取出牌
    poke_cards = card.poke_cards
    # 牌数必须为2
    return false if poke_cards.length != 2

    # 牌值必须是大小王
    if poke_cards[0].poke_value == PokeCardValue::SMALL_JOKER &&
      poke_cards[1].poke_value == PokeCardValue::BIG_JOKER
      # 符合条件，标设为火箭，和最大牌值
      card.card_type = CardType::ROCKET
      card.max_poke_value = poke_cards[1].poke_value
      card.card_length = 1
      return true
    end

    false
  end


  #/* 检查三张 */
  def self.check_three(card)
    # 取出牌
    poke_cards = card.poke_cards
    # 牌数必须为3
    return false if poke_cards.length != 3

    # 三张的牌值必须相同
    if poke_cards[0].poke_value == poke_cards[1].poke_value &&
      poke_cards[0].poke_value == poke_cards[2].poke_value
      # 符合条件，标设为三张，和最大牌值
      card.card_type = CardType::THREE
      card.max_poke_value = poke_cards[0].poke_value
      card.card_length = 1

      return true
    end

    false
  end

  # /* 检查三带一, 条件：前三张或后三张的牌值必须相同, 如 3-7-7-7 或 7-7-7-9 */
  def self.check_three_with_one(card)
    # 取出牌
    poke_cards = card.poke_cards
    # 牌数必须为4
    return false if (poke_cards.length != 4)

    # 前三张的牌值必须相同?
    if poke_cards[0].poke_value == poke_cards[1].poke_value &&
      poke_cards[0].poke_value == poke_cards[2].poke_value
      # 符合条件，标设为三张，和最大牌值
      card.card_type = CardType::THREE_WITH_ONE
      card.max_poke_value = poke_cards[0].poke_value
      #或者后三张的牌值必须相同?
    elsif poke_cards[1].poke_value == poke_cards[2].poke_value &&
      poke_cards[1].poke_value == poke_cards[3].poke_value
      # 符合条件，标设为三张，和最大牌值
      card.card_type = CardType::THREE_WITH_ONE
      card.max_poke_value = poke_cards[1].poke_value
      card.card_length = 1
    end

    card.card_type != CardType::NONE
  end


  # /* 检查三带一对, 条件：5张牌， 三张 + 对子 */
  def self.check_three_with_pairs(card)
    # 取出牌
    poke_cards = card.poke_cards
    # 牌数必须为5
    return false if poke_cards.length != 5

    # 有3张的牌值相同， 和2张相同
    has_three = false
    has_two = false
    three_index = 0

    poke_cards.each_index do |n|
      count = CardUtility.get_poke_count(poke_cards, n)
      if count == 3
        has_three = true
        three_index = n

      elsif count == 2
        has_two = true
      end
    end

    # 是否三带一对
    if has_three && has_two
      # 符合条件，标设为三带一对，和最大牌值
      card.card_type = CardType::THREE_WITH_PAIRS
      card.max_poke_value = poke_cards[three_index].poke_value
      card.card_length = 1
      return true
    end

    false
  end

  # /* 检查炸弹， 条件：四张牌一样 */
  def self.check_bomb(card)
    # 取出牌
    poke_cards = card.poke_cards
    # 牌数必须为4
    return false if poke_cards.length != 4

    # 4张的牌值必须相同?
    if poke_cards[0].poke_value == poke_cards[1].poke_value &&
      poke_cards[0].poke_value == poke_cards[2].poke_value &&
      poke_cards[0].poke_value == poke_cards[3].poke_value
      # 符合条件，标设为炸弹，和最大牌值
      card.card_type = CardType::BOMB
      card.max_poke_value = poke_cards[0].poke_value
      card.card_length = 1

      return true
    end

    false
  end


  #/* 检查4带2，条件：有四张相同 */
  def self.check_four_with_two(card)
    # 取出牌
    poke_cards = card.poke_cards
    # 牌数必须为4
    return false if poke_cards.length != 6

    # 有4张的牌值相同?
    has_four = false
    four_index = 0
    poke_cards.each_index do |n|
      count = CardUtility.get_poke_count(poke_cards, n)
      if count == 4
        has_four = true
        four_index = n
      end
    end

    # 是否4带2
    if has_four
      # 符合条件，标设为四带二，和最大牌值
      card.card_type = CardType::FOUR_WITH_TWO
      card.max_poke_value = poke_cards[four_index].poke_value
      card.card_length = 1
      return true
    end

    false
  end

  # /* 检查4带2对，条件：8张， 有四张相同， 另外4张为2个对子 */
  def self.check_four_with_two_pairs(card)
    # 取出牌
    poke_cards = card.poke_cards
    # 牌数必须为8
    return false if (poke_cards.length != 8)

    # 有4张的牌值相同?
    has_four = false
    four_index = 0
    two_pairs_array = []
    poke_cards.each_index do |n|
      count = CardUtility.get_poke_count(poke_cards, n)
      if (count == 4)
        has_four = true
        four_index = n
      end
      two_pairs_array.push(poke_cards[n].poke_value) if (count == 2)
    end

    two_pairs_array.uniq!

    # 是否4带2对
    if has_four && two_pairs_array.length == 2
      # 符合条件，标设为四带二对，和最大牌值
      card.card_type = CardType::FOUR_WITH_TWO_PAIRS
      card.max_poke_value = poke_cards[four_index].poke_value
      card.card_length = 1
      return true
    end

    false
  end


  # /* 检查飞机， 条件： 大于等于8张牌，能被4整除，有三顺 */
  def self.check_plane(card)
    # 取出牌
    poke_cards = card.poke_cards
    # 牌数必须 大于8张牌，能被4整除
    return false unless poke_cards.length >=8 && (poke_cards.length % 4 == 0)

    three_cards = []
    poke_cards.each_index do |n|
      count = CardUtility.get_poke_count(poke_cards, n)
      three_cards.push(poke_cards[n]) if count == 3
    end

    #  剔除重复的牌
    three_cards.uniq! { |p| p.poke_value }
    #  三张的个数必须等于牌数整除4
    return false if three_cards.length * 4 != poke_cards.length

    #   三张必须是顺子
    if CardUtility.check_straight(three_cards)
      # 符合条件，标设为飞机，和最大牌值为三顺的最大牌
      card.card_type = CardType::PLANE
      card.max_poke_value = three_cards[three_cards.length-1].poke_value
      card.card_length = three_cards.length

      return true
    end

    false
  end


  # /* 检查飞机带翅膀， 条件： 大于等于10张牌，能被5整除，有三顺 和 余下全是对子*/
  def self.check_plane_with_wing(card)
    # 取出牌
    poke_cards = card.poke_cards
    # 牌数必须 大于等于10张牌，能被5整除
    return false if (!(poke_cards.length >=10 && (poke_cards.length % 5 == 0)))

    three_cards = []
    pairs_cards = []
    poke_cards.each_index do |n|
      count = CardUtility.get_poke_count(poke_cards, n)
      three_cards.push(poke_cards[n]) if count == 3
      pairs_cards.push(poke_cards[n]) if count == 2
    end

    # 剔除重复的牌
    three_cards.uniq! { |p| p.poke_value }
    pairs_cards.uniq! { |p| p.poke_value }
    # 三张的个数和对子的个数必须等于牌数整除5,
    return false if (three_cards.length != (poke_cards.length / 5) ||
      pairs_cards.length != (poke_cards.length / 5))

    # 三张必须是顺子
    if CardUtility.check_straight(three_cards)
      # 符合条件，标设为飞机，和最大牌值为三顺的最大牌
      card.card_type = CardType::PLANE_WITH_WING
      card.max_poke_value = three_cards[three_cards.length-1].poke_value
      card.card_length = three_cards.length

      return true
    end

    false
  end


  # /* 检测双顺， 条件：牌数>=6, 全是连续的对子，且不含2 */
  def self.check_pairs_straight(card)
    # 取出牌
    poke_cards = card.poke_cards
    # 牌数必须 大于6张牌，能被2整除
    return false if (!(poke_cards.length >=6 && (poke_cards.length % 2 == 0)))


    couple_cards = []
    poke_cards.each_index do |n|
      count = CardUtility.get_poke_count(poke_cards, n)
      couple_cards.push(poke_cards[n]) if (count == 2)
    end

    # 剔除重复的牌
    couple_cards.uniq! { |p| p.poke_value }

    # 对子数量必须为牌数/2
    return false if (couple_cards.length * 2 != poke_cards.length)


    # 必须是顺牌
    if CardUtility.check_straight(couple_cards)
      # 符合条件，标设为双顺，和最大牌值为双顺的最大牌，及顺子对数
      card.card_type = CardType::PAIRS_STRAIGHT
      card.max_poke_value = couple_cards.last.poke_value
      card.card_length = couple_cards.length

      return true
    end

    false
  end


  # /* 检测三顺， 条件：牌数>=6, 全是连续的三张，且不含2 */
  def self.check_three_straight(card)
    # 取出牌
    poke_cards = card.poke_cards
    # 牌数必须 大于6张牌，能被3整除
    return false if (!(poke_cards.length >=6 && (poke_cards.length % 3 == 0)))

    couple_cards = []
    poke_cards.each_index do |n|
      count = CardUtility.get_poke_count(poke_cards, n)
      couple_cards.push(poke_cards[n]) if (count == 3)
    end

    # 剔除重复的牌
    unique_cards = couple_cards.uniq { |p| p.poke_value }
    # 对子数量必须为牌数/3
    return false if (unique_cards.length * 3 != poke_cards.length)

    # 必须是顺牌
    if CardUtility.check_straight(unique_cards)
      # 符合条件，标设为三顺，和最大牌值为三顺的最大牌，及顺子对数
      card.card_type = CardType::THREE_STRAIGHT
      card.max_poke_value = unique_cards.last.poke_value
      card.card_length = unique_cards.length

      return true
    end

    false
  end

  #如果上手牌为自已所出，则enemy_all_pokes 不为空， 要考虑对手牌的情况，last_poke_card = nil
  #如果上手牌为自已所出，且下家为队友，则partner_all_pokes不为空，要考虑下家队友的情况，source_pokes = nil
  #如果上手牌非自已所出，enemy_all_pokes , partner_all_pokes 都为 nil， 只考虑对手牌张数 enemy_pokes_count, 及上手牌
  #如果上手牌非自己所出，且为队友所出，已排除压队友3张及以上，或牌值大于等于10 的牌
  def self.get_larger_card(all_pokes, source_pokes, enemy_all_poke_cards, partner_all_poke_cards, enemy_pokes_count)
    #partner is team member also is next player
    all_cards = get_all_card_type(all_pokes)
    enemy_cards = get_all_card_type(enemy_all_poke_cards)
    partner_cards = get_all_card_type(partner_all_poke_cards)

    enemy_last_card = get_last_card(enemy_all_poke_cards)
    partner_last_card = get_last_card(partner_all_poke_cards)

    result_card = nil

    if source_pokes.blank?

      if !partner_last_card.nil? and partner_last_card.card_type != CardType::NONE
        result_card = get_min_specify_card(all_cards[:four_cards], all_cards[:pairs_cards],
                                           all_cards[:pairs_straight_cards], all_cards[:result_card],
                                           all_cards[:single_cards], all_cards[:straight_cards],
                                           all_cards[:three_cards], partner_last_card.card_type)
      end

      if result_card.nil? and !enemy_last_card.nil? and enemy_last_card.card_type != CardType::NONE
        result_card = get_larger_return_card(all_cards[:four_cards], all_cards[:pairs_cards],
                                             all_cards[:pairs_straight_cards], result_card, enemy_last_card,
                                             all_cards[:single_cards], all_cards[:straight_cards],
                                             all_cards[:three_cards], 0)
        if result_card.nil?
          result_card = get_min_return_card(all_cards[:four_cards], all_cards[:pairs_cards],
                                            all_cards[:pairs_straight_cards], all_cards[:single_cards],
                                            all_cards[:straight_cards], all_cards[:three_cards],
                                            enemy_last_card.card_type)
        end
      end

      if result_card.nil?
        result_card = get_min_return_card(all_cards[:four_cards], all_cards[:pairs_cards],
                                          all_cards[:pairs_straight_cards], all_cards[:single_cards],
                                          all_cards[:straight_cards], all_cards[:three_cards], CardType::NONE)
      end

    else
      s_pokes = get_cards_by_str_array(source_pokes)
      s_card = get_card(s_pokes)

      result_card = get_larger_return_card(all_cards[:four_cards], all_cards[:pairs_cards],
                                           all_cards[:pairs_straight_cards], result_card, s_card,
                                           all_cards[:single_cards], all_cards[:straight_cards],
                                           all_cards[:three_cards], enemy_pokes_count)
    end

    result_card.get_card_string_array unless result_card.nil?

  end

  def self.has_king_bomb?(all_cards)
    return false if all_cards.blank?
    return false if all_cards[:king_bomb].blank?
    true
  end

  def self.most_power_cards(all_cards, c_type)
    return all_cards[:single_cards].last if c_type == CardType::SINGLE
    return all_cards[:pairs_cards].last if c_type == CardType::PAIRS
    return all_cards[:three_cards].last if c_type == CardType::THREE
    return all_cards[:four_cards].last if c_type == CardType::BOMB
    return all_cards[:straight_cards].last if c_type == CardType::STRAIGHT
    return all_cards[:pairs_straight_cards].last if c_type == CardType::PAIRS_STRAIGHT

  end

  def self.get_last_card(last_str_pokes)
    last_card = nil
    unless last_str_pokes.nil?
      last_pokes = get_cards_by_str_array(last_str_pokes)
      last_card = get_card(last_pokes)
    end
    last_card
  end

  def self.get_all_card_type(all_pokes)
    return nil if all_pokes.nil?
    single_cards = []
    pairs_cards = []
    three_cards = []
    four_cards = []
    king_bomb = []
    straight_cards = []
    pairs_straight_cards = []

    combine_pokes(all_pokes, four_cards, pairs_cards, single_cards, three_cards)
    straight_cards = get_straight(pairs_cards.dup, single_cards.dup)
    pairs_straight_cards = get_pair_straight(three_cards.dup, pairs_cards.dup)
    king_bomb = get_king_bomb(single_cards)

    all_card_types = {:single_cards => single_cards, :pairs_cards => pairs_cards, :three_cards => three_cards,
                      :four_cards => four_cards, :straight_cards => straight_cards,
                      :pairs_straight_cards => pairs_straight_cards, :king_bomb => king_bomb}
  end

  def self.get_min_return_card(four_cards, pairs_cards, pairs_straight_cards, single_cards,
    straight_cards, three_cards, ignore_card_type)
    result_card = nil
    return_cards = []
    if straight_cards.length > 0 and ignore_card_type != CardType::STRAIGHT
      return_cards.push get_card(straight_cards.first)
    end

    if pairs_straight_cards.length > 0 and ignore_card_type != CardType::PAIRS_STRAIGHT
      return_cards.push get_card(pairs_straight_cards.first)
    end

    if three_cards.length > 0 and single_cards.length > 0 and ignore_card_type != CardType::THREE_WITH_ONE
      return_cards.push get_larger_three_with_one(three_cards, single_cards, nil)
    end

    if three_cards.length > 0 and pairs_cards.length > 0 and ignore_card_type != CardType::THREE_WITH_PAIRS
      return_cards.push get_larger_three_with_one(three_cards, pairs_cards, nil)
    end

    return_cards = return_cards - [nil]
    if return_cards.length == 0
      return_cards.push get_card(single_cards.first) if single_cards.length > 0 and ignore_card_type != CardType::SINGLE
      return_cards.push get_card(pairs_cards.first) if pairs_cards.length > 0 and ignore_card_type != CardType::PAIRS
      return_cards.push get_card(three_cards.first) if three_cards.length > 0 and ignore_card_type != CardType::THREE
    end

    return_cards = return_cards - [nil]
    if return_cards.length > 0
      rand_index = rand(0..return_cards.length-1)
      result_card = return_cards[rand_index]
    elsif four_cards.length > 0
      result_card = get_card(four_cards.first)
    end
    result_card
  end

  def self.get_larger_return_card(four_cards, pairs_cards, pairs_straight_cards, result_card, s_card,
    single_cards, straight_cards, three_cards, enemy_pokes_count)
    if s_card.card_type == CardType::SINGLE
      result_card = get_larger_card_helper(single_cards, s_card)
    elsif s_card.card_type == CardType::PAIRS
      result_card = get_larger_card_helper(pairs_cards, s_card)
    elsif s_card.card_type == CardType::THREE
      result_card = get_larger_card_helper(three_cards, s_card)
    elsif s_card.card_type == CardType::THREE_WITH_ONE
      result_card = get_larger_three_with_one(three_cards, single_cards, s_card)
    elsif s_card.card_type == CardType::THREE_WITH_PAIRS
      result_card = get_larger_three_with_one(three_cards, pairs_cards, s_card)
    elsif s_card.card_type == CardType::FOUR_WITH_TWO
      result_card = get_larger_four_with_two(four_cards, single_cards, s_card)
    elsif s_card.card_type == CardType::FOUR_WITH_TWO_PAIRS
      result_card = get_larger_four_with_two(four_cards, pairs_cards, s_card)
    elsif s_card.card_type == CardType::STRAIGHT
      result_card = get_larger_straight(straight_cards, s_card)
    elsif s_card.card_type == CardType::PAIRS_STRAIGHT
      result_card = get_larger_pairs_straight(pairs_straight_cards, s_card)
    elsif s_card.card_type == CardType::BOMB
      result_card = get_larger_card_helper(four_cards, s_card)
    end
    if result_card.nil? && s_card.card_type != CardType::BOMB &&
      (s_card.max_poke_value > 13 or enemy_pokes_count < 10 or enemy_pokes_count == 0)
      result_card = get_larger_card_helper(four_cards, s_card)
    end
    result_card
  end

  def self.get_min_specify_card(four_cards, pairs_cards, pairs_straight_cards, result_card,
    single_cards, straight_cards, three_cards, card_type)
    s_card=nil
    if card_type == CardType::SINGLE
      result_card = get_larger_card_helper(single_cards, s_card)
    elsif card_type == CardType::PAIRS
      result_card = get_larger_card_helper(pairs_cards, s_card)
    elsif card_type == CardType::THREE
      result_card = get_larger_card_helper(three_cards, s_card)
    elsif card_type == CardType::THREE_WITH_ONE
      result_card = get_larger_three_with_one(three_cards, single_cards, s_card)
    elsif card_type == CardType::THREE_WITH_PAIRS
      result_card = get_larger_three_with_one(three_cards, pairs_cards, s_card)
    elsif card_type == CardType::FOUR_WITH_TWO
      result_card = get_larger_four_with_two(four_cards, single_cards, s_card)
    elsif card_type == CardType::FOUR_WITH_TWO_PAIRS
      result_card = get_larger_four_with_two(four_cards, pairs_cards, s_card)
    elsif card_type == CardType::STRAIGHT
      result_card = get_larger_straight(straight_cards, s_card)
    elsif card_type == CardType::PAIRS_STRAIGHT
      result_card = get_larger_pairs_straight(pairs_straight_cards, s_card)
    elsif card_type == CardType::BOMB
      result_card = get_larger_card_helper(four_cards, s_card)
    end
    result_card
  end

  def self.combine_pokes(all_pokes, four_cards, pairs_cards, single_cards, three_cards)
    all_cards = get_cards_by_str_array(all_pokes)
    sort_cards = all_cards.sort { |x, y|
      x.poke_value <=> y.poke_value
    }
    Rails.logger.debug("[get_card_larger_card] sort_cards =>"+sort_cards.to_json)
    tmp_cards = []
    sort_cards.each_with_index do |card, index|
      need_push = true
      if tmp_cards.length ==0 || card.poke_value == tmp_cards.last.poke_value
        need_push = false
      end
      if index == (sort_cards.length - 1)
        if tmp_cards.length >0 && card.poke_value == tmp_cards.last.poke_value
          tmp_cards.push card
        else
          single_cards.push tmp_cards.dup if tmp_cards.length == 1
          single_cards.push [card]
        end
        need_push = tmp_cards.length > 1 ? true : false
      end
      if need_push && tmp_cards.length >0
        if tmp_cards.length == 1
          single_cards.push tmp_cards.dup
        elsif tmp_cards.length == 2
          pairs_cards.push tmp_cards.dup
        elsif tmp_cards.length == 3
          three_cards.push tmp_cards.dup
        elsif tmp_cards.length == 4
          four_cards.push tmp_cards.dup
        end
        Rails.logger.debug("[get_card_larger_card] tmp_cards =>"+tmp_cards.to_json)
        tmp_cards.clear
      end
      tmp_cards.push card
    end
  end

  def self.get_king_bomb(single_cards)
    return [] if single_cards.size < 2
    all_cards = []
    all_cards.push single_cards.last[0]
    single_cards.each do |one_card|
      if one_card[0].poke_value < 15
        all_cards = all_cards + one_card
      end
    end
    sort_cards = all_cards.sort { |x, y|
      y.poke_value <=> x.poke_value
    }
    sort_cards.each do |card|

    end
  end

  def self.get_pair_straight(three_cards, pairs_cards)
    all_cards = []
    three_cards.each do |three_card|
      if three_card[0].poke_value < 15
        all_cards = all_cards + three_card[0..1]
      end
    end
    pairs_cards.each do |pairs_card|
      if pairs_card[0].poke_value < 15
        all_cards = all_cards + pairs_card
      end
    end
    sort_cards = all_cards.sort { |x, y|
      x.poke_value <=> y.poke_value
    }
    Rails.logger.debug("[get_pair_straight] sort_cards =>"+sort_cards.to_json)
    tmp_cards = sort_cards.dup
    pairs_straight_cards = []
    pairs_straight_card = []

    sort_cards.each_with_index do |card, i|
      pairs_straight_card.push card
      if (i+1)%2 == 0
        compare_card = card
        tmp_pairs_cards = []
        tmp_cards.each_with_index do |next_card, j|
          tmp_pairs_cards.push next_card
          if (j+1)%2 == 0
            if compare_card.poke_value + 1 == next_card.poke_value
              pairs_straight_card = pairs_straight_card + tmp_pairs_cards.dup
              compare_card = next_card
            end
            tmp_pairs_cards.clear
          end
        end
        pairs_straight_cards.push pairs_straight_card.dup if pairs_straight_card.length > 5
        pairs_straight_card.clear
      end

    end
    pairs_straight_cards
  end

  def self.get_straight(pairs_cards, single_cards)
    all_cards = []
    pairs_cards.each do |pairs_card|
      if pairs_card[0].poke_value < 15
        all_cards.push pairs_card[0]
      end
    end
    single_cards.each do |one_card|
      if one_card[0].poke_value < 15
        all_cards = all_cards + one_card
      end
    end
    sort_cards = all_cards.sort { |x, y|
      x.poke_value <=> y.poke_value
    }
    Rails.logger.debug("[get_straight] sort_cards =>"+sort_cards.to_json)
    tmp_cards = sort_cards.dup
    straight_cards = []
    straight_card = []
    sort_cards.each do |card|
      straight_card.push card
      compare_card = card
      tmp_cards.each do |next_card|
        if compare_card.poke_value + 1 == next_card.poke_value and next_card.poke_value < 15
          straight_card.push next_card
          compare_card = next_card
        end
      end
      straight_cards.push straight_card.dup if straight_card.length > 4
      straight_card.clear
    end
    straight_cards
  end

  def self.get_larger_card_helper(cards, s_card)
    result_card = nil
    cards.each do |card|
      tmp_card = get_card(card)
      if s_card.nil? || compare(tmp_card, s_card)
        result_card = tmp_card
        break
      end
    end
    result_card
  end

  def self.get_larger_three_with_one(three_cards, single_cards, s_card)
    result_card = nil
    one_card = single_cards.length > 0 ? single_cards.first : nil
    unless one_card.nil? or one_card[0].poke_value > 14
      three_cards.each do |three_card|
        tmp_card = get_card(three_card + one_card)
        if s_card.nil? || compare(tmp_card, s_card)
          result_card = tmp_card
          break
        end
      end
    end
    result_card
  end

  def self.get_larger_four_with_two(four_cards, with_two_cards, s_card)
    result_card = nil
    with_two_card = with_two_cards.length > 1 ? with_two_cards.first+with_two_cards[1] : nil
    skip = false
    unless with_two_card.nil?
      with_two_card.each do |card|
        if card.poke_value > 14
          skip = true
        end
      end
    end

    unless with_two_card.nil? or skip
      four_cards.each do |four_card|
        tmp_card = get_card(four_card + with_two_card)
        if s_card.nil? || compare(tmp_card, s_card)
          result_card = tmp_card
          break
        end
      end
    end
    result_card
  end

  def self.get_larger_straight(straight_cards, s_card)
    result_card = nil
    straight_cards.each do |straight_card|
      if straight_card.length >= s_card.poke_cards.length
        tmp_card = get_card(straight_card[0..s_card.poke_cards.length-1])
        if compare(tmp_card, s_card)
          result_card = tmp_card
          break
        end
      end
    end
    result_card
  end

  def self.get_larger_pairs_straight(pairs_straight_cards, s_card)
    result_card = nil
    pairs_straight_cards.each do |straight_card|
      if straight_card.length >= s_card.poke_cards.length
        tmp_card = get_card(straight_card[0..s_card.poke_cards.length-1])
        if compare(tmp_card, s_card)
          result_card = tmp_card
          break
        end
      end
    end
    result_card
  end

  def self.get_cards_by_str_array(str_array)
    cards = []
    str_array.each do |str_p|
      poke = PokeCard.get_by_poke_id(str_p)
      cards.push poke
    end
    cards
  end

  def self.get_cards_with_17(poke_cards=nil)
    poke_cards = @@all_poke_cards.shuffle if poke_cards.nil?
    tmp_poke_cards = poke_cards.shift(17)
    sort_poke_card(tmp_poke_cards)
  end

  def self.sort_poke_card(poke_cards=nil)
    poke_cards = poke_cards.sort
    return_poke_cards = []
    temple_pokes = poke_cards.dup
    temple_pokes.each do |poke_card|
      if poke_card.include?("w")
        return_poke_cards.push(poke_card)
        poke_cards.delete("#{poke_card}")
      end
    end
    temple_pokes = poke_cards.dup #先排序大小王


    temple_pokes.each do |poke_card|
      if poke_card.include?("02")
        return_poke_cards.push(poke_card)
        poke_cards.delete(poke_card)
      end
    end #排序 2

    temple_pokes = poke_cards.dup


    temple_pokes.each do |poke_card|
      if poke_card.include?("01")
        return_poke_cards.push(poke_card)
        poke_cards.delete(poke_card)
      end
    end #排序 1

    temple_pokes = poke_cards.dup


    i = 13

    while i>2
      temple_pokes.each do |poke_card|
        if poke_card.include?("#{i}")
          return_poke_cards.push(poke_card)
          poke_cards.delete(poke_card)
        end
      end
      temple_pokes = poke_cards.dup
      i= i -1
    end #排序3到13

    return_poke_cards

  end

  def judge_shun_zi(poke_cards,max=nil)
    shou = []
    tmp_card = poke_cards.clone
    tmp_card.each do |i|
       next if i < max.to_s
       shou.push(i)
       next if poke_cards.include?("#{i.to_i+1}")
       break if shou.size == 5
       break if !poke_cards.include?("#{i.to_i+1}")
    end
    if shou.size < 5
      max = shou[shou.size - 1]
      shou = []
    end
    [max,shou]
  end

  def pokes(all_pokes,min_shou = nil,max = nil)
    min_shou = [] if min_shou.nil?
    max,tmp_arr = judge_shun_zi(all_pokes,max)
    if tmp_arr.size >=5
      all_pokes = all_pokes - tmp_arr
      min_shou.push(tmp_arr)
    end

    pokes(all_pokes,min_shou,max) if all_pokes[0] <= "10"
  end

end