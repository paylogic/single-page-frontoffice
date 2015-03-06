"use strict"

describe "Service: LanguageService", ->
  LanguageService = null
  CacheService = null
  gettextCatalog = null
  defaults = null
  languages = null

  beforeEach ->
    module "app"

    inject (_LanguageService_, _CacheService_, _gettextCatalog_, _defaults_, _languages_) ->
      LanguageService = _LanguageService_
      CacheService = _CacheService_
      gettextCatalog = _gettextCatalog_
      defaults = _defaults_
      languages = _languages_

  afterEach ->
    CacheService.destroy()

  describe "Function: languages", ->

    it "should return the application languages", ->
      result = LanguageService.languages()

      expect result
        .toEqual
          "en": "English"
          "nl": "Dutch"

  describe "Function: defaultLanguage", ->

    it "should return the default language", ->
      result = LanguageService.defaultLanguage()

      expect result
        .toEqual "en"

  describe "Function: activeLanguage", ->

    it "should return the language title or the language code", ->
      result = LanguageService.activeLanguage yes

      expect result
        .toEqual "English"

      result = LanguageService.activeLanguage()

      expect result
        .toEqual "en"

  describe "Function: setLanguage", ->

    it "should set the selected language", ->
      spyOn CacheService, "put"
      spyOn gettextCatalog, "setCurrentLanguage"

      LanguageService.setLanguage "nl"

      expect CacheService.put
        .toHaveBeenCalledWith "language", "nl"

      expect gettextCatalog.setCurrentLanguage
        .toHaveBeenCalledWith "nl"

    it "should set the language from the CacheService if no language is provided", ->
      spyOn gettextCatalog, "setCurrentLanguage"

      CacheService.put "language", "gr"

      LanguageService.setLanguage()

      expect gettextCatalog.setCurrentLanguage
        .toHaveBeenCalledWith "gr"

    it "should set the default language if no language is provided and there is no cached language", ->
      spyOn LanguageService, "defaultLanguage"

      LanguageService.setLanguage()

      expect LanguageService.defaultLanguage
        .toHaveBeenCalled()
