###
Main Controller

Fetch events data from the API and initialize the language and document title.
The events are being displayed in a list, providing the basic information and the user
can choose an event to see more details. There is also an option for changing the language.
###

"use strict"

app = angular.module "app"

class MainController
  @$inject = ["$scope", "$document", "$location", "$filter", "EventService", "LanguageService", "defaults"]

  constructor: (@$scope, @$document, @$location, @$filter, @EventService, @LanguageService, @defaults) ->
    @LanguageService.setLanguage()
    @$document[0].title = @$filter('localize')(@defaults.docTitle)
    @loading = yes
    @EventService.events().then (response) =>
        @events = response._embedded["shop:event"]
      , (error) =>
        @errorMessage = error.data?.message
      .finally =>
        @loading = no

  ###
  Navigate to the event with the provided eventUid.

  @param eventUid [string] Event's uid.
  ###
  navigate: (eventUid) ->
    @EventService.put "eventUid", eventUid
    @$location.path "event/#{eventUid}"

app.controller "MainController", MainController
