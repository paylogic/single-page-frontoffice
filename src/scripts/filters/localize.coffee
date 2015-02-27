"use strict"

app = angular.module "app"

app.filter "localize", (LanguageService) ->
  (text) ->
    # Return the text localized in the active language
    # or the text in the default language.
    if text then text[LanguageService.activeLanguage()] or text[LanguageService.defaultLanguage()] else null
