{ attackTypes, armourTypes, species, mapTypes } = require '../constants'

Weapons = require '../weapons/weapons.coffee'
    .getAll()
skills = require '../skills/skills.coffee'
    .getNames()
Arrows = require '../weapons/arrows.coffee'
arrows = Arrows.getAll()
Broadheads = require '../weapons/broadheads.coffee'
broadheads = Broadheads.getAll()

monsters =
    centaurArcher:
        name: 'centaur archer'
        land: [mapTypes.forest, mapTypes.enchanted, mapTypes.swamp]
        species: [species.mythological]
        minLevel: 20
        maxLevel: 100
        movement: 20
        weapon: Weapons.shortBow
        quiver: [ Arrows.create arrows.heavy ]
        broadheads: [ Broadheads.create broadheads.heavy ]
        attack:
            max: 5
            min: 3
            range: 20
        armour:
            type: armourTypes.medium
            amount: 50
        maxhp: 5
        gold: 8
        xp: 8
    drowElf:
        name: 'drow elf'
        land: [mapTypes.forest, mapTypes.dungeon, mapTypes.swamp]
        species: [species.humanoid]
        minLevel: 25
        maxLevel: 100
        movement: 10
        weapon: Weapons.shortBow
        quiver: [ Arrows.create arrows.normal ]
        broadheads: [ Broadheads.create broadheads.poisoning ]
        attack:
            max: 6
            min: 3
            range: 35
        armour:
            type: armourTypes.medium
            amount: 50
        maxhp: 6
        gold: 8
        xp: 10
        skills: [{
            skill: skills.tactics
            level: 5
        }]
    dryad:
        name: 'dryad'
        land: [mapTypes.forest, mapTypes.enchanted]
        species: [species.magical, species.fairy]
        minLevel: 10
        maxLevel: 80
        movement: 15
        weapon: Weapons.shortBow
        quiver: [ Arrows.create arrows.normal ]
        broadheads: [ Broadheads.create broadheads.burning ]
        attack:
            max: 4
            min: 2
            range: 28
        armour:
            type: armourTypes.light
            amount: 20
        maxhp: 5
        gold: 6
        xp: 6
    elf:
        name: 'elf'
        land: [mapTypes.forest, mapTypes.enchanted]
        species: [species.humanoid]
        minLevel: 15
        maxLevel: 80
        movement: 10
        weapon: Weapons.shortBow
        quiver: [ Arrows.create arrows.normal ]
        broadheads: [ Broadheads.create broadheads.piercing ]
        attack:
            max: 4
            min: 3
            range: 32
        armour:
            type: armourTypes.medium
            amount: 40
        maxhp: 4
        gold: 5
        xp: 7
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
        weapon: Weapons.shortBow
        quiver: [ Arrows.create arrows.orcish ]
        broadheads: [ Broadheads.create broadheads.ice ]
        attack:
            max: 6
            min: 3
            range: 28
        armour:
            type: armourTypes.light
            amount: 25
        maxhp: 4
        gold: 6
        xp: 8
    kobold:
        name: 'kobold'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.inferno, mapTypes.desert]
        species: [species.greenskin]
        minLevel: 0
        maxLevel: 30
        movement: 8
        weapon: Weapons.shortBow
        quiver: [ Arrows.create arrows.orcish ]
        broadheads: [ Broadheads.create broadheads.burning ]
        attack:
            max: 2
            min: 1
            range: 30
        armour:
            type: armourTypes.light
            amount: 10
        maxhp: 3
        gold: 3
        xp: 3
    medusa:
        name: 'medusa'
        land: [mapTypes.dungeon, mapTypes.swamp]
        species: [species.mythological]
        minLevel: 10
        maxLevel: 50
        movement: 10
        weapon: Weapons.shortBow
        quiver: [ Arrows.create arrows.elven ]
        broadheads: [ Broadheads.create broadheads.poisoning ]
        attack:
            max: 6
            min: 3
            range: 20
        armour:
            type: armourTypes.medium
            amount: 35
        maxhp: 4
        gold: 6
        xp: 6
    salamander:
        name: 'salamander'
        land: [mapTypes.dungeon, mapTypes.swamp]
        species: [species.lizard]
        minLevel: 5
        maxLevel: 30
        movement: 10
        weapon: Weapons.shortBow
        quiver: [ Arrows.create arrows.normal ]
        broadheads: [ Broadheads.create broadheads.burning ]
        attack:
            max: 4
            min: 2
            range: 28
        armour:
            type: armourTypes.medium
            amount: 40
        maxhp: 5
        gold: 5
        xp: 5
    pixie:
        name: 'pixie'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.forest, mapTypes.desert, mapTypes.enchanted]
        species: [species.magical]
        minLevel: 0
        maxLevel: 30
        movement: 12
        weapon: Weapons.shortBow
        quiver: [ Arrows.create arrows.light ]
        broadheads: [ Broadheads.create broadheads.bleeding ]
        attack:
            max: 0.8
            min: 0.6
            range: 20
        armour:
            type: armourTypes.light
            amount: 10
        maxhp: 3
        gold: 4
        xp: 4
    siren:
        name: 'siren'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.desert, mapTypes.forest]
        species: [species.magical]
        minLevel: 20
        maxLevel: 100
        movement: 10
        weapon: Weapons.shortBow
        quiver: [ Arrows.create arrows.elven ]
        broadheads: [ Broadheads.create broadheads.vampiric ]
        attack:
            max: 6
            min: 4
            range: 28
        armour:
            type: armourTypes.medium
            amount: 60
        maxhp: 5
        gold: 10
        xp: 10
    skeletonArcher:
        name: 'skeleton archer'
        land: [mapTypes.dungeon, mapTypes.crypt, mapTypes.swamp]
        species: [species.undead]
        minLevel: 5
        maxLevel: 100
        movement: 6
        weapon: Weapons.shortBow
        quiver: [ Arrows.create arrows.normal ]
        broadheads: [ Broadheads.create broadheads.piercing ]
        attack:
            max: 2
            min: 1
            range: 20
        armour:
            type: armourTypes.medium
            amount: 30
        maxhp: 4
        gold: 5
        xp: 5

module.exports = (monster for own key, monster of monsters)
