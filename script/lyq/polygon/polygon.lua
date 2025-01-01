_G.Polygon = {}

function Polygon.new(x ,y)
    local polygon = setmetatable({}, Polygon);
    -- polygon.mode1 = 'fill';

    polygon.color = LColor.new(255,255,255,255)

    polygon.renderid = Render.PolygonId;

    polygon.circles = {};

    polygon.rects = {};

    polygon.vertices = {};

    polygon.triangles = {};

    polygon.svgpaths = {};

    polygon.usesvgpaths = false;

    polygon.transform =  Matrix.new();

    polygon.transform.obj = polygon;

    polygon.box = Box2D.new()

    -- polygon.revisexy = Vector.new() --TODO for triangles box2d position..

    --polygon.box2d
    return polygon;
end

Polygon.__index = function(tab, key)
    local body = rawget(tab, "body")
    if key == 'parent' and  body then
        return  tab["body"]["parent"];
    end

    if body then
        if key == 'parent' then
            return  body["parent"];
        elseif key == "name" then
            return "Polygon_"..body[key]
        elseif key == "needparentposition" then
            return body[key]
        elseif key == "needparentoffsetpos" then
            return body[key]
        end 
    end

    if Polygon[key] then
        return Polygon[key];
    end

    return rawget(tab, key);
end

Polygon.__newindex = function(tab, key, value)
    rawset(tab, key, value);
end

function Polygon:setColor(r, g, b, a)
    self.color.r = r;
    self.color.g = g;
    self.color.b = b;
    self.color.a = a;
end

function Polygon:addCircle(circle)
    table.insert(self.circles, circle);
end

function Polygon:addRect(rect)
    table.insert(self.rects, rect);
end

function Polygon:getWorldPointsBox2d(...)
    if self.box2d then
        return self.box2d:getWorldPoints(...)
    end

    return nil
end

function Polygon:getPoints(needparentposition, needparentoffsetpos, needall)
    local points  = {}
    if self.vertices and #self.vertices > 1 then
        for i = 1, #self.vertices, 2 do
            local x, y = self.transform:transformPoint(self.vertices[i], self.vertices[i + 1],needparentposition, needparentoffsetpos, needall)
            
            points[#points + 1] = x
            points[#points + 1] = y
        end
    end
    return points
end

function Polygon:hasBox2d()
    return self.box2d ~= nil
end

function Polygon:update(e)
    --同步物理信息
    if  self.phytype == "dynamic" and self.box2d then

        local x, y = self.box2d:getWorldCenter( )
        local angle = self.box2d:getAngle( )
        if self.oldbox2dx and self.oldbox2dy and self.oldbox2dangle then
            if math.abs(self.oldbox2dx - x) < 0.000001 and math.abs(self.oldbox2dy - y) < 0.000001 and math.abs(self.oldbox2dangle - angle) < 0.000001 then
                return;
            end
        end 

        if not self.box2doffsetx or not self.box2doffsety then
            local x1, y1 = self.box2d:getPosition()
            self.box2doffsetx = x1 - x;
            self.box2doffsety = y1 - y;
        end

        self.oldbox2dx = x;
        self.oldbox2dy = y;
        -- self.transform:reset();
 
        -- self.transform:rotateLeft(angle - (self.oldbox2dangle or 0))
        self.oldbox2dangle = angle;
    

        local posx, posy = self.transform:getPositionXY()
        local offsetx, offsety = self.transform:getOffsetPosXY();
        self.transform:reset()
        -- if self.isConvex == false then
        --     self.transform:moveTo(x - self.revisexy.x, y - self.revisexy.y );
        -- else
            self.transform:moveTo(x, y);
        -- end
        
        self.transform:rotateLeft(angle)

        local newpos = self.transform:getPosition()
        -- if self.isConvex == false then
        --     self.transform.offsetpos.x = offsetx + newpos.x - posx - self.revisexy.x
        --     self.transform.offsetpos.y = offsety + newpos.y - posy - self.revisexy.y
        -- else
            self.transform.offsetpos.x = offsetx + newpos.x - posx
            self.transform.offsetpos.y = offsety + newpos.y - posy
        -- end

    end
end
