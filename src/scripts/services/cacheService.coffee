###
Cache Service

Wrap an instance of the DSCache Factory.
###

"use strict"

app = angular.module "app"

app.service "CacheService", (DSCacheFactory) ->
  DSCacheFactory "cache"
