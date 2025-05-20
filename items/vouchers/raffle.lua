local voucherInfo = {
    name = 'Raffle',
    cost = 10,
    requires = {'v_arrow_scavenger'},
    unlocked = false,
    unlock_condition = {type = 'c_vhss_bought', extra = 25},
    origin = {
        'rlm',
        'rlm_botw',
        color = 'rlm'
    }
}

function voucherInfo.in_pool(self, args)
    if not G.FUNCS.arrow_consumabletype_has_items('VHS') then
        return false
    end
end

function voucherInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { G.arrow_team.joey } }
end

function voucherInfo.locked_loc_vars(self, info_queue, card)
    return { vars = { self.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_vhss_bought or 0} }
end

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.vhs_rate = G.GAME.vhs_rate * 2
            return true
        end)
    }))
end

return voucherInfo