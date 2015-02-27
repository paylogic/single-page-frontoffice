"use strict"

describe "Filter: localize", ->
  filter = null
  LanguageService = null

  mockText =
    "en": "Text in English"
    "nl": "Text in Dutch"

  beforeEach ->
    module "app"

    inject ($filter, _LanguageService_) ->
      filter = $filter
      LanguageService = _LanguageService_

  it "exists", ->
    expect filter "localize"
      .not.toBeNull()

  it "should return the text localized in the active language", ->
    result = filter("localize")(mockText)

    expect result
      .toEqual "Text in English"

    LanguageService.setLanguage "nl"

    result = filter("localize")(mockText)

    expect result
      .toEqual "Text in Dutch"

  it "should return the text in the default language if it does not exist in the active language", ->
    LanguageService.setLanguage "gr"

    result = filter("localize")(mockText)

    expect result
      .toEqual "Text in English"

  it "should return null if no text is provided", ->
    result = filter("localize")("")

    expect result
      .toBeNull()
