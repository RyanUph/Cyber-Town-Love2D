enemies = {}

function enemies.load()

end

function enemies.update(dt)
    
end

function enemies.draw()
    for _, enemy in ipairs(enemies) do
        love.graphics.draw(sprites.enemy, enemy.x, enemy.y, nil, 6, 6, 8, 8)
    end
end

-- Enemy Functions

function spawnEnemy(x, y)
    local enemy = {}
    enemy.x = x
    enemy.y = y
    enemy.speed = 200
    enemy.dead = false
    table.insert(enemies, enemy)
end