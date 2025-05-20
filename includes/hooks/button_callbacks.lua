local ref_uc = G.FUNCS.use_card
G.FUNCS.use_card = function(e, mute, nosave)
    local card = e.config.ref_table
    if card.area == G.consumeables and (card.ability.activation or (card.config.center.activate and type(card.config.center.activate) == 'function')) then
        if card.config.center.activate and type(card.config.center.activate) == 'function' then
            card.config.center.activate(card.config.center, card, not card.ability.activated)
        end
        if card.ability.activation then
            G.FUNCS.tape_activate(card)
            if G.CONTROLLER.HID.controller then
                card.children.focused_ui = G.UIDEF.card_focus_ui(card)
                G.CONTROLLER.locks.use = false
            else
                card:highlight(true)
            end
        end
        return
    end
    return ref_uc(e, mute, nosave)
end

local ref_bfs = G.FUNCS.buy_from_shop
G.FUNCS.buy_from_shop = function(e)
    ref_bfs(e)
    local c1 = e.config.ref_table
    if c1 and c1:is(Card) then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                if c1.ability.consumeable then
                    if c1.config.center.set == 'Stand' then
                        inc_career_stat('c_stands_bought', 1)
                    elseif c1.config.center.set == 'VHS' then
                        inc_career_stat('c_vhss_bought', 1)
                    end
                end
                return true
            end
        }))
    end
end

---------------------------
--------------------------- Stand buy space
---------------------------

local ref_check_buy_space = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
    local ret = ref_check_buy_space(card)
    if not ret then
        return ret
    end

    if card.ability.set == 'Stand' and not G.GAME.stand_unlimited_stands and G.FUNCS.get_leftmost_stand() then
        return false
    end

    return ret
end