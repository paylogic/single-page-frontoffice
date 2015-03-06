###
Main application file

This file is responsibe for all the configuration settings, like setting dependencies,
default values, languages, currencies, configure the providers etc.
###

"use strict"

app = angular.module "app", [
  "ngMessages"
  "ngRoute"
  "angular-data.DSCacheFactory"
  "angular-paylogic-shopping-service"
  "gettext"
]

app.config ($compileProvider, $routeProvider, DSCacheFactoryProvider, paylogicShoppingServiceConfigProvider) ->
  # Disable debug information for performance boosting.
  $compileProvider.debugInfoEnabled no

  # Set the routes for the application.
  $routeProvider
    .when "/event/:eventUid",
      templateUrl: "../partials/event.html"
      controller: "EventController"
      controllerAs: "event"
    .when "/thank-you",
      templateUrl: "../partials/thank_you.html"
    .otherwise
      redirectTo: "/"
      templateUrl: "../partials/event_list.html"

  # Set some cache defaults.
  DSCacheFactoryProvider.setCacheDefaults
    maxAge: 900000
    cacheFlushInterval: 3600000
    deleteOnExpire: "aggressive"
    storageMode: "localStorage"

  # Configuration settings to communicate with the API.
  # Only Paylogic can provide you with an API key, secret and base url.
  paylogicShoppingServiceConfigProvider.set
    apiKey: ""
    apiSecret: ""
    baseURL: ""

# Supported currencies. Add here any more currencies that you wish to support.
app.constant "currencies",
  "EUR": "€"

# Available countries for selection.
app.constant "countries",
  "NL":
    "en": "The Netherlands"

# Supported languages. Add here any more languages that you wish to support.
app.constant "languages",
  "en": "English"
  "nl": "Dutch"

# Gender mapper.
app.constant "gender",
  "1":
    "en": "Male"
    "nl": "Mannelijk"
  "2":
    "en": "Female"
    "nl": "Vrouwelijk"

# Set some defaults.
app.constant "defaults",
  "docTitle":
    "en": "Paylogic SPA"
  "country": "NL"
  "language": "en"

# Mapper to better communicate the response messages from the API to the user.
app.constant "messages",
  "UNKNOWN_ERROR":
    "en": "An error occured. Please try again."
  "MULTIPLE_EVENTS":
    "en": "Please only select products from a single event."
  "PROFILE_MISSING":
    "en": "Profile information is missing."
  "NON_SEPARATELY_SALEABLE_PRODUCT":
    "en": "The products you selected are not separately sellable."
  "NOT_ON_SALE":
    "en": "Product is not on sale."
  "PAYMENT_METHOD_MISSING":
    "en": "Payment method is missing"
  "PRODUCT_NOT_AVAILABLE":
    "en": "Product is not available."
  "INSUFFICIENT_PRODUCTS":
    "en": "Insufficient number of products."
  "MAX_PER_ORDER_EXCEEDED":
    "en": "You have reached the maximum amount of products per order."
  "PAYMENT_METHOD_NOT_APPLICABLE":
    "en": "The selected payment method cannot be used for this set of products and country."
  "SHIPPING_METHOD_NOT_APPLICABLE":
    "en": "The selected shipping method cannot be used for this set of products."
