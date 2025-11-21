---------------------------
--------------------------- Highlight limit overrides
---------------------------

SMODS.Consumable:take_ownership('c_strength', {
    config = { extra = 1, min_highlighted = 1, max_highlighted = 2 },
    loc_vars = function(self, info_queue, card)
        local multi = card.ability.max_highlighted ~= 1
        return {
            vars = {
                card.ability.max_highlighted,
                card.ability.extra
            },
            key = card.config and card.config.center.key..(multi and '_multi' or '') or nil
        }
    end,

    use = function(self, card, area, copier)
        for i=1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end

        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    assert(SMODS.modify_rank(G.hand.highlighted[i], card.ability.extra))
                    return true
                end
            }))
        end

        for i=1, #G.hand.highlighted do
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('tarot2', percent, 0.6);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))

        delay(0.5)
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.highlighted >= (card.ability.min_highlighted or 0) and #G.hand.highlighted <= (card.ability.max_highlighted or 0)
    end
}, true)

SMODS.Consumable:take_ownership('hanged_man', {
    loc_vars = function(self, info_queue, card)
        local multi = card.ability.max_highlighted ~= 1
        return {
            vars = {
                card.ability.max_highlighted,
            },
            key = card.config and card.config.center.key..(multi and '_multi' or '') or nil
        }
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.highlighted >= 0 and #G.hand.highlighted <= card.ability.max_highlighted
    end
}, true)

SMODS.Consumable:take_ownership('death', {
    loc_vars = function(self, info_queue, card)
        local multi = (card.ability.max_highlighted - 1) ~= 1
        return {
            vars = {
                card.ability.max_highlighted,
            },
            key = card.config and card.config.center.key..(multi and '_multi' or '') or nil
        }
    end,

    use = function(self, card, area, copier)
        for i=1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end

        local rightmost = G.hand.highlighted[1]
        for i=1, #G.hand.highlighted do
            if G.hand.highlighted[i].T.x > rightmost.T.x then
                rightmost = G.hand.highlighted[i]
            end
        end

        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    if G.hand.highlighted[i] ~= rightmost then
                        copy_card(rightmost, G.hand.highlighted[i])
                    end
                    return true
                end
            }))
        end

        for i=1, #G.hand.highlighted do
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('tarot2', percent, 0.6);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))

        delay(0.5)
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.highlighted >= card.ability.min_highlighted and #G.hand.highlighted <= card.ability.max_highlighted
    end
}, true)

local enhance_convert_keys = {
    'c_chariot',
    'c_devil',
    'c_justice',
    'c_lovers',
    'c_tower',
    'c_magician',
    'c_heirophant',
    'c_empress',
}

for _, v in ipairs(enhance_convert_keys) do
    local old_center = G.P_CENTERS[v]
    local mod_table = {
        config = {
            mod_conv = old_center.config.mod_conv,
            min_highlighted = old_center.config.min_highlighted or 1,
            max_highlighted = old_center.config.max_highlighted,
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_CENTERS[card.ability.mod_conv]
            local multi = card.ability.max_highlighted ~= 1
            return {
                vars = {
                    card.ability.max_highlighted,
                    localize{type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv}
                },
                key = card.config and card.config.center.key..(multi and '_multi' or '') or nil
            }
        end,

        use = function(self, card, area, copier)
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        G.hand.highlighted[i]:flip()
                        play_sound('card1', percent);
                        G.hand.highlighted[i]:juice_up(0.3, 0.3);
                        return true
                    end
                }))
            end

            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        G.hand.highlighted[i]:set_ability(G.P_CENTERS[card.ability.mod_conv])
                        return true
                    end
                }))
            end

            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        G.hand.highlighted[i]:flip();
                        play_sound('tarot2', percent, 0.6);
                        G.hand.highlighted[i]:juice_up(0.3, 0.3);
                        return true
                    end
                }))
            end

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.hand:unhighlight_all()
                    return true
                end
            }))

            delay(0.5)
        end,

        can_use = function(self, card)
            return G.hand and #G.hand.highlighted >= (card.ability.min_highlighted or 0) and #G.hand.highlighted <= (card.ability.max_highlighted or 0)
        end
    }

    SMODS.Consumable:take_ownership(v, mod_table, true)
