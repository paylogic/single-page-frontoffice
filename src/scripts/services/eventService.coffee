###
Event Service

A service to easily gain access to the Event resource from the API.
###

"use strict"

app = angular.module "app"

app.service "EventService", (CacheService, paylogicShoppingService) ->
  ###
  Get all the available events from the API.

  @return [promise] A promise.
  ###
  events: ->
    paylogicShoppingService.events.query().$promise

  ###
  Get a single event from the API.

  @param eventUid [string] An eventUid to retrieve information for.

  @return [promise] A promise.

  @note If eventUid is not provided, then get it from the cache.
  ###
  singleEvent: (eventUid) ->
    paylogicShoppingService.events.query
      eventUid: if eventUid then eventUid else @get "eventUid"
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
    # If value is not provided, remove key from the Cache.
    if value then CacheService.put key, value else CacheService.remove key

  ###
  Clear the value of eventUid in the cache.
  ###
  clear: ->
    for type in ["eventUid"]
      CacheService.remove type
