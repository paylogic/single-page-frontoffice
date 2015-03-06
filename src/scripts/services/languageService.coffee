###
Language Service

A service to provide multilanguage functionality.
###

"use strict"

app = angular.module "app"

app.service "LanguageService", (CacheService, gettextCatalog, defaults, languages) ->
  ###
  Get all the available languages from the main configuration.

  @return [object] An object with languages.
  ###
  languages: ->
    languages

  ###
  Get the default language.

  @return [string] The default language string.
  ###
  defaultLanguage: ->
    defaults.language

  ###
  Get the title or the code of the active language.

  @param getTitle [boolean] True if we want the title, false for the code.

  @return [string] Language title or code string.
  ###
  activeLanguage: (getTitle) ->
    code = gettextCatalog.getCurrentLanguage()
    if getTitle then languages[code] else code

  ###
  Set the provided language as the active language.

  @param language [string] The language code that we want to set as active.
  ###
  setLanguage: (language) ->
    if language
      CacheService.put "language", language
    gettextCatalog.setCurrentLanguage language or CacheService.get("language") or @defaultLanguage()