end

local suit_convert_keys = {
    'c_star',
    'c_world',
    'c_sun',
    'c_moon'
}

for _, v in ipairs(suit_convert_keys) do
    local old_center = G.P_CENTERS[v]
    local mod_table = {
        config = {
            suit_conv = old_center.config.suit_conv,
            min_highlighted = old_center.config.min_highlighted or 1,
            max_highlighted = old_center.config.max_highlighted,
        },

        loc_vars = function(self, info_queue, card)
            local multi = card.ability.max_highlighted ~= 1
            return {
                vars = {
                    card.ability.max_highlighted,
                    localize(card.ability.suit_conv, 'suits_plural'),
                    colours = {
                        G.C.SUITS[card.ability.suit_conv]
                    }
                },
                key = card.config and card.config.center.key..(multi and '_multi' or '') or nil
            }
        end,

        use = function(self, card, area, copier)
            for i=1, #G.hand.highlighted do
                local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        G.hand.highlighted[i]:flip()
                        play_sound('card1', percent);
                        G.hand.highlighted[i]:juice_up(0.3, 0.3);
                        return true
                    end
                }))
            end

            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        G.hand.highlighted[i]:change_suit(card.ability.suit_conv)
                        return true
                    end
                }))
            end

            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        G.hand.highlighted[i]:flip();
                        play_sound('tarot2', percent, 0.6);
                        G.hand.highlighted[i]:juice_up(0.3, 0.3);
                        return true
                    end
                }))
            end

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.hand:unhighlight_all()
                    return true
                end
            }))

            delay(0.5)
        end,

        can_use = function(self, card)
            return G.hand and #G.hand.highlighted >= (card.ability.min_highlighted or 0) and #G.hand.highlighted <= (card.ability.max_highlighted or 0)
        end
    }

    SMODS.Consumable:take_ownership(v, mod_table, true)
end

-- TODO: better way to do the localization here
-- this tries to do it automatically, but it doesn't support different languages
local seal_keys = {'c_talisman', 'c_trance', 'c_medium', 'c_deja_vu'}
for _, v in ipairs(seal_keys) do
    local old_center = G.P_CENTERS[v]
    local mod_table = {
        config = {
            extra = old_center.config.extra,
            min_highlighted = old_center.config.min_highlighted or 1,
            max_highlighted = old_center.config.max_highlighted
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_SEALS[card.ability.extra]
            local multi = card.ability.max_highlighted ~= 1
            return {
                vars = {
                    localize{type = 'name_text', set = 'Other', key = string.lower(card.ability.extra) .. '_seal'},
                    card.ability.max_highlighted,
                },
                key = card.config and card.config.center.key..(multi and '_multi' or '') or nil
            }
        end,

        use = function(self, card, area, copier)
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                local conv_card = G.hand.highlighted[i]
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1', percent)
                        card:juice_up(0.3, 0.5)
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        conv_card:set_seal(card.ability.extra, nil, true)
                        return true
                    end
                }))
            end

            delay(0.5)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.hand:unhighlight_all();
                    return true
                end
            }))
        end,

        can_use = function(self, card)
            return G.hand and #G.hand.highlighted >= card.ability.min_highlighted and #G.hand.highlighted <= card.ability.max_highlighted
        end
    }

    SMODS.Consumable:take_ownership(v, mod_table, true)
end

