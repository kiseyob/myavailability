"use strict";

angular.module('Myav').directive("qpeSelect", ['$compile', '$parse', ($compile, $parse) ->
  return {
    restrict: 'A'
    link: ($scope, elm, attr) ->
      if elm.is('select')
        elm.addClass('qpe-select')
        wrapper_elm = elm.wrap('<div class="qpe-select-wrapper"></div>')
  }
])