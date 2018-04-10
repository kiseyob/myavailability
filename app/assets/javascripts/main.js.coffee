# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require_self
#= require_tree ./services/main
#= require_tree ./filters/main
#= require_tree ./controllers/main
#= require_tree ./directives/main

Myav = angular.module('Myav', ['ui.router', 'ui.bootstrap', 'ngAnimate', 'ngDialog', 'templates', 'angularSpinner', 'ngOnload', 'angular-fullcalendar', 'angular-clipboard'])

Myav.run(['$rootScope', '$state', '$stateParams', '$window', '$location', '$document', '$timeout', 'ngDialog', ($rootScope, $state, $stateParams, $window, $location, $document, $timeout, ngDialog) ->
    $rootScope.$state = $state
    $rootScope.$stateParams = $stateParams

    $rootScope.initialize = () ->
      

    $rootScope.back = () ->
      $window.history.back();

    $rootScope.$on('$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
      return
    )

    $rootScope.initialize()
])

Myav.config(['$controllerProvider', ($controllerProvider) ->
  $controllerProvider.allowGlobals()
])

Myav.config(['$locationProvider', ($locationProvider) ->
  $locationProvider.html5Mode({
    enabled: true
    requireBase: false
  })
])

Myav.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider
    .when('/show', '/setup')
    .otherwise('/setup')

  $stateProvider
    .state('root', {
      abstract: true,
      views: {
        '': {
          templateUrl: 'main_container.html'
        },
        'header@root': {
          templateUrl: 'header.html',
          controller: 'HeaderCtrl'
        }
      }
    })
    .state('root.show', {
      url: '/show/{userId}',
      views: {
        'container@root': {
          templateUrl: 'show.html'
          controller: 'userCtrl'
        }
      }
    })
    .state('root.setup', {
      url: '/setup',
      views: {
        'container@root': {
          templateUrl: 'setup.html',
          controller: 'userCtrl'
        }
      }
    })

])

Myav.config(['$httpProvider', (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])

Myav.config(['ngDialogProvider', (ngDialogProvider) ->
  ngDialogProvider.setDefaults({
    className: 'ngdialog-theme-default',
    closeByDocument: true,
    closeByEscape: true,
    closePrevious: true
  })
])


