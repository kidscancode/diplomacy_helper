extends Node

enum NATIONS {AUSTRIA, ENGLAND, FRANCE, GERMANY, ITALY, RUSSIA, TURKEY}
#var COLORS = {ENGLAND: Color8(28, 37, 250),
#			  FRANCE: Color8(52, 190, 230),
#			  GERMANY: Color8(247, 150, 24),
#			  AUSTRIA: Color8(140, 83, 214),
#			  ITALY: Color8(41, 175, 36),
#			  RUSSIA: Color8(226, 36, 36),
#			  TURKEY: Color8(234, 227, 32)}

var COLORS = {ENGLAND: Color8(92, 92, 255),
			  FRANCE: Color8(85, 255, 255),
			  GERMANY: Color8(75, 75, 75),
			  AUSTRIA: Color8(252, 127, 0),
			  ITALY: Color8(85, 255, 85),
			  RUSSIA: Color8(252, 57, 31),
			  TURKEY: Color8(255, 255, 85)}

var SUPPLY_CENTERS = ["BER", "MUN", "KIE", "POR", "SPA", "MAR", "PAR",
					  "BRE", "BEL", "HOL", "LON", "LVR", "EDI", "DEN",
					  "NOR", "SWE", "TUN", "NAP", "ROM", "VEN", "TRI",
					  "VIE", "BUD", "SER", "BUL", "RUM", "WAR", "MOS",
					  "STP", "SEV", "CON", "SMY", "ANK"]
			
enum MOVES {MOVE, HOLD, SUPPORT, CONVOY, NONE, DISBAND}
enum UNIT_TYPES {ARMY, FLEET}

# starting units
var STARTING_UNITS = [{"pos": Vector2(250, 250),
					   "nation": FRANCE,
					   "type": FLEET},
					  {"pos": Vector2(350, 350),
					   "nation": GERMANY,
					   "type": ARMY}]
				  