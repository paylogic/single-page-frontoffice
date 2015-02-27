"use strict"

app = angular.module "app", [
  "ngMessages"
  "ngAnimate"
  "ngRoute"
  "angular-data.DSCacheFactory"
  "angular-paylogic-shopping-service"
  "gettext"
]

app.config ($compileProvider, $routeProvider, DSCacheFactoryProvider, paylogicShoppingServiceConfigProvider) ->
  # Disable debug information for performance boosting.
  $compileProvider.debugInfoEnabled no

  $routeProvider
    .when "/event/:eventUid",
      templateUrl: "../partials/event.html"
      controller: "EventController as event"
    .when "/thank-you",
      templateUrl: "../partials/thank_you.html"
    .otherwise
      redirectTo: "/"
      templateUrl: "../partials/eventList.html"

  DSCacheFactoryProvider.setCacheDefaults
    maxAge: 900000
    cacheFlushInterval: 3600000
    deleteOnExpire: "aggressive"
    storageMode: "localStorage"

  paylogicShoppingServiceConfigProvider.set
    apiKey: ""
    apiSecret: ""
    baseURL: ""

app.constant "currencies",
  "EUR": "€"

app.constant "gender",
  "1":
    "en": "Male"
  "2":
    "en": "Female"

app.constant "countries",
  "NL":
    "en": "The Netherlands"

app.constant "languages",
  "en": "English"
  "nl": "Dutch"

app.constant "defaults",
  "docTitle":
    "en": "Paylogic SPA"
  "country": "NL"
  "language": "en"

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
    "en": "You have reached the maximum amount per order for this product."
  "PAYMENT_METHOD_NOT_APPLICABLE":
    "en": "The selected payment method cannot be used for this set of products and country."
  "SHIPPING_METHOD_NOT_APPLICABLE":
    "en": "The selected shipping method cannot be used for this set of products."
