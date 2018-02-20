{ attackTypes, armourTypes, species, mapTypes, actions } = require '../constants'
{ err } = require '../general'

Weapons = require '../weapons/weapons.coffee'
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
        maxLevel: 40
        movement: 12
        weapon: Weapons.shortWand
        attack:
            max: 1.2
            min: 1
        spell: spells.soulArrow
        maxMana: 6
        armour:
            type: armourTypes.light
            amount: 10
        maxhp: 3
        gold: 5
        xp: 5
    genie:
        name: 'genie'
        land: [mapTypes.enchanted, mapTypes.tower, mapTypes.magical]
        species: [species.magical]
        minLevel: 10
        maxLevel: 100
        movement: 15
        weapon: Weapons.shortWand
        attack:
            max: 3
            min: 2
        spell: spells.iceShards
        maxMana: 10
        armour:
            type: armourTypes.light
            amount: 20
        maxhp: 4
        gold: 6
        xp: 6
    ghost:
        name: 'ghost'
        land: [mapTypes.tower, mapTypes.enchanted, mapTypes.magical, mapTypes.forest, mapTypes.crypt, mapTypes.dungeon]
        species: [species.undead]
        minLevel: 5
        maxLevel: 50
        movement: 12
        weapon: Weapons.shortWand
        attack:
            max: 1.6
            min: 1.4
        spell: spells.arcaneBolt
        maxMana: 12
        armour:
            type: armourTypes.light
            amount: 20
        maxhp: 3
        gold: 4
        xp: 5
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
        maxLevel: 30
        movement: 10
        weapon: Weapons.shortWand
        attack:
            max: 0.5
            min: 0.4
        spell: spells.arcaneTorrent
        maxMana: 8
        armour:
            type: armourTypes.light
            amount: 15
        maxhp: 2
        gold: 3
        xp: 4
    lich:
        name: 'lich'
        land: [ mapTypes.crypt, mapTypes.inferno, mapTypes.magical, mapTypes.tower, mapTypes.arctic, mapTypes.dungeon  ]
        species: [species.undead, species.magical]
        minLevel: 20
        maxLevel: 100
        movement: 6
        weapon: Weapons.shortWand
        attack:
            max: 4.0
            min: 2.5
        spell: spells.lifeDrain
        maxMana: 16
        armour:
            type: armourTypes.light
            amount: 40
        maxhp: 6
        gold: 10
        xp: 10
    skeletonMagi:
        name: 'skeleton magi'
        land: [mapTypes.magical, mapTypes.tower]
        species: [species.undead]
        minLevel: 5
        maxLevel: 50
        movement: 6
        weapon: Weapons.shortWand
        attack:
            max: 1.4
            min: 1
        spell: spells.fireArrow
        maxMana: 8
        armour:
            type: armourTypes.light
            amount: 10
        maxhp: 4
        gold: 4
        xp: 6
    succubus:
        name: 'succubus'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.inferno, mapTypes.tower, mapTypes.magical]
        species: [species.infernal]
        minLevel: 20
        maxLevel: 1000
        movement: 15
        weapon: Weapons.shortWand
        attack:
            max: 3
            min: 2
        spell: spells.fireBall
        maxMana: 20
        armour:
            type: armourTypes.medium
            amount: 80
        maxhp: 4
        gold: 12
        xp: 8
    wisp:
        name: 'wisp'
        land: [mapTypes.tower, mapTypes.enchanted, mapTypes.magical, mapTypes.forest, mapTypes.desert]
        species: [species.magical]
        minLevel: 0
        maxLevel: 20
        movement: 12
        weapon: Weapons.shortWand
        attack:
            max: 0.6
            min: 0.5
        spell: spells.soulArrow
        maxMana: 8
        armour:
            type: armourTypes.light
            amount: 5
        maxhp: 1.6
        gold: 2
        xp: 4
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
        minLevel: 10
        maxLevel: 1000
        movement: 6
        weapon: Weapons.shortWand
        attack:
            max: 2.2
            min: 1.6
        spell: spells.arcaneTorrent
        maxMana: 12
        armour:
            type: armourTypes.light
            amount: 50
        maxhp: 5
        gold: 6
        xp: 6
        getAction: (monster, hero) ->
            distance = Math.abs monster.combatPos - hero.combatPos
            if not hero.weapon.spell? and monster.combatPos < Math.min(40 + monster.movement, 50)
                return actions.retreat
            if monster.mana > monster.weapon.spell.mana
                return actions.useSpell
            return actions.approach

module.exports = (monster for own key, monster of monsters)
