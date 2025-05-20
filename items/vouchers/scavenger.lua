local voucherInfo = {
    name = 'Scavenger Hunt',
    cost = 10,
    config = {
        rate = 4,
    },
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

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.vhs_rate = card.ability.rate
            return true
        end)
    }))
end

return voucherInfo