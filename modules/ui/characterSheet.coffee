{ log, err } = require '../general'
{ directions, states, MAX_SKILL_LEVEL } = require '../constants'
Hero = require '../hero.coffee'

outputter = (state, hero, map) ->
    console.clear()
    Hero.showStats hero, state.state
    log()
    log '1\t\tweapon'
    log '2\t\tarmour'
    log '3\t\tmasteries'
    log '4\t\tskills'
    log '5\t\tabilities'
    log()
    log 'q\t\tback'
    return

mutator = (state, input, hero, map) ->
    switch input
        when '1' then return [ true, { state: states.characterSheet.weapons }, hero, map ]
        when '2' then return [ true, { state: states.characterSheet.armour }, hero, map ]
        when '3' then return [ true, { state: states.characterSheet.masteries }, hero, map ]
        when '4' then return [ true, { state: states.characterSheet.skills }, hero, map ]
        when '5' then return [ true, { state: states.characterSheet.abilities }, hero, map ]

    return [ false, state, hero, map ]

submenuOutputter = (state, hero, map) ->
    Hero.showStats hero, state.state
    log()
    log 'q\t\tback'
    return

skillsOutputter = (state, hero, map) ->
    if not state.param? then return submenuOutputter state, hero, map

    skillKey = state.param
    skill = hero.skills[skillKey]
    log ' --- ' + skill.name + ' --- '
    log skill.description
    log 'current level: ' + skill.level + '/' + MAX_SKILL_LEVEL
    log()
    log 'e\t\tupgrade skill (skillpoints left: ' + hero.skillPoints  + ')'
    log 'q\t\tback'

    return

skillsMutator = (state, input, hero, map) ->
    if not state.param?
        skills = hero.skills.keys
        num = parseInt(input, 16)-1
        if not isNaN(num) and num < skills.length
            return [ true, { state: state.state, param: skills[num] }, hero, map ]
    else
        if input is 'e' then return [ true, state, Hero.upgradeSkill(hero, state.param), map ]
    return [ false, state, hero, map ]

register = (processors, outputProcessors) ->
    return [
        [
            processors...
            { state: states.characterSheet.main, fn: mutator }
            { state: states.characterSheet.skills, fn: skillsMutator }
        ]
        [
            outputProcessors...
            { state: states.characterSheet.main, fn: outputter}
            { state: states.characterSheet.weapons, fn: submenuOutputter}
            { state: states.characterSheet.armour, fn: submenuOutputter}
            { state: states.characterSheet.masteries, fn: submenuOutputter}
            { state: states.characterSheet.skills, fn: skillsOutputter}
            { state: states.characterSheet.abilities, fn: submenuOutputter}
        ]
    ]

module.exports =
    register: register
