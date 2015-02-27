"use strict"

describe "Directive: datepicker", ->
  scope = null
  elm = null

  changeInputValue = (element, value) ->
    element.val value
    element.trigger "change"
    scope.$digest()

  beforeEach ->
    module "app"

    inject ($rootScope, $compile) ->
      elm = angular.element """
        <input ng-model="result" datepicker />
      """

      spyOn $.UIkit, "datepicker"

      scope = $rootScope.$new()
      $compile(elm)(scope)
      scope.$digest()

  it "should be correctly initialized", ->
    expect $.UIkit.datepicker
      .toHaveBeenCalled()

    expect $.UIkit.datepicker.calls.count()
      .toEqual 1

    expect $.UIkit.datepicker
      .toHaveBeenCalledWith elm,
        format: "YYYY-MM-DD"
        offsettop: 0

  it "should change the model value whenever the input's value change", ->
    expect scope.result
      .toBeUndefined()

    changeInputValue $(elm), "2014-11-01"

    expect scope.result
      .toEqual "2014-11-01"

  it "should remove any event listeners after scope is destroyed", ->
    spyOn $.fn, "off"

    scope.$destroy()

    expect $.fn.off
      .toHaveBeenCalled()
