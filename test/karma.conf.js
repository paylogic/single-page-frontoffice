module.exports = function (config) {

  config.set({

    basePath: '../',

    files: [
      'app/vendor/angular/angular.js',
      'app/vendor/angular-messages/angular-messages.js',
      'app/vendor/angular-route/angular-route.js',
      'app/vendor/angular-cache/dist/angular-cache.js',
      'app/vendor/angular-resource/angular-resource.js',
      'app/vendor/angular-base64/angular-base64.js',
      'app/vendor/angular-mocks/angular-mocks.js',
      'app/vendor/angular-gettext/dist/angular-gettext.js',
      'app/vendor/angular-paylogic-shopping-service/angular.paylogic.shopping.service.js',
      'app/vendor/jquery/dist/jquery.js',
      'app/vendor/uikit/js/uikit.js',
      'app/vendor/uikit/js/components/datepicker.js',
      'app/vendor/uikit/js/components/form-select.js',
      'app/vendor/uikit/js/components/notify.js',
      'app/scripts/**/*.js',
      'test/unit/**/*.coffee',
      'src/partials/*.html'
    ],

    preprocessors: {
      'test/**/*.coffee': ['coffee'],
      'src/partials/*.html': ['ng-html2js']
    },

    plugins: [
      'karma-phantomjs-launcher',
      'karma-jasmine',
      'karma-ng-html2js-preprocessor',
      'karma-coffee-preprocessor'
    ],

    autoWatch: true,

    captureTimeout: 10000,

    frameworks: ['jasmine'],

    browsers: ['PhantomJS'],

    junitReporter: {
      outputFile: 'test_out/unit.xml',
      suite: 'unit'
    },

    coffeePreprocessor: {
      options: {
        bare: true,
        sourceMap: false
      },
      transformPath: function (path) {
        return path.replace(/\.coffee$/, '.js');
      }
    },

    ngHtml2JsPreprocessor: {
      stripPrefix: 'src/'
    }

  });

};
