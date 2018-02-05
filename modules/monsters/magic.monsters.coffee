{ attackTypes, armourTypes, species, mapTypes } = require '../constants'

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
        attack:
            attackType: attackTypes.magic
            max: 1.2
            min: 1
        spell: spells.soulArrow
        mana: 6
        armour:
            type: armourTypes.light
            melee:
                max: 10
                min: 0
            ranged:
                max: 10
                min: 0
            magic:
                max: 30
                min: 5
        maxhp: 3
        gold:
            min: 2
            max: 5
        xp:
            min: 2
            max: 5
    genie:
        name: 'genie'
        land: [mapTypes.enchanted, mapTypes.tower, mapTypes.magical]
        species: [species.magical]
        minLevel: 10
        maxLevel: 40
        movement: 15
        attack:
            attackType: attackTypes.magic
            max: 3
            min: 2
        spell: spells.iceShards
        mana: 10
        armour:
            type: armourTypes.light
            melee:
                max: 15
                min: 0
            ranged:
                max: 15
                min: 0
            magic:
                max: 40
                min: 20
        maxhp: 4
        gold:
            min: 4
            max: 6
        xp:
            min: 4
            max: 6
    imp:
        name: 'imp'
        land: [mapTypes.dungeon, mapTypes.inferno, mapTypes.magical, mapTypes.desert]
        species: [species.infernal, species.magical]
        minLevel: 0
        maxLevel: 20
        movement: 10
        attack:
            attackType: attackTypes.magic
            max: 0.5
            min: 0.4
        spell: spells.iceArrow
        mana: 8
        armour:
            type: armourTypes.light
            melee:
                max: 25
                min: 0
            ranged:
                max: 20
                min: 0
            magic:
                max: 25
                min: 10
        maxhp: 2
        gold:
            min: 1
            max: 4
        xp:
            min: 2
            max: 3
    skeletonMagi:
        name: 'skeleton magi'
        land: [mapTypes.magical, mapTypes.tower]
        species: [species.undead]
        minLevel: 5
        maxLevel: 50
        movement: 6
        attack:
            attackType: attackTypes.magic
            max: 1.4
            min: 1
        spell: spells.fireArrow
        mana: 8
        armour:
            type: armourTypes.light
            melee:
                max: 10
                min: 0
            ranged:
                max: 60
                min: 50
            magic:
                max: 20
                min: 0
        maxhp: 4
        gold:
            min: 2
            max: 4
        xp:
            min: 3
            max: 6
    succubus:
        name: 'succubus'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.inferno, mapTypes.tower, mapTypes.magical]
        species: [species.infernal]
        minLevel: 20
        maxLevel: 50
        movement: 15
        attack:
            attackType: attackTypes.magic
            max: 3
            min: 2
        spell: spells.fireBall
        mana: 20
        armour:
            type: armourTypes.medium
            melee:
                max: 45
                min: 0
            ranged:
                max: 45
                min: 0
            magic:
                max: 45
                min: 0
        maxhp: 4
        gold:
            min: 6
            max: 10
        xp:
            min: 4
            max: 6
    wisp:
        name: 'wisp'
        land: [mapTypes.tower, mapTypes.enchanted, mapTypes.magical]
        species: [species.magical]
        minLevel: 0
        maxLevel: 20
        movement: 12
        attack:
            attackType: attackTypes.magic
            max: 1
            min: 0.4
        spell: spells.soulArrow
        mana: 8
        armour:
            type: armourTypes.light
            melee:
                max: 10
                min: 0
            ranged:
                max: 10
                min: 0
            magic:
                max: 10
                min: 0
        maxhp: 1.6
        gold:
            min: 1
            max: 2
        xp:
            min: 2
            max: 3

module.exports = (monster for own key, monster of monsters)
