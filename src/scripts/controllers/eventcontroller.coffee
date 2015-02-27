"use strict"

app = angular.module "app"

class EventController
  @$inject = ["$scope", "$location", "$document", "$filter", "EventListData", "BillData", "defaults"]

  constructor: (@$scope, @$location, @$document, @$filter, @EventListData, @BillData, @defaults) ->
    @loading = yes
    @EventListData.singleEvent().then (response) =>
        @content = response
        @$document[0].title = @$filter('localize')(@content.title)
        @$scope.$broadcast "eventLoaded", @content
      , (error) =>
        @errorMessage = error.data?.message
      .finally =>
        @loading = no

  clear: ->
    @EventListData.clear()
    @BillData.clear()
    @$document[0].title = @$filter('localize')(@defaults.docTitle)
    @$location.path "/"

app.controller "EventController", EventController
