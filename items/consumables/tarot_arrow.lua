local consumInfo = {
    name = 'The Arrow',
    set = 'Tarot',
    cost = 3,
    alerted = true,
    part = 'diamond',
}

function consumInfo.in_pool(self, args)
    if not G.FUNCS.arrow_consumabletype_has_items('Stand') then
        return false
    end
end

function consumInfo.loc_vars(self, info_queue, card)
    if G.GAME and G.GAME.unlimited_stands then
        info_queue[#info_queue+1] = {key = "stand_info_unlimited", set = "Other"}
    else
        if card.area then
            info_queue[#info_queue+1] = {key = "stand_info", set = "Other", vars = { G.GAME and G.GAME.modifiers.max_stands or 1, (card.area.config.collection and localize('k_stand')) or (G.GAME.modifiers.max_stands > 1 and localize('b_stand_cards') or localize('k_stand')) }}
        end
    end
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { G.arrow_team.gote } }
end

function consumInfo.use(self, card, area, copier)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('timpani')
        if next(SMODS.find_card("c_jojobal_vento_gold")) then
            local stand = SMODS.find_card("c_jojobal_vento_gold")[1]
            check_for_unlock({ type = "evolve_ger" })
            G.FUNCS.evolve_stand(stand)
        else
            G.FUNCS.new_stand(false)
        end
        return true
    end }))
    delay(0.6)
end

function consumInfo.can_use(self, card)
    if G.consumeables.config.card_limit <= #G.consumeables.cards - (card.area == G.consumeables and 1 or 0) then
        return false
    end

    return G.GAME.unlimited_stands or (to_big(G.FUNCS.get_num_stands()) < to_big(G.GAME.modifiers.max_stands)) or next(SMODS.find_card("c_jojobal_vento_gold"))
end

return consumInfo