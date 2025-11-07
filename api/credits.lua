ArrowAPI.DEFAULT_CREDIT_MATRIX = {col = 21, row = 10}
ArrowAPI.DEFAULT_CREDIT_SIZE = {w = 16, h = 6}
ArrowAPI.DEFAULT_CREDIT_SECTIONS = {
    {key = 'concept', title_colour = G.C.YELLOW},
    {key = 'artist', title_colour = G.C.ETERNAL},
    {key = 'programmer', title_colour = G.C.GOLD}
}

ArrowAPI.ARROW_USE_CREDITS = true
ArrowAPI.credits = {
    ArrowAPI = {
        matrix = {col = 20, row = 10},
        {
            key = 'direction',
            title_colour = G.C.YELLOW,
            pos_start = {col = 0, row = 0},
            pos_end = {col = 5, row = 10},
            contributors = {
                ["BarrierTrio/Gote"] = true,
                ["Kekulism"] = true,
                ["Vivian Giacobbi"] = true,
            }
        },
        {
            key = 'artist',
            title_colour = G.C.ETERNAL,
            pos_start = {col = 5, row = 0},
            pos_end = {col = 12.5, row = 10},
            contributors = {}
        },
        {
            key = 'programmer',
            title_colour = G.C.GOLD,
            pos_start = {col = 12.5, row = 0},
            pos_end = {col = 20, row = 5},
            contributors = {}
        },
        {
            key = 'shader',
            title_colour = G.C.DARK_EDITION,
            pos_start = {col = 12.5, row = 5},
            pos_end = {col = 20, row = 10},
            contributors = {
                ["Vivian Giacobbi"] = true,
                ["Sir. Gameboy"] = true
            }
        }
    },

    use_credits = function(mod, extra_args)
        mod.ARROW_USE_CREDITS = true
        extra_args = extra_args or {}
        local credit_table = {
            matrix = extra_args.matrix or ArrowAPI.DEFAULT_CREDIT_MATRIX,
        }

        local use_default_sections = true
        for _, arg in ipairs(extra_args) do
            if arg.key then
                credit_table[#credit_table+1] = {
                    key = arg.key,
                    title_colour = arg.title_colour or SMODS.current_mod.badge_colour,
                    pos_start = arg.pos_start,
                    pos_end = arg.pos_end,
                    contributors = arg.contributors or {}
                }

                for i, sec in ipairs(ArrowAPI.DEFAULT_CREDIT_SECTIONS) do
                    if arg.key == sec.key then
                        -- stop using default sections if we've defined
                        -- a default section with unique dimensions
                        if arg.pos_start or arg.pos_end then use_default_sections = false end

                        -- default sections cant change their keys for ease
                        credit_table[#credit_table].key = sec.key
                        break
                    elseif i == #ArrowAPI.DEFAULT_CREDIT_SECTIONS then
                        -- or if a section is not a default section entirely
                        use_default_sections = false
                    end
                end
            end
        end

        -- create default sections
        if use_default_sections then
            -- check for already used sections with provided info
            local used_sections = {}
            for i, v in ipairs(credit_table) do
                used_sections[v.key] = true
            end

            -- fill in any default sections without provided information
            for i = 1, #ArrowAPI.DEFAULT_CREDIT_SECTIONS do
                local key = ArrowAPI.DEFAULT_CREDIT_SECTIONS[i].key
                if not used_sections[key] then
                    credit_table[#credit_table+1] = {
                        key = key,
                        title_colour = ArrowAPI.DEFAULT_CREDIT_SECTIONS[i].title_colour,
                        contributors = {}
                    }
                end
            end
            credit_table.use_default_sections = true
        end

        ArrowAPI['credits'][mod.id] = credit_table
    end,
}

ArrowAPI.credits.create_credits_tab = function(mod)
	local ref_table = {}
	for i=1, #ArrowAPI.credits[mod.id] do
		ref_table[i] = true
	end

	local depth = 0
	local mode = 'row'
	local tree = {}
	local start_coords = {col = 0, row = 0}
	local end_coords = ArrowAPI.credits[mod.id].matrix or ArrowAPI.DEFAULT_CREDIT_MATRIX

	while next(ref_table) do
		mode = (mode == 'row') and 'col' or 'row'
		depth = depth + 1

		tree[depth] = {mode = mode}
        local possible_sections = {}

		for k, v in pairs(ref_table) do
            local ref = ArrowAPI.credits[mod.id][k]
            local pos_start = ref.pos_start
            local pos_end = ref.pos_end

            local no_ref = false
            for i = #possible_sections, 1, -1 do
                if ref.pos_start[mode] < possible_sections[i].pos_end[mode] then
                    pos_start = {col = math.min(pos_start['col'], possible_sections[i].pos_start['col']), row = math.min(pos_start['row'], possible_sections[i].pos_start['row'])}
                    pos_end = {col = math.max(pos_end['col'], possible_sections[i].pos_end['col']), row =  math.max(pos_end['row'], possible_sections[i].pos_end['row'])}
                    no_ref = true
                    table.remove(possible_sections, i)
                end
            end

            local possible_section = {
                ref_index = not no_ref and k or nil,
                pos_start = {col = math.max(start_coords['col'], pos_start['col']), row = math.max(start_coords['row'], pos_start['row'])},
                pos_end = {col = math.min(end_coords['col'], pos_end['col']), row = math.min(end_coords['row'], pos_end['row'])}
            }

            table.insert(possible_sections, possible_section)
		end

        for _, v in ipairs(possible_sections) do
            local new_section = copy_table(v)
            if tree[depth-1] then
                local parent_mode = tree[depth-1].mode
                for i, parent in ipairs(tree[depth-1]) do
                    if v.pos_start[parent_mode] >= parent.pos_start[parent_mode] and
                    v.pos_end[parent_mode] <= parent.pos_end[parent_mode] then
                        new_section.parent_idx = i
                    end
                end
            end

            -- clears this index from the ref table
            if new_section.ref_index then
                ref_table[new_section.ref_index] = nil
            end

            tree[depth][#tree[depth]+1] = new_section
        end
	end

    local h_mod = ArrowAPI.DEFAULT_CREDIT_SIZE.h / end_coords.row
    local w_mod = ArrowAPI.DEFAULT_CREDIT_SIZE.w / end_coords.col
    local nodes = {}

    for depth_level, tbl in ipairs(tree) do
        nodes[depth_level] = {}
        for i, sec in ipairs(tbl) do
            local w = w_mod * (sec.pos_end.col - sec.pos_start.col)
            local h = h_mod * (sec.pos_end.row - sec.pos_start.row)
            local node = {
                n = tree[depth_level].mode == 'col' and G.UIT.C or G.UIT.R,
                config = {align = 'cm', minw = w, maxw = w, minh = h, maxh = h},
                nodes = {{
                    n = tree[depth_level].mode == 'col' and G.UIT.R or G.UIT.C,
                    config = {align = 'cm', minw = w, maxw = w, minh = h, maxh = h},
                    nodes = {}
                }}
            }

            local base_col_num = 12
            local col_mod = h/w
            local num_per_col = math.floor(base_col_num * col_mod)
            local mod_scale = col_mod * 0.7 * (col_mod < 1 and 1.5 or 1)

            -- only add definition and padding if it represents a low-level index
            if sec.ref_index then
                node.config.padding = 0.1 * (1/(depth_level ^ 5))
                node.nodes[1].config.outline_colour = G.C.JOKER_GREY
                node.nodes[1].config.r = 0.1
                node.nodes[1].config.outline = 1


                local ref = ArrowAPI.credits[mod.id][sec.ref_index]
                local contributor_nodes = {{
                    n=G.UIT.C,
                    config={align = "tm"},
                    nodes = {}
                }}
                local col_nodes = contributor_nodes[1].nodes

                for name, _ in pairs(ref.contributors) do
                    local scale_fac = math.min(0.8, ArrowAPI.ui.calc_scale_fac(name))
                    col_nodes[#col_nodes+1] = {
                        n=G.UIT.R,
                        config={align = "tm"},
                        nodes = {{
                            n=G.UIT.T,
                            config={text = name, scale = scale_fac * mod_scale, colour = G.C.UI.TEXT_LIGHT, shadow = true}
                        }}
                    }

                    if #col_nodes >= num_per_col then
                        contributor_nodes[#contributor_nodes+1] = {
                            n=G.UIT.C,
                            config={align = "tm"},
                            nodes = {}
                        }
                        col_nodes = contributor_nodes[#contributor_nodes].nodes
                    end
                end

                local title = localize('credits_'..ref.key)
                local title_fac = math.min(0.7, ArrowAPI.ui.calc_scale_fac(title))
                node.nodes[1].nodes = {
                    {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                        {n=G.UIT.T, config={text = title, scale = title_fac*1.4*mod_scale, colour = ref.title_colour, shadow = true}},
                    }},
                    {n=G.UIT.R, config={align = "cm", padding = 0}, nodes = contributor_nodes}
                }
            end

            table.insert(nodes[depth_level], node)
            if sec.parent_idx then
                table.insert(nodes[depth_level-1][sec.parent_idx].nodes[1].nodes, node)
            end
        end
    end

    local t = {n=G.UIT.ROOT, config={align = "cm", padding = 0.2, colour = G.C.BLACK, r = 0.1, emboss = 0.05, minh = 6, minw = 10}, nodes={
        {n = G.UIT.R, config = { align = "tm", padding = 0.2 }, nodes = {
            {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                {n=G.UIT.T, config={text = mod.display_name, scale = 1, colour = mod.badge_colour, shadow = true}},
            }}
        }},
        {n=G.UIT.R, config={align = "cm", padding = 0.05, outline_colour = mod.badge_colour, r = 0.1, outline = 1}, nodes = nodes[1]}
    }}

    mod.ARROW_USE_CREDITS = t

    return function()
        return mod.ARROW_USE_CREDITS
    end
end