local old_cryptid = G.P_CENTERS['c_cryptid']
SMODS.Consumable:take_ownership('c_cryptid', {
    config = {
        extra = old_cryptid.config.extra,
        min_highlighted = old_cryptid.config.min_highlighted or 1,
        max_highlighted = old_cryptid.config.max_highlighted
    },

    loc_vars = function(self, info_queue, card)
        local multi = card.ability.max_highlighted ~= 1
        return {
            vars = {
                card.ability.extra,
                card.ability.max_highlighted,
            },
            key = card.config and card.config.center.key..(multi and '_multi' or '') or nil
        }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            func = function()
                local _first_dissolve = nil
                local new_cards = {}
                for i=1, #G.hand.highlighted do
                    for j = 1, card.ability.extra do
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local _card = copy_card(G.hand.highlighted[i], nil, nil, G.playing_card)
                        _card:add_to_deck()
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        table.insert(G.playing_cards, _card)
                        G.hand:emplace(_card)
                        _card:start_materialize(nil, _first_dissolve)
                        _first_dissolve = true
                        new_cards[#new_cards+1] = _card
                    end
                end
                playing_card_joker_effects(new_cards)
                return true
            end
        }))

        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
                return true
            end
        }))
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.highlighted >= card.ability.min_highlighted and #G.hand.highlighted <= card.ability.max_highlighted
    end
}, true)

SMODS.Consumable:take_ownership('aura', {
    config = {min_highlighted = 1, max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        local multi = card.ability.max_highlighted ~= 1
        local poly_name = localize{type = 'name_text', key = 'e_polychrome', set = 'Edition'}
        return {
            vars = {
                card.ability.max_highlighted,
                poly_name
            },
            key = card.config and card.config.center.key..(multi and '_multi' or '') or nil
        }
    end,

    use = function(self, card, area, copier)
        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    local edition = poll_edition('aura', nil, true, true)
                    local aura_card = G.hand.highlighted[i]
                    aura_card:set_edition(edition, true)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end

        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
                return true
            end
        }))
    end,

    can_use = function(self, card)
        if not G.hand or #G.hand.highlighted < card.ability.min_highlighted or #G.hand.highlighted > card.ability.max_highlighted then
            return false
        end

        for _, v in ipairs(G.hand.highlighted) do
            if v.edition then return false end
        end

        return true
    end
}, true)





---------------------------
--------------------------- Batch level behavior
---------------------------

SMODS.Consumable:take_ownership('c_black_hole',
    {
        use = function(self, card, area, copier)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = true
                return true end }))
            update_hand_text({delay = 0}, {mult = '+', StatusText = true})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                return true end }))
            update_hand_text({delay = 0}, {chips = '+', StatusText = true})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = nil
                return true end }))
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+1'})
            delay(1.3)
            ArrowAPI.game.batch_level_up(card, SMODS.PokerHands)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
        end,
    },
    true
)





---------------------------
--------------------------- Inconsistent xmult fixes
---------------------------

SMODS.Joker:take_ownership('j_throwback', {
    loc_vars = function(self, info_queue, card)
        if not G.GAME then
            return { vars = { card.ability.extra, 1 }}
        end

        return { vars = {card.ability.extra, 1 + card.ability.extra * G.GAME.skips}}
    end,

    calculate = function(self, card, context)
        if not context.cardarea == G.jokers then return end

        if context.joker_main and G.GAME.skips > 0 then
            local x_mult = 1 + G.GAME.skips * card.ability.extra
            return {
                message = localize{type='variable',key='a_xmult',vars={x_mult}},
                colour = G.C.RED,
                Xmult_mod = x_mult,
                card = context.blueprint_card or card
            }
        end

        if context.blueprint then return end

        if context.skip_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize{type = 'variable', key = 'a_xmult', vars = {1 + card.ability.extra * G.GAME.skips}},
                        colour = G.C.RED,
                        card = card
                    })
                    return true
                end
            }))
            return nil, true
        end
    end

}, true)

