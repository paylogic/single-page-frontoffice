###
Event Controller

Fetch data from the API for a single event and initialize the content.
It is used to provide detailed information about the selected event, including
all the available products that a user can choose from.
###

"use strict"

app = angular.module "app"

class EventController
  @$inject = ["$scope", "$location", "$document", "$filter", "EventService", "BillService", "defaults"]

  constructor: (@$scope, @$location, @$document, @$filter, @EventService, @BillService, @defaults) ->
    @loading = yes
    @EventService.singleEvent().then (response) =>
      @content = response
      @$document[0].title = @$filter('localize')(@content.title)
      @$scope.$broadcast "eventLoaded", @content
    , (error) =>
      @errorMessage = error.data?.message
    .finally =>
      @loading = no

  ###
  Clear event and bill data from the cache and navigate back
  to the event selection page.
  ###
  clear: ->
    @EventService.clear()
    @BillService.clear()
    @$document[0].title = @$filter('localize')(@defaults.docTitle)
    @$location.path "/"

app.controller "EventController", EventController
