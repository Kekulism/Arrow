local voucherInfo = {
    name = 'Foo Fighter',
    cost = 10,
    config = {
        extra = {
            rate = 1,
        }
    },
    part = 'stone',
}

function voucherInfo.in_pool(self, args)
    if not G.FUNCS.arrow_consumabletype_has_items('Stand') then
        return false
    end
end

function voucherInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { G.arrow_team.gote } }
end

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.stand_rate = G.GAME.stand_rate + card.ability.extra.rate
            return true
        end)
    }))
end

return voucherInfo