--If the current container is being 'Hovered', usually by a cursor, determine if any hover popups need to be generated and do so

if Galdur then
    local ref_node_hover = Node.hover
    function Node:hover(...)
        if self.config and self.params and self.params.deck_select and self.config.center.artist and self.config.h_popup then
            local desc_nodes = self.config.h_popup.nodes[2].nodes[1].nodes
            table.insert(desc_nodes, 3, {
                n = G.UIT.R,
                config = {align = "cm"},
                nodes = {{
                    n = G.UIT.O,
                    config = {
                        object = UIBox{
                            definition = G.UIDEF.deck_credit(self.config.center),
                            config = {offset = {x=0,y=0}}
                        }
                    }
                }}
            })
        end

        return ref_node_hover(self, ...)
    end
end


--- weird bullshit
local ref_uie_draw = UIElement.draw_self
function UIElement:draw_self()
    if self.config.id == 'arrow_badge_color_node' then
        if not self.states.visible then
            if self.config.force_focus then add_to_drawhash(self) end
            return
        end

        if self.config.force_focus or self.config.force_collision or self.states.collide.can then
            add_to_drawhash(self)
        end

        if self.config.colour[4] > 0.01 then
            prep_draw(self, 1)
            love.graphics.scale(1/(G.TILESIZE))

            G.SHADERS['arrow_ui_poly']:send('polychrome', {G.TIMERS.REAL/(28), G.TIMERS.REAL})
            G.SHADERS['arrow_ui_poly']:send("time", 123.33412*12.5123152%3000)
            love.graphics.setShader(G.SHADERS['arrow_ui_poly'], G.SHADERS['arrow_ui_poly'])

            love.graphics.setColor(darken(self.config.colour, 0.3, true))
            self:draw_pixellated_rect('emboss', 1.5, self.config.emboss)

            love.graphics.setColor(self.config.colour)
            self:draw_pixellated_rect('fill', 1.5)
            love.graphics.setShader()
            love.graphics.pop()
        end

        self:draw_boundingrect()
        return
    elseif self.config.grad_colour and (self.UIT == G.UIT.B or self.UIT == G.UIT.C or self.UIT == G.UIT.R) then
        if not self.states.visible then
            if self.config.force_focus then add_to_drawhash(self) end
            return
        end

        if self.config.force_focus or self.config.force_collision or self.config.button_UIE or self.config.button or self.states.collide.can then
            add_to_drawhash(self)
        end

        local parallax_dist = 1.5
        local button_being_pressed = false

        if (self.config.button or self.config.button_UIE) then
            self.layered_parallax.x = ((self.parent and self.parent ~= self.UIBox and self.parent.layered_parallax.x or 0) + (self.config.shadow and 0.4*self.shadow_parrallax.x or 0)/G.TILESIZE)
            self.layered_parallax.y = ((self.parent and self.parent ~= self.UIBox and self.parent.layered_parallax.y or 0) + (self.config.shadow and 0.4*self.shadow_parrallax.y or 0)/G.TILESIZE)

            if self.config.button and ((self.last_clicked and self.last_clicked > G.TIMERS.REAL - 0.1) or ((self.config.button and (self.states.hover.is or self.states.drag.is))
                and G.CONTROLLER.is_cursor_down)) then
                    self.layered_parallax.x = self.layered_parallax.x - parallax_dist*self.shadow_parrallax.x/G.TILESIZE*(self.config.button_dist or 1)
                    self.layered_parallax.y = self.layered_parallax.y - parallax_dist*self.shadow_parrallax.y/G.TILESIZE*(self.config.button_dist or 1)
                    parallax_dist = 0
                    button_being_pressed = true
            end
        end

        prep_draw(self, 1)
        love.graphics.scale(1/(G.TILESIZE))
        love.graphics.scale(button_being_pressed and 0.985 or 1)

        local scale = G.TILESIZE * G.TILESCALE
        local start_x = (G.ROOM.T.x + self.T.x) * scale
        local end_x = start_x + self.T.w * scale
        G.SHADERS['arrow_button_grad']:send('start_x', start_x)
        G.SHADERS['arrow_button_grad']:send('end_x', end_x)

        local color = self.config.grad_colour
        local array_table = {}
        local size = #color.grad_pos

        for i=1, 8 do
            if i <= size then
                local start_idx = (i - 1) * 3
                array_table[i] = {color[start_idx + 1]/255, color[start_idx + 2]/255, color[start_idx + 3]/255, color.grad_pos[i]}
            else
                array_table[i] = {1, 1, 1, 1}
            end
        end

        G.SHADERS['arrow_button_grad']:send("grad_size", size)
        G.SHADERS['arrow_button_grad']:send("grad_points", unpack(array_table))

        if self.config.emboss then
            love.graphics.setColor(darken(G.C.UI.BACKGROUND_DARK, self.states.hover.is and 0.5 or 0.3, true))
            self:draw_pixellated_rect('emboss', parallax_dist, self.config.emboss)
        end

        love.graphics.setShader(G.SHADERS['arrow_button_grad'])
        love.graphics.setColor(G.C.WHITE)
        self:draw_pixellated_rect('fill', parallax_dist)
        love.graphics.setShader()

        local collided_button = self.config.button_UIE or self
        if ((collided_button.config.hover and collided_button.states.hover.is) or (collided_button.last_clicked and collided_button.last_clicked > G.TIMERS.REAL - 0.1)) then
            love.graphics.setColor(G.C.UI.HOVER)
            self:draw_pixellated_rect('fill', parallax_dist)
        end

        love.graphics.pop()

        --Draw the outline for highlighted buttons
        if self.states.focus.is then
            self.focus_timer = self.focus_timer or G.TIMERS.REAL
            local lw = 50*math.max(0, self.focus_timer - G.TIMERS.REAL + 0.3)^2
            prep_draw(self, 1)
            love.graphics.scale((1)/(G.TILESIZE))
            love.graphics.setLineWidth(lw + 1.5)
            love.graphics.setColor(adjust_alpha(G.C.WHITE, 0.2*lw, true))
            self:draw_pixellated_rect('fill', parallax_dist)
            love.graphics.setColor(self.config.colour[4] > 0 and mix_colours(G.C.WHITE, self.config.colour, 0.8) or G.C.WHITE)
            self:draw_pixellated_rect('line', parallax_dist)
            love.graphics.pop()
        else
            self.focus_timer = nil
        end

        return
    end

    local ret = ref_uie_draw(self)

    if self.config.id == 'arrow_angle_widget' then
        local grad_enabled = #ArrowAPI.palette_ui_config.grad_widget_config.grad_points > 1
        local config = self.config.ref_table

        if config.mode == 'linear' then
            local origin_x = self.VT.w * G.TILESIZE/2
            local origin_y = self.VT.h * G.TILESIZE/2

            prep_draw(self, 1)
            love.graphics.scale(1/(G.TILESIZE))

            love.graphics.setColor(darken(grad_enabled and G.C.UI.BACKGROUND_DARK or G.C.UI.TEXT_INACTIVE, 0.3, true))
            love.graphics.circle('fill', origin_x, origin_y+(0.05*G.TILESIZE), origin_x)

            love.graphics.setColor(grad_enabled and G.C.UI.BACKGROUND_DARK or G.C.UI.TEXT_INACTIVE)
            love.graphics.circle('fill', origin_x, origin_y, origin_x)

            love.graphics.setColor(grad_enabled and G.C.FILTER or darken(G.C.UI.TEXT_INACTIVE, 0.3))
            love.graphics.setLineWidth(0.65)
            love.graphics.setLineStyle('rough')

            local adjusted_x = config.point.x / 2 + 0.5
            local adjusted_y = config.point.y / -2 + 0.5

            love.graphics.line(adjusted_x * self.VT.w * G.TILESIZE, adjusted_y * self.VT.h * G.TILESIZE, origin_x, origin_y)

            love.graphics.pop()
            return
        end

        prep_draw(self, 1)
        love.graphics.scale(1/(G.TILESIZE))

        love.graphics.setColor(darken(grad_enabled and G.C.UI.BACKGROUND_DARK or G.C.UI.TEXT_INACTIVE, 0.3, true))
        self:draw_pixellated_rect('emboss', 1.5, 0.05)

        love.graphics.setColor(grad_enabled and G.C.UI.BACKGROUND_DARK or G.C.UI.TEXT_INACTIVE)
        self:draw_pixellated_rect('fill', 1.5)

        local adjusted_x = config.point.x / 2 + 0.5
        local adjusted_y = config.point.y / -2 + 0.5

        love.graphics.setColor(grad_enabled and G.C.FILTER or darken(G.C.UI.TEXT_INACTIVE, 0.3))
        love.graphics.polygon("fill", angle_point(self.VT.w*G.TILESIZE*adjusted_x, self.VT.h*G.TILESIZE*adjusted_y, 2.2))

        love.graphics.pop()
    elseif self.config.id == 'arrow_grad_widget_pointers' then
        local sorted_points = {}
        for i=1, #self.config.grad_points do
            local point = self.config.grad_points[i]
            sorted_points[i] = {orig_idx = i, grad_idx = (i == ArrowAPI.palette_ui_config.open_palette.grad_idx), selected = point.selected, pos = point.pos}
        end

        table.sort(sorted_points, function(a, b)
            return (not a.grad_idx and b.grad_idx) and (not a.selected and b.selected) and a.pos < b.pos
        end)

        for i=1, #sorted_points do
            local point = sorted_points[i]
            if point.selected then
                local text = string.format("%.2f", tostring(point.pos))

                if not self.config.text_drawable then
                    self.config.text_drawable = love.graphics.newText(G.LANG.font.FONT, {G.C.WHITE, text})
                else
                    self.config.text_drawable:set(text)
                end

                prep_draw(self, 1)
                love.graphics.scale(1/(G.TILESIZE))
                love.graphics.setColor(G.C.UI.TEXT_LIGHT)
                love.graphics.draw(
                    self.config.text_drawable,
                    (self.VT.w*point.pos - 0.15)*G.TILESIZE,
                    -0.25*G.TILESIZE,
                    0,
                    0.2*G.LANG.font.squish*G.LANG.font.FONTSCALE,
                    0.2*G.LANG.font.FONTSCALE
                )
                love.graphics.pop()


                prep_draw(self, 1)
                love.graphics.scale(1/(G.TILESIZE))
                love.graphics.setColor(G.C.UI.TEXT_LIGHT)
                love.graphics.polygon("fill", grad_point(self.VT.w*G.TILESIZE*point.pos, self.VT.h*G.TILESIZE, 1.25))
                love.graphics.pop()
            elseif G.SETTINGS.GRAPHICS.shadows == 'On' then
                prep_draw(self, 0.99)
                love.graphics.scale(1/(G.TILESIZE))
                love.graphics.setColor(0,0,0,0.3)
                love.graphics.polygon("fill", grad_point(self.VT.w*G.TILESIZE*point.pos - self.shadow_parrallax.x*0.75, self.VT.h*G.TILESIZE - self.shadow_parrallax.y*0.75))
                love.graphics.pop()
            end

            prep_draw(self, 1)
            love.graphics.scale(1/(G.TILESIZE))
            love.graphics.setColor(point.orig_idx == ArrowAPI.palette_ui_config.open_palette.grad_idx and G.C.FILTER or G.C.JOKER_GREY)
            love.graphics.polygon("fill", grad_point(self.VT.w*G.TILESIZE*point.pos, self.VT.h*G.TILESIZE))
            love.graphics.pop()

            prep_draw(self, 1)
            love.graphics.scale(1/(G.TILESIZE))

            local color =  self.config.grad_points[point.orig_idx].color
            love.graphics.setColor({color[1]/255, color[2]/255, color[3]/255, 1})
            love.graphics.polygon("fill", grad_color(self.VT.w*G.TILESIZE*point.pos, self.VT.h*G.TILESIZE))
            love.graphics.pop()
        end
    elseif self.config.id == 'arrow_rgb_slider' then
        prep_draw(self, 1)
        love.graphics.scale(1/(G.TILESIZE))
        local scale = G.TILESIZE * G.TILESCALE

        G.SHADERS['arrow_rgb_slider']:send('start_x', (self.VT.x + G.ROOM.T.x) * scale)
        G.SHADERS['arrow_rgb_slider']:send('end_x', (self.VT.x + G.ROOM.T.x + self.VT.w) * scale)
        G.SHADERS['arrow_rgb_slider']:send('colour_channel', self.config.ref_table.ref_value)
        G.SHADERS['arrow_rgb_slider']:send('current_color', self.config.ref_table.ref_table)
        love.graphics.setShader(G.SHADERS['arrow_rgb_slider'])
        self:draw_pixellated_rect('fill', 1.5)
        love.graphics.setShader()
        love.graphics.pop()
    end

    if self.config.slider_point then
        prep_draw(self, 0.99)
        love.graphics.scale(1/(G.TILESIZE))
        love.graphics.setColor(0,0,0,0.3)
        love.graphics.polygon("fill", slider_point(self.VT.w*G.TILESIZE-self.shadow_parrallax.x*0.75, self.VT.h*G.TILESIZE/2- self.shadow_parrallax.y*0.75, 0.12*G.TILESIZE, 1.21*self.VT.h*G.TILESIZE))
        love.graphics.pop()

        prep_draw(self, 1)
        love.graphics.scale(1/(G.TILESIZE))
        love.graphics.setColor(G.C.UI.TEXT_LIGHT)
        love.graphics.polygon("fill", slider_point(self.VT.w*G.TILESIZE, self.VT.h*G.TILESIZE/2, 0.12*G.TILESIZE, 1.21*self.VT.h*G.TILESIZE))
        love.graphics.pop()
    end

    return ret
