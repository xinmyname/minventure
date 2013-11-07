class GameState
	time: 0
	health: 0
	maxHealth: 0
	level: 0
	experience: 0
	money: 0
	loot: 0
	buy: 0
	sell: 0
	limit: 0
	encounter: null
	playerState: null

	setHealth: (value) ->
		@health = value
		$('#health').html(value)

	setLevel: (value) ->
		@level = value
		$('#level').html(value)
		@maxHealth = Math.round(173.5*Math.exp(0.0339*value)-147)
		$('#maxHealth').html(@maxHealth)

	setExperience: (value) ->
		@experience = value
		$('#experience').html(value)

	setMoney: (value) ->
		@money = value
		$('#money').html(value)

	setLoot: (value) ->
		@loot = value

	setLimit: (value) ->
		@limit = value
		$('#limit').html(value)

	setEncounter: (value) ->
		@encounter?.teardown()
		@encounter = value
		@encounter.setup()

	setPlayerState: (value) ->
		@playerState?.teardown()
		@playerState = value
		@playerState.setup()

gameOver = ->
	console.log "GAME OVER!"

class Encounter
	constructor:(@id,@name,@minLimit,@maxLimit) ->

	setup: ->
		$('#encounter').removeClass();
		$('#encounter').addClass(@id)
		$('#description').html(@name)

	action: ->

	teardown: ->

	getMinLimit: ->
		@minLimit

	getMaxLimit: ->
		@maxLimit

	nextLimit: ->
		delta = @getMaxLimit() - @getMinLimit()
		Math.floor(Math.random()*delta) + @getMinLimit()

class Location extends Encounter
	setup: ->
		super
		gameState.setLimit @nextLimit()

class Monster extends Encounter
	constructor: ->
		super "monster", "Monster!", 0, 0

	setup: ->
		super
		gameState.setLimit @nextLimit()

	action: ->
		damage = 1
		newHealth = gameState.health - damage

		if newHealth <= 0
			gameOver()
		else
			gameState.setHealth newHealth

	getMinLimit: ->
		42

	getMaxLimit: ->
		42

class City extends Encounter
	constructor: ->
		super "city", "City!", 4, 6

class Town extends Encounter
	constructor: ->
		super "town", "Town!", 2, 4

moveToNextEncounter = ->
	next = Math.random()

	for ec in encounterChance
		if next >= ec.value
			nextId = ec.id
		else
			break

	nextEncounter = encounters[nextId]

	gameState.setEncounter nextEncounter

class PlayerState
	constructor: (@id,@potential,@kinetic) ->

	action: ->

	setup: ->
		$button = $('#' + @id)
		$button.addClass("selected")
		$button.html(@kinetic)

	teardown: ->
		$button = $('#' + @id)
		$button.removeClass()
		$button.html(@potential)

class Moving extends PlayerState
	constructor: ->
		super "move", "Move!", "Moving!"

	action: ->
		if gameState.encounter instanceof Monster
			if (Math.random < 0.10)
				moveToNextEncounter()
		else if gameState.limit == 1
			moveToNextEncounter()
		else
			gameState.setLimit gameState.limit-1

class Fighting extends PlayerState
	constructor: ->
		super "fight", "Fight!", "Fighting!"

	action: ->
		if gameState.encounter instanceof Monster
			damage = 10
			newLimit = gameState.limit - damage

			if newLimit <= 0
				@monsterDefeated()
			else
				gameState.setLimit newLimit

	monsterDefeated: ->
		moveToNextEncounter()

class Buying extends PlayerState
	constructor: ->
		super "buy", "Buy!", "Buying!"

class Selling extends PlayerState
	constructor: ->
		super "sell", "Sell!", "Selling!"

class Resting extends PlayerState
	constructor: ->
		super "rest", "Rest!", "Resting!"

	action: ->
		if (gameState.health < gameState.maxHealth)
			expMultiplier = 1
			lootMultiplier = 1
			addHealth = expMultiplier * lootMultiplier
			newHealth = gameState.health + addHealth
			if (newHealth > gameState.maxHealth)
				newHealth = gameState.maxHealth
			gameState.setHealth newHealth

class EncounterChance
	constructor:(@encounter,@chance) ->

encounters = 
	swamp: new Location "swamp", "Swamp!", 2, 8
	prarie: new Location "prarie", "Prarie!", 2, 7
	hills: new Location "hills", "Hills!", 2, 8
	mountains: new Location "mountains", "Mountains!", 2, 5
	desert: new Location "desert", "Desert!", 2, 8
	coastline: new Location "coastline", "Coastline!", 2, 5
	jungle: new Location "jungle", "Jungle!", 2, 8
	ruins: new Location "ruins", "Ruins!", 2, 4
	tundra: new Location "tundra", "Tundra!", 2, 6
	forest: new Location "forest", "Forest!", 2, 8
	savana: new Location "savana", "Savana!", 2, 8
	town: new Town
	city: new City
	monster: new Monster

encounterChance=[
	{value:0.00, id:"ruins"},
	{value:0.05, id:"city"},
	{value:0.10, id:"town"},
	{value:0.20, id:"swamp"},
	{value:0.25, id:"savana"},
	{value:0.30, id:"desert"},
	{value:0.35, id:"jungle"},
	{value:0.40, id:"forest"},
	{value:0.60, id:"hills"},
	{value:0.70, id:"prarie"},
	{value:0.75, id:"mountains"},
	{value:0.80, id:"tundra"},
	{value:0.85, id:"coastline"},
	{value:0.9, id:"monster"}
]

playerStates =
	move: new Moving 
	fight: new Fighting 
	buy: new Buying 
	sell: new Selling 
	rest: new Resting 

gameState = new GameState

gameState.setLevel 1
gameState.setHealth 25
gameState.setExperience 0
gameState.setMoney 0
gameState.setLoot 0
gameState.setEncounter encounters.forest
gameState.setPlayerState playerStates.rest

timerId = 0

setInterval = (delay, exp) ->
    timerId = window.setInterval exp, delay

setInterval 1000, ->
	gameState.playerState.action()
	gameState.encounter.action()

$('#move').click ->
	gameState.setPlayerState playerStates.move

$('#fight').click ->
	gameState.setPlayerState playerStates.fight

$('#buy').click ->
	gameState.setPlayerState playerStates.buy

$('#sell').click ->
	gameState.setPlayerState playerStates.sell

$('#rest').click ->
	gameState.setPlayerState playerStates.rest

$(document.documentElement).keypress (e) ->
	if e.keyCode == 109 # m
		gameState.setEncounter encounters.monster
	if e.keyCode == 108 # l
		gameState.setEncounter encounters.prarie

# Hero's Journey
# 1. Call to Adventure
# 2. Refusal of the Call
# 3. Meeting the Mentor
# 4. Crossing the Threshold
# 5. Road Of Trials
# 6. Meeting Of The Goddess
# 7. Atonement With The Father
# 8. Apotheosis
# 9. The Return




