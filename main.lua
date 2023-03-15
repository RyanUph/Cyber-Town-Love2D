function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    require('src/player')
    require('src/enemy')
    require('src/loadmap')
    require('libraries/gooi')
    camera = require('libraries.camera')
    wf = require('libraries/windfield')

    player.load()
    enemies.load()
    cam = camera()
    world = wf.newWorld(0, 10000 * 10)
    loadMap('cyberTown')

    -- Player collider
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 55, 80, 10)
    player.collider:setFixedRotation(true)

    sprites = {}
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.enemy = love.graphics.newImage('sprites/enemy.png')

    font = love.graphics.newFont(30)
end

function love.update(dt)
    world:update(dt)
    player.update(dt)
    enemies.update(dt)
    cam:lookAt(player.x, player.y)

    scoreText = love.graphics.newText(font, "Score: " .. player.data.score)
end

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers['Background'])
        gameMap:drawLayer(gameMap.layers['Ground'])
        player.draw()
        enemies.draw()
        world:draw()
    cam:detach()

    love.graphics.draw(scoreText, 50, 50)
end

-- Functions

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function love.keypressed(key)
    --if key == 'e' and not attack then spawnBullet() end
    if key == 'q' then spawnEnemy(cam:worldCoords(love.mouse.getPosition())) end
    if key == "e" and player.anim == player.animations.idle and not attack then attack = true spawnBullet() end
end