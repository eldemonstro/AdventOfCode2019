# frozen_string_literal: true
require 'pry'

text = File.open(__dir__ + '/input.txt').read

$leftovers = Hash.new(0)

$recipes = text.split("\n").map do |recipe|
  ingredients_text, result_text = recipe.split(" => ")

  ingredients = ingredients_text.split(", ").map do |ingredient_text|
    {
      quantity: ingredient_text.split[0].to_i,
      material: ingredient_text.split[1]
    }
  end

  {
    result: result_text.split[1],
    quantity: result_text.split[0].to_i,
    ingredients: ingredients
  }
end

$recipes.push ({ result: "ORE", quantity: 1 })

def getRequiredOre(material, quantity)
  ore_sum = 0

  if material == "ORE"
    return quantity
  end

  recipe = $recipes.find { |recipe| recipe[:result] == material }

  while $leftovers[recipe[:result]] < quantity

    ore_sum += recipe[:ingredients].map do |ingredient|
      getRequiredOre(ingredient[:material], ingredient[:quantity])
    end.sum

    $leftovers[recipe[:result]] += (recipe[:quantity])
  end

  $leftovers[recipe[:result]] -= quantity

  ore_sum
end

ore_per_fuel = getRequiredOre("FUEL", 1)
leftovers_per_fuel = $leftovers.dup
fuel_total = 1

ore_used = 0
increment = 1
ore_remaining = 1_000_000_000_000

minimum_quantity = ore_remaining / ore_per_fuel
$leftovers =  $leftovers.map { |leftover| leftover * minimum_quantity }

fuel_total = fuel_total * minimum_quantity

ore_remaining = ore_remaining - (ore_per_fuel * minimum_quantity)

binding.pry

puts "fuel total #{fuel_total}"
