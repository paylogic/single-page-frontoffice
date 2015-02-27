"use strict"

describe "Filter: option", ->
  filter = null

  mockPaymentMethod =
    "name":
      "en": "Test Payment method"
    "costs":
      "amount": "1.23"
      "currency": "EUR"

  mockShippingMethod =
    "name":
      "en": "E-Tickets"
    "costs":
      "amount": "1.00"
      "currency": "EUR"

  beforeEach ->
    module "app"

    inject ($filter) ->
      filter = $filter

  it "exists", ->
    expect filter "option"
      .not.toBeNull()

  it "should return the correct option format", ->
    payment = filter("option")(mockPaymentMethod)
    shipping = filter("option")(mockShippingMethod)

    expect payment
      .toEqual "Test Payment method (+ € 1.23 EUR)"

    expect shipping
      .toEqual "E-Tickets (+ € 1.00 EUR)"

  it "should return null, when no method is provided", ->
    payment = filter("option")("")

    expect payment
      .toBeNull()
