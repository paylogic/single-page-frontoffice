"use strict"

app = angular.module "app"

app.service "Cache", (DSCacheFactory) ->
  DSCacheFactory "cache"
