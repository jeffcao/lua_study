require "framework.functions"
require "framework.debug"
require "src.PokeCard"
require "src.CardUtility"
require 'src.LuaTableExtend'

cclog = function(msg)
	print(msg)
end


PokeCard.sharedPokeCard(nil)

last_p_cards = {}

table.insert(last_p_cards, PokeCard.getCardById("a01"))
table.insert(last_p_cards, PokeCard.getCardById("b01"))
-- dump(last_cards, "last_cards")
last_cards = CardUtility.getCard(last_p_cards)

source_cards = {}

-- table.insert(source_cards, PokeCard.getCardById("a02"))
-- table.insert(source_cards, PokeCard.getCardById("b02"))

table.insert(source_cards, PokeCard.getCardById("w01"))
table.insert(source_cards, PokeCard.getCardById("w02"))

table.insert(source_cards, PokeCard.getCardById("a04"))
table.insert(source_cards, PokeCard.getCardById("b04"))
table.insert(source_cards, PokeCard.getCardById("c04"))
table.insert(source_cards, PokeCard.getCardById("d07"))
-- dump(source_cards, "source_cards")


r_card = CardUtility.tip_card(last_cards, source_cards, false)
dump(r_card, "r_card")