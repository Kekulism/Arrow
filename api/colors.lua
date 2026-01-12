local ffi = require("ffi")


local function collect_image_data(set, atlases)
    collectgarbage('stop')
    local data_table = {}
    local pixel_map = {}

    local atlas
    local file_data

    local ref_pointer
    local color_width
    local width_per_unit
    local colors_per_unit

    local color_key
    local prior_rows
    local start_idx

    for k, v in pairs(atlases) do
        pixel_map[k] = {}
        atlas = SMODS.Atlases[k]

        file_data = NFS.newFileData(atlas.full_path)
        local image_data = love.image.newImageData(file_data)
        data_table[k] = image_data

        ref_pointer = ffi.cast("uint8_t*", image_data:getFFIPointer())
        color_width = image_data:getWidth() * 4 / G.SETTINGS.GRAPHICS.texture_scaling
        width_per_unit = atlas.px * 4
        colors_per_unit = width_per_unit * atlas.py

        for _, item in ipairs(v) do
            local item_table = {pos_x = item.pos.x, pos_y = item.pos.y}
            for _, color in ipairs(ArrowAPI.colors.palettes[set].default_palette) do
                item_table[color.key] = {}
            end

            prior_rows = atlas.py * item.pos.y
            start_idx = prior_rows * color_width + item.pos.x * width_per_unit

            for j = 0, (colors_per_unit - 1), 4 do
                local row = math.floor(j/width_per_unit)
                local true_idx = start_idx + ((j % (width_per_unit)) + (row * color_width))
                if G.SETTINGS.GRAPHICS.texture_scaling > 1 then
                    -- modifying to check the top left of the four pixels corresponding to the 1x version
                    local mod_idx = (true_idx + (prior_rows + row) * color_width) * 2
                    if ref_pointer[mod_idx + 3] > 0 then
                        color_key = tostring(ref_pointer[mod_idx]..'-'..ref_pointer[mod_idx + 1]..'-'..ref_pointer[mod_idx + 2])

                        if item_table[color_key] then
                            item_table[color_key][#item_table[color_key]+1] = true_idx
                        end
                    end
                else
                    if ref_pointer[true_idx + 3] > 0 then
                        color_key = tostring(ref_pointer[true_idx]..'-'..ref_pointer[true_idx + 1]..'-'..ref_pointer[true_idx + 2])
                        if item_table[color_key] then
                            item_table[color_key][#item_table[color_key]+1] = true_idx
                        end
                    end
                end
            end

            for kk, vv in pairs(item_table) do
                if type(vv) == 'table' and not next(vv) then
                    item_table[kk] = nil
                end
            end

            pixel_map[k][item.key] = item_table
        end
    end
    collectgarbage('collect')
    collectgarbage('restart')

    return data_table, pixel_map
end

local set_order = {
    Joker = 1,
    Tarot = 2,
    Planet = 3,
    Spectral = 4,
    Voucher = 5,
    Booster = 6,
    Back = 7,
    Seal = 8,
    Cards = 9,
}

local ignore_states = {
    [G.STATES.TAROT_PACK] = true,
    [G.STATES.SPECTRAL_PACK] = true,
    [G.STATES.STANDARD_PACK] = true,
    [G.STATES.BUFFOON_PACK] = true,
    [G.STATES.PLANET_PACK] = true,
    [G.STATES.SMODS_BOOSTER_OPENED] = true
}

local alpha = 0.960433870103
local beta = 0.397824734759

local function amax_bmin(a, b)
    local abs_a, abs_b = math.abs(a), math.abs(b)
    local max = math.max(abs_a, abs_b)
    local min = math.min(abs_a, abs_b)

    return alpha*max + beta*min
end

ArrowAPI.colors = {
    badge_colours = {},

    palettes = {
        Background = {},
        Spectral = {},
        Planet = {},
        Tarot = {},
        Hearts = {},
        Spades = {},
        Diamonds = {},
        Clubs = {},
    },

    --- Caches the default image_data for all given palette sets
    --- @param set_list table | nil List of set keys for card types, i.e. "Tarot", "Planet"
    setup_palettes = function(set_list)
        local s1, default_config = pcall(function()
            return load(NFS.read(ArrowAPI.path..('config.lua')), ('=[SMODS %s "default_config"]'):format(ArrowAPI.id))()
        end)

        if not s1 or not default_config.saved_palettes then
            ArrowAPI.logging.warn('[ArrowAPI - WARN] Missing config file or malformed config')
            return
        end

        -- this is intended to clean settings between the embedded cardsauce arrow installation
        -- and an independent installation when switching between them
        local edited_config = false
        local default_palettes = default_config.saved_palettes
        local saved_palettes = ArrowAPI.config.saved_palettes
        for k, v in pairs(default_palettes) do
            local num_palettes = math.max(#v, #saved_palettes[k])
            for i = num_palettes, 1, -1 do
                local saved_palette = saved_palettes[k][i]
                local default_palette = default_palettes[k][i]
                if (saved_palette and saved_palette.default and not default_palette) then
                    table.remove(saved_palettes[k], i)
                    saved_palettes[k].saved_index = math.min(saved_palettes[k].saved_index, #saved_palettes[k])
                    edited_config = true
                end
            end
        end

        if edited_config then
            SMODS.save_mod_config(ArrowAPI)
        end

        -- background palette handled differently
        -- so we don't have to collect card and atlas data
        local bkg_palette = ArrowAPI.colors.palettes.Background
        local saved_bkg_palettes = ArrowAPI.config.saved_palettes['Background']
        bkg_palette.default_palette = saved_bkg_palettes[1]
        bkg_palette.current_palette = copy_table(saved_bkg_palettes[saved_bkg_palettes.saved_index])
        bkg_palette.last_palette = copy_table(bkg_palette.current_palette)
        ArrowAPI.colors.use_custom_palette('Background')

        -- TODO // create a way to edit this list or add to it via compatible mods
        set_list = set_list or {"Tarot", "Planet", "Spectral", "Hearts", "Spades", "Diamonds", "Clubs"}
        for i = 1, #set_list do
            local set = set_list[i]
            local palette = ArrowAPI.colors.palettes[set]
            local items = {}

            local atlases = {}

            -- some weird stuff with the soul atlas
            -- since it uses this shared thing
            if set == 'Spectral' then
                if not atlases['arrow_spectrals'] then
                    atlases['arrow_spectrals'] = {}
                end
                atlases['arrow_spectrals'][#atlases['arrow_spectrals']+1] = {key = 'shared_soul', pos = {x = 9, y = 2}}
            end

            for k, center in pairs(G.P_CENTERS) do
                if not center.no_collection and (center.set == set or center.palette_set == set)
                and (not center.original_mod or (center.original_mod.optional_features or {}).arrow_palettes) then

                    local center_key = center.key
                    local positions = {[center_key] = center.pos, [center_key..'_soul'] = center.soul_pos}

                    -- this captures any additional draw layers you might use in modded cards
                    -- but it expects that you use the same atlas (and generally you should tbh)
                    for _, pos in ipairs(center.palette_register or {}) do
                        positions[#positions+1] = pos
                    end

                    for key, pos in pairs(positions) do
                        if not atlases[center.atlas] then
                            atlases[center.atlas] = {}
                        end


                        atlases[center.atlas][#atlases[center.atlas]+1] = {key = key, pos = pos}
                    end
                    items[#items+1] = {key = center_key, order = center.order, table = 'CENTERS', set = (center.set or center.palette_set)}
                end
            end

            -- playing card collection uses a pared down version of
            -- get_front_spriteinfo for this, but I don't like it
            local card_map = {}
            for k, card in pairs(G.P_CARDS) do
                if not card.no_collection and card.suit == set
                and (not card.original_mod or (card.original_mod.optional_features or {}).arrow_palettes) then
                    card_map[k] = {}
                    for _, info in ipairs(G.COLLABS.options[card.suit]) do
                        local deckSkin = SMODS.DeckSkins[info]

                        local atlas, pos
                        local palettes = deckSkin.palette_map or deckSkin.palettes
                        for _, pal in pairs(palettes) do
                            local rank_type = false
                            for j = 1, #pal.ranks do
                                if pal.ranks[j] == card.value then rank_type = true break end
                            end

                            if rank_type then
                                atlas = pal.atlas
                                if type(pal.pos_style) == "table" then
                                    if pal.pos_style[card.value] then
                                        if pal.pos_style[card.value].atlas then
                                            atlas = pal.pos_style[card.value].atlas
                                        end
                                        if pal.pos_style[card.value].pos then
                                            pos = pal.pos_style[card.value].pos
                                        end
                                    elseif pal.pos_style.fallback_style then
                                        if pal.pos_style.fallback_style == 'collab' then
                                            pos = G.COLLABS.pos[card.value]
                                        elseif pal.pos_style.fallback_style == 'suit' then
                                            pos = { x = card.pos.x, y = 0}
                                        elseif pal.pos_style.fallback_style == 'deck' then
                                            pos = card.pos
                                        end
                                    end
                                elseif pal.pos_style == 'collab' then
                                    pos = G.COLLABS.pos[card.value]
                                elseif pal.pos_style == 'suit' then
                                    pos = { x = card.pos.x, y = 0}
                                elseif pal.pos_style == 'deck' then
                                    pos = card.pos
                                elseif pal.pos_style == 'ranks' then
                                    for j, rank in ipairs(pal.ranks) do
                                        if rank == card.value then
                                            pos = { x = j - 1, y = 0}
                                        end
                                    end
                                end

                                if not card_map[k][atlas] then
                                    card_map[k][atlas] = true

                                    if not atlases[atlas] then
                                        atlases[atlas] = {}
                                    end

                                    atlases[atlas][#atlases[atlas]+1] = {key = k..'_'..atlas, pos = pos}
                                    items[#items+1] = {key = k..'_'..atlas, collab_key = atlas, item_key = k, rank = card.value, table = 'CARDS', front_atlas = atlas, front_pos = pos, set = 'Card'}
                                end
                            end
                        end
                    end
                end
            end

            -- TODO // Tags are not currently displayed at all in the palette editor due to
            -- distinct rendering, would want to fix that eventually
            for _, tag in ipairs(G.P_CENTER_POOLS['Tag']) do
                if not tag.no_collection and (tag.set == set or tag.palette_set == set)
                and (not tag.original_mod or (tag.original_mod.optional_features or {}).arrow_palettes) then
                    if not atlases[tag.atlas] then
                        atlases[tag.atlas] = {}
                    end

                    atlases[tag.atlas][#atlases[tag.atlas]+1] = {key = tag.key, pos = tag.pos}
                end
            end

            for _, seal in ipairs(G.P_CENTER_POOLS['Seal']) do
                if not seal.no_collection and (seal.set == set or seal.palette_set == set)
                and (not seal.original_mod or (seal.original_mod.optional_features or {}).arrow_palettes) then
                    if not atlases[seal.atlas] then
                        atlases[seal.atlas] = {}
                    end

                    atlases[seal.atlas][#atlases[seal.atlas]+1] = {key = seal.key, pos = seal.pos}
                    items[#items+1] = {key = seal.key, table = 'SEALS', order = seal.order, set = 'Seal'}
                end
            end


            -- result of this sort function is prioritizing set order, however
            -- centers don't have a built in order value, just the object buffers
            -- and the center pools
            -- TODO // add sorting properly for centers
            table.sort(items, function(a, b)
                local a_order = set_order[a.set] or 0
                local b_order = set_order[b.set] or 0
                if a.set ~= b.set  and a_order ~= b_order then
                    return a_order < b_order
                end

                if a.table == 'CARDS' and b.table == 'CARDS' then
                    if a.collab_key ~= b.collab_key then
                        return a.collab_key < b.collab_key
                    end
                    local a_rank = SMODS.Ranks[a.rank]
                    local b_rank = SMODS.Ranks[b.rank]
                    local a_nominal = 10*(a_rank.nominal or 0) + 10*(a_rank.face_nominal or 0)
                    local b_nominal = 10*(b_rank.nominal or 0) + 10*(b_rank.face_nominal or 0)

                    return a_nominal < b_nominal
                end

                return (a.order or 0) < (b.order or 0)
            end)

            palette.items = items
            palette.default_palette = ArrowAPI.config.saved_palettes[set][1]

            local atlas_table, pixel_map = collect_image_data(set, atlases)
            palette.image_data = {atlases = atlas_table, pixel_map = pixel_map}

            palette.current_palette = copy_table(ArrowAPI.config.saved_palettes[set][ArrowAPI.config.saved_palettes[set].saved_index])
            palette.last_palette = copy_table(palette.current_palette)

            local badge = palette.current_palette[#palette.current_palette]
            local grad_table = {badge[1]/255, badge[2]/255, badge[3]/255, 1, colours = {}}
            for j = 1, #badge.grad_pos do
                local start_idx = (j-1)*3
                grad_table.colours[j] = {badge[start_idx+1]/255, badge[start_idx+2]/255, badge[start_idx+3]/255, 1}
            end
            ArrowAPI.colors.badge_colours[set] = grad_table
            if G.C.SUITS[set] then
                G.C.SUITS[set] = ArrowAPI.colors.badge_colours[set]
                G.C.SO_1[set] = ArrowAPI.colors.badge_colours[set]
            else
                G.C.SECONDARY_SET[set] = ArrowAPI.colors.badge_colours[set]
            end

            ArrowAPI.colors.use_custom_palette(set, nil, true)
        end
    end,

    set_background_color = function(background_table, args)
        local color_c = args.special_colour or args.new_colour
        local color_l = args.new_colour
        local color_d = args.tertiary_colour or args.new_colour
        local bright_c = 0.9
        local bright_l = 1.3
        local bright_d = 0.7
        if args.special_colour and args.tertiary_colour then
            bright_c = 1
            bright_l = 1
            bright_d = 1
        end

        background_table.C[1] = color_c[1]*bright_c - background_table.C[1]
        background_table.C[2] = color_c[2]*bright_c - background_table.C[2]
        background_table.C[3] = color_c[3]*bright_c - background_table.C[3]

        background_table.L[1] = color_l[1]*bright_l - background_table.L[1]
        background_table.L[2] = color_l[2]*bright_l - background_table.L[2]
        background_table.L[3] = color_l[3]*bright_l - background_table.L[3]

        background_table.D[1] = color_d[1]*bright_d - background_table.D[1]
        background_table.D[2] = color_d[2]*bright_d - background_table.D[2]
        background_table.D[3] = color_d[3]*bright_d - background_table.D[3]

        background_table.contrast = args.contrast - background_table.contrast
    end,

    hue_shift = function(color, hue_mod)
        local k_rgb_to_yprime = {0.299, 0.587, 0.114}
        local g_rgb_to_i = {0.596, -0.275, -0.321}
        local k_rgb_to_q = {0.212, -0.523, 0.311}

        local k_yiq_to_r = {1.0, 0.956, 0.621}
        local k_yiq_to_g = {1.0, -0.272, -0.647}
        local k_yiq_to_b = {1.0, -1.107, 1.704}

        -- dot products
        local yprime = color[1] * k_rgb_to_yprime[1] + color[2] * k_rgb_to_yprime[2] + color[3] * k_rgb_to_yprime[3]
        local i = color[1] * g_rgb_to_i[1] + color[2] * g_rgb_to_i[2] + color[3] * g_rgb_to_i[3]
        local q = color[1] * k_rgb_to_q[1] + k_rgb_to_q[2] * k_rgb_to_q[2] + color[3] * k_rgb_to_q[3]

        local hue = math.atan2(q, i)
        local chroma = math.sqrt(i * i + q * q)

        hue = hue + hue_mod

        q = chroma * math.sin(hue)
        i = chroma * math.cos(hue)

        local y_iq = {yprime, i, q}

        return {
            (y_iq[1] * k_yiq_to_r[1] + y_iq[2] * k_yiq_to_r[2] + y_iq[3] * k_yiq_to_r[3]),
            (y_iq[1] * k_yiq_to_g[1] + y_iq[2] * k_yiq_to_g[2] + y_iq[3] * k_yiq_to_g[3]),
            (y_iq[1] * k_yiq_to_b[1] + y_iq[2] * k_yiq_to_b[2] + y_iq[3] * k_yiq_to_b[3]),
        }
    end,

    use_custom_palette = function(set, saved_index, bypass_last)
        local palette = ArrowAPI.colors.palettes[set]
        if set == 'Background' then
            if saved_index then
                -- loading from saved palette
                ArrowAPI.config.saved_palettes[set].saved_index = saved_index
                SMODS.save_mod_config(ArrowAPI)

                local saved = ArrowAPI.config.saved_palettes[set][saved_index]
                local new_palette = {name = saved.name}
                for i = 1, #palette.default_palette do
                    local default = palette.default_palette[i]
                    local cust_color = saved[i]
                    local palette_table = {
                        key = default.key,
                        grad_pos = copy_table(cust_color.grad_pos),
                        grad_config = copy_table(cust_color.grad_config),
                        overrides = copy_table(cust_color.overrides)
                    }
                    for k = 1, #default do
                        palette_table[k] = cust_color[k]
                    end
                    new_palette[i] = palette_table
                end

                palette.current_palette = new_palette
            end

            -- update background
            for i = 1, #palette.current_palette do
                local color = palette.current_palette[i]
                for j = 1, 3 do
                    G.C.BLIND[color.key][j] = color[j] and color[j]/255 or 1
                end
            end

            -- updating
            local background_args = nil
            if G.GAME then
                if G.GAME.won then
                    background_args = {new_colour = G.C.BLIND.won, contrast = 1}
                else
                    local current_blind = G.GAME.blind and G.GAME.blind.config.blind
                    if G.STAGE == G.STAGES.MAIN_MENU or (current_blind and current_blind.boss and current_blind.boss.showdown) then
                        background_args = {new_colour = G.C.BLIND.SHOWDOWN_COL_2, special_colour = G.C.BLIND.SHOWDOWN_COL_1, tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 3}
                    elseif not ignore_states[G.STATE] then
                        background_args = {new_colour = G.C.BLIND.Small, contrast = 1}
                    end
                end
            end

            if background_args then
                ArrowAPI.colors.set_background_color(G.C.BACKGROUND, background_args)
            end

            return
        end

        local custom_palette = {}
        if not saved_index then
            -- updating current palette
            local badge = palette.current_palette[#palette.current_palette]
            local badge_table = ArrowAPI.colors.badge_colours[set]

            if #badge.grad_pos > 1 then
                for i = 1, math.max(#badge.grad_pos, #badge_table.colours) do
                    if i <= #badge.grad_pos then
                        local start_idx = (i - 1) * 3
                        badge_table.colours[i] = {
                            badge[start_idx + 1]/255, badge[start_idx + 2]/255, badge[start_idx + 3]/255, 1
                        }
                    else
                        badge_table.colours[i] = nil
                    end
                end
            else
                badge_table.colours = {{badge[1]/255, badge[2]/255, badge[3]/255, 1}}
                badge_table[1] = badge[1]/255
                badge_table[2] = badge[2]/255
                badge_table[3] = badge[3]/255
                badge_table[4] = 1
            end

            for i=1, #palette.current_palette-1 do
                local last = palette.last_palette[i]
                local current = palette.current_palette[i]
                local default = palette.default_palette[i]
                local changed = false

                for j = 1, #current.grad_pos do
                    if last.grad_pos[j] ~= current.grad_pos[j] then
                        changed = true
                        break
                    end
                end

                if bypass_last or current.grad_config.pos[1] ~= last.grad_config.pos[1] or current.grad_config.pos[2] ~= last.grad_config.pos[2]
                or current.grad_config.mode ~= last.grad_config.mode or current.grad_config.val ~= last.grad_config.val then
                    changed = true
                end

                if current.overrides.changed_flag then changed = true end

                local palette_table = {key = default.key}

                for j=1, #current do
                    if current[j] ~= last[j] then changed = true end
                    palette_table[j] = current[j]
                end

                if changed then
                    palette_table.grad_pos = copy_table(current.grad_pos)
                    palette_table.grad_config = copy_table(current.grad_config)
                    palette_table.overrides = copy_table(current.overrides)
                    custom_palette[#custom_palette+1] = palette_table
                    palette.last_palette[i] = copy_table(palette_table)
                end
            end
        else
            -- loading from saved palette
            ArrowAPI.config.saved_palettes[set].saved_index = saved_index
            SMODS.save_mod_config(ArrowAPI)

            custom_palette = ArrowAPI.config.saved_palettes[set][saved_index]
            local new_palette = {name = custom_palette.name}

            for i = 1, #palette.default_palette-1 do
                local default = palette.default_palette[i]
                local cust_color = custom_palette[i]
                local palette_table = {
                    key = default.key,
                    grad_pos = copy_table(cust_color.grad_pos),
                    grad_config = copy_table(cust_color.grad_config),
                    overrides = copy_table(cust_color.overrides)
                }

                for j = 1, #cust_color do
                    palette_table[j] = cust_color[j]
                end

                new_palette[i] = palette_table
            end

            local badge = new_palette[#new_palette]
            local badge_table = ArrowAPI.colors.badge_colours[set]
            if G.C.SUITS[set] then
                G.C.SUITS[set] = badge_table
                G.C.SO_1[set] = badge_table
            else
                G.C.SECONDARY_SET[set] = badge_table
            end

            if #badge.grad_pos > 1 then
                for i = 1, math.max(#badge.grad_pos, #badge_table.colours) do
                    if i <= #badge.grad_pos then
                        local start_idx = (i - 1) * 3
                        badge_table.colours[i] = {
                            badge[start_idx + 1]/255, badge[start_idx + 2]/255, badge[start_idx + 3]/255, 1
                        }
                    else
                        badge_table.colours[i] = nil
                    end
                end
            else
                badge_table.colours = {{badge[1]/255, badge[2]/255, badge[3]/255, 1}}
                badge_table[1] = badge[1]/255
                badge_table[2] = badge[2]/255
                badge_table[3] = badge[3]/255
                badge_table[4] = 1
            end

            palette.current_palette = new_palette
            palette.last_palette = copy_table(new_palette)
        end

        collectgarbage('stop')

        local rot
        local rot_max
        local lerp_val
        local angle
        local grad_pos
        local replace_color = {1, 1, 1}
        local idx
        local mod_idx
        local palette_color
        local palette_key
        local color_list

        local edit_pointer
        local pixel_map
        local back
        local next
        local dist
        local center
        local x
        local y

        local row_start
        local prev_rows
        local current_row

        local width_per_unit

        for k, v in pairs(palette.image_data.atlases) do
            local atlas = SMODS.Atlases[k]

            color_width = v:getWidth() * 4 / G.SETTINGS.GRAPHICS.texture_scaling
            width_per_unit = atlas.px * 4
            height_per_unit = atlas.py

            edit_pointer = ffi.cast("uint8_t*", v:getFFIPointer())
            pixel_map = palette.image_data.pixel_map[k]

            for i = 1, #custom_palette do
                for item, colors in pairs(pixel_map) do
                    -- todo add item filtering
                    palette_key = custom_palette[i].key
                    color_list = colors[palette_key]
                    if color_list then
                        palette_color = custom_palette[i].overrides[item] or custom_palette[i]
                        prev_rows = colors.pos_y * height_per_unit
                        row_start = colors.pos_x * width_per_unit

                        for j = 1, #color_list do
                            idx = color_list[j]
                            current_row = (math.floor(idx / color_width)) - prev_rows

                            replace_color[1] = palette_color[1]
                            replace_color[2] = palette_color[2]
                            replace_color[3] = palette_color[3]

                            if #palette_color.grad_pos > 1 then
                                angle = palette_color.grad_config.val
                                grad_pos = palette_color.grad_pos

                                x = (((idx % color_width - row_start) / width_per_unit) - 0.5) * 2
                                y = ((current_row / height_per_unit) - 0.5) * -2

                                if palette_color.grad_config.mode == 'linear' then
                                    -- value between 0 and pi/2 for the coord's x rotation
                                    rot = x * math.cos(angle) + y * math.sin(angle)
                                    rot_max = math.abs(math.cos(angle)) + math.abs(math.sin(angle))
                                    lerp_val = 0.5 * (rot/rot_max + 1)
                                    rot = nil
                                    rot_max = nil
                                else
                                    center = palette_color.grad_config.pos

                                    -- depending on benchmark, might not need this approx
                                    -- local dist = math.sqrt((center[2] - color_list[j].y)^2 + (center[1] - color_list[j].x)^2)
                                    dist = amax_bmin(center[2] - y, center[1] - x)
                                    lerp_val = 1 - math.min(1, math.max(0, (dist / palette_color.grad_config.val)))
                                end

                                for grad = 1, #grad_pos - 1 do
                                    if lerp_val <= grad_pos[grad+1] then
                                        lerp_val = (lerp_val - grad_pos[grad]) / (grad_pos[grad+1] - grad_pos[grad])

                                        back = (grad - 1) * 3
                                        next = grad * 3

                                        replace_color[1] = palette_color[back + 1] + lerp_val * (palette_color[next + 1] - palette_color[back + 1])
                                        replace_color[2] = palette_color[back + 2] + lerp_val * (palette_color[next + 2] - palette_color[back + 2])
                                        replace_color[3] = palette_color[back + 3] + lerp_val * (palette_color[next + 3] - palette_color[back + 3])
                                        break
                                    end
                                end
                            end

                            if G.SETTINGS.GRAPHICS.texture_scaling == 2 then
                                mod_idx = (idx + (prev_rows+current_row) * color_width) * 2
                                edit_pointer[mod_idx] = replace_color[1]
                                edit_pointer[mod_idx+1] = replace_color[2]
                                edit_pointer[mod_idx+2] = replace_color[3]

                                mod_idx = mod_idx + 4
                                edit_pointer[mod_idx] = replace_color[1]
                                edit_pointer[mod_idx+1] = replace_color[2]
                                edit_pointer[mod_idx+2] = replace_color[3]

                                mod_idx = mod_idx + color_width * 2
                                edit_pointer[mod_idx] = replace_color[1]
                                edit_pointer[mod_idx+1] = replace_color[2]
                                edit_pointer[mod_idx+2] = replace_color[3]

                                mod_idx = mod_idx - 4
                                edit_pointer[mod_idx] = replace_color[1]
                                edit_pointer[mod_idx+1] = replace_color[2]
                                edit_pointer[mod_idx+2] = replace_color[3]
                            else
                                edit_pointer[idx] = replace_color[1]
                                edit_pointer[idx + 1] = replace_color[2]
                                edit_pointer[idx + 2] = replace_color[3]
                            end
                        end
                    end
                end
            end

            SMODS.Atlases[k].image = love.graphics.newImage(v,
                { mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling })
        end

        collectgarbage('collect')
        collectgarbage('restart')
    end,
}