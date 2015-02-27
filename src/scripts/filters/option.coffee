"use strict"

app = angular.module "app"

app.filter "option", ($filter) ->
  (method) ->
    # Example: Test Payment method (+ € 1.23 EUR).
    if method then "#{$filter('localize')(method.name)} (+ #{$filter('price')(method.costs)})" else null
