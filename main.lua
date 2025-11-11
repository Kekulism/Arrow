ArrowAPI = SMODS.current_mod
ArrowAPI.current_config = copy_table(ArrowAPI.config)
ArrowAPI.startup_item_check = false
ArrowAPI.col_stand_hover = nil

G.C.STAND = HEX('B85F8E')
G.C.VHS = HEX('a2615e')

if not G.ARGS.LOC_COLOURS then loc_colour() end
G.ARGS.LOC_COLOURS['stand'] = G.C.STAND
G.ARGS.LOC_COLOURS['vhs'] = G.C.VHS
G.ARGS.LOC_COLOURS['eternal'] = G.C.ETERNAL
G.ARGS.LOC_COLOURS['perishable'] = G.C.PERISHABLE
G.ARGS.LOC_COLOURS['rental'] = G.C.RENTAL

local includes = {
	-- data types
	'compat',
	'math',
	'config',
	'logging',
	'string',
	'table',
	'pseudorandom',
	'ui',
	'credits',
	'shaders',
	'loading',

	'hooks/node',
	'hooks/blind',
	'hooks/button_callbacks',
	'hooks/common_events',
	'hooks/cardarea',
	'hooks/card',
	'hooks/game',
	'hooks/back',
	'hooks/smods',
	'hooks/UI_definitions',

	'overrides',
	'stands',
	'vhs',
	'game',
	'misc',
}

for _, include in ipairs(includes) do
	local init, error = SMODS.load_file("api/" .. include ..".lua")
	if error then sendErrorMessage("[Arrow] Failed to load "..include.." with error "..error) else
		local data = init()
		sendDebugMessage("[Arrow] Loaded hook: " .. include)
	end
end

