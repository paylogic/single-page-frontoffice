"use strict"

app = angular.module "app"

app.service "EventListData", (Cache, paylogicShoppingService) ->
  events: ->
    paylogicShoppingService.events.query().$promise

  singleEvent: (eventUid) ->
    # If eventUid is not provided, get it from the Cache.
    paylogicShoppingService.events.query
        eventUid: if eventUid then eventUid else @get "eventUid"
      .$promise

  get: (key) ->
    Cache.get key

  put: (key, value) ->
    # If value is not provided, remove key from the Cache.
    if value then Cache.put key, value else @remove key

  remove: (key) ->
    Cache.remove key

  clear: ->
    for type in ["eventUid"]
      @remove type
