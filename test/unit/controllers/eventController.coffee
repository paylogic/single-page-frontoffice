"use strict"

describe "Controller: EventController", ->
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

  mockContent =
    "title":
      "en": "Test event"

  mockError =
    "data":
      "message": "Test error message"

  beforeEach ->
    module "app"

    inject ($rootScope, $httpBackend, $controller) ->
      $httpBackend.expectGET "https://shopping-service.sandbox.paylogic.com/events"
        .respond mockEvents

      scope = $rootScope.$new()

      createController = ->
        controller = $controller "EventController",
          $scope: scope

  it "should initialize the event content", inject ($q, $document, EventService) ->
    spyOn EventService, "singleEvent"
      .and.callFake ->
        deferred = $q.defer()
        deferred.resolve mockContent
        return deferred.promise

    controller = createController()

    spyOn scope, "$broadcast"

    expect controller.loading
      .toBeTruthy()

    scope.$digest()

    expect controller.content
      .toEqual
        "title":
          "en": "Test event"

    expect $document[0].title
      .toEqual "Test event"

    expect scope.$broadcast
      .toHaveBeenCalledWith "eventLoaded",
        "title":
          "en": "Test event"

    expect controller.loading
      .toBeFalsy()

  it "should handle the EventService singleEvent function failure correctly", inject ($q, EventService) ->
    spyOn EventService, "singleEvent"
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

  describe "Function: clear", ->

    it "should clear the data and return to index", inject ($location, $document, EventService, BillService, defaults) ->
      spyOn EventService, "clear"
      spyOn BillService, "clear"
      spyOn $location, "path"

      controller = createController()

      controller.clear()

      expect EventService.clear
        .toHaveBeenCalled()

      expect BillService.clear
        .toHaveBeenCalled()

      expect $document[0].title
        .toEqual "Paylogic SPA"

      expect $location.path
        .toHaveBeenCalledWith "/"