SMODS.Joker:take_ownership('j_stencil', {
    loc_vars = function(self, info_queue, card)
        if not G.jokers then
            return { vars = { 1 }}
        end

        local x_mult = (G.jokers.config.card_limit - #G.jokers.cards)
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.name == 'Joker Stencil' then x_mult = x_mult + 1 end
        end
        return { vars = {x_mult}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            local x_mult = (G.jokers.config.card_limit - #G.jokers.cards)
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.name == 'Joker Stencil' then x_mult = x_mult + 1 end
            end

            if x_mult > 0 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={x_mult}},
                    Xmult_mod = x_mult
                }
            end
        end
    end

}, true)

SMODS.Joker:take_ownership('j_swashbuckler', {
    loc_vars = function(self, info_queue, card)
        if not G.jokers then
            return { vars = { 0 } }
        else
            local sell_cost = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card and (G.jokers.cards[i].area and G.jokers.cards[i].area == G.jokers) then
                    sell_cost = sell_cost + G.jokers.cards[i].sell_cost
                end
            end
            return { vars = { sell_cost } }
        end
    end,

    calculate = function(self, card, context)
        if not context.cardarea == G.jokers then return end

        if context.joker_main then
            local sell_cost = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card and (G.jokers.cards[i].area and G.jokers.cards[i].area == G.jokers) then
                    sell_cost = sell_cost + G.jokers.cards[i].sell_cost
                end
            end

            if sell_cost > 0 then
                return {
                    message = localize{type='variable',key='a_mult',vars={sell_cost}},
                    mult_mod = sell_cost
                }
            end
        end
    end

}, true)

SMODS.Joker:take_ownership('j_duo', { config = { x_mult = 2, type = 'Pair'}} , true)
SMODS.Joker:take_ownership('j_trio', { config = { x_mult = 3, type = 'Three of a Kind'} } , true)
SMODS.Joker:take_ownership('j_family', { config = { x_mult = 4, type = 'Four of a Kind'} } , true)
SMODS.Joker:take_ownership('j_tribe', { config = { x_mult = 2, type = 'Flush'} } , true)
SMODS.Joker:take_ownership('j_order', { config = { x_mult = 3, type = 'Straight'} } , true)
SMODS.Joker:take_ownership('j_ramen', { config = { x_mult = 2, extra = 0.01} }, true)





---------------------------
--------------------------- Boss Blind type condition mod
---------------------------

SMODS.Joker:take_ownership('j_luchador', {
    loc_vars = function(self, info_queue, card)
        local has_message = (G.GAME and card.area and (card.area == G.jokers))
        local main_end = nil
        if has_message then

            local disableable = G.GAME.blind and (G.GAME.blind.boss and not G.GAME.blind.disabled)
            main_end = {
                {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                    {n=G.UIT.C, config={ref_table = card, align = "m", colour = disableable and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06}, nodes={
                        {n=G.UIT.T, config={text = ' '..localize(disableable and 'k_active' or 'ph_no_boss_active')..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.9}},
                    }}
                }}
            }
        end

        return {
            vars = {},
            main_end = main_end
        }
    end,

    calculate = function(self, card, context)
        if context.selling_self then
            if G.GAME.blind.boss and not G.GAME.blind.disabled then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
                G.GAME.blind:disable()
                return nil, true
            end
        end
    end
}, true)


SMODS.Joker:take_ownership('j_madness', {
    calculate = function(self, card, context)
        if context.blueprint then return end

        if context.setting_blind and G.GAME.blind:get_type() ~= 'Boss' then
            card.ability.x_mult = card.ability.x_mult + card.ability.extra
            local destructable_jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card and not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then
                    destructable_jokers[#destructable_jokers+1] = G.jokers.cards[i]
                end
            end
            local joker_to_destroy = #destructable_jokers > 0 and pseudorandom_element(destructable_jokers, pseudoseed('madness')) or nil

            if joker_to_destroy and not (context.blueprint_card or card).getting_sliced then
                joker_to_destroy.getting_sliced = true
                G.E_MANAGER:add_event(Event({func = function()
                    (context.blueprint_card or card):juice_up(0.8, 0.8)
                    joker_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                return true end }))
            end
            if not (context.blueprint_card or card).getting_sliced then
                card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.x_mult}}})
            end
            return nil, true
        end
    end
}, true)

