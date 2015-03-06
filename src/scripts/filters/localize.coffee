###
Localize filter

Use this filter to translate the provided text in the current or active language.
###

"use strict"

app = angular.module "app"

app.filter "localize", (LanguageService) ->
  ###
  Return the text localized in the active or default language.

  @param text [object] The text resource that should be translated.

  @return [string|null] The translated text or null.
  ###
  (text) ->
    if text then text[LanguageService.activeLanguage()] or text[LanguageService.defaultLanguage()] else null
