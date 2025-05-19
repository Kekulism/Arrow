UsableModPath = SMODS.current_mod.path:match("Mods/[^/]+")
PathPatternReplace = UsableModPath:gsub("(%W)","%%%1")  -- shoot me in the foot, why doesn't lua just have a str.replace
arrow_config = SMODS.current_mod.config
arrow_enabled = copy_table(arrow_config)

SMODS.current_mod.DT = {}

G.C.STAND = HEX('B85F8E')
G.C.VHS = HEX('a2615e')

local includes = {
	'ui',
}

for _, include in ipairs(includes) do
	local init, error = SMODS.load_file("includes/" .. include ..".lua")
	if error then sendErrorMessage("[Arrow] Failed to load "..include.." with error "..error) else
		local data = init()
		sendDebugMessage("[Arrow] Loaded hook: " .. include)
	end
end
