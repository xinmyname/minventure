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

	setMaxHealth: (value) ->
		@maxHealth = value
		$('#maxHealth').html(value)

	setLevel: (value) ->
		@level = value
		$('#level').html(value)

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

class City extends Encounter

class Town extends Encounter

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

encounters = 
	swamp: new Location "swamp", "Swamp!"
	prarie: new Location "prarie", "Prarie!"

playerStates =
	move: new Moving 
	fight: new Fighting 
	buy: new Buying 
	sell: new Selling 
	rest: new Resting 

gameState = new GameState

gameState.setHealth 25
gameState.setMaxHealth 25
gameState.setLevel 1
gameState.setExperience 0
gameState.setMoney 0
gameState.setLoot 0
gameState.setEncounter encounters.swamp
gameState.setPlayerState playerStates.rest

setInterval = (delay, exp) ->
    window.setInterval exp, delay

setInterval 1000, ->

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


