###
Bill Service

A service to easily gain access to the Bill and Order resources from the API.
###

"use strict"

app = angular.module "app"

app.service "BillService", (CacheService, paylogicShoppingService) ->
  ###
  Send new data, that contain the selected products, payment and shipping
  methods and get the updated bill information.

  @param data [object] Information about the selected products, payment and shipping methods.

  @return [promise] A promise.
  ###
  refresh: (data) ->
    paylogicShoppingService.bill.get data
      .$promise

  ###
  Send new data, that contain the selected products, payment and shipping
  methods and consumer information to the server and create a new order.

  @param data [object] Information about the selected products, payment and shipping methods and consumer data.

  @return [promise] A promise.
  ###
  order: (data) ->
    paylogicShoppingService.orders.create data
      .$promise

  ###
  Wrapper for the Cache Service get method.

  @param key [string] The key that we want to get the value for.

  @return [string] The value of the provided in key.
  ###
  get: (key) ->
    CacheService.get key

  ###
  Wrapper for the Cache Service put method.

  @param key [string] The key that we want to set the value for.
  @param value [string] The value for the provided key.

  @note If an empty value is provided, the provided key will be removed from the cache.
  ###
  put: (key, value) ->
    # If value is not provided, remove key from the cache.
    if value then CacheService.put key, value else CacheService.remove key

  ###
  Clear the values of quantities, bill and consumer data in the cache.
  ###
  clear: ->
    for type in ["quantities", "data", "consumer"]
      CacheService.remove type
