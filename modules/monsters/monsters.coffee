{ attackTypes, actions, heroStates, species, mapTypes, armourTypes, WEAPON_GAIN_FACTOR, XP_GAIN_FACTOR, HP_GAIN_FACTOR, MANA_GAIN_FACTOR, weaponStates } = require '../constants'
{ random, log, err, warn } = require '../general'

chalk = require 'chalk'
Weapon = require '../weapons/weapons.coffee'
Armour = require '../armours/armours.coffee'
inspector = require '../inspector.coffee'
Hero = require '../hero.coffee'

meleeMonsters = require './melee.monsters.coffee'
rangedMonsters = require './ranged.monsters.coffee'
magicMonsters = require './magic.monsters.coffee'

monsters = [meleeMonsters..., rangedMonsters..., magicMonsters...]

create = (monster) ->
    newMonster =
        arrow: monster.arrow
        broadhead: monster.broadhead
        broadheads: monster.broadheads
        combatPos: monster.combatPos
        gold: monster.gold
        land: monster.land
        level: monster.level
        maxMana: monster.maxMana
        maxhp: monster.maxhp
        movement: monster.movement
        name: monster.name
        position: monster.position
        quiver: monster.quiver
        species: monster.species
        spell: monster.spell
        state: [monster.state...]
        xp: monster.xp

    if not monster.hp then newMonster.hp = monster.maxhp else newMonster.hp = monster.hp
    if not monster.mana then newMonster.mana = monster.maxMana else newMonster.mana = monster.mana

    # masteries
    newMonster.masteries = Object.assign {}, monster.masteries

    # create weapon
    newMonster.weapon = Object.assign {}, monster.weapon

    # create armour
    newMonster.armour = Object.assign {}, monster.armour

    # create skills
    newMonster.skills = Object.assign {}, monster.skills

    if monster.getAction?
        newMonster.getAction = monster.getAction
    else
        newMonster.getAction = getAction

    return Object.freeze newMonster
createFromTemplate = (monster, level) ->
    newMonster =
        arrow: 0
        broadhead: 0
        broadheads: monster.broadheads
        combatPos: null
        gold: ((monster.gold * 0.75) + random(monster.gold * 25)/100) * Math.pow XP_GAIN_FACTOR, level-1
        hp: monster.maxhp * Math.pow(HP_GAIN_FACTOR, level-1)
        land: monster.land
        level: level
        mana: (monster.maxMana || 1) * Math.pow(MANA_GAIN_FACTOR, level-1)
        maxMana: (monster.maxMana || 1) * Math.pow(MANA_GAIN_FACTOR, level-1)
        maxhp: monster.maxhp * Math.pow(HP_GAIN_FACTOR, level-1)
        movement: monster.movement
        name: monster.name
        position: monster.position
        quiver: monster.quiver
        species: monster.species
        spell: monster.spell
        state: []
        xp: monster.xp * Math.pow(XP_GAIN_FACTOR, level-1)

    # TODO skills and skills bonus damage
    newMonster.skills = Object.assign {}, monster.skills

    # create weapon
    options =
        min: monster.attack.min * Math.pow WEAPON_GAIN_FACTOR, level-1
        max: monster.attack.max * Math.pow WEAPON_GAIN_FACTOR, level-1
        range: monster.attack.range || 1
        speed: monster.attack.speed
        spell: monster.spell
    newMonster.weapon = Weapon.create Object.assign {}, monster.weapon, options

    # create armour
    armours = Armour.getAll()
    switch monster.armour.type
        when armourTypes.light then newMonster.armour = Armour.create Object.assign {}, armours.robe, { resistance: { physical: monster.armour.amount } }
        when armourTypes.medium then newMonster.armour = Armour.create Object.assign {}, armours.leather, { resistance: { physical: monster.armour.amount } }
        when armourTypes.heavy then newMonster.armour = Armour.create Object.assign {}, armours.breastPlate, { resistance: { physical: monster.armour.amount } }

    # masteries
    newMonster.masteries = {}
    newMonster.masteries[newMonster.weapon.type] = { level: level }

    if monster.getAction?
        newMonster.getAction = monster.getAction
    else
        newMonster.getAction = getAction

    return Object.freeze newMonster
