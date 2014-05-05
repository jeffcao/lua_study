
ROOM_TYPE_TELEPHONE_CHARGE = 3

--when charge room hall popup, set a timer to detect 24:00 to refresh data
--this is the time point to detect
CHARGE_ROOM_24_DETECT_MIN = 5 * 60
CHARGE_ROOM_24_DETECT_EXCEED = 2

CHARGE_MATCH_STATUS = {
	joining_enable = '10',
	joining_disable = '11',
	playing_joining_enable = '20',
	playing_joining_disable = '21',
	playing = '30',
	ended = '40'
}

--for test a move is click or flip
MOVE_TEST_LIMIT = 3