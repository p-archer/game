{ attackTypes, actions, heroStates, species, mapTypes, armourTypes, WEAPON_GAIN_FACTOR, XP_GAIN_FACTOR, HP_GAIN_FACTOR, MANA_GAIN_FACTOR, weaponStates } = require '../constants'
{ random, log, err, warn } = require '../general'

chalk = require 'chalk'
Weapon = require '../weapons/weapons.coffee'
Armour = require '../armours/armours.coffee'
inspector = require '../inspector.coffee'

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

    # mastery
    newMonster.mastery = Object.assign {}, monster.mastery

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
        arrow: monster.arrow
        broadhead: monster.broadhead
        broadheads: monster.broadheads
        combatPos: null
        gold: (monster.gold.min + random((monster.gold.max - monster.gold.min)*100)/100) * level
        hp: monster.maxhp * Math.pow(HP_GAIN_FACTOR, level)
        land: monster.land
        level: level
        mana: (monster.maxMana || 1) * Math.pow(MANA_GAIN_FACTOR, level)
        maxMana: (monster.maxMana || 1) * Math.pow(MANA_GAIN_FACTOR, level)
        maxhp: monster.maxhp * Math.pow(HP_GAIN_FACTOR, level)
        movement: monster.movement
        name: monster.name
        position: monster.position
        quiver: monster.quiver
        species: monster.species
        spell: monster.spell
        state: []
        xp: (monster.xp.min + random((monster.xp.max - monster.xp.min)*100)/100) * Math.pow(XP_GAIN_FACTOR, level)

    # mastery
    masteryLevel = level/2 + random level/2
    newMonster.mastery = {}
    newMonster.mastery =
        level: masteryLevel

    # TODO skills and skills bonus damage
    newMonster.skills = {}

    # create weapon
    weapons = Weapon.getAll()
    armours = Armour.getAll()
    options =
        min: monster.attack.min * Math.pow WEAPON_GAIN_FACTOR, masteryLevel
        max: monster.attack.max * Math.pow WEAPON_GAIN_FACTOR, masteryLevel
        range: monster.attack.range || 1
        spell: monster.spell
    switch monster.attack.attackType
        when attackTypes.melee then newMonster.weapon = Weapon.create Object.assign {}, weapons.shortSword, options
        when attackTypes.ranged then newMonster.weapon = Weapon.create Object.assign {}, weapons.shortBow, options
        when attackTypes.magic then newMonster.weapon = Weapon.create Object.assign {}, weapons.shortWand, options

    # create armour
    armourOptions =
        resistance:
            melee: monster.armour.melee.min + random(monster.armour.melee.max - monster.armour.melee.min)
            ranged: monster.armour.ranged.min + random(monster.armour.ranged.max - monster.armour.ranged.min)
            magic: monster.armour.magic.min + random(monster.armour.magic.max - monster.armour.magic.min)
    switch monster.armour.type
        when armourTypes.light then newMonster.armour = Armour.create Object.assign {}, armours.robe, armourOptions
        when armourTypes.medium then newMonster.armour = Armour.create Object.assign {}, armours.leather, armourOptions
        when armourTypes.heavy then newMonster.armour = Armour.create Object.assign {}, armours.breastPlate, armourOptions

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
    available = monsters.filter (x) ->
        return x.land.has(mapType) and x.minLevel <= level and x.maxLevel >= level
    return available[random available.length]
attack = (monster, hero) ->
    damage = Weapon.getDamage monster, hero
    effects = Weapon.getEffects monster
    # TODO deal with leeching
    # TODO deal with reflect

    return [ monster, damage, effects ]
getAction = (source, target) ->
    if source.state.filter((x) -> x.effect is heroStates.frozen).length > 0
        log chalk.blueBright '> ' + source.name + ' is frozen'
        return null

    distance = Math.abs source.combatPos - target.combatPos
    if distance is 1
        return actions.attack
    else
        switch source.weapon.attackType
            when attackTypes.magic
                if source.mana < source.weapon.spell.mana * source.weapon.manaAdjustment
                    return actions.approach
                else
                    return actions.useSpell
            when attackTypes.melee
                if source.state.has heroStates.maimed
                    log '> ' + source.name + ' can not move'
                else
                    return actions.approach
            when attackTypes.ranged
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
            return [ monster, 0, [] ]
        when actions.retreat
            combatPos = Math.min(source.combatPos + source.movement, 50)
            monster = create Object.assign {}, source, { combatPos: combatPos }

            log '> ' + source.name + ' retreating ' + target.name
            return [ monster, 0, [] ]
        when actions.attack
            return attack source, target
        when actions.useSpell
            spell = source.weapon.spell
            spellAmp = if source.weapon.attackType is attackTypes.magic and source.weapon.spellAmplification? then source.weapon.spellAmplification else 1
            getDamage = () -> [ Weapon.getDamage(source, target) * spellAmp, Weapon.getEffects(source) ]

            takeDamage = () ->
                all = []
                sum = 0
                return (damage, effects) ->
                    sum += damage
                    all = [ all..., effects... ]
                    return [ sum, all ]

            [ damage, effects ] = spell.use getDamage, takeDamage()
            monster = create Object.assign {}, source, { mana: source.mana - source.weapon.spell.mana * source.weapon.manaAdjustment }

            log '> ' + monster.name + ' used ' + chalk.yellow(spell.name)
            return [ monster, damage, effects ]
        else
            log '> ' + source.name + ' passes turn'
            return [ source, 0, [] ]
getAll = () -> return monsters
getDamageStr = (source) ->
    skillsBonus = Weapon.getSkillBonus source.skills, source.weapon.attackType
    masteryBonus = Weapon.getMasteryBonus source.mastery
    return '' + (source.weapon.min * masteryBonus * skillsBonus).toFixed(2) + ' - ' + (source.weapon.max * masteryBonus * skillsBonus).toFixed(2)
getArmourStr = (source) ->
    return source.armour.name + '\tresistances: ' + source.armour.resistance.melee + '/' + source.armour.resistance.ranged + '/' + source.armour.resistance.magic
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
            log '> armour: ' + chalk.yellow getArmourStr monster
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

takeDamage = (monster, attackType, damage, effects) ->
    if damage <= 0
        return [ monster, true, 0, 0 ]

    if effects.has { effect: weaponStates.critical }
        log chalk.blueBright '> critical hit'
        damage *= 2
    if effects.has { effect: weaponStates.piercing }
        log chalk.blueBright '> piercing hit'
        attackType = attackTypes.pure

    adjustedDamage = Armour.soakDamage monster.armour, damage, attackType
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