end

function angle_point(x, y, scale)
    scale = scale or 1
    return {
        x - 0.3*scale, y-0.5*scale,
        x - 0.5*scale, y-0.3*scale,
        x - 0.5*scale, y+0.3*scale,
        x - 0.3*scale, y+0.5*scale,
        x + 0.3*scale, y+0.5*scale,
        x + 0.5*scale, y+0.3*scale,
        x + 0.5*scale, y-0.3*scale,
        x + 0.3*scale, y-0.5*scale,
    }
end

function slider_point(x, y, width, height)
    width = width or 0.25
    height = height or 1
    local half_height = height/2
    local height_sub = 0.9*half_height
    return {
        x - 0.4*width, y-half_height,
        x - 0.5*width, y-height_sub,
        x - 0.5*width, y+height_sub,
        x - 0.4*width, y+half_height,
        x + 0.4*width, y+half_height,
        x + 0.5*width, y+height_sub,
        x + 0.5*width, y-height_sub,
        x + 0.4*width, y-half_height,
    }
end

function grad_color(x, y, scale)
    scale = scale or 1
    local y_off = (1 - scale) * 3.3 * 1.5
    scale = scale * 2
    return {
        x - 0.75*scale, y-3.3*scale - y_off,
        x - 0.9*scale, y-3.15*scale - y_off,
        x - 0.9*scale, y-1.75*scale - y_off,
        x - 0.75*scale, y-1.6*scale - y_off,
        x + 0.75*scale, y-1.6*scale - y_off,
        x + 0.9*scale, y-1.75*scale - y_off,
        x + 0.9*scale, y-3.15*scale - y_off,
        x + 0.75*scale, y-3.3*scale - y_off
    }
end

function grad_point(x, y, scale)
    scale = scale or 1
    local y_off = (1 - scale) * 3.3 * 1.5
    scale = scale * 2
    return {
        x - 1.1*scale, y-3.5*scale - y_off,
        x - 1.25*scale, y-3.3*scale - y_off,
        x - 1.25*scale, y-1.4*scale - y_off,
        x + 0, y-0.2*scale - y_off,
        x + 1.25*scale, y-1.4*scale - y_off,
        x + 1.25*scale, y-3.3*scale - y_off,
        x + 1.1*scale, y-3.5*scale - y_off,
    }
end

function Node:r_click() end

local ref_node_remove = Node.remove
function Node:remove()
    local ret = ref_node_remove(self)

    if G.CONTROLLER.r_clicked.target == self then
        G.CONTROLLER.r_clicked.target = nil
    end
    if G.CONTROLLER.r_cursor_down.target == self then
        G.CONTROLLER.r_cursor_down.target = nil
    end
    if G.CONTROLLER.r_cursor_up.target == self then
        G.CONTROLLER.r_cursor_up.target = nil
    end

    return ret
end