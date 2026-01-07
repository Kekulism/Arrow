local blindInfo = {
    name = "Mystery",
    atlas = 'arrow_mystery',
    prefix_config = {atlas = false},
    pos = {x = 0, y = 0},
    boss_colour = HEX('762929'),
    dollars = 5,
    mult = 1,
    vars = {},
    boss = {min = 4, max = 10},
    no_collection = true,
    ignore_showdown_check = true,
}

function blindInfo.in_pool(self)
    return false
end

return blindInfo