SMODS.food_expires = function(context)
    if next(SMODS.find_card('j_csau_bunji')) then return false end
    return true
end

SMODS.return_to_hand = function(card, context)
    if not G.GAME.blind.disabled and G.GAME.blind.name == 'The Vod' then
        return true
    elseif G.GAME.fnwk_extra_blinds then
        for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
            if not v.disabled and v.name == 'The Vod' then
                return true
            end
        end
    end

    if G.FUNCS.find_activated_tape('c_csau_yoyoman') and table.contains(context.scoring_hand, card) then return true end
    if context.scoring_name == "High Card" and next(SMODS.find_card("j_csau_besomeone")) and table.contains(context.scoring_hand, card) then return true end
    return false
end

function SMODS.skip_cards_until(requirements, offset_pos)
    if not requirements then return end
    local len = #G.deck.cards
    for i = 1, len do
        local card = G.deck.cards[#G.deck.cards-offset_pos]
        local results = {}

        if requirements.rank_min then
            results.rank_min = card.base.nominal >= requirements.rank_min
        end
        local requirements_met = true
        for _, met in pairs(results) do
            if not met then
                requirements_met = false
                break
            end
        end

        if requirements_met then
            return card
        else
            table.remove(G.deck.cards, #G.deck.cards-offset_pos)
            table.insert(G.deck.cards, 1, card)
        end
    end
    return nil
end

function SMODS.draw_card_filtered(i, hand_space, mod_table)
    if mod_table.roar then
        local card = SMODS.skip_cards_until({ rank_min = 6 }, mod_table.roar)
        if not card then
            return
        else
            mod_table.roar = mod_table.roar + 1
        end
    end
    draw_card(G.deck,G.hand, i*100/hand_space,'up', true)
end

function SMODS.draw_cards_from_deck(hand_space, mod_table)
    mod_table = mod_table or {}
    local roar = G.FUNCS.find_activated_tape('c_csau_roar')
    if roar and not roar.ability.destroyed then
        mod_table.roar = 0
        roar:juice_up()
        roar.ability.extra.uses = roar.ability.extra.uses+1
        if roar.ability.extra.uses >= roar.ability.extra.runtime then
            G.FUNCS.destroy_tape(roar)
            roar.ability.destroyed = true
        end
    end
    for i=1, hand_space do --draw cards from deckL
        SMODS.draw_card_filtered(i, hand_space, mod_table)
    end

    mod_table.roar = nil
end

SMODS.spectral_downside = function()
    local rem = G.FUNCS.find_activated_tape('c_csau_remlezar')
    if rem and not rem.ability.destroyed then
        rem:juice_up()
        rem.ability.extra.uses = rem.ability.extra.uses+1
        if rem.ability.extra.uses >= rem.ability.extra.runtime then
            G.FUNCS.destroy_tape(rem)
            rem.ability.destroyed = true
        end
        return false
    end
    return true
end

SMODS.will_destroy_card = function()
    local sew = G.FUNCS.find_activated_tape('c_csau_sew')
    if sew and not sew.ability.destroyed then
        sew:juice_up()
        sew.ability.extra.uses = sew.ability.extra.uses+1
        if sew.ability.extra.uses >= sew.ability.extra.runtime then
            G.FUNCS.destroy_tape(sew)
            sew.ability.destroyed = true
        end
        return false
    end
    return true
end
