_G.app = {}
local metatab =  {
    __call = function(self, param1, ...)
    
    if type(param1) == 'function' then
        table.insert(self, param1);
    else
            for i, v in pairs(self) do
                if type(v) == 'function' then
                    self[i](param1, ...);
                end
            end
        end
    end
  }

  --参数统一
 _G.app.update = setmetatable({},  metatab)

 _G.app.beforrender = setmetatable({},  metatab)

_G.app.render = setmetatable({},  metatab)

_G.app.afterrender = setmetatable({},  metatab)

_G.app.mousepressed = setmetatable({}, metatab)

_G.app.mousemoved = setmetatable({}, metatab)

_G.app.load = setmetatable({},  metatab)

_G.app.mousereleased = setmetatable({},  metatab)

_G.app.keypressed = setmetatable({},  metatab)

_G.app.wheelmoved = setmetatable({},  metatab)

_G.app.resizeWindow = setmetatable({},  metatab)