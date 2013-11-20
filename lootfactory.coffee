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
	constructor: (@subfragments) ->
	render: (plural) ->

class OptionalFragment extends Fragment

class LookupFragment extends Fragment

class PluralFragment extends Fragment

class TextFragment extends Fragment

class ListFragment extends Fragment

class SelectFragment extends Fragment

class LootFactory


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

	
	_templates = [
		"?{Weight} ?[{Race}|{Material}] [^Dagger|^Knife|^Axe|^Short Sword|^Broadsword|^Long Sword|^Katana|^Saber|^Club|^Mace|^Morning Star|^Flail|^Quarterstaff|^Polearm|^Spear|^Bow|^Crossbow]",
		"?{Aspect} ?{Race} {Mail} [^Armor|Pair of Gauntlets|^Helm|Pair of Boots]",
		"?{Aspect} ?{Race} {Material} ^Shield",
		"{Color} Monster [^Hide|^Fur|^Tusk|^Horns|Teeth|Bones]",
		"?{Weight} {Metal} [^Saw|^Axe|Scissors|^Hammer|^Wrench|Pliers]",
		"^Scroll of {Characteristic}",
		"{Metal} ^Wand of {Characteristic}",
		"{Color} ^Potion of {Characteristic}",
		"{Metal} ^Amulet",
		"?{Metal} ^Amulet of {Characteristic}",
		"{Gem} ^Amulet",
		"{Gem} ^Amulet of {Characteristic}",
		"Amulet of Yendor",
		"{Metal} ^Ring",
		"?{Metal} ^Ring of {Characteristic}",
		"{Gem} ^Ring",
		"{Gem} ^Ring of {Characteristic}",
		"?{Gem} Encrusted {Metal} ^Ring",
		"?{Gem} Encrusted ?{Metal} ^Ring of {Characteristic}",
		"?{Weight} {Metal} ^Bracelet",
		"?{Weight} ?{Metal} ^Bracelet of {Characteristic}",
		"?{Gem} Encrusted {Metal} ^Bracelet",
		"?{Gem} Encrusted ?{Metal} ^Bracelet of {Characteristic}",
		"?{Weight} {Metal} ^Necklace",
		"?{Weight} ?{Metal} ^Necklace of {Characteristic}",
		"?{Gem} Encrusted {Metal} ^Necklace",
		"?{Gem} Encrusted ?{Metal} ^Necklace of {Characteristic}",
		"{Material} ^Rod",
		"{Material} ^Staff", 
		"{Gem} Encrusted {Material} ^Rod",
		"{Gem} Encrusted {Material} ^Staff", 
		"?{Aspect} {Material} ^Key",
		"?{Aspect} {Material} ^Arrow",
		"?{Aspect} {Material} ^Bolt",
		"{Size} ?{Aspect} {Color} ^Gem",
		"{MetalElement} Ore",
		"?{Size} ?{Aspect} {Color} [^Shirt|Trousers|Shorts|Capris|^Skirt|^Robe|^Hood|Gloves|^Dress|^Jacket|^Vest|Pajamas|^Scarf|^Coat|^Cap|^Cape|^Mask|^Headband]",
		"?{Size} ?{Color} ^Book of {Topic}",
		"?{Length} ?{Color} ^Book of {Topic}",
		"?{Weight} ?{Color} ^Book of {Topic}",
		"?{Aspect} {Material} [^Fork|^Spoon|^Knife]",
	]

	create: ->
		loot = ""
		template = _templates[Math.floor(Math.random() * _templates.length)]
		fragmentList = parseTemplate template

		singular = fragmentList.render false
		plural = fragmentList.render true

		new Loot(singular, plural, 1)

	makeFragments: (template) ->
		fragments = []

		chars = template.split ''

		fragment = ""

		i = 0 
		while (i < chars.length)
			c = chars[i]

			i++




	nextFragment: ->


factory = new LootFactory()

loot = factory.create() 

console.log loot.description

