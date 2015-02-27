"use strict"

app = angular.module "app"

app.service "BillData", (Cache, paylogicShoppingService) ->
  refresh: (data) ->
    paylogicShoppingService.bill.get data
      .$promise

  order: (data) ->
    paylogicShoppingService.orders.create data
      .$promise

  get: (key) ->
    Cache.get key

  put: (key, value) ->
    # If value is not provided, remove key from the Cache.
    if value then Cache.put key, value else @remove key

  remove: (key) ->
    Cache.remove key

  clear: ->
    for type in ["quantities", "data", "consumer"]
      @remove type
