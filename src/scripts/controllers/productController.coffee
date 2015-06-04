###
Product Controller

Provides functionality for the Product Directive. It is used for increasing
and decreasing product's quantity in the bill. Every time we add or
remove a product, we update the quantities in the cache and refreshing
the bill data.
###

"use strict"

app = angular.module "app"

class ProductController
  @$inject = ["$scope", "$filter", "BillService", "messages"]

  constructor: (@$scope, @$filter, @BillService, @messages) ->
    @showLoading = @$scope.quantities[@$scope.content._links.self.href] > 0

    # Every time the bill is done refreshing, toggle the price and loading display.
    @$scope.$on "billRefreshed", =>
      @showPrice = @$scope.quantities[@$scope.content._links.self.href] > 0
      @showLoading = no

  ###
  Increase the quantity of the product and refresh the bill data.
  ###
  increaseQty: ->
    # It cannot exceeds the maximum per order. Show a notification.
    if @countQuantities() is @$scope.content.max_per_order
      $.UIkit.notify "<i class='uk-icon-warning'></i> #{@$filter('localize')(@messages['MAX_PER_ORDER_EXCEEDED'])}",
        status: "danger"
        timeout: 3000
      return
    @showPrice = no
    @showLoading = yes
    @$scope.quantities[@$scope.content._links.self.href]++
    @refreshBillData()

  ###
  Decrease the quantity of the product and refresh the bill data.
  The quantity cannot be a negative number.
  ###
  decreaseQty: ->
    @showPrice = no
    if @$scope.quantities[@$scope.content._links.self.href] > 0
      @$scope.quantities[@$scope.content._links.self.href]--
      @showLoading = @$scope.quantities[@$scope.content._links.self.href] > 0
      @refreshBillData()

  ###
  Refresh the bill data and save the new quantities in the cache.
  ###
  refreshBillData: ->
    @BillService.put "quantities", @$scope.quantities
    @$scope.refreshBill()

  ###
  Count the total amount of products added in the bill.

  @return [number] The amount of products.
  ###
  countQuantities: ->
    count = 0
    for key, value of @$scope.quantities
      count += value
    count

app.controller "ProductController", ProductController
