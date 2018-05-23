{ attackTypes, species, mapTypes, speed } = require '../constants'

Weapons = require '../weapons/weapons.coffee'
    .getAll()
Armours = require '../armours/armours.coffee'
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
        movement: 8
        weapon: Weapons.huntingBow
        quiver: [ Arrows.create arrows.heavy ]
        broadheads: [ Broadheads.create broadheads.heavy ]
        attack:
            speed: speed.normal
            max: 5
            min: 3
            range: 20
        armour:
            type: Armours.leather
            resistance:
                physical: 20
                poison: -25
        maxhp: 5
        gold: 12
        xp: 7
    drowElf:
        name: 'drow elf'
        land: [mapTypes.forest, mapTypes.dungeon, mapTypes.swamp, mapTypes.inferno ]
        species: [species.humanoid]
        minLevel: 35
        maxLevel: 300
        movement: 6
        weapon: Weapons.blackBow
        quiver: [ Arrows.create arrows.normal ]
        broadheads: [ Broadheads.create broadheads.poisoning ]
        attack:
            speed: speed.fast
            max: 6
            min: 3
            range: 35
        armour:
            type: Armours.leather
            resistance:
                physical: 20
                poison: 50
        maxhp: 6
        gold: 16
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
        movement: 7
        weapon: Weapons.longBow
        quiver: [ Arrows.create arrows.normal ]
        broadheads: [ Broadheads.create broadheads.burning ]
        attack:
            speed: speed.fast
            max: 3.5
            min: 2
            range: 24
        armour:
            type: Armours.leather
            resistance:
                physical: 10
                fire: 25
                ice: -25
        maxhp: 5
        gold: 8
        xp: 6
    elf:
        name: 'elf'
        land: [mapTypes.forest, mapTypes.enchanted]
        species: [species.humanoid]
        minLevel: 15
        maxLevel: 80
        movement: 5
        weapon: Weapons.elvenBow
        quiver: [ Arrows.create arrows.normal ]
        broadheads: [ Broadheads.create broadheads.piercing ]
        attack:
            speed: speed.fast
            max: 4
            min: 3
            range: 32
        armour:
            type: Armours.leather
            resistance:
                physical: 20
                poison: 25
        maxhp: 4
        gold: 10
        xp: 6
        skills: [{
            skill: skills.tactics
            level: 2
        }]
    iceElemental:
        name: 'ice elemental'
        land: [mapTypes.arctic, mapTypes.tower, mapTypes.magical]
        species: [species.magical]
        minLevel: 30
        maxLevel: 100
        movement: 6
        weapon: Weapons.dwarvenBow
        quiver: [ Arrows.create arrows.orcish ]
        broadheads: [ Broadheads.create broadheads.ice ]
        attack:
            speed: speed.normal
            max: 5
            min: 3
            range: 28
        armour:
            type: Armours.skin
            resistance:
                physical: 15
                ice: 100
                fire: -50
        maxhp: 4
        gold: 2
        xp: 8
    kobold:
        name: 'kobold'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.inferno, mapTypes.desert]
        species: [species.greenskin]
        minLevel: 0
        maxLevel: 30
        movement: 5
        weapon: Weapons.shortBow
        quiver: [ Arrows.create arrows.orcish ]
        broadheads: [ Broadheads.create broadheads.burning ]
        attack:
            speed: speed.vfast
            max: 1
            min: 0.8
            range: 26
        armour:
            type: Armours.skin
            resistance:
                physical: 0
                ice: -20
                fire: 20
        maxhp: 3
        gold: 5
        xp: 2
    medusa:
        name: 'medusa'
        land: [mapTypes.dungeon, mapTypes.swamp]
        species: [species.mythological]
        minLevel: 10
        maxLevel: 50
        movement: 3
        weapon: Weapons.boneBow
        quiver: [ Arrows.create arrows.elven ]
        broadheads: [ Broadheads.create broadheads.poisoning ]
        attack:
            speed: speed.fast
            max: 4
            min: 2
            range: 20
        armour:
            type: Armours.skin
            resistance:
                physical: 15
                poison: 100
                fire: -20
                lightning: -20
                arcane: 20
        maxhp: 4
        gold: 12
        xp: 6
    salamander:
        name: 'salamander'
        land: [mapTypes.dungeon, mapTypes.swamp]
        species: [species.lizard]
        minLevel: 5
        maxLevel: 30
        movement: 5
        weapon: Weapons.fireSpit
        quiver: [ Arrows.create arrows.normal ]
        broadheads: [ Broadheads.create broadheads.burning ]
        attack:
            speed: speed.slow
            max: 4
            min: 3
            range: 28
        armour:
            type: Armours.scales
            resistance:
                physical: 15
                fire: 95
                ice: -40
                arcane: 20
                poison: 50
        maxhp: 5
        gold: 2
        xp: 6
    pixie:
        name: 'pixie'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.forest, mapTypes.desert, mapTypes.enchanted]
        species: [species.magical]
        minLevel: 0
        maxLevel: 50
        movement: 8
        weapon: Weapons.dart
        quiver: [ Arrows.create arrows.light ]
        broadheads: [ Broadheads.create broadheads.bleeding ]
        attack:
            speed: speed.fast
            max: 1.8
            min: 1.2
            range: 16
        armour:
            type: Armours.robe
            resistance:
                physical: 0
                fire: -20
        maxhp: 3
        gold: 6
        xp: 3
    siren:
        name: 'siren'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.desert, mapTypes.forest]
        species: [species.magical]
        minLevel: 20
        maxLevel: 100
        movement: 6
        weapon: Weapons.elvenBow
        quiver: [ Arrows.create arrows.elven ]
        broadheads: [ Broadheads.create broadheads.vampiric ]
        attack:
            speed: speed.normal
            max: 6
            min: 4
            range: 28
        armour:
            type: Armours.skin
            resistance:
                physical: 20
                fire: -20
                ice: 20
                lightning: 40
                dark: 20
                arcane: 20
        maxhp: 5
        gold: 14
        xp: 10
    skeletonArcher:
        name: 'skeleton archer'
        land: [mapTypes.dungeon, mapTypes.crypt, mapTypes.swamp]
        species: [species.undead]
        minLevel: 5
        maxLevel: 100
        movement: 4
        weapon: Weapons.boneBow
        quiver: [ Arrows.create arrows.normal ]
        broadheads: [ Broadheads.create broadheads.piercing ]
        attack:
            speed: speed.normal
            max: 5
            min: 3.4
            range: 20
        armour:
            type: Armours.leather
            resistance:
                physical: 5
                poison: 50
                fire: -20
                ice: 20
        maxhp: 4
        gold: 6
        xp: 4

module.exports = (monster for own key, monster of monsters)
