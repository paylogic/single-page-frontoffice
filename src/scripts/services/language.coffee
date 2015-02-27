"use strict"

app = angular.module "app"

app.service "LanguageService", (Cache, gettextCatalog, defaults, languages) ->
  languages: ->
    languages

  defaultLanguage: ->
    defaults.language

  activeLanguage: (getTitle) ->
    # Get the language title or the language code.
    code = gettextCatalog.getCurrentLanguage()
    if getTitle then languages[code] else code

  setLanguage: (language) ->
    if language
      Cache.put "language", language
    gettextCatalog.setCurrentLanguage language or Cache.get("language") or @defaultLanguage()
