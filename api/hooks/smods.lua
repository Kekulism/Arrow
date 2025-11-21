function ArrowAPI.reset_game_globals(run_start)
    if run_start then
        G.GAME.arrow_extra_discounts = {}
        G.GAME.arrow_extra_blinds = G.GAME.arrow_extra_blinds or {}
        G.GAME.modifiers.max_stands = G.GAME.modifiers.max_stands or 1
        G.GAME.modifiers.consumable_selection_mod = G.GAME.modifiers.consumable_selection_mod or 0
        G.GAME.arrow_last_upgraded_hand = {}
    end
end

function ArrowAPI.set_ability_reset_keys()
    return {
        'evolved'
    }
end

local ref_card_collection_uibox = SMODS.card_collection_UIBox
SMODS.card_collection_UIBox = function(_pool, rows, args)
    if _pool == G.P_CENTER_POOLS.Stand then
        args.modify_card = function(card, center, i, j)
            card.sticker = ArrowAPI.stands.get_win_sticker(center)
        end
    end
    return ref_card_collection_uibox(_pool, rows, args)
end



---------------------------
--------------------------- Adding mod badges to galdur interface
---------------------------

local ref_mod_badges = SMODS.create_mod_badges
function SMODS.create_mod_badges(obj, badges)
    local ret = ref_mod_badges(obj, badges)
    if obj and obj.origin then
        badges[#badges+1] = ArrowAPI.ui.dynamic_badge(obj)
    end
    return ret
end





---------------------------
--------------------------- Hand level modification behavior
---------------------------

function SMODS.get_effective_hand_level(base_level, optional_contexts)
    local context = {mod_handlevel = true, numerator = base_level}
    if optional_contexts and type(optional_contexts) == 'table' then
        for k, v in pairs(optional_contexts) do
            context[k] = v
        end
    end
    local mod_level = SMODS.calculate_context(context)
    mod_level.numerator = mod_level.numerator or base_level
    return mod_level.numerator
end





---------------------------
--------------------------- Added calculation flags
---------------------------

table.insert(SMODS.other_calculation_keys, 17, 'prevent_downside')
SMODS.silent_calculation['prevent_downside'] = true

local ref_context_flags = SMODS.update_context_flags
function SMODS.update_context_flags(context, flags)
    local ret = ref_context_flags(context, flags)

    if flags.prevent_downside then context.downside = false end

    if flags.title_card then
        context.title_center = flags.title_center
        context.title_front = flags.title_front
    end

    if flags.splash_card then
        context.splash_center = flags.splash_center
        context.splash_front = flags.splash_front
    end

    return ret
end

function SMODS.spectral_downside(card)
    local downside = true
    local flags = SMODS.calculate_context({spectral_downside = true, card = card, downside = downside})
    if flags.prevent_downside then downside = not flags.prevent_downside end
	return downside
end

local ref_indv_eff = SMODS.calculate_individual_effect
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)
    local ret = ref_indv_eff(effect, scored_card, key, amount, from_edition)
    if ret then return ret end

    if key == 'prevent_trigger' or key == 'prevent_downside' then
        return key
    end

    if key == 'title_center' or key == 'title_front' and key == 'splash_center' or key == 'splash_front' then
        return { [key] = amount }
    end
end

