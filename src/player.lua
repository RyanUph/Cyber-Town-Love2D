anim8 = require('libraries/anim8')
player = {}

function player.load()
    player.x = 400
    player.y = 1450
    player.speed = 300
    player.spriteSheet = love.graphics.newImage('sprites/player.png')
    player.grid = anim8.newGrid(16, 16, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animations = {}
    player.animations.walk = anim8.newAnimation(player.grid('1-5', 2), 0.1)
    player.animations.attack = anim8.newAnimation(player.grid('1-4', 5), 0.14)
    player.animations.idle = anim8.newAnimation(player.grid('1-1', 1), 0.1)
    player.anim = player.animations.idle

    facingRight = true
    facingLeft = false
end

function player.update(dt)
    playerMovement(dt)
end

function player.draw()
    if facingRight then
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 5, 5, 8, 8)
    end

    if facingLeft then
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, -5, 5, 8, 8)
    end
end

-- Player Functions

function playerMovement(dt)
    isMoving = false
    attack = false
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

    if love.keyboard.isDown('e') then
        attack = true
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