SMODS.Joker:take_ownership('j_chicot', {
    calculate = function(self, card, context)
        if context.blueprint or card.getting_sliced then return end

        if context.setting_blind and G.GAME.blind.boss then
            G.E_MANAGER:add_event(Event({func = function()
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.blind:disable()
                    play_sound('timpani')
                    delay(0.4)
                    return true end }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
            return true end }))
            return nil, true
        end
    end
}, true)






---------------------------
--------------------------- Stand Negatives
---------------------------

SMODS.Joker:take_ownership('j_perkeo', {
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
		return { vars = {card.ability.extra}}
	end,

	calculate = function(self, card, context)
		if not context.ending_shop or #G.consumeables.cards < 1 then
			if not context.repetition then
				return nil, true
			end

			return
		end

		local valid_consumeables = {}
		for _, v in ipairs(G.consumeables.cards) do
			if v.ability.set ~= 'Stand' then
				valid_consumeables[#valid_consumeables+1] = v
			end
		end

		if #valid_consumeables > 0 then
			G.E_MANAGER:add_event(Event({
				func = function()
					local copied_card = copy_card(pseudorandom_element(valid_consumeables, pseudoseed('perkeo')), nil)
					copied_card:set_edition({negative = true}, true)
					copied_card:add_to_deck()
					G.consumeables:emplace(copied_card)
					return true
				end}))
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
		end
		return nil, true
	end
}, true)






---------------------------
--------------------------- Spectral Downsides
---------------------------

SMODS.Consumable:take_ownership('sigil', {
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        juice_flip(used_tarot)
        local _suit = pseudorandom_element(SMODS.Suits, pseudoseed('sigil'))
        for i = 1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local _card = G.hand.cards[i]
                    assert(SMODS.change_base(_card, _suit.key))
                    return true
                end
            }))
        end
        for i = 1, #G.hand.cards do
            local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip(); play_sound('tarot2', percent, 0.6); G.hand.cards[i]:juice_up(0.3, 0.3); return true
                end
            }))
        end
        delay(0.5)
    end,
})
SMODS.Consumable:take_ownership('ouija', {
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        juice_flip(used_tarot)
        local _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('ouija'))
        for i = 1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local _card = G.hand.cards[i]
                    assert(SMODS.change_base(_card, nil, _rank.key))
                    return true
                end
            }))
        end

        if SMODS.spectral_downside() then
            G.hand:change_size(-1)
        end

        for i = 1, #G.hand.cards do
            local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip(); play_sound('tarot2', percent, 0.6); G.hand.cards[i]:juice_up(0.3, 0.3); return true
                end
            }))
        end
        delay(0.5)
    end,
})
local function random_destroy(used_tarot)
    local destroyed_cards = {}
    local downside = SMODS.spectral_downside(used_tarot)
    if downside then
        destroyed_cards[#destroyed_cards + 1] = pseudorandom_element(G.hand.cards, pseudoseed('random_destroy'))
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            return true
        end
    }))
    if downside then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                for i = #destroyed_cards, 1, -1 do
                    local card = destroyed_cards[i]
                    if SMODS.shatters(card) then
                        card:shatter()
                    else
                        card:start_dissolve(nil, i ~= #destroyed_cards)
                    end
                end
                return true
            end
        }))
    end
    return destroyed_cards
end

