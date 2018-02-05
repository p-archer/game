{ attackTypes, armourTypes, species, mapTypes } = require '../constants'

skills = require '../skills/skills.coffee'
    .getNames()
arrows = require '../weapons/arrows.coffee'
broadheads = require '../weapons/broadheads.coffee'

monsters =
    centaurArcher:
        name: 'centaur archer'
        land: [mapTypes.forest, mapTypes.enchanted, mapTypes.swamp]
        species: [species.mythological]
        minLevel: 20
        maxLevel: 50
        movement: 20
        arrow: arrows.normal
        broadhead: broadheads.normal
        attack:
            attackType: attackTypes.ranged
            max: 5
            min: 3
            range: 15
        armour:
            type: armourTypes.medium
            melee:
                max: 30
                min: 10
            ranged:
                max: 25
                min: 5
            magic:
                max: 0
                min: 0
        maxhp: 5
        gold:
            min: 3
            max: 7
        xp:
            min: 5
            max: 8
    drowElf:
        name: 'drow elf'
        land: [mapTypes.forest, mapTypes.dungeon, mapTypes.swamp]
        species: [species.humanoid]
        minLevel: 25
        maxLevel: 55
        movement: 10
        arrow: arrows.normal
        broadhead: broadheads.poisoning
        attack:
            attackType: attackTypes.ranged
            max: 6
            min: 3
            range: 35
        armour:
            type: armourTypes.medium
            melee:
                max: 45
                min: 20
            ranged:
                max: 40
                min: 10
            magic:
                max: 30
                min: 10
        maxhp: 6
        gold:
            min: 6
            max: 7
        xp:
            min: 7
            max: 10
        skills: [{
            skill: skills.tactics
            level: 5
        }]
    dryad:
        name: 'dryad'
        land: [mapTypes.forest, mapTypes.enchanted]
        species: [species.magical, species.fairy]
        minLevel: 10
        maxLevel: 40
        movement: 15
        arrow: arrows.normal
        broadhead: broadheads.burning
        attack:
            attackType: attackTypes.ranged
            max: 4
            min: 2
            range: 20
        armour:
            type: armourTypes.light
            melee:
                max: 10
                min: 0
            ranged:
                max: 20
                min: 0
            magic:
                max: 20
                min: 5
        maxhp: 5
        gold:
            min: 3
            max: 6
        xp:
            min: 4
            max: 6
    elf:
        name: 'elf'
        land: [mapTypes.forest, mapTypes.enchanted]
        species: [species.humanoid]
        minLevel: 15
        maxLevel: 50
        movement: 10
        arrow: arrows.normal
        broadhead: broadheads.piercing
        attack:
            attackType: attackTypes.ranged
            max: 4
            min: 3
            range: 32
        armour:
            type: armourTypes.medium
            melee:
                max: 35
                min: 20
            ranged:
                max: 20
                min: 10
            magic:
                max: 20
                min: 10
        maxhp: 4
        gold:
            min: 2
            max: 5
        xp:
            min: 4
            max: 7
        skills: [{
            skill: skills.tactics
            level: 2
        }]
    iceElemental:
        name: 'ice elemental'
        land: [mapTypes.arctic, mapTypes.tower, mapTypes.magical]
        species: [species.magical]
        minLevel: 10
        maxLevel: 100
        movement: 8
        arrow: arrows.orcish
        broadhead: broadheads.freezing
        attack:
            attackType: attackTypes.ranged
            max: 6
            min: 3
            range: 25
        armour:
            type: armourTypes.light
            melee:
                max: 35
                min: 20
            ranged:
                max: 35
                min: 20
            magic:
                max: 50
                min: 20
        maxhp: 4
        gold:
            min: 4
            max: 6
        xp:
            min: 6
            max: 8
    kobold:
        name: 'kobold'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.inferno, mapTypes.desert]
        species: [species.greenskin]
        minLevel: 0
        maxLevel: 20
        movement: 8
        arrow: arrows.orcish
        broadhead: broadheads.burning
        attack:
            attackType: attackTypes.ranged
            max: 2
            min: 1
            range: 15
        armour:
            type: armourTypes.light
            melee:
                max: 15
                min: 0
            ranged:
                max: 15
                min: 0
            magic:
                max: 15
                min: 0
        maxhp: 3
        gold:
            min: 1
            max: 3
        xp:
            min: 1
            max: 3
    medusa:
        name: 'medusa'
        land: [mapTypes.dungeon, mapTypes.swamp]
        species: [species.mythological]
        minLevel: 10
        maxLevel: 50
        movement: 10
        arrow: arrows.elven
        broadhead: broadheads.poisoning
        attack:
            attackType: attackTypes.ranged
            max: 6
            min: 3
            range: 10
        armour:
            type: armourTypes.medium
            melee:
                max: 25
                min: 10
            ranged:
                max: 30
                min: 10
            magic:
                max: 20
                min: 10
        maxhp: 4
        gold:
            min: 3
            max: 6
        xp:
            min: 4
            max: 8
    salamander:
        name: 'salamander'
        land: [mapTypes.dungeon, mapTypes.swamp]
        species: [species.lizard]
        minLevel: 5
        maxLevel: 30
        movement: 10
        arrow: arrows.normal
        broadhead: broadheads.burning
        attack:
            attackType: attackTypes.ranged
            max: 4
            min: 2
            range: 15
        armour:
            type: armourTypes.medium
            melee:
                max: 20
                min: 10
            ranged:
                max: 20
                min: 10
            magic:
                max: 20
                min: 10
        maxhp: 5
        gold:
            min: 3
            max: 5
        xp:
            min: 2
            max: 5
    skeletonArcher:
        name: 'skeleton archer'
        land: [mapTypes.dungeon, mapTypes.crypt, mapTypes.swamp]
        species: [species.undead]
        minLevel: 5
        maxLevel: 50
        movement: 6
        arrow: arrows.normal
        broadhead: broadheads.piercing
        attack:
            attackType: attackTypes.ranged
            max: 2
            min: 1
            range: 15
        armour:
            type: armourTypes.medium
            melee:
                max: 20
                min: 0
            ranged:
                max: 60
                min: 50
            magic:
                max: 10
                min: 0
        maxhp: 4
        gold:
            min: 1
            max: 4
        xp:
            min: 2
            max: 5

module.exports = (monster for own key, monster of monsters)
