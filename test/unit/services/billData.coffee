"use strict"

describe "Service: BillData", ->
  BillData = null
  Cache = null

  beforeEach ->
    module "app"

    inject (_BillData_, _Cache_) ->
      BillData = _BillData_
      Cache = _Cache_

  afterEach ->
    Cache.destroy()

  describe "Function: refresh", ->

    result = null

    beforeEach (done) ->
      result = BillData.refresh()
      done()

    it "should return a promise", ->
      expect result.then
        .toBeDefined()

  describe "Function: order", ->

    result = null

    beforeEach (done) ->
      result = BillData.order()
      done()

    it "should return a promise", ->
      expect result.then
        .toBeDefined()

  describe "Function: get", ->

    it "should return a value from the cache", ->
      Cache.put "test", "testValue"

      expect BillData.get "test"
        .toEqual "testValue"

  describe "Function: put", ->

    it "should insert the value into the cache under the given key, if a value is provided", ->
      BillData.put "test", "testValue"

      expect Cache.get "test"
        .toEqual "testValue"

    it "should remove the item with the given key, if a value is not provided", ->
      Cache.put "test", "testValue"

      BillData.put "test", ""

      expect Cache.get "test"
        .toBeUndefined()

  describe "Function: remove", ->

    it "should remove the item with the given key", ->
      Cache.put "test", "testValue"

      BillData.remove "test"

      expect Cache.get "test"
        .toBeUndefined()

  describe "Function: clear", ->

    it "should remove the items with the keys that are defined in bill data types", ->
      Cache.put "quantities", "test"
      Cache.put "data", "test"
      Cache.put "consumer", "test"
      Cache.put "notInDataTypes", "test"

      BillData.clear()

      expect Cache.get "quantities"
        .toBeUndefined()

      expect Cache.get "data"
        .toBeUndefined()

      expect Cache.get "consumer"
        .toBeUndefined()

      expect Cache.get "notInDataTypes"
        .toEqual "test"
