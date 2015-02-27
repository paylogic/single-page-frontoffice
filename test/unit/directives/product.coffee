"use strict"

describe "Directive: product", ->
  scope = null
  createController = null

  beforeEach ->
    module "app"

    module "partials/product.html"

    inject ($controller, $rootScope, $compile, _BillData_) ->
      elm = angular.element """
        <product content="content" quantities="quantities" placing-order="placingOrder" refresh-bill="refreshBill"></product>
      """

      scope = $rootScope.$new()

      scope.content =
        "_links":
          "self":
            "href": "productUri"
        "name":
          "en": "Test product"
        "subtitle":
          "en": "Test product subtitle"
        "price":
          "amount": "2.00"
          "currency": "EUR"
        "sold_out": no
        "sold_out_text":
          "en": "Sold out text"
        "max_per_order": 10

      scope.quantities =
        "productUri": 0

      scope.placingOrder = no

      scope.refreshBill = ->
        yes

      createController = ->
        $controller "ProductController",
          $scope: scope
          BillData: _BillData_

      $compile(elm)(scope)
      scope.$digest()

  describe "Controller: ProductController", ->

    it "should be initialized correctly", ->
      controller = createController()

      expect controller.showLoading
        .toBeFalsy()

    it "should toggle the visibility of price and loading elements when bill is refreshed", ->
      controller = createController()

      scope.quantities.productUri = 2

      scope.$broadcast "billRefreshed"

      expect controller.showPrice
        .toBeTruthy()

      expect controller.showLoading
        .toBeFalsy()

    describe "Function: increaseQty", ->

      it "should increase the product's quantity by 1 and refresh the bill", ->
        controller = createController()

        spyOn controller, "refreshBillData"

        controller.increaseQty()

        expect controller.showPrice
          .toBeFalsy()

        expect controller.showLoading
          .toBeTruthy()

        expect scope.quantities.productUri
          .toEqual 1

        expect controller.refreshBillData
          .toHaveBeenCalled()

      it "should create a notify when quantity is greater than max per order", ->
        controller = createController()

        scope.quantities.productUri = 10

        spyOn $.UIkit, "notify"

        controller.increaseQty()

        expect $.UIkit.notify
          .toHaveBeenCalled()

    describe "Function: decreaseQty", ->

      it "should decrease the product's quantity by 1, if quantity is > 0", ->
        controller = createController()

        scope.quantities.productUri = 4

        spyOn controller, "refreshBillData"

        controller.decreaseQty()

        expect controller.showPrice
          .toBeFalsy()

        expect scope.quantities.productUri
          .toEqual 3

        expect controller.showLoading
          .toBeTruthy()

        expect controller.refreshBillData
          .toHaveBeenCalled()

      it "should not change the product's quantity, if quantity is not > 0", ->
        controller = createController()

        scope.quantities.productUri = 0

        spyOn controller, "refreshBillData"

        controller.decreaseQty()

        expect controller.showPrice
          .toBeFalsy()

        expect scope.quantities.productUri
          .toEqual 0

        expect controller.showLoading
          .toBeFalsy()

        expect controller.refreshBillData
          .not.toHaveBeenCalled()

    describe "Function: refreshBillData", ->

      it "should update the quantities in the cache and refresh the bill", inject (BillData) ->
        controller = createController()

        spyOn scope, "refreshBill"

        scope.quantities.productUri = 2

        controller.refreshBillData()

        expect BillData.get "quantities"
          .toEqual
            "productUri": 2

        expect scope.refreshBill
          .toHaveBeenCalled()
