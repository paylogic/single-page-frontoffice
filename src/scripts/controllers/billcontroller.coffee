"use strict"

app = angular.module "app"

class BillController
  @$inject = ["$scope", "$window", "$filter", "BillData", "defaults", "gender", "countries", "messages"]

  constructor: (@$scope, @$window, @$filter, @BillData, @defaults, @gender, @countries, @messages) ->
    # When event is fully loaded get the products and initialize the data.
    @$scope.$on "eventLoaded", (event, data) =>
      @products = data._embedded["shop:product"]
      @init()

    # Watch for any changes in consumer data.
    @$scope.$watchCollection "bill.consumer", (newValue, oldValue) =>
      if newValue isnt oldValue then @saveDataInCache()

  init: ->
    @$scope.confirmBtnText = "DEFAULT"
    @initQuantities()
    @updateDataFromCache()
    @refreshBillData()

  initQuantities: ->
    @quantities = {}
    for product in @products
      if not product.sold_out
        # Check if there is a cached product quantity.
        @quantities[product._links.self.href] = @BillData.get("quantities")?[product._links.self.href] or 0

  updateDataFromCache: ->
    @paymentMethod = @BillData.get("data")?.payment_method
    @shippingMethod = @BillData.get("data")?.shipping_method
    @consumer = @BillData.get "consumer"

  saveDataInCache: ->
    @BillData.put "data", @content
    @BillData.put "consumer", @consumer

  refreshBillData: ->
    data = @prepareBillData()
    if data.products.length > 0
      @performBillRequest data
    else
      @content = null

  prepareBillData: ->
    data = {}
    data.products = @productData()
    data.country = @consumer?.country or @defaults.country
    data.payment_method = @paymentMethod?.uid
    data.shipping_method = @shippingMethod?.uid
    data

  productData: ->
    # Construct the product data for the bill request.
    products = []
    for product, quantity of @quantities
      if quantity > 0
        products.push "#{product},#{quantity}"
    products

  performBillRequest: (data) ->
    @overviewLoader = yes
    @BillData.refresh data
      .then (response) =>
        @content = response
        @saveDataInCache()
        @updateDataFromCache()
      , (error) =>
        $.UIkit.notify "<i class='uk-icon-warning uk-margin-small-right'></i>#{@$filter('localize')(@messages[error.data?.type])}",
          status: "danger"
          timeout: 3000
      .finally =>
        @overviewLoader = no
        @$scope.$broadcast "billRefreshed"

  placeOrder: ->
    if @$scope.billForm.$valid
      @performOrderRequest yes

  performOrderRequest: (production) ->
    @placingOrder = yes
    @$scope.confirmBtnText = "PLACING_ORDER"
    @BillData.order @prepareOrderData()
      .then (response) =>
        @BillData.clear()
        @$scope.confirmBtnText = "REDIRECTING"
        # Redirect only if it is not called by a unit test.
        if production then @$window.location.href = response._links.payment_url.href
      , (error) =>
        @placingOrder = no
        @$scope.confirmBtnText = "DEFAULT"
        $.UIkit.notify "<i class='uk-icon-warning uk-margin-small-right'></i>#{@$filter('localize')(@messages[error.data?.type])}",
          status: "danger"
          timeout: 3000

  prepareOrderData: ->
    data = {}
    data.products = @content?.products
    data.consumer = @consumer
    data.consumer?.ip = "192.168.1.1"
    data.payment_method = @content?.payment_method?.uid
    data.shipping_method = @content?.shipping_method?.uid
    data

app.controller "BillController", BillController
