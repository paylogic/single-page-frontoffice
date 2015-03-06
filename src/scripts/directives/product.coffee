###
Product Directive

The directive is used to display information about each product from an event
and exposes functionality like adding or removing product from the bill.
Products are displayed in event details page, after the user selects an event.

@example <div product content="" quantities="" placing-order="" refresh-bill=""></div>
###

"use strict"

app = angular.module "app"

product = ->
  restrict: "EA"
  replace: yes
  scope:
    content: "="
    quantities: "="
    placingOrder: "="
    refreshBill: "&"
  templateUrl: "partials/product.html"
  controller: "ProductController"
  controllerAs: "product"

app.directive "product", product
