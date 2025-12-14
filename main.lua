if ArrowAPI then
	sendDebugMessage('[ArrowAPI] already provided. Skipping...')
	return
end

ArrowAPI = SMODS.current_mod
ArrowAPI.startup_item_check = false
ArrowAPI.col_stand_hover = nil
ArrowAPI.palette_ui_config = {
	rgb = {0, 0, 0},
	open_palette = {
		set = '',
		idx = '',
	},
	hex_input = '',
	name_input = ''
}

-- TNSMI setup, aliased from ArrowAPI
TNSMI = SMODS.current_mod
TNSMI.cardareas = {}
TNSMI.prompt_text_input = ''
TNSMI.search_text = ''

G.C.SECONDARY_SET.SoundPack = HEX("56A887")
G.C.STAND = HEX('B85F8E')
G.C.VHS = HEX('a2615e')

G.C.BLIND.SHOWDOWN_COL_1 = copy_table(G.C.RED)
G.C.BLIND.SHOWDOWN_COL_2 = copy_table(G.C.BLUE)

-- copied from arrow
G.C.TAGS = {
    tag_uncommon = G.C.GREEN,
    tag_rare = G.C.RED,
    tag_negative = G.C.DARK_EDITION,
    tag_foil = G.C.DARK_EDITION,
    tag_holo = G.C.DARK_EDITION,
    tag_polychrome = G.C.DARK_EDITION,
    tag_investment = G.C.MONEY,
    tag_voucher = G.C.SECONDARY_SET.Voucher,
    tag_boss = G.C.IMPORTANT,
    tag_standard = G.C.IMPORTANT,
    tag_charm = G.C.SECONDARY_SET.Tarot,
    tag_meteor = G.C.SECONDARY_SET.Planet,
    tag_buffoon = G.C.RED,
    tag_handy = G.C.MONEY,
    tag_garbage = G.C.MONEY,
    tag_ethereal = G.C.SECONDARY_SET.Spectral,
    tag_coupon = G.C.MONEY,
    tag_double = G.C.IMPORTANT,
    tag_juggle = G.C.BLUE,
    tag_d_six = G.C.GREEN,
    tag_top_up = G.C.BLUE,
    tag_skip = G.C.MONEY,
    tag_orbital = G.C.SECONDARY_SET.Planet,
    tag_economy = G.C.MONEY,
	tag_spirit = G.C.STAND,
	tag_plinket = G.C.VHS
}

if not G.ARGS.LOC_COLOURS then loc_colour() end
G.ARGS.LOC_COLOURS['stand'] = G.C.STAND
G.ARGS.LOC_COLOURS['vhs'] = G.C.VHS
G.ARGS.LOC_COLOURS['eternal'] = G.C.ETERNAL
G.ARGS.LOC_COLOURS['perishable'] = G.C.PERISHABLE
G.ARGS.LOC_COLOURS['rental'] = G.C.RENTAL

-- dunno if I'll use these
G.ARGS.LOC_COLOURS['showdown1'] = G.C.BLIND.SHOWDOWN_COL_1
G.ARGS.LOC_COLOURS['showdown2'] = G.C.BLIND.SHOWDOWN_COL_2

