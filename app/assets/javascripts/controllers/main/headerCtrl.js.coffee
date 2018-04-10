@HeaderCtrl = ($rootScope, $scope) ->
  $scope.email = ""
  
  $scope.initialize = () ->
    $scope.$watch(() -> 
      $rootScope.email
    , () ->
      $scope.email = $rootScope.email
    )
    return

  $scope.initialize()


@HeaderCtrl.$inject = ['$rootScope', '$scope']