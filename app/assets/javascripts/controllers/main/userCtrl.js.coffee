@userCtrl = ($rootScope, $scope, $state, $stateParams, $q, $timeout, $sce, $window, $location, $http, ngDialog, clipboard) ->
  $scope.data =
    uid: 
      value: ''
      desc: 'Exchange ID'
    password:
      value: ''
      desc: 'Exchange Password'
    email: 
      value: ''
      desc: 'Email Address including @3dsystems.com'
    url:
      value: ''
      desc: 'MyAvailability URL'
  $scope.submit_btn_disable = true
  $scope.options = {
    defaultView: 'agendaWeek'
    allDaySlot: false
  }
  $scope.loading = false

  $scope.initialize = () ->
    $scope.uid = $stateParams.userId || $location.search().name
    if $state.current.name == 'root.show'
      if !_.isEmpty($scope.uid)
        $scope.loading = true
        $http.get("/api/users/#{$scope.uid}/events").success((data) ->
          start = data.working_hours.start_time + data.time_bias + moment().utcOffset()
          end = data.working_hours.end_time + data.time_bias + moment().utcOffset()
          min = 360 + data.time_bias + moment().utcOffset() #6am
          max = 1440 + data.time_bias + moment().utcOffset() #12am
          $scope.options = {
            defaultView: 'agendaWeek'
            allDaySlot: false
            businessHours: {
              dow: data.working_hours.day_of_week
              start: Math.floor(start/60)+":"+start%60
              end: Math.floor(end/60)+":"+end%60
            }
            validRange: {
              start: moment().format('YYYY-MM-DD')
              end: moment(moment() + moment.duration(1, 'months')).format('YYYY-MM-DD')
            }
            minTime: Math.floor(min/60)+":"+min%60+":00",
            maxTime: Math.floor(max/60)+":"+max%60+":00",
            height: "auto"
          }

          $scope.events = _.map(data.events, (e) ->
            {
              title: e.type
              start: moment(e.start_time)
              end: moment(e.end_time)
              color: '#5f6dd0'
            }
          )
          $scope.loading = false
        ).error((error, code) ->
          $scope.loading = false
          $timeout(()->
            $location.path("/setup").search({name: $scope.uid})
          , 1)
        )
      else
        $state.go('root.setup')
    else if $state.current.name == 'root.setup'
      $scope.data.uid.value = $scope.uid
      if !_.isEmpty($scope.uid)
        $scope.loading = true
        $http.get("/api/users/#{$scope.uid}").success((data) ->
          $scope.data.email.value = data.email
        )
      $scope.$watch(() -> $scope.onChange())
    return

  $scope.onChange = () ->
    if $scope.setup_form.$submitted or !_.isEmpty($scope.setup_form.$error)
      $scope.submit_btn_disable = true
    else
      $scope.submit_btn_disable = false
      
    $scope.updateURL()

    return $scope.submit_btn_disable

  $scope.updateURL = () ->
    if $scope.data.uid.value
      $scope.data.url.value = "https://#{$location.host()}/show/#{$scope.data.uid.value}"
    else
      $scope.data.url.value = ""

  $scope.submit = () ->
    $scope.setup_form.$submitted = true
    $scope.onChange()
    if clipboard.supported
      clipboard.copyText($scope.data.url.value)
    
    data = {
      name: $scope.data.uid.value
      password: $scope.data.password.value
      email: $scope.data.email.value
    }
    $http.post('/api/users', data).success(() ->
      $state.go('root.show', {userId: $scope.data.uid.value})
    ).error((error) ->

    )

  $scope.initialize()

@userCtrl.$inject = ['$rootScope', '$scope', '$state', '$stateParams', '$q', '$timeout', '$sce', '$window', '$location', '$http', 'ngDialog', 'clipboard']
