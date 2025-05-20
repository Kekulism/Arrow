local voucherInfo = {
    name = 'Plant Appraiser',
    cost = 10,
    requires = {'v_arrow_foo'},
    config = {
        extra = {
            rate = 0.12,
        }
    },
    part = 'lion',
    unlocked = false,
    unlock_condition = {type = 'c_stands_bought', extra = 25},
}

function voucherInfo.in_pool(self, args)
    if not G.FUNCS.arrow_consumabletype_has_items('Stand') then
        return false
    end
end

function voucherInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { G.arrow_team.gote } }
end

function voucherInfo.locked_loc_vars(self, info_queue, card)
    return { vars = { self.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_stands_bought or 0} }
end

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.arrow_evolvedrarity_mod = G.GAME.arrow_evolvedrarity_mod + card.ability.extra.rate
            return true
        end)
    }))
end

return voucherInfo