SMODS.Consumable:take_ownership('grim', {
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local destroyed_cards = random_destroy(used_tarot)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = #destroyed_cards > 0 and 0.7 or 0,
            func = function()
                local cards = {}
                for i = 1, card.ability.extra do
                    -- TODO preserve suit vanilla RNG
                    local _suit, _rank =
                        pseudorandom_element(SMODS.Suits, pseudoseed('grim_create')).card_key, 'A'
                    local cen_pool = {}
                    for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                        if v.key ~= 'm_stone' and not G.GAME.banned_keys[v.key] and not v.overrides_base_rank then
                            cen_pool[#cen_pool + 1] = v
                        end
                    end

                    if #cen_pool == 0 then cen_pool[1] = 'c_base' end

                    cards[i] = create_playing_card({
                        front = G.P_CARDS[_suit .. '_' .. _rank],
                        center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
                    }, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
                end
                playing_card_joker_effects(cards)
                return true
            end
        }))

        delay(0.3)

        if #destroyed_cards > 0 then
            SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
        end
    end
})

SMODS.Consumable:take_ownership('familiar', {
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local destroyed_cards = random_destroy(used_tarot)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = #destroyed_cards > 0 and 0.7 or 0,
            func = function()
                local cards = {}
                for i = 1, card.ability.extra do
                    -- TODO preserve suit vanilla RNG
                    local faces = {}
                    for _, v in ipairs(SMODS.Rank.obj_buffer) do
                        local r = SMODS.Ranks[v]
                        if r.face then table.insert(faces, r) end
                    end
                    local _suit, _rank =
                        pseudorandom_element(SMODS.Suits, pseudoseed('familiar_create')).card_key,
                        pseudorandom_element(faces, pseudoseed('familiar_create')).card_key
                    local cen_pool = {}
                    for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                        if v.key ~= 'm_stone' and not G.GAME.banned_keys[v.key] and not v.overrides_base_rank then
                            cen_pool[#cen_pool + 1] = v
                        end
                    end
                    if #cen_pool == 0 then cen_pool[1] = 'c_base' end
                    cards[i] = create_playing_card({
                        front = G.P_CARDS[_suit .. '_' .. _rank],
                        center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
                    }, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
                end
                playing_card_joker_effects(cards)
                return true
            end
        }))

        delay(0.3)

        if #destroyed_cards > 0 then
            SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
        end
    end
})

SMODS.Consumable:take_ownership('incantation', {
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local destroyed_cards = random_destroy(used_tarot)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = #destroyed_cards > 0 and 0.7 or 0,
            func = function()
                local cards = {}
                for i=1, card.ability.extra do
                    -- TODO preserve suit vanilla RNG
                    local numbers = {}
                    for _, v in ipairs(SMODS.Rank.obj_buffer) do
                        local r = SMODS.Ranks[v]
                        if v ~= 'Ace' and not r.face then table.insert(numbers, r) end
                    end
                    local _suit, _rank =
                        pseudorandom_element(SMODS.Suits, pseudoseed('incantation_create')).card_key,
                        pseudorandom_element(numbers, pseudoseed('incantation_create')).card_key
                    local cen_pool = {}
                    for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                        if v.key ~= 'm_stone' and not G.GAME.banned_keys[v.key] and not v.overrides_base_rank then
                            cen_pool[#cen_pool + 1] = v
                        end
                    end
                    if #cen_pool == 0 then cen_pool[1] = 'c_base' end
                    cards[i] = create_playing_card({
                        front = G.P_CARDS[_suit .. '_' .. _rank],
                        center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
                    }, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
                end
                playing_card_joker_effects(cards)
                return true
            end
        }))

        delay(0.3)

        if #destroyed_cards > 0 then
            SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
        end
    end
})


