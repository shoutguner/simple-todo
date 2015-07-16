'use strict';

var controllers = angular.module('controllers', []);
var services = angular.module('services', ['ngResource']);
var directives = angular.module('directives', []);

var taskManager = angular.module('taskManager', [
    'templates',
    'ngRoute',
    'ui.bootstrap',
    'ngCookies',
    'ngResource',
    'ng-token-auth',
    'ngFileUpload',
    'controllers',
    'services',
    'directives'
]);

taskManager.config([
    '$routeProvider',
    function($routeProvider){
        $routeProvider
            .when('/sign_in', {
                templateUrl: 'sign_in.html',
                controller: 'UserSessionsController',
                resolve: {
                    auth: ['$auth', '$location', function($auth, $location) {
                        return $auth.validateUser().then(function() {
                            // redirect authorized users to the main page
                            $location.path('/todo');
                        }).catch(function() {
                            // redirect unauthorized users to the login page
                            $location.path('/sign_in');
                        });
                    }]
                }
            }).when('/sign_up', {
                templateUrl: 'sign_up.html',
                controller: 'UserRegistrationsController',
                resolve: {
                    auth: ['$auth', '$location', function($auth, $location) {
                        return $auth.validateUser().then(function() {
                            // redirect authorized users to the main page
                            $location.path('/todo');
                        }).catch(function() {
                            // redirect unauthorized users to the register page
                            $location.path('/sign_up');
                        });
                    }]
                }
            }).when('/todo', {
                templateUrl: 'todo.html',
                controller: 'ProjectsController',
                resolve: {
                    auth: ['$auth', '$location', function($auth, $location) {
                        return $auth.validateUser().catch(function() {
                            // redirect unauthorized users to the login page
                            $location.path('/sign_in');
                        });
                    }]
                }


            }).otherwise({
                resolve: {
                    auth: ['$auth', '$location', function($auth, $location) {
                        return $auth.validateUser().then(function() {
                            // redirect authorized users to the main page
                            $location.path('/todo');
                        }).catch(function() {
                            // redirect unauthorized users to the login page
                            $location.path('/sign_in');
                        });
                    }]
                }
            });
    }
]);

taskManager.config([
    '$authProvider',
    function($authProvider) {
        $authProvider.configure({
            storage: 'cookies',
            //default is '/api' which is wrong for our project
            apiUrl: '',
            authProviderPaths: {
                facebook: '/auth/facebook'
            }
        });
    }
]);

taskManager.run([
    '$rootScope',
    '$location',
    function($rootScope, $location) {
        $rootScope.$on('auth:logout-success', function() {
            $location.path('/sign_in');
        });

        $rootScope.$on('auth:login-success', function() {
            $location.path('/home');
        });
    }
]);