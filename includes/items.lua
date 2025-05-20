local itemsToLoad = {
    Booster = {
        'analog1',
        'analog2',
        'analog3',
        'analog4',
    },

    Consumable = {
        'spec_diary',
        'tarot_arrow',
    },

    Tag = {
        'plinkett',
        'spirit',
    },

    Voucher = {
        'scavenger',
        'raffle',
        'foo',
        'plant',
    },
}

for k, v in pairs(itemsToLoad) do
    if next(itemsToLoad[k]) then
        for i = 1, #v do
            load_arrow_item(v[i], k)
        end
    end
end