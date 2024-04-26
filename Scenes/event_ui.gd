extends Control

var buttons 

var current_event

var event_list = [
{
		"chance": 0.4,
		"can_happen": true,
		"type": "one-time",
		"name": "Green energy support",
		"description": "Politics around country started pushing for a green energy. They are determined to support all green energy producers with subsidies.",
		"options": [{
			"text": "What a nice initiative.",
			"details": "+15% green energy price",
			"effects": [
				{
					"variable": "green_energy_price",
					"value": 0.15
				}
			]
		},
		{
			"text": "We need to support them!",
			"details": "+20% green energy price, -15% non-green energy production",
			"effects": [
				{
					"variable": "green_energy_price",
					"value": 0.2
				},
				{
					"variable": "nongreen_production",
					"value": -0.15
				}
			]
		},
		{
			"text": "Maybe we can sway them to change their mind.",
			"details": "-10 000 000$, -20% non-green power plants upkeep cost",
			"effects": [
				{
					"variable": "money",
					"value": -10
				},
				{
					"variable": "nongreen_upkeep",
					"value": -0.2
				}
			]
		}
		]
	},
	{
		"chance": 0.3,
		"can_happen": true,
		"type": "one-time",
		"name": "Green activists",
		"description": "All around the country people voicing their support for green energy",
		"options": [{
			"text": "Let's send our own 'activists' to deal with them.",
			"details": "-1 000 000$, -1 popularity",
			"effects": [
				{
					"variable": "money",
					"value": 1
				},
				{
					"variable": "popularity",
					"value": -1
				}
			]
		},
		{
			"text": "Give the people what they want!",
			"details": "-10% green energy price, -50% green energy power plants upkeep",
			"effects": [
				{
					"variable": "green_energy_price",
					"value": -0.1
				},
				{
					"variable": "green_upkeep",
					"value": -0.5
				}
			]
		},
		{
			"text": "We need to show them that green energy is unreasonable.",
			"details": "-20% green energy production, +10% non-green energy production",
			"effects": [
				{
					"variable": "green_production",
					"value": -0.2
				},
				{
					"variable": "nongreen_production",
					"value": +0.1
				}
			]
		}
		]
	},
{
		"chance": 0.5,
		"can_happen": true,
		"type": "limitless",
		"name": "Proposal from the opponents",
		"description": "Our competing company offered to reduce energy production together so that energy prices would go up.",
		"options": [{
			"text": "Now we're talking!",
			"details": "+15% energy price, -10% energy production, -0.5 popularity",
			"effects": [
				{
					"variable": "energy_price",
					"value": 0.15
				},
				{
					"variable": "energy_production",
					"value": -0.1
				},
				{
					"variable": "popularity",
					"value": -0.5
				}
			]
		},
		{
			"text": "Let's also demand government subsidies",
			"details": "+25% energy price, -10% energy production, -1.5 popularity",
			"effects": [
				{
					"variable": "energy_price",
					"value": 0.25
				},
				{
					"variable": "energy_production",
					"value": -0.1
				},
				{
					"variable": "popularity",
					"value": -1.5
				}
			]
		},
		{
			"text": "How dare you? We'll report you to the proper authorities.",
			"details": "+5% control",
			"effects": [
				{
					"variable": "control",
					"value": 0.05
				},
				{
					"variable": "can_happen",
					"value": false
				}
			]
		}
		]
	},
	{
		"chance": 0.6,
		"can_happen": true,
		"type": "limitless",
		"name": "Safety problems",
		"description": "During the last safety inspection of our power plants, many problems were found and we are now facing heavy fines",
		"options": [
		{
			"text": "We should seriously improve our safety standarts.",
			"details": "-0.5 popularity, +10% upkeep cost",
			"effects": [
				{
					"variable": "popularity",
					"value": -0.5
				},
				{
					"variable": "upkeep_cost",
					"value": 0.1
				}
			]
		},
		{
			"text": "Let's just pay the fines.",
			"details": "-2 500 000$, -1 popularity, +5% upkeep cost",
			"effects": [
				{
					"variable": "popularity",
					"value": -1
				},
				{
					"variable": "upkeep_cost",
					"value": 0.05
				},
				{
					"variable": "money",
					"value": -2.5
				}
			]
		},
		{
			"text": "Just ask safety inspector to look the other way.",
			"details": "-5 000 000$",
			"effects": [
				{
					"variable": "money",
					"value": -5
				}
			]
		}
	]
	},
	{
		"chance": 0.7,
		"can_happen": true,
		"type": "limitless",
		"name": "Bad weather",
		"description": "The weather recently has been grim, it can negatively affect our solar panels",
		"options": [
		{
			"text": "There is nothing we can do.",
			"details": "-10% solar power plant production",
			"effects": [
				{
					"variable": "solar_production",
					"value": -0.1
				}
			]
		},
		{
			"text": "Then we need to rely less on them.",
			"details": "-20% solar power plant production, -30% solar power plants upkeep",
			"effects": [
				{
					"variable": "solar_production",
					"value": -0.2
				},
				{
					"variable": "solar_upkeep",
					"value": -0.3
				}
			]
		},
		{
			"text": "Let's improve our technologies.",
			"details": "-2 000 000, +10% solar power plant upkeep",
			"effects": [
				{
					"variable": "money",
					"value": -2
				},
				{
					"variable": "solar_upkeep",
					"value": 0.1
				}
			]
		}
	]
	},
	{
		"chance": 0.8,
		"can_happen": true,
		"type": "limitless",
		"name": "Bad Press",
		"description": "Your opponents have launched a smear campaign against you, spreading false information and damaging your reputation.",
		"options": [
		{
			"text": "Start a counter-campaign to discredit them.",
			"details": "-1 popularity, +5% control",
			"effects": [
				{
					"variable": "popularity",
					"value": -1
				},
				{
					"variable": "control",
					"value": 0.05
				}
			]
		},
		{
			"text": "Ignore the accusations.",
			"details": "-0.5 popularity",
			"effects": [
				{
					"variable": "popularity",
					"value": -0.5
				}
			]
		},
		{
			"text": "Decrease prices for consumers",
			"details": "+0.5 popularity, -10% energy price",
			"effects": [
				{
					"variable": "popularity",
					"value": 0.5
				},
				{
					"variable": "energy_price",
					"value": -0.1
				}
			]
		}
	]
	},
	{
		"chance": 0.9,
		"can_happen": true,
		"type": "limitless",
		"name": "Nuclear breakthrough",
		"description": "Scientists are close to discovering new way to improve nuclear power production",
		"options": [{
			"text": "We need to sponsor them.",
			"details": "-20 000 000$, -30% nuclear power plant upkeep cost",
			"effects": [
				{
					"variable": "money",
					"value": -20
				},
				{
					"variable": "nuclear_upkeep",
					"value": -0.3
				}
			]
		},
		{
			"text": "It's nice, but how about more?",
			"details": "-50 000 000$, -30% nuclear power upkeep cost, +20% nuclear power production",
			"effects": [
				{
					"variable": "money",
					"value": -50
				},
				{
					"variable": "nuclear_upkeep",
					"value": -0.3
				},
				{
					"variable": "nuclear_production",
					"value": 0.2
				}
			]
		},
		{
			"text": "Let's see what they come up with.",
			"details": "-10% nuclear power plant upkeep cost",
			"effects": [
				{
					"variable": "nuclear_upkeep",
					"value": -0.1
				}
			]
		}
		]
	},
	{
		"chance": 1.1,
		"can_happen": true,
		"type": "limitless",
		"name": "Сoal opportunities",
		"description": "Local government looking for investors to expend coal mining in the region. They thought we might be interested",
		"options": [{
			"text": "We will help however we can.",
			"details": "-20 000 000$, -20% coal power plant upkeep cost",
			"effects": [
				{
					"variable": "money",
					"value": -20
				},
				{
					"variable": "coal_upkeep",
					"value": -0.2
				}
			]
		},
		{
			"text": "We are not interested",
			"details": "no effects",
			"effects": [
			]
		},
		{
			"text": "Maybe we can reach some kind of agreement.",
			"details": "-10% energy price, -20% coal power plant upkeep cost",
			"effects": [
				{
					"variable": "energy_price",
					"value": -0.1
				},
				{
					"variable": "coal_upkeep",
					"value": -0.2
				}
			]
		}
		]
	}
]



