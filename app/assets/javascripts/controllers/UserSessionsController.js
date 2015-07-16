'use strict';

angular.module('controllers').controller('UserSessionsController', [
    '$scope',
    '$auth',
    '$cookies',
    'userService',
    function ($scope, $auth, $cookies, userService) {
        $scope.signIn = function(loginForm) {
            // frontend validation
            var validationResult = userService.validateLoginInput(loginForm);
            if(validationResult.error !== '') {
                // not passed frontend validation
                $scope.error = validationResult.error;
            }else{
                // passed frontend validation
                $scope.submitLogin(loginForm);
            }
        };

        $scope.$on('auth:login-error', function(ev, reason) {
            $scope.error = reason.errors[0];
        });

        $scope.signOut = function() {
            $auth.signOut()
                .then(function(response) {
                    // handle success response
                })
                .catch(function(response) {
                    // handle error response
                });
        };

        $scope.signInFacebook = function() {
            $auth.authenticate('facebook')
                .then(function(resp) {
                    // handle success
                })
                .catch(function(resp) {
                    // handle errors
                });
        };
    }
]);