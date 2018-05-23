{ attackTypes, armourTypes, species, mapTypes, actions, speed } = require '../constants'
{ err } = require '../general'

Weapons = require '../weapons/weapons.coffee'
    .getAll()
Armours = require '../armours/armours.coffee'
    .getAll()
skills = require '../skills/skills.coffee'
    .getNames()
spells = require '../abilities/abilities.coffee'
    .getSpells()

monsters =
    fairy:
        name: 'fairy'
        land: [mapTypes.forest, mapTypes.enchanted, mapTypes.magical]
        species: [species.fairy, species.magical]
        minLevel: 10
        maxLevel: 80
        movement: 6
        weapon: Weapons.wand
        attack:
            max: 1
            min: 0.8
            speed: speed.normal
        spell: spells.soulArrow
        maxMana: 6
        armour:
            type: Armours.robe
            resistance:
                physical: 0
                fire: 20
                dark: -20
        maxhp: 3
        gold: 8
        xp: 4
    genie:
        name: 'genie'
        land: [mapTypes.enchanted, mapTypes.tower, mapTypes.magical]
        species: [species.magical]
        minLevel: 20
        maxLevel: 100
        movement: 5
        weapon: Weapons.yewWand
        attack:
            max: 1.8
            min: 1.6
            speed: speed.normal
        spell: spells.iceShards
        maxMana: 12
        armour:
            type: Armours.robe
            resistance:
                physical: 5
                dark: -20
                fire: 25
                ice: 25
                lightning: 80
        maxhp: 4
        gold: 12
        xp: 6
    ghost:
        name: 'ghost'
        land: [mapTypes.tower, mapTypes.enchanted, mapTypes.magical, mapTypes.forest, mapTypes.crypt, mapTypes.dungeon]
        species: [species.undead]
        minLevel: 10
        maxLevel: 50
        movement: 12
        weapon: Weapons.tomeFragment
        attack:
            max: 0.5
            min: 0.3
            speed: speed.normal
        spell: spells.arcaneBolt
        maxMana: 12
        armour:
            type: Armours.robe
            resistance:
                physical: 100
                fire: 50
                ice: 50
                poison: 100
                arcane: -25
                lightning: -50
        maxhp: 3
        gold: 0
        xp: 8
        getAction: (monster, hero) ->
            distance = Math.abs monster.combatPos - hero.combatPos
            if not hero.weapon.spell? and monster.combatPos < Math.min(40 + monster.movement, 50)
                return actions.retreat
            if monster.mana > monster.weapon.spell.mana
                return actions.useSpell
            return actions.approach
    imp:
        name: 'imp'
        land: [mapTypes.dungeon, mapTypes.inferno, mapTypes.magical, mapTypes.desert]
        species: [species.infernal, species.magical]
        minLevel: 0
        maxLevel: 50
        movement: 10
        weapon: Weapons.shortWand
        attack:
            max: 0.8
            min: 0.6
            speed: speed.normal
        spell: spells.arcaneTorrent
        maxMana: 8
        armour:
            type: Armours.skin
            resistance:
                physical: 5
                arcane: 20
                lightning: -20
                fire: 25
                ice: -25
                dark: 50
        maxhp: 2
        gold: 6
        xp: 3
    lich:
        name: 'lich'
        land: [ mapTypes.crypt, mapTypes.inferno, mapTypes.magical, mapTypes.tower, mapTypes.arctic, mapTypes.dungeon  ]
        species: [species.undead, species.magical]
        minLevel: 40
        maxLevel: 1000
        movement: 6
        weapon: Weapons.grimoire
        attack:
            max: 0.6
            min: 0.4
            speed: speed.normal
        spell: spells.lifeDrain
        maxMana: 16
        armour:
            type: Armours.robe
            resistance:
                physical: 15
                arcane: 50
                dark: 95
                lightning: -25
                fire: 20
                ice: 50
                poison: 95
        maxhp: 6
        gold: 18
        xp: 10
    skeletonMagi:
        name: 'skeleton magi'
        land: [mapTypes.magical, mapTypes.tower]
        species: [species.undead]
        minLevel: 10
        maxLevel: 50
        movement: 6
        weapon: Weapons.tomeFragment
        attack:
            max: 0.5
            min: 0.3
            speed: speed.normal
        spell: spells.fireArrow
        maxMana: 8
        armour:
            type: Armours.leather
            resistance:
                physical: 10
                poison: 80
                fire: -20
                ice: -20
                dark: 50
                arcane: 25
                lightning: -20
        maxhp: 4
        gold: 10
        xp: 5
    succubus:
        name: 'succubus'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.inferno, mapTypes.tower, mapTypes.magical]
        species: [species.infernal]
        minLevel: 30
        maxLevel: 1000
        movement: 15
        weapon: Weapons.tome
        attack:
            max: 0.6
            min: 0.4
            speed: speed.slow
        spell: spells.fireBall
        maxMana: 20
        armour:
            type: Armours.robe
            resistance:
                physical: 30
                lightning: -20
                poison: 50
                fire: 50
                ice: -25
                arcane: 25
        maxhp: 4
        gold: 20
        xp: 7
    wisp:
        name: 'wisp'
        land: [mapTypes.tower, mapTypes.enchanted, mapTypes.magical, mapTypes.forest, mapTypes.desert]
        species: [species.magical]
        minLevel: 0
        maxLevel: 40
        movement: 12
        weapon: Weapons.iceWand
        attack:
            max: 1.0
            min: 0.8
            speed: speed.normal
        spell: spells.soulArrow
        maxMana: 8
        armour:
            type: Armours.robe
            resistance:
                physical: 0
                fire: -20
                lightning: -20
                ice: 25
        maxhp: 1.6
        gold: 4
        xp: 2
        getAction: (monster, hero) ->
            distance = Math.abs monster.combatPos - hero.combatPos
            if not hero.weapon.spell? and monster.combatPos < Math.min(40 + monster.movement, 50)
                return actions.retreat
            if monster.mana > monster.weapon.spell.mana
                return actions.useSpell
            return actions.approach
    wraith:
        name: 'wraith'
        land: [mapTypes.tower, mapTypes.enchanted, mapTypes.magical, mapTypes.forest, mapTypes.crypt, mapTypes.dungeon]
        species: [species.undead]
        minLevel: 20
        maxLevel: 1000
        movement: 6
        weapon: Weapons.boneWand
        attack:
            max: 1.4
            min: 1.2
            speed: speed.normal
        spell: spells.arcaneTorrent
        maxMana: 12
        armour:
            type: Armours.robe
            resistance:
                physical: 100
                fire: 50
                ice: 50
                poison: 100
                arcane: -25
                lightning: -50
        maxhp: 5
        gold: 0
        xp: 12
        getAction: (monster, hero) ->
            distance = Math.abs monster.combatPos - hero.combatPos
            if not hero.weapon.spell? and monster.combatPos < Math.min(40 + monster.movement, 50)
                return actions.retreat
            if monster.mana > monster.weapon.spell.mana
                return actions.useSpell
            return actions.approach

module.exports = (monster for own key, monster of monsters)
