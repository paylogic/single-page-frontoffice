"use strict"

describe "Service: EventListData", ->
  EventListData = null
  Cache = null

  beforeEach ->
    module "app"

    inject (_EventListData_, _Cache_) ->
      EventListData = _EventListData_
      Cache = _Cache_

  afterEach ->
    Cache.destroy()

  describe "Function: events", ->

    result = null

    beforeEach (done) ->
      result = EventListData.events()
      done()

    it "should return a promise", ->
      expect result.then
        .toBeDefined()

  describe "Function: singleEvent", ->

    result = null
    resultWithID = null

    beforeEach (done) ->
      result = EventListData.singleEvent()
      resultWithID = EventListData.singleEvent "eventUid"
      done()

    it "should return a promise, provided or not an event uid", ->
      expect result.then
        .toBeDefined()

      expect resultWithID.then
        .toBeDefined()

  describe "Function: get", ->

    it "should return a value from the cache", ->
      Cache.put "test", "testValue"

      expect EventListData.get "test"
        .toEqual "testValue"

  describe "Function: put", ->

    it "should insert the value into the cache under the given key, if a value is provided", ->
      EventListData.put "test", "testValue"

      expect Cache.get "test"
        .toEqual "testValue"

    it "should remove the item with the given key, if value is not provided", ->
      Cache.put "test", "testValue"

      EventListData.put "test", ""

      expect Cache.get "test"
        .toBeUndefined()

  describe "Function: remove", ->

    it "should remove the item with the given key", ->
      Cache.put "test", "testValue"

      EventListData.remove "test"

      expect Cache.get "test"
        .toBeUndefined()

  describe "Function: clear", ->

    it "should remove the items with the keys that are defined in event list data types", ->
      Cache.put "eventUid", "test"
      Cache.put "notInDataTypes", "test"

      EventListData.clear()

      expect Cache.get "eventUid"
        .toBeUndefined()

      expect Cache.get "notInDataTypes"
        .toEqual "test"
