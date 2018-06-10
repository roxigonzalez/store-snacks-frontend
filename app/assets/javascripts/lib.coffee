do ->

  authInterceptor = (API, auth) ->
    {
      request: (config) ->
        token = auth.getToken()
        if config.url.indexOf(API) == 0 and token
          config.headers.Authorization = 'Bearer ' + token
        console.log config.headers.Authorization
        config
      response: (res) ->
        if res.config.url.indexOf(API) == 0 and res.data.auth_token
          auth.saveToken res.data.auth_token
        res

    }

  authService = ($window) ->
    srvc = this

    srvc.parseJwt = (token) ->
      base64Url = token.split('.')[1]
      base64 = base64Url.replace('-', '+').replace('_', '/')
      JSON.parse $window.atob(base64)

    srvc.saveToken = (token) ->
      $window.localStorage['jwtToken'] = token
      return

    srvc.logout = (token) ->
      $window.localStorage.removeItem 'jwtToken'
      return

    srvc.getToken = ->
      $window.localStorage['jwtToken']

    srvc.isAuthed = ->
      token = srvc.getToken()
      if token
        params = srvc.parseJwt(token)
        Math.round((new Date).getTime() / 1000) <= params.exp
      else
        false

    return

  userService = ($http, API, auth) ->
    srvc = this
    srvc.login = (username, password) ->
      $http.post "#{API}/auth/login?email=#{username}&password=#{password}"
    return

  MainCtrl = (user, auth) ->
    self = this

    handleRequest = (res) ->
      token = if res.data then res.data.auth_token else null
      self.message = res.data.message
      return

    self.login = ->
      user.login(self.username, self.password).then handleRequest, handleRequest
      return

    self.logout = ->
      auth.logout and auth.logout()
      return

    self.isAuthed = ->
      if auth.isAuthed then auth.isAuthed() else false

    return

  angular.module('app', []).factory('authInterceptor', authInterceptor).service('user', userService).service('auth', authService).constant('API', 'https://snacks-market-api-test.herokuapp.com').config(($httpProvider) ->
    $httpProvider.interceptors.push 'authInterceptor'
    return
  ).controller 'Main', MainCtrl
  return
