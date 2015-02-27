exports.config = {

  specs: [
    'e2e/*.js'
  ],

  multiCapabilities: [{
    browserName: 'firefox'
  }, {
    browserName: 'chrome'
  }],

  baseUrl: 'http://localhost:8080'

};
