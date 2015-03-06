"use strict"

describe "Controller: BillController", ->
  scope = null
  createController = null

  mockData =
    "_embedded":
      "shop:product": [
        {
          "_links":
            "self":
              "href": "Test product link"
          "name":
            "en": "Test product"
          "sold_out": no
        }
        {
          "_links":
            "self":
              "href": "Another product link"
          "name":
            "en": "Another product"
          "sold_out": yes
        }
      ]

  mockQuantities =
    "Test product link": 1
    "Another product link": 2
    "Third": 0

  mockConsumer =
    "first_name": "John"
    "last_name": "Doe"
    "country": "US"

  mockPaymentMethod =
    "uid": "Test payment method"

  mockShippingMethod =
    "uid": "Test shipping method"

  mockBill =
    "product_total":
      "amount": "5.00"
      "currency": "EUR"
    "products": [
      {
        "product": "productUri",
        "quantity": 1
      }
    ]
    "payment_method":
      "uid": "Test payment method"
    "shipping_method":
      "uid": "Test shipping method"

  mockOrder =
    "_links":
      "payment_url":
        "href": "test payment url"

  mockError =
    "data":
      "message": "Test error message"

  beforeEach ->
    module "app"

    inject ($rootScope, $controller) ->
      scope = $rootScope.$new()

      createController = ->
        controller = $controller "BillController",
          $scope: scope

  it "should initialize the products", ->
    controller = createController()

    spyOn controller, "init"
    spyOn controller, "saveDataInCache"

    scope.$broadcast "eventLoaded", mockData

    expect controller.products
      .toEqual mockData["_embedded"]["shop:product"]

    expect controller.init
      .toHaveBeenCalled()

    expect controller.saveDataInCache
      .not.toHaveBeenCalled()

  describe "Function: init", ->

    it "should initialize the data", ->
      controller = createController()

      spyOn controller, "initQuantities"
      spyOn controller, "updateDataFromCache"
      spyOn controller, "refreshBillData"

      controller.init()

      expect scope.confirmBtnText
        .toEqual "DEFAULT"

      expect controller.initQuantities
        .toHaveBeenCalled()

      expect controller.updateDataFromCache
        .toHaveBeenCalled()

      expect controller.refreshBillData
        .toHaveBeenCalled()

  describe "Function: initQuantities", ->

    it "should initialize the product quantities", inject (BillService) ->
      controller = createController()

      spyOn BillService, "get"

      controller.products = mockData._embedded["shop:product"]

      controller.initQuantities()

      expect BillService.get.calls.count()
        .toEqual 1

      expect controller.quantities
        .toEqual
          "Test product link": 0

  describe "Function: updateDataFromCache", ->

    it "should update the data from cache", inject (BillService) ->
      BillService.put "data", mockBill

      controller = createController()

      controller.updateDataFromCache()

      expect controller.paymentMethod
        .toEqual
          "uid": "Test payment method"

      expect controller.shippingMethod
        .toEqual
          "uid": "Test shipping method"

      expect controller.consumer
        .toBeUndefined()

  describe "Function: saveDataInCache", ->

    it "should save data in the cache", inject (BillService) ->
      spyOn BillService, "put"

      controller = createController()

      controller.content = "Content"
      controller.consumer = "Consumer"

      controller.saveDataInCache()

      expect BillService.put
        .toHaveBeenCalledWith "data", "Content"

      expect BillService.put
        .toHaveBeenCalledWith "consumer", "Consumer"

  describe "Function: refreshBillData", ->

    it "should refresh the bill data", ->
      controller = createController()

      spyOn controller, "performBillRequest"

      controller.quantities = mockQuantities

      controller.refreshBillData()

      # If we have products call the perform bill request method with the correct data
      data = controller.prepareBillData()

      expect controller.performBillRequest
        .toHaveBeenCalledWith data

      # If no products, controller's content must be null
      controller.quantities = {}

      controller.refreshBillData()

      expect controller.content
        .toBeNull()

  describe "Function: prepareBillData", ->

    it "should prepare the data for the bill request", inject (defaults) ->
      controller = createController()

      spyOn controller, "productData"

      controller.consumer = mockConsumer
      controller.paymentMethod = mockPaymentMethod
      controller.shippingMethod = mockShippingMethod

      billData = controller.prepareBillData()

      expect controller.productData
        .toHaveBeenCalled()

      expect billData.country
        .toEqual mockConsumer.country

      controller.consumer.country = ""

      billData = controller.prepareBillData()

      expect billData.country
        .toEqual defaults.country

      expect billData.payment_method
        .toEqual mockPaymentMethod.uid

      expect billData.shipping_method
        .toEqual mockShippingMethod.uid

  describe "Function: productData", ->

    it "should prepare the product data for the bill and the order requests", ->
      controller = createController()

      controller.quantities = mockQuantities

      productData = controller.productData()

      expect productData
        .toEqual [
          "Test product link,1"
          "Another product link,2"
        ]

  describe "Function: performBillRequest", ->

    it "should perform the bill request correctly", inject ($q, BillService) ->
      spyOn BillService, "refresh"
        .and.callFake ->
          deferred = $q.defer()
          deferred.resolve mockBill
          return deferred.promise

      controller = createController()

      spyOn controller, "saveDataInCache"
      spyOn controller, "updateDataFromCache"
      spyOn scope, "$broadcast"

      data = controller.prepareBillData()

      controller.performBillRequest data

      expect controller.overviewLoader
        .toBeTruthy()

      scope.$digest()

      expect controller.content
        .toEqual mockBill

      expect controller.saveDataInCache
        .toHaveBeenCalled()

      expect controller.updateDataFromCache
        .toHaveBeenCalled()

      expect controller.overviewLoader
        .toBeFalsy()

      expect scope.$broadcast
        .toHaveBeenCalledWith "billRefreshed"

    it "should handle the bill request failure correctly", inject ($q, BillService) ->
      spyOn BillService, "refresh"
        .and.callFake ->
          deferred = $q.defer()
          deferred.reject mockError
          return deferred.promise

      spyOn $.UIkit, "notify"

      controller = createController()

      spyOn scope, "$broadcast"

      controller.performBillRequest()

      expect controller.overviewLoader
        .toBeTruthy()

      scope.$digest()

      expect $.UIkit.notify
        .toHaveBeenCalled()

      expect controller.overviewLoader
        .toBeFalsy()

      expect scope.$broadcast
        .toHaveBeenCalledWith "billRefreshed"

  describe "Function: placeOrder", ->

    it "should place an order if form is valid", ->
      controller = createController()

      spyOn controller, "performOrderRequest"

      scope.billForm = {}
      scope.billForm.$valid = yes

      controller.placeOrder()

      expect controller.performOrderRequest
        .toHaveBeenCalled()

    it "should do nothing if form is invalid", ->
      controller = createController()

      spyOn controller, "performOrderRequest"

      scope.billForm = {}
      scope.billForm.$valid = no

      controller.placeOrder()

      expect controller.performOrderRequest
        .not.toHaveBeenCalled()

  describe "Function: performOrderRequest", ->

    it "should perform the order request correctly", inject ($q, BillService) ->
      spyOn BillService, "order"
        .and.callFake ->
          deferred = $q.defer()
          deferred.resolve mockOrder
          return deferred.promise

      spyOn BillService, "clear"

      controller = createController()

      controller.performOrderRequest()

      expect controller.placingOrder
        .toBeTruthy()

      expect scope.confirmBtnText
        .toEqual "PLACING_ORDER"

      scope.$digest()

      expect BillService.clear
        .toHaveBeenCalled()

      expect scope.confirmBtnText
        .toEqual "REDIRECTING"

    it "should handle the order request failure correctly", inject ($q, BillService) ->
      spyOn BillService, "order"
        .and.callFake ->
          deferred = $q.defer()
          deferred.reject mockError
          return deferred.promise

      spyOn $.UIkit, "notify"

      controller = createController()

      controller.performOrderRequest()

      expect controller.placingOrder
        .toBeTruthy()

      expect scope.confirmBtnText
        .toEqual "PLACING_ORDER"

      scope.$digest()

      expect controller.placingOrder
        .toBeFalsy()

      expect scope.confirmBtnText
        .toEqual "DEFAULT"

      expect $.UIkit.notify
        .toHaveBeenCalled()

  describe "Function: prepareOrderData", ->

    it "should prepare the data for the order request", ->
      controller = createController()

      controller.content = mockBill

      orderData = controller.prepareOrderData()

      expect orderData.products
        .toEqual mockBill.products

      expect orderData.consumer
        .toBeUndefined()

      expect orderData.payment_method
        .toEqual mockBill.payment_method.uid

      expect orderData.shipping_method
        .toEqual mockBill.shipping_method.uid
