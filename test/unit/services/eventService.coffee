"use strict"

describe "Service: EventService", ->
  EventService = null
  CacheService = null

  beforeEach ->
    module "app"

    inject (_EventService_, _CacheService_) ->
      EventService = _EventService_
      CacheService = _CacheService_

  afterEach ->
    CacheService.destroy()

  describe "Function: events", ->

    result = null

    beforeEach (done) ->
      result = EventService.events()
      done()

    it "should return a promise", ->
      expect result.then
        .toBeDefined()

  describe "Function: singleEvent", ->

    result = null
    resultWithID = null

    beforeEach (done) ->
      result = EventService.singleEvent()
      resultWithID = EventService.singleEvent "eventUid"
      done()

    it "should return a promise, provided or not an event uid", ->
      expect result.then
        .toBeDefined()

      expect resultWithID.then
        .toBeDefined()

  describe "Function: get", ->

    it "should return a value from the cache", ->
      CacheService.put "test", "testValue"

      expect EventService.get "test"
        .toEqual "testValue"

  describe "Function: put", ->

    it "should insert the value into the cache under the given key, if a value is provided", ->
      EventService.put "test", "testValue"

      expect CacheService.get "test"
        .toEqual "testValue"

    it "should remove the item with the given key, if value is not provided", ->
      CacheService.put "test", "testValue"

      EventService.put "test", ""

      expect CacheService.get "test"
        .toBeUndefined()

  describe "Function: clear", ->

    it "should remove the items with the keys that are defined in event list data types", ->
      CacheService.put "eventUid", "test"
      CacheService.put "notInDataTypes", "test"

      EventService.clear()

      expect CacheService.get "eventUid"
        .toBeUndefined()

      expect CacheService.get "notInDataTypes"
        .toEqual "test"
