###
Bill Controller

This controller is responsible for handling all the requests to the Bill and the
Order resources in the API. Every time the user selects a product or
a payment / shipping method, a request to the Bill is performed to get the
an overview for the order. After completing all the personal information and
submitting the form, a request to the Order is performed to get the redirect url
for the payment page.
###

"use strict"

app = angular.module "app"

class BillController
  @$inject = ["$scope", "$window", "$filter", "BillService", "defaults", "gender", "countries", "messages"]

  constructor: (@$scope, @$window, @$filter, @BillService, @defaults, @gender, @countries, @messages) ->
    # When event is fully loaded get the products and initialize the data.
    @$scope.$on "eventLoaded", (event, data) =>
      @products = data._embedded["shop:product"]
      @init()

    # Watch for any changes in consumer data.
    @$scope.$watchCollection "bill.consumer", (newValue, oldValue) =>
      if newValue isnt oldValue then @saveDataInCache()

  ###
  Initialize all the data that should be available to the controller.
  ###
  init: ->
    @$scope.confirmBtnText = "DEFAULT"
    @initQuantities()
    @updateDataFromCache()
    @refreshBillData()

  ###
  Initialize the quantities for not sold out products.

  @note If there is a saved quantity in the cache then use this.
  ###
  initQuantities: ->
    @quantities = {}
    for product in @products
      if not product.sold_out
        # Check if there is a cached product quantity.
        @quantities[product._links.self.href] = @BillService.get("quantities")?[product._links.self.href] or 0

  ###
  Update payment / shipping methods and consumer data from the cache.
  ###
  updateDataFromCache: ->
    @paymentMethod = @BillService.get("data")?.payment_method
    @shippingMethod = @BillService.get("data")?.shipping_method
    @consumer = @BillService.get "consumer"

  ###
  Save bill and consumer data in the cache.
  ###
  saveDataInCache: ->
    @BillService.put "data", @content
    @BillService.put "consumer", @consumer

  ###
  Refresh the bill data or delete the content.

  @note If there are no products selected, delete content.
  ###
  refreshBillData: ->
    data = @prepareBillData()
    if data.products.length > 0
      @performBillRequest data
    else
      @content = null

  ###
  Helper to prepare the data for the bill request.

  @return [object] Bill data.
  ###
  prepareBillData: ->
    data = {}
    data.products = @productData()
    data.country = @consumer?.country or @defaults.country
    data.payment_method = @paymentMethod?.uid
    data.shipping_method = @shippingMethod?.uid
    data

  ###
  Helper to construct the product data for the bill request.
  Iterate through quantities and construct the product strings.

  @return [array] Products array.

  @example ["productUri,2", "newProductUri,4"]
  ###
  productData: ->
    products = []
    for product, quantity of @quantities
      if quantity > 0
        products.push "#{product},#{quantity}"
    products

  ###
  Perform a request to the Bill resource in the API and fetch the new data.

  @param data [object] Bill data.
  ###
  performBillRequest: (data) ->
    @overviewLoader = yes
    @BillService.refresh data
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

  ###
  Continue with the order request if form is valid.
  ###
  placeOrder: ->
    if @$scope.billForm.$valid
      @performOrderRequest yes

  ###
  Perform a request to the Order resource in the API to complete the order.
  If the order was successful, clear the bill data from the cache and
  redirect user to the payment page.

  @param production [boolean] The working environment. Do not redirect when in testing.
  ###
  performOrderRequest: (production) ->
    @placingOrder = yes
    @$scope.confirmBtnText = "PLACING_ORDER"
    @BillService.order @prepareOrderData()
      .then (response) =>
        @BillService.clear()
        @$scope.confirmBtnText = "REDIRECTING"
        # Redirect only if it is not called by a unit test.
        if production then @$window.location.href = response._links.payment_url.href
      , (error) =>
        @placingOrder = no
        @$scope.confirmBtnText = "DEFAULT"
        $.UIkit.notify "<i class='uk-icon-warning uk-margin-small-right'></i>#{@$filter('localize')(@messages[error.data?.type])}",
          status: "danger"
          timeout: 3000

  ###
  Helper to prepare the order data for the request.

  @return [object] Order data.
  ###
  prepareOrderData: ->
    data = {}
    data.products = @content?.products
    data.consumer = @consumer
    if @consumer then data.consumer.ip = '192.168.1.1'
    data.payment_method = @content?.payment_method?.uid
    data.shipping_method = @content?.shipping_method?.uid
    data

app.controller "BillController", BillController
