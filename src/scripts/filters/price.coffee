"use strict"

app = angular.module "app"

app.filter "price", (currencies) ->
  (costs, quantity=1, fractionSize=2) ->
    # Example: € 5.00 EUR
    if costs
      # Calculate amount with quantity (used for product's total price).
      amount = costs.amount * quantity
      "#{currencies[costs.currency]} #{amount.toFixed(fractionSize)} #{costs.currency}"
    else
      null
