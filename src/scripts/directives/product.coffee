"use strict"

app = angular.module "app"

class ProductController
  @$inject = ["$scope", "$filter", "BillData", "messages"]

  constructor: (@$scope, @$filter, @BillData, @messages) ->
    @showLoading = @$scope.quantities[@$scope.content._links.self.href] > 0

    @$scope.$on "billRefreshed", =>
      @showPrice = @$scope.quantities[@$scope.content._links.self.href] > 0
      @showLoading = no

  increaseQty: ->
    # It cannot exceeds the maximum per order.
    if @$scope.quantities[@$scope.content._links.self.href] is @$scope.content.max_per_order
      $.UIkit.notify "<i class='uk-icon-warning uk-margin-small-right'></i>#{@$filter('localize')(@messages['MAX_PER_ORDER_EXCEEDED'])}",
        status: "danger"
        timeout: 3000
      return
    @showPrice = no
    @showLoading = yes
    @$scope.quantities[@$scope.content._links.self.href]++
    @refreshBillData()

  decreaseQty: ->
    @showPrice = no
    if @$scope.quantities[@$scope.content._links.self.href] > 0
      @$scope.quantities[@$scope.content._links.self.href]--
      @showLoading = @$scope.quantities[@$scope.content._links.self.href] > 0
      @refreshBillData()

  refreshBillData: ->
    @BillData.put "quantities", @$scope.quantities
    @$scope.refreshBill()

app.controller "ProductController", ProductController

product = ->
  restrict: "E"
  replace: yes
  scope:
    content: "="
    quantities: "="
    placingOrder: "="
    refreshBill: "&"
  templateUrl: "partials/product.html"
  controller: "ProductController as product"

app.directive "product", product
