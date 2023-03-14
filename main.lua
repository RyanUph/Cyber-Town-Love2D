function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    require('src/player')
    require('src/loadmap')
    require('libraries/gooi')
    camera = require('libraries.camera')
    wf = require('libraries/windfield')

    player.load()
    cam = camera()
    world = wf.newWorld(0, 10000 * 10)
    loadMap('cyberTown')

    -- Player collider
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 55, 80, 10)
    player.collider:setFixedRotation(true)

    enemySprite = love.graphics.newImage('sprites/enemy.png')
end

function love.update(dt)
    cam:lookAt(player.x, player.y)
    world:update(dt)
    player.update(dt)
end

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers['Ground'])
        gameMap:drawLayer(gameMap.layers['Background'])
        player.draw()
        world:draw()
    cam:detach()
end