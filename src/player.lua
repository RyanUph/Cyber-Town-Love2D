anim8 = require('libraries/anim8')
player = {}
bullets = {}

function player.load()
    player.x = 400
    player.y = 1450
    player.speed = 300
    player.spriteSheet = love.graphics.newImage('sprites/player.png')
    player.grid = anim8.newGrid(16, 16, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animations = {}
    player.animations.walk = anim8.newAnimation(player.grid('1-5', 2), 0.1)
    player.animations.attack = anim8.newAnimation(player.grid('1-4', 5), 0.14, function() attack = false player.anim = player.animations.idle player.anim:gotoFrame(1) end)
    player.animations.idle = anim8.newAnimation(player.grid('1-1', 1), 0.1)
    player.anim = player.animations.idle

    player.data = {}
    player.data.score = 0
    player.data.bestScore = 0

    facingRight = true
    facingLeft = false
end

function player.update(dt)
    playerMovement(dt)
    bulletMovement(dt)
    destroyBullet(dt)
    killEnemy(dt)

    player.data.bestScore = player.data.score
end

function player.draw()
    if facingRight then
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 5, 5, 8, 8)
    end

    if facingLeft then
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, -5, 5, 8, 8)
    end

    for _, bullet in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, bullet.x, bullet.y, nil, 3, 3, 8, 8)
    end
end

-- Player Functions

function playerMovement(dt)
    isMoving = false
    --attack = false
    local vX = 0
    local vY = 0

    if love.keyboard.isDown('d') then
        vX = player.speed * dt
        player.anim = player.animations.walk

        isMoving = true
        facingRight = true
        facingLeft = false
    end

    if love.keyboard.isDown('a') then
        vX = player.speed * -1 * dt
        player.anim = player.animations.walk

        isMoving = true
        facingRight = false
        facingLeft = true
    end

    if isMoving == false then
        player.anim = player.animations.idle
        player.anim:gotoFrame(1)
    end

    if isMoving == false and attack == true then
       player.anim = player.animations.attack
    end

    player.collider:setLinearVelocity(vX * player.speed, vY)
    player.x = player.collider:getX()
    player.y = player.collider:getY()
    player.anim:update(dt)
end

-- Bullet Functions

function bulletMovement(dt)
    for _, bullet in ipairs(bullets) do
        if bullet.direction == 1 then bullet.x = bullet.x + bullet.speed * dt end
        if bullet.direction == 2 then bullet.x = bullet.x - bullet.speed * dt end
    end
end

function destroyBullet(dt)
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        local gx, gy = cam:worldCoords(0, 0)
        local gw, gh = cam:worldCoords(love.graphics.getWidth(), love.graphics.getHeight())
        if b.x < gx - 10 or b.y < gy - 10 or b.x > gw + 10 or b.y > gh + 10 then
            table.remove(bullets, i)
        end
    end
end

function killEnemy(dt)
    for _, enemy in ipairs(enemies) do
        for _, bullet in ipairs(bullets) do
            if distanceBetween(enemy.x, enemy.y, bullet.x, bullet.y) < 30 then
                enemy.dead = true
                bullet.dead = true
                player.data.score = player.data.score + 1
            end
        end
    end

    for i = #bullets, 1, -1 do
        local b = bullets[i]
        if b.dead == true then table.remove(bullets, i) end
    end

    for i = #enemies, 1, -1 do
        local e = enemies[i]
        if e.dead == true then
            table.remove(enemies, i)
        end
    end
end

function spawnBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 800
    bullet.dead = false

    if facingRight then bullet.direction = 1 end
    if facingLeft then bullet.direction = 2 end
    table.insert(bullets, bullet)
end