angular.module('Myav').directive 'pipe' , () ->
  return {
    template: "|"
    link: (scope, element, attributes) ->
      element.addClass('pipe');
  }