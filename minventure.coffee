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
		$('#loot').html(value)

	setEncounter: (value) ->
		@encounter = value
		$('#encounter').removeClass();
		$('#encounter').addClass(value.id)
		$('#description').html(value.name)

	setPlayerState: (value) ->

		@playerState = value

		for keyId,keyValue of playerStates
			$button = $('#' + keyId)
			$button.removeClass()
			if keyId == value.id
				$button.addClass("selected")
				$button.html(keyValue.kinetic)
			else
				$button.html(keyValue.potential)

class Encounter
	constructor:(@id,@name) ->
	setup: ->
	action: ->
	teardown: ->

class Location extends Encounter

class Monster extends Encounter
	constructor: ->
		super "monster", "Monster!"

class City extends Encounter
	constructor: ->
		super "city", "City!"

class Town extends Encounter
	constructor: ->
		super "town", "Town!"

class PlayerState
	constructor: (@id,@potential,@kinetic) ->
	setup: ->
	action: ->
	teardown: ->

class Moving extends PlayerState
	constructor: ->
		super "move", "Move!", "Moving!"

class Fighting extends PlayerState
	constructor: ->
		super "fight", "Fight!", "Fighting!"

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

encounters = 
	swamp: new Location "swamp", "Swamp!"
	prarie: new Location "prarie", "Prarie!"
	hills: new Location "hills", "Hills!"
	mountains: new Location "mountains", "Mountains!"
	desert: new Location "desert", "Desert!"
	coastline: new Location "coastline", "Coastline!"
	jungle: new Location "jungle", "Jungle!"
	ruins: new Location "ruins", "Ruins!"
	tundra: new Location "tundra", "Tundra!"
	forest: new Location "forest", "Forest!"
	savana: new Location "savana", "Savana!"
	town: new Town
	city: new City
	monster: new Monster

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
gameState.setEncounter encounters.swamp
gameState.setPlayerState playerStates.rest

setInterval = (delay, exp) ->
    window.setInterval exp, delay

setInterval 1000, ->
	gameState.playerState.action()

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


