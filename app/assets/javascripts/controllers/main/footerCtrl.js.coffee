@FooterCtrl = ($scope, $rootScope, $state, $location) ->
  
  $scope.initialize = () ->
    $location.hash('')
    #userInfo.loadUserInfo() if authorization.isLoggedIn()

  $scope.tooggleFooterHeader = () ->
    if $rootScope.isDetail()
      $('.footer-bar').css('display', "none") 
      $('.mainnav-tab').css('position', "fixed")
      $('#main').css('position', "absolute")
      $('.toolbar-container').css('position', "fixed")
    else
      $('.footer-bar').css('display', "block")
      $('.mainnav-tab').css('position', "inherit")
      $('#main').css('position', "inherit")
      $('.toolbar-container').css('position', "inherit")

    if $state.includes('root.user')
      $('#main').addClass('main-center-align')
    else
      $('#main').removeClass('main-center-align')
      
  $scope.initialize()

  return true
  
@FooterCtrl.$inject = ['$scope', '$rootScope', '$state', '$location']
