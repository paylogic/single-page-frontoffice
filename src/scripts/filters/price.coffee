###
Price filter

Use this filter to format prices based on the currency from the given costs.

@example € 5.00 EUR
###

"use strict"

app = angular.module "app"

app.filter "price", (currencies) ->
  ###
  Return a formatted price using the costs currency.

  @param costs [object] The costs of the resource.
  @param quantity [number] The quantity to calculate the total price for. Defaults to 1.
  @param franctionSize [number] The decimals that will be used. Defaults to 2.

  @return [string|null] The formatted price or null.
  ###
  (costs, quantity=1, fractionSize=2) ->
    if costs and costs.amount > 0
      # Calculate amount with quantity (used for product's total price).
      amount = costs.amount * quantity
      "#{currencies[costs.currency]} #{amount.toFixed(fractionSize)} #{costs.currency}"
    else
      null
