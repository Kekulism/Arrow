SMODS.Sound({ key = "vhsopen", path = "vhsopen.ogg"})
SMODS.Sound({ key = "vhsclose", path = "vhsclose.ogg"})
SMODS.UndiscoveredSprite{
    key = "VHS",
    atlas = "arrow_undiscovered",
    pos = { x = 0, y = 0 }
}
SMODS.ConsumableType{
    key = "VHS",
    primary_colour = G.C.VHS,
    secondary_colour = G.C.VHS,
    collection_rows = { 7, 6 },
    shop_rate = 0,
    loc_txt = {},
    default = "c_csau_blackspine",
    can_stack = false,
    can_divide = false,
}