###
Datepicker Directive

Encapsulates the initialization of the UIkit datepicker component on the
selected element. It helps update the model value, each time the value
of the element change.

@example <input ng-model="" type="text" datepicker />
###

"use strict"

app = angular.module "app"

datepicker = ->
  restrict: "A"
  require: "ngModel"
  link: (scope, element, attrs, ngModelCtrl) ->
    # Initialize the UIkit datepicker component.
    $.UIkit.datepicker element,
      format: "YYYY-MM-DD"
      offsettop: 0

    # Change the model value whenever the value of the element change.
    $ element
      .on "change", ->
        ngModelCtrl.$setViewValue $(@).val()

    # Remove event listeners after scope is destroyed.
    scope.$on "$destroy", ->
      $ element
        .off "change"

app.directive "datepicker", datepicker
