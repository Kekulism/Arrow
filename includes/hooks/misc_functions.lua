function set_stand_win()
    G.PROFILES[G.SETTINGS.profile].stand_usage = G.PROFILES[G.SETTINGS.profile].stand_usage or {}
    for k, v in pairs(G.consumeables.cards) do
        if v.config.center_key and v.ability.set == 'Stand' then
            G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key] = G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key] or {count = 1, order = v.config.center.order, wins = {}, losses = {}, wins_by_key = {}, losses_by_key = {}}
            if G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key] then
                G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins = G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins or {}
                G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins[G.GAME.stake] = (G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins[G.GAME.stake] or 0) + 1
                G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins_by_key[SMODS.stake_from_index(G.GAME.stake)] = (G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins_by_key[SMODS.stake_from_index(G.GAME.stake)] or 0) + 1
            end
        end
    end
    G:save_settings()
end

function get_stand_win_sticker(_center, index)
    if not G.PROFILES[G.SETTINGS.profile].stand_usage then return 0 end
    local stand_usage = G.PROFILES[G.SETTINGS.profile].stand_usage[_center.key] or {}
    if stand_usage.wins then
        if SMODS and SMODS.can_load then
            local applied = {}
            local _count = 0
            local _stake = nil
            for k, v in pairs(stand_usage.wins_by_key or {}) do
                SMODS.build_stake_chain(G.P_STAKES[k], applied)
            end
            for i, v in ipairs(G.P_CENTER_POOLS.Stake) do
                if applied[v.order] then
                    _count = _count+1
                    if (v.stake_level or 0) > (_stake and G.P_STAKES[_stake].stake_level or 0) then
                        _stake = v.key
                    end
                end
            end
            if index then return _count end
            if _count > 0 then return G.sticker_map[_stake] end
        else
            local _stake = 0
            for k, v in pairs(G.PROFILES[G.SETTINGS.profile].stand_usage[_center.key].wins or {}) do
                _stake = math.max(k, _stake)
            end
            if index then return _stake end
            if _stake > 0 then return G.sticker_map[_stake] end
        end
    end
    if index then return 0 end
end

local ref_spp = set_profile_progress
function set_profile_progress()
    ref_spp()
    G.PROGRESS.stand_stickers = {tally = 0, of = 0}
    for _, v in pairs(G.P_CENTERS) do
        if v.set == 'Stand' then
            G.PROGRESS.stand_stickers.of = G.PROGRESS.stand_stickers.of + #G.P_CENTER_POOLS.Stake
            G.PROGRESS.stand_stickers.tally = G.PROGRESS.stand_stickers.tally + get_stand_win_sticker(v, true)
        end
    end
    G.PROFILES[G.SETTINGS.profile].progress.stand_stickers = copy_table(G.PROGRESS.stand_stickers)
end