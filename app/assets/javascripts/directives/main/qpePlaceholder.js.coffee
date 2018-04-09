"use strict";

angular.module('Myav').directive("qpePlaceholder", ['$compile', '$parse', ($compile, $parse) ->
  return {
    restrict: 'A'
    scope:
      qpePlaceholder: '='
      desc: '='
      ngInvalid: '='
      errorMsg: '='
      errorClass: '@'
    link: (scope, elm, attr) ->
      scope.requiredString = () ->
        return '*' if (attr.required and !scope.isFilled()) #and !(scope.ngInvalid and !_.isEmpty(scope.errorMsg))
      
      scope.type = () ->
        attr.type
      
      scope.isFilled = () ->
        filled =  !_.isEmpty(elm.val())
        if elm.is('select')
          elm.attr('is-filled', filled)
        return filled
      
      scope.classes = () ->
        classes = []
        if scope.isFilled()
          classes.push('filled') 
          if scope.ngInvalid
            classes.push('error') 
            classes.push(scope.errorClass) if scope.errorClass?
        return classes
        
      scope.text = () ->
        if scope.ngInvalid and !_.isEmpty(scope.errorMsg) and scope.isFilled()
          return scope.errorMsg
        return scope.qpePlaceholder

      scope.target_id = attr.id
      if _.isEmpty(scope.target_id)
        scope.target_id = "select-"+Math.random().toString(36).slice(2)+Math.random().toString(36).slice(2)
        elm.attr('id', scope.target_id);
      if !elm.is('select') or !(attr.qpeSelect?)
        wrapper_elm = elm.wrap('<div class="qpe-placeholder-wrapper"></div>')
      code = '
<label for="{{target_id}}" class="qpe-placeholder unselectable" ng-class="classes()">{{text()}}
  <span class="reqd">{{requiredString()}}</span>
</label>
<div class="input-desc {{type()}}" ng-if="desc">{{desc}}</div>
'
      elm.parent().addClass('has-desc') if scope.desc
      elm.addClass('qpe-placeholder-input')
      new_elm = $(code).insertAfter(elm);
      $compile(new_elm)(scope)
  }
])