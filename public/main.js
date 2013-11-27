// Generated by CoffeeScript 1.6.2
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  requirejs.config({
    paths: {
      'jquery': '/lib/jquery/jquery'
    }
  });

  define(['jquery'], function($) {
    var City, Encounter, Fighting, GameState, Location, Monster, Moving, PlayerState, Resting, Ruins, Town, encounterChance, encounters, gameOver, gameState, gameTick, moveToNextEncounter, playerStates, startGame, statusLines, stopGame, updateStatus, _ref;

    GameState = (function() {
      function GameState() {}

      GameState.prototype.health = 0;

      GameState.prototype.level = 0;

      GameState.prototype.experience = 0;

      GameState.prototype.money = 0;

      GameState.prototype.limit = 0;

      GameState.prototype.encounter = null;

      GameState.prototype.playerState = null;

      GameState.prototype.timerId = 0;

      GameState.prototype.nextLevelAt = 0;

      GameState.prototype.bounty = 0;

      GameState.prototype.godMode = false;

      GameState.prototype.setHealth = function(value) {
        this.health = value;
        return $('#health').html(value);
      };

      GameState.prototype.setLevel = function(value) {
        this.level = value;
        $('#level').html(value);
        this.maxHealth = this.getMaxHealth();
        return $('#maxHealth').html(this.maxHealth);
      };

      GameState.prototype.setExperience = function(value) {
        this.experience = value;
        return $('#experience').html(value);
      };

      GameState.prototype.setMoney = function(value) {
        this.money = value;
        return $('#money').html(value);
      };

      GameState.prototype.setLimit = function(value) {
        this.limit = value;
        return $('#limit').html(value);
      };

      GameState.prototype.setEncounter = function(value) {
        var _ref;

        if ((_ref = this.encounter) != null) {
          _ref.teardown();
        }
        this.encounter = value;
        return this.encounter.setup();
      };

      GameState.prototype.setPlayerState = function(value) {
        var _ref;

        if ((_ref = this.playerState) != null) {
          _ref.teardown();
        }
        this.playerState = value;
        return this.playerState.setup();
      };

      GameState.prototype.getMaxHealth = function() {
        return Math.round(173.5 * Math.exp(0.0339 * this.level) - 147);
      };

      GameState.prototype.setNextLevelAt = function(value) {
        return this.nextLevelAt = value;
      };

      GameState.prototype.setGodMode = function(value) {
        this.godMode = value;
        if (this.godMode) {
          return $("html").addClass("godMode");
        } else {
          return $("html").removeClass("godMode");
        }
      };

      GameState.prototype.setBounty = function(value) {
        return this.bounty = value;
      };

      GameState.prototype.save = function() {
        var state, stateJson;

        stopGame();
        state = {
          h: this.health,
          l: this.level,
          e: this.experience,
          m: this.money,
          li: this.limit,
          n: this.nextLevelAt,
          b: this.bounty,
          en: this.encounter.id,
          p: this.playerState.id
        };
        stateJson = JSON.stringify(state);
        localStorage["minventure.state"] = stateJson;
        return startGame();
      };

      GameState.prototype.load = function() {
        var state, stateJson;

        stopGame();
        stateJson = localStorage["minventure.state"];
        state = JSON.parse(stateJson);
        this.setEncounter(encounters[state.en]);
        this.setPlayerState(playerStates[state.p]);
        this.setHealth(state.h);
        this.setLevel(state.l);
        this.setExperience(state.e);
        this.setMoney(state.m);
        this.setLimit(state.li);
        this.setNextLevelAt(state.n);
        this.setBounty(state.b);
        return startGame();
      };

      return GameState;

    })();
    moveToNextEncounter = function() {
      var ec, next, nextEncounter, nextId, _i, _len;

      next = Math.random();
      for (_i = 0, _len = encounterChance.length; _i < _len; _i++) {
        ec = encounterChance[_i];
        if (next >= ec.value) {
          nextId = ec.id;
        } else {
          break;
        }
      }
      nextEncounter = encounters[nextId];
      return gameState.setEncounter(nextEncounter);
    };
    gameOver = function() {
      gameState.setHealth(0);
      updateStatus("You are dead.");
      return stopGame();
    };
    updateStatus = function(status) {
      statusLines[0].text(statusLines[1].text());
      statusLines[1].text(statusLines[2].text());
      statusLines[2].text(statusLines[3].text());
      return statusLines[3].text(status);
    };
    PlayerState = (function() {
      function PlayerState(id, potential, kinetic) {
        this.id = id;
        this.potential = potential;
        this.kinetic = kinetic;
      }

      PlayerState.prototype.action = function() {};

      PlayerState.prototype.setup = function() {
        var $button;

        $button = $('#' + this.id);
        $button.addClass("selected");
        return $button.html(this.kinetic);
      };

      PlayerState.prototype.teardown = function() {
        var $button;

        $button = $('#' + this.id);
        $button.removeClass();
        return $button.html(this.potential);
      };

      return PlayerState;

    })();
    Moving = (function(_super) {
      __extends(Moving, _super);

      function Moving() {
        Moving.__super__.constructor.call(this, "move", "Move!", "Moving!");
      }

      Moving.prototype.action = function() {
        var limit;

        limit = gameState.limit - 1;
        if (gameState.encounter instanceof Monster) {
          if (Math.random() < 0.10) {
            updateStatus("You run away!");
            return moveToNextEncounter();
          }
        } else if (limit === 0) {
          return moveToNextEncounter();
        } else {
          return gameState.setLimit(limit);
        }
      };

      return Moving;

    })(PlayerState);
    Fighting = (function(_super) {
      __extends(Fighting, _super);

      function Fighting() {
        Fighting.__super__.constructor.call(this, "fight", "Fight!", "Fighting!");
      }

      Fighting.prototype.action = function() {
        var damage, newLimit;

        if (gameState.encounter instanceof Monster) {
          damage = Math.floor(gameState.maxHealth * (0.3 + (Math.random() * 0.10)));
          newLimit = gameState.limit - damage;
          if (newLimit <= 0) {
            return this.monsterDefeated();
          } else {
            return gameState.setLimit(newLimit);
          }
        }
      };

      Fighting.prototype.monsterDefeated = function() {
        updateStatus("You defeated the monster!");
        this.addExperience(gameState.encounter);
        this.addBounty(gameState.encounter);
        this.addLoot(gameState.encounter);
        return moveToNextEncounter();
      };

      Fighting.prototype.addExperience = function(monster) {
        var exp, expMultiplier, maxExpEarned, nextLevelAt;

        exp = gameState.experience + monster.experience;
        gameState.setExperience(exp);
        if (exp >= gameState.nextLevelAt) {
          gameState.setLevel(gameState.level + 1);
          gameState.setHealth(gameState.getMaxHealth());
          updateStatus("You gained a level!");
          expMultiplier = Math.floor(gameState.level / 24 + 4);
          maxExpEarned = Math.floor(monster.getMaxLimit() / 2);
          nextLevelAt = Math.floor(gameState.nextLevelAt + (maxExpEarned * expMultiplier));
          updateStatus("Next level at " + nextLevelAt + " experience.");
          return gameState.setNextLevelAt(nextLevelAt);
        }
      };

      Fighting.prototype.addLoot = function(monster) {};

      Fighting.prototype.addBounty = function(monster) {
        return gameState.setBounty(gameState.bounty + Math.floor(monster.maxHealth / 10));
      };

      return Fighting;

    })(PlayerState);
    Resting = (function(_super) {
      __extends(Resting, _super);

      function Resting() {
        Resting.__super__.constructor.call(this, "rest", "Rest!", "Resting!");
      }

      Resting.prototype.action = function() {
        var addHealth, expMultiplier, healRate, lootMultiplier, newHealth;

        if (gameState.encounter instanceof Monster) {
          return;
        }
        if (gameState.health < gameState.getMaxHealth()) {
          healRate = Math.floor(gameState.getMaxHealth() * 0.08);
          expMultiplier = 1;
          lootMultiplier = 1;
          addHealth = healRate * expMultiplier * lootMultiplier;
          newHealth = gameState.health + addHealth;
          if (newHealth > gameState.maxHealth) {
            newHealth = gameState.maxHealth;
          }
          return gameState.setHealth(newHealth);
        }
      };

      return Resting;

    })(PlayerState);
    Encounter = (function() {
      function Encounter(id, name, minLimit, maxLimit) {
        this.id = id;
        this.name = name;
        this.minLimit = minLimit;
        this.maxLimit = maxLimit;
      }

      Encounter.prototype.setup = function() {
        $('#encounter').removeClass();
        $('#encounter').addClass(this.id);
        $('#description').html(this.name);
        return gameState.setLimit(this.nextLimit());
      };

      Encounter.prototype.action = function() {};

      Encounter.prototype.teardown = function() {};

      Encounter.prototype.getMinLimit = function() {
        return this.minLimit;
      };

      Encounter.prototype.getMaxLimit = function() {
        return this.maxLimit;
      };

      Encounter.prototype.nextLimit = function() {
        var delta;

        delta = this.getMaxLimit() - this.getMinLimit();
        return Math.floor(Math.random() * delta) + this.getMinLimit();
      };

      return Encounter;

    })();
    Location = (function(_super) {
      __extends(Location, _super);

      function Location() {
        _ref = Location.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Location.prototype.setup = function() {
        return Location.__super__.setup.apply(this, arguments);
      };

      return Location;

    })(Encounter);
    Monster = (function(_super) {
      __extends(Monster, _super);

      function Monster() {
        Monster.__super__.constructor.call(this, "monster", "Monster!", 0, 0);
        this.maxHealth = 0;
        this.experience = 0;
      }

      Monster.prototype.setup = function() {
        Monster.__super__.setup.apply(this, arguments);
        this.maxHealth = this.nextLimit();
        this.experience = Math.floor(this.maxHealth / 2);
        gameState.setLimit(this.maxHealth);
        if (gameState.godMode) {
          return gameState.setPlayerState(playerStates.fight);
        }
      };

      Monster.prototype.action = function() {
        var damage, newHealth, percent;

        percent = Math.random() * 0.08 + 0.02;
        damage = Math.floor(this.maxHealth * percent);
        if (!gameState.godMode && damage > 0) {
          updateStatus("You take " + damage + " damage!");
          newHealth = gameState.health - damage;
          if (newHealth <= 0) {
            return gameOver();
          } else {
            return gameState.setHealth(newHealth);
          }
        }
      };

      Monster.prototype.teardown = function() {
        Monster.__super__.teardown.apply(this, arguments);
        if (gameState.godMode) {
          return gameState.setPlayerState(playerStates.move);
        }
      };

      Monster.prototype.getMinLimit = function() {
        return Math.floor((gameState.maxHealth / 1.1) - (gameState.maxHealth / 2));
      };

      Monster.prototype.getMaxLimit = function() {
        return Math.floor((gameState.maxHealth / 1.5) + (gameState.maxHealth / 2));
      };

      return Monster;

    })(Encounter);
    Ruins = (function(_super) {
      __extends(Ruins, _super);

      function Ruins() {
        Ruins.__super__.constructor.call(this, "ruins", "Ruins!", 2, 4);
      }

      Ruins.prototype.setup = function() {
        var description, loot;

        Ruins.__super__.setup.apply(this, arguments);
        loot = lootFactory.create();
        description = loot.description();
        return updateStatus("You found " + description + "!");
      };

      return Ruins;

    })(Encounter);
    City = (function(_super) {
      __extends(City, _super);

      function City() {
        City.__super__.constructor.call(this, "city", "City!", 4, 6);
      }

      City.prototype.setup = function() {
        var newMoney, tribute;

        City.__super__.setup.apply(this, arguments);
        tribute = gameState.bounty;
        if (tribute > 0) {
          updateStatus("The magistrate gives you " + tribute + " gold.");
          newMoney = gameState.money + tribute;
          gameState.setMoney(newMoney);
          return gameState.setBounty(0);
        }
      };

      return City;

    })(Encounter);
    Town = (function(_super) {
      __extends(Town, _super);

      function Town() {
        Town.__super__.constructor.call(this, "town", "Town!", 2, 4);
      }

      Town.prototype.setup = function() {
        var newMoney, tribute;

        Town.__super__.setup.apply(this, arguments);
        tribute = gameState.limit;
        updateStatus("The villagers give you " + tribute + " gold.");
        newMoney = gameState.money + tribute;
        return gameState.setMoney(newMoney);
      };

      return Town;

    })(Encounter);
    gameTick = function() {
      gameState.playerState.action();
      return gameState.encounter.action();
    };
    startGame = function() {
      return gameState.timerId = window.setInterval(gameTick, 800);
    };
    stopGame = function() {
      return window.clearInterval(gameState.timerId);
    };
    encounters = {
      swamp: new Location("swamp", "Swamp!", 2, 8),
      prarie: new Location("prarie", "Prarie!", 2, 7),
      hills: new Location("hills", "Hills!", 2, 8),
      mountains: new Location("mountains", "Mountains!", 2, 5),
      desert: new Location("desert", "Desert!", 2, 8),
      coastline: new Location("coastline", "Coastline!", 2, 5),
      jungle: new Location("jungle", "Jungle!", 2, 8),
      tundra: new Location("tundra", "Tundra!", 2, 6),
      forest: new Location("forest", "Forest!", 2, 8),
      savana: new Location("savana", "Savana!", 2, 8),
      ruins: new Ruins,
      town: new Town,
      city: new City,
      monster: new Monster
    };
    encounterChance = [
      {
        value: 0.00,
        id: "ruins"
      }, {
        value: 0.05,
        id: "town"
      }, {
        value: 0.10,
        id: "city"
      }, {
        value: 0.20,
        id: "swamp"
      }, {
        value: 0.25,
        id: "savana"
      }, {
        value: 0.30,
        id: "desert"
      }, {
        value: 0.35,
        id: "jungle"
      }, {
        value: 0.40,
        id: "forest"
      }, {
        value: 0.60,
        id: "hills"
      }, {
        value: 0.65,
        id: "prarie"
      }, {
        value: 0.70,
        id: "mountains"
      }, {
        value: 0.75,
        id: "tundra"
      }, {
        value: 0.80,
        id: "coastline"
      }, {
        value: 0.85,
        id: "monster"
      }
    ];
    statusLines = [];
    playerStates = {
      move: new Moving,
      fight: new Fighting,
      rest: new Resting
    };
    gameState = new GameState;
    gameState.setLevel(1);
    gameState.setHealth(25);
    gameState.setExperience(0);
    gameState.setMoney(0);
    gameState.setNextLevelAt(72);
    gameState.setEncounter(encounters.forest);
    gameState.setPlayerState(playerStates.rest);
    $(function() {
      statusLines = [$('#line1'), $('#line2'), $('#line3'), $('#line4')];
      return startGame();
    });
    $('#move').click(function() {
      return gameState.setPlayerState(playerStates.move);
    });
    $('#fight').click(function() {
      return gameState.setPlayerState(playerStates.fight);
    });
    $('#buy').click(function() {
      return gameState.setPlayerState(playerStates.buy);
    });
    $('#sell').click(function() {
      return gameState.setPlayerState(playerStates.sell);
    });
    $('#rest').click(function() {
      return gameState.setPlayerState(playerStates.rest);
    });
    $('#save').click(function() {
      return gameState.save();
    });
    $('#load').click(function() {
      return gameState.load();
    });
    return $(document.documentElement).keypress(function(e) {
      if (e.keyCode === 109) {
        return gameState.setEncounter(encounters.monster);
      } else if (e.keyCode === 103) {
        return gameState.setGodMode(!gameState.godMode);
      }
    });
  });

}).call(this);

/*
//@ sourceMappingURL=main.map
*/
