"use strict"

describe "Filter: price", ->
  filter = null

  costs =
    amount: "2.48"
    currency: "EUR"

  beforeEach ->
    module "app"

    inject ($filter) ->
      filter = $filter

  it "exists", ->
    expect filter "price"
      .not.toBeNull()

  it "should return the correct price format", ->
    result = filter("price")(costs)

    expect result
      .toEqual "€ 2.48 EUR"

  it "should return the correct price format, including quantity", ->
    result = filter("price")(costs, 2)

    expect result
      .toEqual "€ 4.96 EUR"

  it "should return the price with the correct fraction size", ->
    result = filter("price")(costs, 1, 4)

    expect result
      .toEqual "€ 2.4800 EUR"

  it "should return null, when no costs are provided", ->
    result = filter("price")("")

    expect result
      .toBeNull()
