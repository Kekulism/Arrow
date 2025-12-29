-- overwrite for palette generation
function get_front_spriteinfo(_front)
    if not _front.suit or not SMODS.DeckSkins[G.SETTINGS.CUSTOM_DECK.Collabs[_front.suit]] then
        return SMODS.get_atlas("cards_1"), _front.pos
    end

    local deckSkin = SMODS.DeckSkins[G.SETTINGS.CUSTOM_DECK.Collabs[_front.suit]]
    local palette = deckSkin.palette_map and deckSkin.palette_map[G.SETTINGS.colour_palettes[_front.suit] or ''] or (deckSkin.palettes or {})[1]

    local hasRank = false
    for i = 1, #palette.ranks do
        if palette.ranks[i] == _front.value then hasRank = true break end
    end

    if hasRank then
        local atlas = SMODS.get_atlas(palette.atlas)
        if type(palette.pos_style) == "table" then
            if palette.pos_style[_front.value] then
                if palette.pos_style[_front.value].atlas then
                    atlas = SMODS.get_atlas(palette.pos_style[_front.value].atlas)
                end
                if palette.pos_style[_front.value].pos then
                    return atlas, palette.pos_style[_front.value].pos
                end
            elseif palette.pos_style.fallback_style then
                if palette.pos_style.fallback_style == 'collab' then
                    return atlas, G.COLLABS.pos[_front.value]
                elseif palette.pos_style.fallback_style == 'suit' then
                    return atlas, { x = _front.pos.x, y = 0}
                elseif palette.pos_style.fallback_style == 'deck' then
                    return atlas, _front.pos
                end
            end
        elseif palette.pos_style == 'collab' then
            return atlas, G.COLLABS.pos[_front.value]
        elseif palette.pos_style == 'suit' then
            return atlas, { x = _front.pos.x, y = 0}
        elseif palette.pos_style == 'deck' then
            return atlas, _front.pos
        elseif palette.pos_style == 'ranks' or nil then
            for i, rank in ipairs(palette.ranks) do
                if rank == _front.value then
                    return atlas, { x = i - 1, y = 0}
                end
            end
        end
    end

    return SMODS.get_atlas("cards_1"), _front.pos
end

for suitName, _ in pairs(G.COLLABS.options) do
    local palettes = {
        {
            key = 'lc',
            ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace",},
            display_ranks = {'King', 'Queen', 'Jack'},
            atlas = 'arrow_suits',
            pos_style = 'suit'
        }
    }
    SMODS.DeckSkins['default_'..suitName].palettes[1] = palettes[1]
    SMODS.DeckSkins['default_'..suitName].palette_map['lc'] = palettes[1]
end