dead = (monster, hero) ->
    bonusGold = getBonusGold monster, hero
    log()
    log chalk.green '> ' + monster.name + ' is dead'
    log chalk.green('> looted ') + chalk.yellow(monster.gold.toFixed(2) + ' + ' + bonusGold.toFixed(2) + ' gold')
    log chalk.green('> gained ') + chalk.yellow(monster.xp.toFixed(2) + ' xp')

    return [ monster.gold + bonusGold, monster.xp ]
getBonusGold = (monster, hero) ->
    types = monster.species
    if types.has(species.beast) and hero.skills.skinning?
        return monster.gold * hero.skills.skinning.level * hero.skills.skinning.bonus
    return 0
getRandomType = (level, mapType) ->
    return monsters[5]

    available = monsters.filter (x) ->
        return x.land.has(mapType) and x.minLevel <= level and x.maxLevel >= level
    return available[random available.length]
attack = (monster, hero) ->
    # TODO deal with reflect
    [ damages, effects ] = Weapon.getDamage(monster, hero)
    return [ monster, damages, effects ]
getAction = (source, target) ->
    if source.state.filter((x) -> x.effect is heroStates.frozen).length > 0
        log chalk.blueBright '> ' + source.name + ' is frozen'
        return null

    distance = Math.abs source.combatPos - target.combatPos
    if distance is 1
        return actions.attack
    else
        if source.weapon.spell?
            if source.mana < source.weapon.spell.mana * source.weapon.manaAdjustment
                return actions.approach
            else
                return actions.useSpell
        if source.weapon.range is 1
            if source.state.has { effect: heroStates.maimed }
                log '> ' + source.name + ' can not move'
            else
                return actions.approach
        if source.weapon.range > 1
            arrow = source.quiver[source.arrow]
            broadhead = source.broadheads[source.broadhead]
            if source.weapon.range * arrow.range * broadhead.range * 1.2 >= distance
                return actions.attack
            else
                return actions.approach
    return null
takeAction = (source, target, action) ->
    switch action
        when actions.approach
            combatPos = Math.max(source.combatPos - source.movement, target.combatPos + 1)
            monster = create Object.assign {}, source, { combatPos: combatPos }

            log '> ' + source.name + ' approaching ' + target.name
            return [ monster, [], [] ]
        when actions.retreat
            combatPos = Math.min(source.combatPos + source.movement, 50)
            monster = create Object.assign {}, source, { combatPos: combatPos }

            log '> ' + source.name + ' retreating ' + target.name
            return [ monster, [], [] ]
        when actions.attack
            return attack source, target
        when actions.useSpell
            spell = source.weapon.spell
            spellAmp = if source.weapon.spellAmplification? then source.weapon.spellAmplification else 1
            getDamage = () ->
                return Weapon.getDamage(source, target)

            takeDamage = (damages, effects) ->
                damage.amount * spellAmp for damage in damages
                return [ damages, effects ]
            [ damages, effects ] = spell.use getDamage, takeDamage
            monster = create Object.assign {}, source, { mana: source.mana - source.weapon.spell.mana * source.weapon.manaAdjustment }

            log '> ' + monster.name + ' used ' + chalk.yellow(spell.name)
            return [ monster, damages, effects ]
        else
            log '> ' + source.name + ' passes turn'
            return [ source, [], [] ]
getAll = () -> return monsters
getDamageStr = (source) ->
    skillsBonus = Weapon.getSkillBonus source.skills, source.weapon.attackType
    masteryBonus = Weapon.getMasteryBonus source.masteries, source.weapon.type
    return '' + (source.weapon.min * masteryBonus * skillsBonus).toFixed(2) + ' - ' + (source.weapon.max * masteryBonus * skillsBonus).toFixed(2)
