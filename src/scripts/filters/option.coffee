###
Option filter

Use this filter to format the select list's options for payment and shipping methods.

@example Test Payment method (+ € 1.23 EUR)
###

"use strict"

app = angular.module "app"

app.filter "option", ($filter) ->
  ###
  Format a select list's options for the provided payment or shipping method.

  @param method [object] A payment or shipping method.

  @return [string|null] The formatted option or null.
  ###
  (method) ->
    if method
      if $filter('price')(method.costs)
        "#{$filter('localize')(method.name)} (+ #{$filter('price')(method.costs)})"
      else
        $filter('localize')(method.name)}
    else
      null
