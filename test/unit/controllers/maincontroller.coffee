"use strict"

describe "Controller: MainController", ->
  scope = null
  createController = null

  mockEvents =
    "_embedded":
      "shop:event": [
        {
          "title":
            "en": "Test event"
        }
      ]

  mockError =
    "data":
      "message": "Test error message"

  beforeEach ->
    module "app"

    inject ($rootScope, $controller) ->
      scope = $rootScope.$new()

      createController = ->
        controller = $controller "MainController",
          $scope: scope

  it "should set the language and the document title", inject ($document, defaults, LanguageService) ->
    spyOn LanguageService, "setLanguage"

    controller = createController()

    expect LanguageService.setLanguage
      .toHaveBeenCalled()

    expect $document[0].title
      .toEqual "Paylogic SPA"

  it "should initialize the events data", inject ($q, EventListData) ->
    spyOn EventListData, "events"
      .and.callFake ->
        deferred = $q.defer()
        deferred.resolve mockEvents
        return deferred.promise

    controller = createController()

    expect controller.loading
      .toBeTruthy()

    scope.$digest()

    expect controller.events
      .toEqual [
        {
          "title":
            "en": "Test event"
        }
      ]

    expect controller.loading
      .toBeFalsy()

  it "should handle the EventListData events function failure correctly", inject ($q, EventListData) ->
    spyOn EventListData, "events"
      .and.callFake ->
        deferred = $q.defer()
        deferred.reject mockError
        return deferred.promise

    controller = createController()

    expect controller.loading
      .toBeTruthy()

    scope.$digest()

    expect controller.errorMessage
      .toEqual "Test error message"

    expect controller.loading
      .toBeFalsy()

  describe "Function: navigate", ->

    it "should cache the selected event and navigate to event details page", inject ($location, EventListData) ->
      spyOn $location, "path"

      controller = createController()

      controller.navigate "testEventUid"

      expect EventListData.get "eventUid"
        .toEqual "testEventUid"

      expect $location.path
        .toHaveBeenCalledWith "event/testEventUid"
