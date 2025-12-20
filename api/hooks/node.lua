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
    if self.config.id and (self.config.id:sub(1,20) == 'arrow_palette_button' or self.config.id:sub(1,20) == 'arrow_palette_defaul') then
        self.ARGS.button_colours = {G.C.WHITE}
    end

    local ret = ref_uie_draw(self)

    if self.config.id == 'arrow_grad_widget_pointers' then
        local grad_points = self.config.grad_points
        for i=1, #grad_points do
            local point = grad_points[i]
            if point.selected then
                prep_draw(self, 1)
                love.graphics.scale(1/(G.TILESIZE))
                love.graphics.setColor(G.C.UI.TEXT_LIGHT)
                love.graphics.polygon("fill", grad_point(self.VT.w*G.TILESIZE*point.pos, self.VT.h*G.TILESIZE, 1.25))
                love.graphics.pop()
            end

            prep_draw(self, 1)
            love.graphics.scale(1/(G.TILESIZE))
            love.graphics.setColor(G.C.JOKER_GREY)
            love.graphics.polygon("fill", grad_point(self.VT.w*G.TILESIZE*point.pos, self.VT.h*G.TILESIZE))
            love.graphics.pop()

            prep_draw(self, 1)
            love.graphics.scale(1/(G.TILESIZE))

            love.graphics.setColor({point.color[1]/255, point.color[2]/255, point.color[3]/255, 1})
            love.graphics.polygon("fill", grad_color(self.VT.w*G.TILESIZE*point.pos, self.VT.h*G.TILESIZE))
            love.graphics.pop()
        end
    end

    --Draw the 'chosen triangle'
    if self.config.slider_point then
        prep_draw(self, 0.98)
        love.graphics.scale(1/(G.TILESIZE))
        if self.config.shadow and G.SETTINGS.GRAPHICS.shadows == 'On' then
            love.graphics.setColor(0,0,0,0.3*self.config.colour[4])
            love.graphics.polygon("fill", slider_point(0 - self.shadow_parrallax.x*0.75, 0 - self.shadow_parrallax.y*0.75, self.VT.w*G.TILESIZE))
        end
        love.graphics.pop()

        prep_draw(self, 1)
        love.graphics.scale(1/(G.TILESIZE))
        love.graphics.setColor(self.config.colour)
        love.graphics.polygon("fill", slider_point(0, 0, self.VT.w*G.TILESIZE))
        love.graphics.pop()

        if self.config.inner_point then
            prep_draw(self, 1)
            love.graphics.scale(1/(G.TILESIZE))
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.polygon("fill", slider_point(0, 0, self.VT.w*G.TILESIZE, 0.75))
            love.graphics.pop()
        end
    end

    return ret
end

function slider_point(x, y, w, scale)
    scale = math.max(0, math.min(1, scale or 1))
    local y_off = (1 - scale) * 2.9 * 1.5
    scale = scale * 2
    return {
        x+w - 1.5*scale, y-3.1*scale - y_off,
        x+w + 0, y-0.2*scale - y_off,
        x+w + 1.5*scale, y-3.1*scale - y_off
    }
end

function grad_color(x, y, scale)
    scale = scale or 1
    local y_off = (1 - scale) * 3.3 * 1.5
    scale = scale * 2
    return {
        x - 0.9*scale, y-3.3*scale - y_off,
        x - 0.9*scale, y-1.6*scale - y_off,
        x + 0.9*scale, y-1.6*scale - y_off,
        x + 0.9*scale, y-3.3*scale - y_off
    }
end

function grad_point(x, y, scale)
    scale = scale or 1
    local y_off = (1 - scale) * 3.3 * 1.5
    scale = scale * 2
    return {
        x - 1.25*scale, y-3.5*scale - y_off,
        x - 1.25*scale, y-1.4*scale - y_off,
        x + 0, y-0.2*scale - y_off,
        x + 1.25*scale, y-1.4*scale - y_off,
        x + 1.25*scale, y-3.5*scale - y_off
    }
end