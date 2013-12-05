class Loot
  constructor: (@singular,@plural,@quantity) ->

  incrementQuantity: ->
    @quantity = @quantity + 1

  description: ->
    if @quantity > 1
      @plural
    else
      @singular

class Fragment
  constructor: (type) ->
    @type = type
    @parent = null
    @children = []
    @text = ""

  addChild: (child) ->
    child.parent = this
    @children.push child

  addCharacter: (ch) ->
    @text = @text.concat ch

  debug: ->
    s = ""
    p = @parent
    while p != null
      s = s.concat "  "
      p = p.parent

    console.log "#{s}#{@type}: #{@text}"

    child.debug() for child in @children

class OptionalFragment extends Fragment
  constructor: ->
    super "Optional"

class LookupFragment extends Fragment
  constructor: ->
    super "Lookup"

class PluralFragment extends Fragment
  constructor: ->
    super "Plural"

class TextFragment extends Fragment
  constructor: ->
    super "Text"

class ListFragment extends Fragment
  constructor: ->
    super "List"

class SelectFragment extends Fragment
  constructor: ->
    super "Select"

  ###


    new ListFragment
      new OptionalFragment
        new LookupFragment "Weight"
      new OptionalFragment
        new SelectFragment
          new LookupFragment "Race"
          new LookupFragment "Material"
      new SelectFragment
        new PluralFragment "Dagger"
        new PluralFragment "Knife"
        new PluralFragment "Axe"
        new PluralFragment "Short Sword"
        new PluralFragment "Broadsword"


    new ListFragment
      new PluralFragment "Scroll"
      new TextFragment "of"
      new LookupFragment "Characteristic"

    new ListFragment
      new TextFragment "Amulet"
      new TextFragment "of"
      new TextFragment "Yendor"
  ###


class LootFactory

  _templates = [
    "{Weight}? [{Race}|{Material}]? [Dagger$|Knife$|Axe$|'Short Sword'$|Broadsword$|'Long Sword'$|Katana$|Saber$|Club$|Mace$|'Morning Star'$|Flail$|Quarterstaff$|Polearm$|Spear$|Bow$|Crossbow$]",
    "{Aspect}? {Race}? {Mail} [Armor$|'Pair of Gauntlets'|Helm$|'Pair of Boots']",
    "{Aspect}? {Race}? {Material} Shield$",
    "{Color} Monster [Hide$|Fur$|Tusk$|Horns$|Teeth|Bones]",
    "{Weight}? {Metal} [Saw$|Axe$|Scissors|Hammer$|Wrench$|Pliers]",
    "Scroll$ of {Characteristic}",
    "{Metal} $Wand of {Characteristic}",
    "{Color} $Potion of {Characteristic}",
    "{Metal} $Amulet",
    "?{Metal} $Amulet of {Characteristic}",
    "{Gem} $Amulet",
    "{Gem} $Amulet of {Characteristic}",
    "Amulet of Yendor",
    "{Metal} $Ring",
    "?{Metal} $Ring of {Characteristic}",
    "{Gem} $Ring",
    "{Gem} $Ring of {Characteristic}",
    "?{Gem} Encrusted {Metal} $Ring",
    "?{Gem} Encrusted ?{Metal} $Ring of {Characteristic}",
    "?{Weight} {Metal} $Bracelet",
    "?{Weight} ?{Metal} $Bracelet of {Characteristic}",
    "?{Gem} Encrusted {Metal} $Bracelet",
    "?{Gem} Encrusted ?{Metal} $Bracelet of {Characteristic}",
    "?{Weight} {Metal} $Necklace",
    "?{Weight} ?{Metal} $Necklace of {Characteristic}",
    "?{Gem} Encrusted {Metal} $Necklace",
    "?{Gem} Encrusted ?{Metal} $Necklace of {Characteristic}",
    "{Material} $Rod",
    "{Material} $Staff",
    "{Gem} Encrusted {Material} $Rod",
    "{Gem} Encrusted {Material} $Staff",
    "?{Aspect} {Material} $Key",
    "?{Aspect} {Material} $Arrow",
    "?{Aspect} {Material} $Bolt",
    "{Size} ?{Aspect} {Color} $Gem",
    "{MetalElement} Ore",
    "?{Size} ?{Aspect} {Color} [$Shirt|Trousers|Shorts|Capris|$Skirt|$Robe|$Hood|Gloves|$Dress|$Jacket|$Vest|Pajamas|$Scarf|$Coat|$Cap|$Cape|$Mask|$Headband]",
    "?{Size} ?{Color} $Book of {Topic}",
    "?{Length} ?{Color} $Book of {Topic}",
    "?{Weight} ?{Color} $Book of {Topic}",
    "?{Aspect} {Material} [$Fork|$Spoon|$Knife]",
  ]

  reText = /[A-Za-z0-9]/

  create: ->
    template = _templates[Math.floor(Math.random() * _templates.length)]
    fragmentList = new FragmentList
    @parseFragment fragmentList, template, 0

    singular = fragmentList.render false
    plural = fragmentList.render true

    new Loot(singular, plural, 1)

  parseFragment: (parent, template, p) ->

    while p < template.length
      c = template.charAt p

      switch c
        when '?' then parent.addChild new OptionalFragment()
        when '{' then p = @parseLookup parent, template, p
        when '[' then p = @parseSelect parent, template, p
        when '$' then p = @parsePlural parent, template, p
        when ' ' then p = p + 1
        else p = @parseText parent, template, p

      p++

    p

  parseLookup: (parent, template, p) ->
    fragment = new LookupFragment()

    p++

    while true
      ch = template.charAt p
      if reText.exec(ch) == null
        break
      fragment.addCharacter ch
      p++

    parent.addChild fragment

    ++p

  parseSelect: (parent, template, p) ->

  parsePlural: (parent, template, p) ->
    fragment = new PluralFragment

    p++

    while true
      ch = template.charAt p
      if reText.exec(ch) == null
        break
      fragment.addCharacter ch
      p++

    parent.addChild fragment

    p


  parseText: (parent, template, p) ->
    fragment = new TextFragment

    while true
      ch = template.charAt p
      if reText.exec(ch) == null
        break
      fragment.addCharacter ch
      p++

    parent.addChild fragment

    p

factory = new LootFactory()

list = new ListFragment()
factory.parseFragment list, "?{Gem} Encrusted {Metal} $Ring", 0

list.debug()

# loot = factory.create()
# console.log loot.description

