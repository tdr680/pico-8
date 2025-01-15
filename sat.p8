pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- pico-8 polygon collision detection

-- polygon structure: {x, y, points = {{x,y}, {x,y}, ...}}
-- points are relative to the polygon's x and y position.

function polygon_intersects(p1, p2)
  -- separating axis theorem (sat)

  local function get_axes(poly)
    local axes = {}
    for i = 1, #poly.points do
      local p1_idx = i
      local p2_idx = i % #poly.points + 1
      local v1 = poly.points[p1_idx]
      local v2 = poly.points[p2_idx]
      local edge = {x = v2.x - v1.x, y = v2.y - v1.y}
      -- normal vector (perpendicular to the edge)
      add(axes, {x = -edge.y, y = edge.x})
    end
    return axes
  end

  local function project_polygon(poly, axis)
    local min = nil
    local max = nil
    for _, point in ipairs(poly.points) do
      local dot_product = (point.x + poly.x) * axis.x + (point.y + poly.y) * axis.y
      if min == nil or dot_product < min then
        min = dot_product
      end
      if max == nil or dot_product > max then
        max = dot_product
      end
    end
    return {min = min, max = max}
  end

  local axes1 = get_axes(p1)
  local axes2 = get_axes(p2)

  for _, axis in ipairs(axes1) do
    local projection1 = project_polygon(p1, axis)
    local projection2 = project_polygon(p2, axis)

    if projection1.max < projection2.min or projection2.max < projection1.min then
      return false -- separated on this axis
    end
  end

    for _, axis in ipairs(axes2) do
    local projection1 = project_polygon(p1, axis)
    local projection2 = project_polygon(p2, axis)

    if projection1.max < projection2.min or projection2.max < projection1.min then
      return false -- separated on this axis
    end
  end

  return true -- no separating axis found, polygons intersect
end


-- example usage:
local poly1 = {
  x = 30, y = 30,
  points = {{x = 0, y = 0}, {x = 20, y = 0}, {x = 10, y = 20}} -- triangle
}

local poly2 = {
  x = 40, y = 20,
  points = {{x = 0, y = 0}, {x = 10, y = -10}, {x = 20, y = 0}, {x=10,y=10}} -- diamond
}

function _draw()
 cls()
  --draw polygons
  local function draw_poly(p)
    for i = 1, #p.points do
      local p1_idx = i
      local p2_idx = i % #p.points + 1
      local v1 = p.points[p1_idx]
      local v2 = p.points[p2_idx]
      line(p.x+v1.x,p.y+v1.y,p.x+v2.x,p.y+v2.y,7)
    end
  end
  draw_poly(poly1)
  draw_poly(poly2)

 if polygon_intersects(poly1, poly2) then
   print("collision!")
 else
   print("no collision.")
 end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
