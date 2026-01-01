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

    return "arrow_"..string.lower(_front.suit), _front.pos
end

SMODS.Suits.Hearts.pos.y = 0
SMODS.Suits.Spades.pos.y = 0
SMODS.Suits.Diamonds.pos.y = 0
SMODS.Suits.Clubs.pos.y = 0

local default_suits = {
    Hearts = true,
    Clubs = true,
    Diamonds = true,
    Spades = true
}

for k, v in pairs(SMODS.Ranks) do
    v.suit_map.Hearts = 0
    v.suit_map.Clubs = 0
    v.suit_map.Diamonds = 0
    v.suit_map.Spades = 0
    v.lc_atlas = nil
    v.hc_atlas = nil
end

for k, v in pairs(G.P_CARDS) do
    if default_suits[v.suit] then
        v.atlas = 'arrow_'..v.suit
        v.pos.y = 0
    end
end

-- evil overwrite to remove the fallback atlases
SMODS.inject_p_card = function(suit, rank)
    G.P_CARDS[suit.card_key .. '_' .. rank.card_key] = {
        name = rank.key .. ' of ' .. suit.key,
        value = rank.key,
        suit = suit.key,
        pos = { x = rank.pos.x, y = rank.suit_map[suit.key] or suit.pos.y },
    }
end

for k, v in pairs(SMODS.DeckSkins) do
    if v.palettes then
        -- replace the default lc suit palette
        if k == 'default_'..v.suit then
            local palette = {
                key = 'lc',
                ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace",},
                display_ranks = {'King', 'Queen', 'Jack'},
                atlas = 'arrow_'..string.lower(v.suit),
                pos_style = 'suit'
            }
            v.palettes[1] = palette
            v.palette_map['lc'] = palette
        end

        -- TODO for other collabs, offer replacements

        -- eliminate ALL high contrast palettes
        if v.palettes[2] and v.palettes[2].key == 'hc' then
            table.remove(v.palettes, 2)
            v.palette_map['hc'] = nil
        end
    end
end
