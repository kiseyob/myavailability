@ConfirmPopUpCtrl = ($scope) ->
  $scope.messages = []

  $scope.initialize = () ->
    $scope.messages = $scope.ngDialogData.msg.split("\n")
    $scope.cancel = $scope.ngDialogData.cancel or "Cancel"
    $scope.hideCancel = $scope.ngDialogData.hideCancel
    console.log($scope.hideCancel)
    $scope.ok = $scope.ngDialogData.ok or "OK"

    $scope.ngDialogData.title = $scope.ngDialogData.title
    $scope.ngDialogData.header = $scope.ngDialogData.header
    _.each($scope.messages, (message, index) -> $scope.messages[index] = message)

  $scope.initialize()

@ConfirmPopUpCtrl.$inject = ['$scope']