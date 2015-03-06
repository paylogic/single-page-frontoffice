"use strict"

describe "Service: BillService", ->
  BillService = null
  CacheService = null

  beforeEach ->
    module "app"

    inject (_BillService_, _CacheService_) ->
      BillService = _BillService_
      CacheService = _CacheService_

  afterEach ->
    CacheService.destroy()

  describe "Function: refresh", ->

    result = null

    beforeEach (done) ->
      result = BillService.refresh()
      done()

    it "should return a promise", ->
      expect result.then
        .toBeDefined()

  describe "Function: order", ->

    result = null

    beforeEach (done) ->
      result = BillService.order()
      done()

    it "should return a promise", ->
      expect result.then
        .toBeDefined()

  describe "Function: get", ->

    it "should return a value from the cache", ->
      CacheService.put "test", "testValue"

      expect BillService.get "test"
        .toEqual "testValue"

  describe "Function: put", ->

    it "should insert the value into the cache under the given key, if a value is provided", ->
      BillService.put "test", "testValue"

      expect CacheService.get "test"
        .toEqual "testValue"

    it "should remove the item with the given key, if a value is not provided", ->
      CacheService.put "test", "testValue"

      BillService.put "test", ""

      expect CacheService.get "test"
        .toBeUndefined()

  describe "Function: clear", ->

    it "should remove the items with the keys that are defined in bill data types", ->
      CacheService.put "quantities", "test"
      CacheService.put "data", "test"
      CacheService.put "consumer", "test"
      CacheService.put "notInDataTypes", "test"

      BillService.clear()

      expect CacheService.get "quantities"
        .toBeUndefined()

      expect CacheService.get "data"
        .toBeUndefined()

      expect CacheService.get "consumer"
        .toBeUndefined()

      expect CacheService.get "notInDataTypes"
        .toEqual "test"
