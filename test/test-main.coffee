tests = (file for file of window.__karma__.files when /Spec\.js$/.test file)

requirejs.config {
    baseUrl: '/base/src',

    paths: {
        'jquery': '../bower_components/jquery/jquery'
    },

    deps: tests,

    callback: window.__karma__.start
}

