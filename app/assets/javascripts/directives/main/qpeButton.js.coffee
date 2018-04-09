"use strict";

angular.module('Myav').directive("qpeButton", ['$compile', '$parse', ($compile, $parse) ->
  return {
    restrict: 'C'
    link: (scope, elm, attr) ->
      if attr.ngDisabled
        scope.$watch(attr.ngDisabled, (disabled) ->
          if disabled
            elm.addClass('disabled') 
          else
            elm.removeClass('disabled') 
        )
        $el = angular.element(elm);
        $el.bind('click', (event)->
          event.stopImmediatePropagation() if $el.attr('disabled')
        )
  }
])