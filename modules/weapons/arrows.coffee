{ log, err } = require '../constants'

arrows =
    normal:
        name: 'standard arrow'
        range: 1
        damage: 1
        description: 'Standard arrows.'
    elven:
        name: 'elven arrow'
        range: 1.25
        damage: 0.8
        description: '-20% damage, +25% range'
    orcish:
        name: 'orcish arrow'
        range: 0.8
        damage: 1.25
        decription: '+25% damage, -20% range'
    sniper:
        name: 'sniper arrow'
        range: 2
        damage: 0.5
        description: '-50% damage, +100% range'
    steel:
        name: 'steel arrow'
        range: 0.5
        damage: 2
        description: 'Heavy arrows with decreased range but greatly improved damage.'

module.exports = arrows