local includes = {
	-- data types
	'loading',
	'loc',
	'sound',
	'compat',
	'math',
	'config',
	'logging',
	'string',
	'table',
	'pseudorandom',
	'colors',
	'ui',
	'credits',
	'shaders',

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

local module_path = ArrowAPI.path.."modules/Arrow"
local load_path = NFS.getInfo(module_path) and "modules/Arrow/"
ArrowAPI.custom_path = load_path

for _, include in ipairs(includes) do
	local init, error = SMODS.load_file((ArrowAPI.custom_path or "") .. "api/" .. include ..".lua")
	if error then sendErrorMessage("[Arrow] Failed to load "..include.." with error "..error) else
		init()
		sendDebugMessage("[Arrow] Loaded hook: " .. include)
	end
end

ArrowAPI.config_tools.use_credits(ArrowAPI, {
    matrix = {col = 18.5, row = 7},
    {
		key = 'direction',
		title_colour = G.C.YELLOW,
		pos_start = {col = 0, row = 0},
		pos_end = {col = 5, row = 10},
		contributors = {
			{name = "BarrierTrio/Gote"},
			{name = "Kekulism"},
			{name = "Vivian Giacobbi"},
		}
	},
	{
		key = 'artist',
		title_colour = G.C.ETERNAL,
		pos_start = {col = 5, row = 0},
		pos_end = {col = 12.5, row = 10},
	},
	{
		key = 'programmer',
		title_colour = G.C.GOLD,
		pos_start = {col = 12.5, row = 0},
		pos_end = {col = 20, row = 5},
	},
	{
		key = 'graphics',
		title_colour = G.C.DARK_EDITION,
		pos_start = {col = 12.5, row = 5},
		pos_end = {col = 20, row = 10},
		contributors = {
			{name = "Vivian Giacobbi"},
			{name = "Sir. Gameboy"}
		}
	}
})


ArrowAPI.config_tools.use_config(ArrowAPI, {
	{key = 'enable_ItemCredits', default_value = true},
	{key = 'enable_DetailedDescs', default_value = false},
	{key = 'rows', default_value = 2, exclude_from_ui = true},
	{key = 'cols', default_value = 6, exclude_from_ui = true},
	{key = 'loaded_packs', default_value = {
		[1] = "sp_balatro",
		replace_map = {}
	}, exclude_from_ui = true},
	{key = 'saved_palettes', default_value = {
		["Spectral"] = {
			{
				{61,68,96,["key"]="61-68-96",["default"]=true},
				{106,101,81,["key"]="106-101-81",["default"]=true},
				{78,87,121,["key"]="78-87-121",["default"]=true},
				{79,99,103,["key"]="79-99-103",["default"]=true},
				{92,120,125,["key"]="92-120-125",["default"]=true},
				{139,131,97,["key"]="139-131-97",["default"]=true},
				{167,156,103,["key"]="167-156-103",["default"]=true},
				{199,178,74,["key"]="199-178-74",["default"]=true},
				{232,214,127,["key"]="232-214-127",["default"]=true},
				{94,114,151,["key"]="94-114-151",["default"]=true},
				{82,100,162,["key"]="82-100-162",["default"]=true},
				{91,127,193,["key"]="91-127-193",["default"]=true},
				{114,151,217,["key"]="114-151-217",["default"]=true},
				{99,143,225,["key"]="99-143-225",["default"]=true},
				{122,164,242,["key"]="122-164-242",["default"]=true},
				{225,235,133,["key"]="225-235-133",["default"]=true},
				{239,241,156,["key"]="239-241-156",["default"]=true},
				{192,223,174,["key"]="192-223-174",["default"]=true},
				{207,229,185,["key"]="207-229-185",["default"]=true},
				{150,170,203,["key"]="150-170-203",["default"]=true},
				{137,198,234,["key"]="137-198-234",["default"]=true},
				{191,204,227,["key"]="191-204-227",["default"]=true},
				{144,226,249,["key"]="144-226-249",["default"]=true},
				{169,226,242,["key"]="169-226-242",["default"]=true},
				{226,235,249,["key"]="226-235-249",["default"]=true},
				{239,250,254,["key"]="239-250-254",["default"]=true},
				{255,84,104,["key"]="255-84-104",["default"]=true},
				{170,64,92,["key"]="170-64-92",["default"]=true},
				{255,255,255,["key"]="255-255-255",["default"]=true},
				["name"] = "Default",
			}, {
				{93,141,181,["key"]="94-114-151"},
				{81,110,146,["key"]="78-87-121"},
				{94,181,240,["key"]="99-143-225"},
				{91,166,221,["key"]="91-127-193"},
				{245,169,184,["key"]="199-178-74"},
				{249,136,153,["key"]="167-156-103"},
				{91,206,250,["key"]="122-164-242"},
				{248,196,203,["key"]="232-214-127"},
				{251,113,131,["key"]="139-131-97"},
				{51,65,89,["key"]="61-68-96"},
				{132,140,174,["key"]="92-120-125"},
				{86,136,168,["key"]="82-100-162"},
				{171,94,105,["key"]="106-101-81"},
				{89,135,187,["key"]="114-151-217"},
				{198,233,244,["key"]="169-226-242"},
				{250,222,227,["key"]="225-235-133"},
				{252,190,198,["key"]="192-223-174"},
				{251,177,188,["key"]="207-229-185"},
				{156,219,249,["key"]="144-226-249"},
				{250,219,223,["key"]="239-241-156"},
				{156,209,235,["key"]="137-198-234"},
				{251,113,131,["key"]="255-84-104"},
				{179,94,105,["key"]="170-64-92"},
				["name"] = "Spectrans",
				["badge_colour"] = "arrow_spectrans",
			},
			["saved_index"] = 2,
		},
		["Tarot"] = {
			{
				{79,99,103,["key"]="79-99-103",["default"]=true},
				{255,229,180,["key"]="255-229-180",["default"]=true},
				{218,183,114,["key"]="218-183-114",["default"]=true},
				{243,198,89,["key"]="243-198-89",["default"]=true},
				{165,133,71,["key"]="165-133-71",["default"]=true},
				{233,216,254,["key"]="233-216-254",["default"]=true},
				{214,186,249,["key"]="214-186-249",["default"]=true},
				{183,162,253,["key"]="183-162-253",["default"]=true},
				{167,145,243,["key"]="167-145-243",["default"]=true},
				{153,129,234,["key"]="153-129-234",["default"]=true},
				{138,113,225,["key"]="138-113-225",["default"]=true},
				{107,97,139,["key"]="107-97-139",["default"]=true},
				{255,255,255,["key"]="255-255-255",["default"]=true},
				["name"]="Default"
			},
			["saved_index"] = 1,
		},
		["Background"] = {
			{
				{80,132,110,["key"]="Small",["default"]=true},
				{79,99,103,["key"]="won",["default"]=true},
				{254,95,85,["key"]="SHOWDOWN_COL_1",["default"]=true},
				{0,157,255,["key"]="SHOWDOWN_COL_2",["default"]=true},
				["name"]="Default"
			},{
				{75,194,146,["key"]="SHOWDOWN_COL_1"},
				{136,103,165,["key"]="SHOWDOWN_COL_2"},
				["name"]="Cardsauce"
			},{
				{58,102,88,["key"]="Small"},
				{44,153,127,["key"]="SHOWDOWN_COL_1"},
				{9,39,29,["key"]="SHOWDOWN_COL_2"},
				["name"]="Darkshroom"
			},{
				{58,102,76,["key"]="Small"},
				{96,178,131,["key"]="SHOWDOWN_COL_1"},
				{163,200,111,["key"]="SHOWDOWN_COL_2"},
				["name"]="Vineshroom"
			},{
				{58,75,102,["key"]="Small"},
				{84,123,184,["key"]="SHOWDOWN_COL_1"},
				{103,184,116,["key"]="SHOWDOWN_COL_2"},
				["name"]="Fullsauce"
			},{
				{112,75,75,["key"]="Small"},
				{226,101,101,["key"]="SHOWDOWN_COL_1"},
				{165,59,56,["key"]="SHOWDOWN_COL_2"},
				["name"]="Extrasauce"
			},{
				{201,84,120,["key"]="Small"},
				{153,103,167,["key"]="SHOWDOWN_COL_1"},
				{72,48,98,["key"]="SHOWDOWN_COL_2"},
				["name"]="Twitch"
			},{
				{68,97,56,["key"]="Small"},
				{181,230,29,["key"]="SHOWDOWN_COL_1"},
				{4,161,229,["key"]="SHOWDOWN_COL_2"},
				["name"]="Fren"
			},{
				{101,84,120,["key"]="Small"},
				{136,103,165,["key"]="SHOWDOWN_COL_1"},
				{255,255,0,["key"]="SHOWDOWN_COL_2"},
				["name"]="Jabroni"
			},{
				{64,64,64,["key"]="Small"},
				{191,199,213,["key"]="SHOWDOWN_COL_1"},
				{55,66,68,["key"]="SHOWDOWN_COL_2"},
				["name"]="Uzumaki"
			},
			["saved_index"] = 2,
		},
		["Planet"] = {
			{
				{61,68,96,["key"] = "61-68-96",["default"] = true},
				{79,99,103,["key"]="79-99-103",["default"]=true},
				{88,96,127,["key"]="88-96-127",["default"]=true,},
				{59,102,131,["key"]="59-102-131",["default"]=true},
				{54,116,157,["key"]="54-116-157",["default"]=true},
				{72,94,137,["key"]="72-94-137",["default"]=true},
				{87,125,136,["key"]="87-125-136",["default"]=true},
				{102,99,149,["key"]="102-99-149",["default"]=true},
				{66,86,186,["key"]="66-86-186",["default"]=true},
				{135,119,176,["key"]="135-119-176",["default"]=true},
				{91,155,170,["key"]="91-155-170",["default"]=true},
				{77,138,223,["key"]="77-138-223",["default"]=true},
				{103,176,209,["key"]="103-176-209",["default"]=true},
				{116,198,208,["key"]="116-198-208",["default"]=true},
				{113,206,233,["key"]="113-206-233",["default"]=true},
				{253,220,160,["key"]="253-220-160",["default"]=true},
				{140,157,199,["key"]="140-156-199",["default"]=true},
				{176,189,214,["key"]="176-189-214",["default"]=true},
				{183,162,253,["key"]="183-162-253",["default"]=true},
				{132,197,210,["key"]="132-197-210",["default"]=true},
				{137,232,253,["key"]="137-232-253",["default"]=true},
				{223, 245, 252, ["key"] = "223-245-252", ["default"] = true,},
				{255, 255, 255, ["key"] = "255-255-255", ["default"] = true},
				["name"] = "Default",
			},
			["saved_index"] = 1,
		},
	}, exclude_from_ui = true},
})