getArmourStr = (source) ->
    return source.armour.name + '\tamount: ' + source.armour.resistance # TODO fix this
showStats = (monster, inspectionLevel) ->
    log '> enemy type: ' + chalk.redBright monster.name
    switch inspectionLevel
        when 1 then log '> level: ' + monster.level
        when 2
            log '> level: ' + monster.level
            log '> hp: ' + ((monster.hp/monster.maxhp)*100).toFixed(2) + '%'
        when 3
            log '> level: ' + monster.level
            log '> hp: ' + monster.hp.toFixed(2) + '/' + monster.maxhp.toFixed(2)
        when 4
            log '> level: ' + monster.level
            log '> hp: ' + monster.hp.toFixed(2) + '/' + monster.maxhp.toFixed(2)
            log '> weapon: ' + monster.weapon.attackType
            log '> damage: ' + chalk.redBright getDamageStr(monster)
        when 5
            log '> level: ' + monster.level
            log '> hp: ' + monster.hp.toFixed(2) + '/' + monster.maxhp.toFixed(2)
            log '> movement: ' + monster.movement
            log '> weapon: ' + monster.weapon.attackType + ' range: ' + monster.weapon.range
            log '> damage: ' + chalk.redBright getDamageStr monster
            log '> armour: ' + getArmourStr monster
            if monster.skills.size > 0
                log '> skills: '
                for own key, skill of monster.skills
                    log '>\t' + skill.name + ' ' + skill.level
    return
adjust = (map, pos, changes...) ->
    # TODO mutates map
    monsterList = [ map.current.monsters... ]
    newArray = monsterList.filter (x) ->
        return x.position.x isnt pos.x or x.position.y isnt pos.y
    current = monsterList.filter (x) ->
        return x.position.x is pos.x and x.position.y is pos.y
    monster = create Object.assign {}, current[0], changes...
    map.current.monsters = [newArray..., monster]

    return monster

takeDamage = (monster, damages, effects) ->
    damage = damages.reduce (a, x) ->
        return a + x.amount
    , 0
    if damage <= 0
        return [ monster, true, 0, 0 ]

    if effects.has { effect: weaponStates.critical }
        log chalk.blueBright '> critical hit'
        damage.amount *= 2 for damage in damages

    # err 'taking damage:', damage.amount, 'of type', '[' + damage.type + ']' for damage in damages

    adjustedDamage = Armour.soakDamage monster.armour, damages
    # err 'real damage', adjustedDamage
    newMonster = Object.assign {}, monster, { hp: monster.hp - adjustedDamage, state: [ monster.state..., effects... ] }

    hp = 0
    mana = 0
    for state in effects
        switch state.effect
            when weaponStates.leeching
                hp += Math.min adjustedDamage * 0.1, monster.hp
            when weaponStates.manaLeeching
                mana += Math.min adjustedDamage * 0.1, monster.mana
            when weaponStates.lifeDrain
                hp += Math.min adjustedDamage, monster.hp
            when weaponStates.manaDrain
                mana += Math.min adjustedDamage, monster.mana

    inspector.display null, newMonster, adjustedDamage, hp, mana

    if newMonster.hp <= 0
        return [ create(newMonster), false, hp, mana ]

    return [ create(newMonster), true, hp, mana ]

remove = (map, pos) ->
    # TODO mutates map
    map.current.monsters = map.current.monsters.filter (x) ->
        return x.position.x isnt pos.x or x.position.y isnt pos.y

    return map

module.exports =
    adjust: adjust
    attack: attack
    create: create
    createFromTemplate: createFromTemplate
    dead: dead
    getAll: getAll
    getRandomType: getRandomType
    remove: remove
    showStats: showStats
    takeAction: takeAction
    takeDamage: takeDamage