func new_event():
	position.x -= 100000
	buttons = $ColorRect/MarginContainer/VBoxContainer/Buttons.get_children()
	var event_importance = randf()
	for event in event_list:
		if event.chance > event_importance && event.can_happen:
			current_event = event
			if event.type == "one-time":
				event.can_happen = false
				print("switched")
			$ColorRect/MarginContainer/VBoxContainer/EventName.text = event.name
			$ColorRect/MarginContainer/VBoxContainer/EventDescription.text = event.description
			for i in len(buttons):
				buttons[i].get_child(0).text = event.options[i].text
				buttons[i].get_child(1).text = event.options[i].details
			break

func _ready():
	position.x += 100000
	
func select_option(id):
	for effect in current_event.options[id].effects:
		match effect.variable:
			"can_happen":
				current_event.can_happen = false
			"green_energy_price":
				$"../../Buildings".green_price_bonus += effect.value
			"nongreen_production":
				$"../../Buildings".nongreen_production_multiplier += effect.value
			"money":
				$"../../Buildings".money += effect.value
			"nongreen_upkeep":
				$"../../Buildings".nongreen_upkeep_multiplier += effect.value
			"energy_price":
				$"../../Buildings".energy_price_multiplier += effect.value
			"energy_production":
				$"../../Buildings".production_multiplier += effect.value
			"popularity":
				$"../../Buildings".popularity += effect.value
			"control":
				$"../../Buildings".control_percent += effect.value
			"coal_upkeep":
				$"../../Buildings".coal_upkeep_multiplier += effect.value
			"nuclear_upkeep":
				$"../../Buildings".nuclear_upkeep_multiplier += effect.value
			"nuclear_production":
				$"../../Buildings".nuclear_production_multiplier += effect.value
			"solar_production":
				$"../../Buildings".solar_production_multiplier += effect.value
			"solar_upkeep":
				$"../../Buildings".solar_upkeep_multiplier += effect.value
			"upkeep_cost":
				$"../../Buildings".upkeep_multiplier += effect.value
			"green_upkeep":
				$"../../Buildings".green_upkeep_multiplier += effect.value
			"green_production":
				$"../../Buildings".green_production_multiplier += effect.value
			_:
				print(effect.variable, " DOES NOT WORK")
		
	$"../..".change_speed_back()
	position.x += 100000

func _on_button_pressed():
	select_option(0)


func _on_button_2_pressed():
	select_option(1)


func _on_button_3_pressed():
	select_option(2)
