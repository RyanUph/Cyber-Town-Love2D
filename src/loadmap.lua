sti = require('libraries.sti')

function loadMap(mapName)
    gameMap = sti('maps/' .. mapName .. '.lua')

    groundRC = {}
    if gameMap.layers["GroundRC"] then
        for _, obj in pairs(gameMap.layers["GroundRC"].objects) do
            ground = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            ground:setType('static')
            table.insert(groundRC, ground)
        end
    end
end