SMODS.Consumable:take_ownership('ankh', {
    use = function(self, card, area, copier)
        --Need to check for edgecases - if there are max Jokers and all are eternal OR there is a max of 1 joker this isn't possible already
        --If there are max Jokers and exactly 1 is not eternal, that joker cannot be the one selected
        --otherwise, the selected joker can be totally random and all other non-eternal jokers can be removed

        local chosen_joker = pseudorandom_element(G.jokers.cards, pseudoseed('ankh_choice'))

        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            func = function()
                local new_copy = copy_card(chosen_joker, nil, nil, nil, chosen_joker.edition and chosen_joker.edition.negative)
                new_copy:start_materialize()
                new_copy:add_to_deck()
                if new_copy.edition and new_copy.edition.negative then
                    new_copy:set_edition(nil, true)
                end
                G.jokers:emplace(new_copy)
                return true
            end
        }))

        if not SMODS.spectral_downside(card) then return end
        delay(0.4)
        local deletable_jokers = {}
        for _, v in pairs(G.jokers.cards) do
            if v ~= chosen_joker and not SMODS.is_eternal(v, card) then deletable_jokers[#deletable_jokers + 1] = v end
        end

        local _first_dissolve = nil
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.75,
            func = function()
                for k, v in pairs(deletable_jokers) do
                    if v ~= chosen_joker then
                        v:start_dissolve(nil, _first_dissolve)
                        _first_dissolve = true
                    end
                end
                return true
            end
        }))
    end
})

SMODS.Consumable:take_ownership('hex', {
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local eligible_card = pseudorandom_element(card.eligible_editionless_jokers, pseudoseed('hex'))
                eligible_card:set_edition({polychrome = true}, true)
                check_for_unlock({type = 'have_edition'})

                if SMODS.spectral_downside(card) then
                    local _first_dissolve = nil
                    for k, v in pairs(G.jokers.cards) do
                        if v ~= eligible_card and not SMODS.is_eternal(v, card) then
                            v:start_dissolve(nil, _first_dissolve)
                            _first_dissolve = true

                        end
                    end
                end

                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        delay(0.6)
    end
})

SMODS.Consumable:take_ownership('ectoplasm', {
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local eligible_card = pseudorandom_element(card.eligible_editionless_jokers, pseudoseed('ectoplasm'))
                eligible_card:set_edition({negative = true}, true)
                check_for_unlock({type = 'have_edition'})

                if SMODS.spectral_downside(card) then
                    G.GAME.ecto_minus = G.GAME.ecto_minus or 1
                    G.hand:change_size(-G.GAME.ecto_minus)
                    G.GAME.ecto_minus = G.GAME.ecto_minus + 1
                end

                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        delay(0.6)
    end
})

SMODS.Consumable:take_ownership('wraith', {
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                local new_rare = create_card('Joker', G.jokers, nil, 0.99, nil, nil, nil, 'wra')
                new_rare:add_to_deck()
                G.jokers:emplace(new_rare)
                card:juice_up(0.3, 0.5)
                if G.GAME.dollars ~= 0 and SMODS.spectral_downside(card) then
                    ease_dollars(-G.GAME.dollars, true)
                end
                return true
            end
        }))
        delay(0.6)
    end
})

SMODS.Consumable:take_ownership('immolate', {
    use = function(self, card, area, copier)
        local destroyed_cards = {}
        local downside = SMODS.spectral_downside(card)
        if downside then
            local temp_hand = {}
            for _, v in ipairs(G.hand.cards) do
                temp_hand[#temp_hand+1] = v
            end
            table.sort(temp_hand, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
            pseudoshuffle(temp_hand, pseudoseed('immolate'))

            for i = 1, card.ability.extra.destroy do
                destroyed_cards[#destroyed_cards+1] = temp_hand[i]
            end
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = downside and 0.4 or 0,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        if downside then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    for i=#destroyed_cards, 1, -1 do
                        local card = destroyed_cards[i]
                        if SMODS.shatters(card) then
                            card:shatter()
                        else
                            card:start_dissolve(nil, i == #destroyed_cards)
                        end
                    end
                    return true
                end
            }))
            delay(0.5)
        end

        ease_dollars(card.ability.extra.dollars)

        delay(0.3)

        if downside then
            SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
        end
    end
})