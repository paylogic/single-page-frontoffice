"use strict"

app = angular.module "app"

class MainController
  @$inject = ["$scope", "$document", "$location", "$filter", "EventListData", "LanguageService", "defaults"]

  constructor: (@$scope, @$document, @$location, @$filter, @EventListData, @LanguageService, @defaults) ->
    @LanguageService.setLanguage()
    @$document[0].title = @$filter('localize')(@defaults.docTitle)
    @loading = yes
    @EventListData.events().then (response) =>
        @events = response._embedded["shop:event"]
      , (error) =>
        @errorMessage = error.data?.message
      .finally =>
        @loading = no

  navigate: (eventUid) ->
    @EventListData.put "eventUid", eventUid
    @$location.path "event/#{eventUid}"

app.controller "MainController", MainController
