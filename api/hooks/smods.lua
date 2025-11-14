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

local ref_context_flags = SMODS.update_context_flags
function SMODS.update_context_flags(context, flags)
    local ret = ref_context_flags(context, flags)

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