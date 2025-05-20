function SMODS.current_mod.reset_game_globals(run_start)
    if run_start then
        G.GAME.modifiers.max_stands = G.GAME.modifiers.max_stands or 1
        if G.GAME.modifiers.csau_marathon then
            -- set all consumable types besides VHS to 0 shop rate
            for _, v in pairs(SMODS.ConsumableTypes) do
                if v.key ~= 'VHS' then
                    local key = v.key:lower() .. '_rate'
                    G.GAME[key] = 0
                end
            end
        end
    end
end

local ref_ccuib = SMODS.card_collection_UIBox
SMODS.card_collection_UIBox = function(_pool, rows, args)
    if _pool == G.P_CENTER_POOLS.Stand then
        args.modify_card = function(card, center, i, j)
            card.sticker = get_stand_win_sticker(center)
        end
    end
    return ref_ccuib(_pool, rows, args)
end