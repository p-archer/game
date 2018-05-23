{ attackTypes, species, mapTypes, speed } = require '../constants'

skills = require '../skills/skills.coffee'
    .getNames()
Weapons = require '../weapons/weapons.coffee'
    .getAll()
Armours = require '../armours/armours.coffee'
    .getAll()

monsters =
    bear:
        name: 'bear'
        land: [mapTypes.forest, mapTypes.arctic]
        species: [species.beast]
        minLevel: 20
        maxLevel: 80
        movement: 8
        weapon: Weapons.claws
        attack:
            speed: speed.slow
            max: 5
            min: 2.5
        armour:
            type: Armours.fur
            resistance:
                physical: 0
                fire: -20
                ice: 50
        maxhp: 10
        gold: 2
        xp: 8
    centaurLancer:
        name: 'centaur lancer'
        land: [mapTypes.forest, mapTypes.enchanted, mapTypes.swamp]
        species: [species.mythological]
        minLevel: 10
        maxLevel: 50
        movement: 10
        weapon: Weapons.shortSword
        attack:
            speed: speed.normal
            max: 4
            min: 2
        armour:
            type: Armours.leather
            resistance:
                physical: 15
                lightning: -20
                poison: 15
        maxhp: 5
        gold: 10
        xp: 7
    demon:
        name: 'demon'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.arctic, mapTypes.crypt, mapTypes.desert, mapTypes.enchanted, mapTypes.forest, mapTypes.inferno, mapTypes.magical, mapTypes.tower]
        species: [species.infernal]
        minLevel: 50
        maxLevel: 1000
        movement: 8
        weapon: Weapons.orcishSword
        attack:
            speed: speed.fast
            max: 10
            min: 5
        armour:
            type: Armours.leather
            resistance:
                physical: 50
                lightning: -25
                dark: 50
                fire: 50
                ice: 50
                poison: 50
                arcane: 75
        maxhp: 8
        gold: 12
        xp: 12
    direWolf:
        name: 'dire wolf'
        land: [mapTypes.forest, mapTypes.arctic]
        species: [species.beast]
        minLevel: 15
        maxLevel: 65
        movement: 8
        weapon: Weapons.fangs
        attack:
            speed: speed.fast
            max: 4
            min: 3
        armour:
            type: Armours.fur
            resistance:
                physical: 5
                fire: -25
                ice: 50
        maxhp: 6
        gold: 2
        xp: 8
    fireElemental:
        name: 'fire elemental'
        land: [mapTypes.inferno, mapTypes.tower, mapTypes.magical]
        species: [species.magical]
        minLevel: 10
        maxLevel: 100
        movement: 5
        weapon: Weapons.fists
        attack:
            speed: speed.normal
            max: 5
            min: 3
        armour:
            type: Armours.scales
            resistance:
                physical: 10
                ice: -50
                fire: 100
        maxhp: 5
        gold: 2
        xp: 7
    fox:
        name: 'fox'
        land: [mapTypes.forest, mapTypes.swamp, mapTypes.enchanted]
        species: [species.beast]
        minLevel: 0
        maxLevel: 40
        movement: 8
        weapon: Weapons.fangs
        attack:
            max: 1.0
            min: 0.6
            speed: speed.vfast
        armour:
            type: Armours.fur
            resistance:
                physical: 0
                fire: -20
                ice: 20
        maxhp: 3
        gold: 1
        xp: 3
    giant:
        name: 'giant'
        land: [mapTypes.arctic, mapTypes.enchanted, mapTypes.desert]
        species: [species.giant]
        minLevel: 20
        maxLevel: 100
        movement: 4
        weapon: Weapons.shortSword # TODO hammer
        attack:
            speed: speed.vslow
            max: 10
            min: 8
        armour:
            type: Armours.leather
            resistance:
                physical: 20
                poison: 20
                arcane: 20
                dark: 20
                ice: 25
        maxhp: 13
        gold: 10
        xp: 10
    goblin:
        name: 'goblin'
        land: [mapTypes.dungeon, mapTypes.inferno]
        species: [species.infernal]
        minLevel: 0
        maxLevel: 40
        movement: 5
        weapon: Weapons.scimitar
        attack:
            speed: speed.fast
            max: 1
            min: 1
        armour:
            type: Armours.skin
            resistance:
                physical: 5
                lightning: -25
                ice: -20
                fire: 20
                poison: 25
        maxhp: 3
        gold: 5
        xp: 2
    highwayman:
        name: 'highwayman'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.forest]
        species: [species.humanoid]
        minLevel: 10
        maxLevel: 60
        movement: 5
        weapon: Weapons.scimitar
        attack:
            speed: speed.fast
            max: 3
            min: 1.5
        armour:
            type: Armours.leather
            resistance:
                physical: 20
                fire: -15
                poison: 15
                lightning: -15
        maxhp: 5
        gold: 10
        xp: 6
    jackal:
        name: 'jackal'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.desert]
        species: [species.mythological, species.beast]
        minLevel: 5
        maxLevel: 80
        movement: 8
        weapon: Weapons.fangs
        attack:
            speed: speed.vfast
            max: 2
            min: 1
        armour:
            type: Armours.fur
            resistance:
                physical: 0
                fire: -25
                poison: -10
        maxhp: 4
        gold: 2
        xp: 4
    orc:
        name: 'orc'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.arctic]
        species: [species.greenskin]
        minLevel: 20
        maxLevel: 100
        movement: 4
        weapon: Weapons.orcishSword
        attack:
            speed: speed.slow
            max: 8
            min: 4
        armour:
            type: Armours.breastPlate
            resistance:
                physical: 40
                lightning: -25
                ice: 20
                fire: 20
                arcane: 50
                poison: 30
                dark: 25
        maxhp: 6
        gold: 10
        xp: 8
    orcWarrior:
        name: 'orc warrior'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.arctic]
        species: [species.greenskin]
        minLevel: 30
        maxLevel: 100
        movement: 3
        weapon: Weapons.orcishSword
        attack:
            speed: speed.slow
            max: 8
            min: 6
        armour:
            type: Armours.breastPlate
            resistance:
                physical: 45
                lightning: -25
                ice: 25
                fire: 25
                arcane: 70
                poison: 25
                dark: 35
        maxhp: 8
        gold: 14
        xp: 10
    orcChieftain:
        name: 'orc chieftain'
        land: [mapTypes.dungeon, mapTypes.swamp, mapTypes.arctic]
        species: [species.greenskin]
        minLevel: 50
        maxLevel: 1000
        movement: 3
        weapon: Weapons.orcishSword
        attack:
            speed: speed.slow
            max: 14
            min: 12
        armour:
            type: Armours.breastPlate
            resistance:
                physical: 50
                ice: 50
                fire: 50
                dark: 75
                arcane: 80
                lightning: -10
                poison: 70
        maxhp: 10
        gold: 20
        xp: 14
    skeletonKnight:
        name: 'skeleton knight'
        land: [mapTypes.dungeon, mapTypes.crypt]
        species: [species.undead]
        minLevel: 10
        maxLevel: 100
        movement: 4
        weapon: Weapons.broadSword
        attack:
            speed: speed.normal
            max: 5
            min: 2
        armour:
            type: Armours.breastPlate
            resistance:
                physical: 30
                fire: 15
                ice: 15
                lightning: -20
                dark: 25
                arcane: 10
                poison: 100
        maxhp: 7
        gold: 10
        xp: 6
    skeletonWarrior:
        name: 'skeleton warrior'
        land: [mapTypes.dungeon, mapTypes.crypt, mapTypes.tower]
        species: [species.undead]
        minLevel: 0
        maxLevel: 100
        movement: 5
        weapon: Weapons.broadSword
        attack:
            speed: speed.normal
            max: 3
            min: 1.4
        armour:
            type: Armours.leather
            resistance:
                physical: 10
                poison: 80
                lightning: -25
        maxhp: 5
        gold: 6
        xp: 3
    spider:
        name: 'spider'
        land: [mapTypes.forest, mapTypes.dungeon, mapTypes.crypt]
        species: [species.beast]
        minLevel: 0
        maxLevel: 40
        movement: 6
        weapon: Weapons.fangs
        attack:
            speed: speed.fast
            max: 1
            min: 1
        armour:
            type: Armours.skin
            resistance:
                physical: 0
                fire: -25
                ice: 25
        maxhp: 3
        gold: 0
        xp: 1.6
    troll:
        name: 'troll'
        land: [mapTypes.forest, mapTypes.dungeon, mapTypes.swamp]
        species: [species.greenskin]
        minLevel: 10
        maxLevel: 100
        movement: 5
        weapon: Weapons.fists
        attack:
            speed: speed.normal
            max: 5
            min: 3
        armour:
            type: Armours.skin
            resistance:
                physical: 15
                fire: -25
                ice: 25
                poison: 25
        maxhp: 8
        gold: 10
        xp: 8
    trollWarlord:
        name: 'troll warlord'
        land: [mapTypes.forest, mapTypes.dungeon, mapTypes.swamp]
        species: [species.greenskin]
        minLevel: 30
        maxLevel: 1000
        movement: 4
        weapon: Weapons.broadSword
        attack:
            speed: speed.slow
            max: 10
            min: 6
        armour:
            type: Armours.leather
            resistance:
                physical: 25
                fire: -25
                ice: 25
                poison: 50
                lightning: -10
                dark: 20
                arcane: 20
        maxhp: 8
        gold: 15
        xp: 12
    wolf:
        name: 'wolf'
        land: [mapTypes.forest, mapTypes.arctic]
        species: [species.beast]
        minLevel: 0
        maxLevel: 50
        movement: 8
        weapon: Weapons.fangs
        attack:
            speed: speed.fast
            max: 2.2
            min: 1.8
        armour:
            type: Armours.fur
            resistance:
                physical: 5
                fire: -25
                ice: 25
        maxhp: 5
        gold: 1
        xp: 5
    wolverine:
        name: 'wolverine'
        land: [mapTypes.forest, mapTypes.arctic]
        species: [species.beast]
        minLevel: 0
        maxLevel: 30
        movement: 8
        weapon: Weapons.fangs
        attack:
            speed: speed.vfast
            max: 1
            min: 1
        armour:
            type: Armours.fur
            resistance:
                physical: 5
                fire: -25
                ice: 25
        maxhp: 3
        gold: 0
        xp: 3
    zombie:
        name: 'zombie'
        land: [mapTypes.dungeon, mapTypes.crypt]
        species: [species.undead]
        minLevel: 5
        maxLevel: 60
        movement: 2
        weapon: Weapons.fists
        attack:
            speed: speed.vslow
            max: 2
            min: 1
        armour:
            type: Armours.skin
            resistance:
                physical: 10
                poison: 100
                fire: -25
                ice: 25
        maxhp: 10
        gold: 2
        xp: 7

module.exports = (monster for own key, monster of monsters)
