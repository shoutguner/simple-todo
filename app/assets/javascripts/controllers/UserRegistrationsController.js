'use strict';

angular.module('controllers').controller('UserRegistrationsController', [
    '$scope',
    '$location',
    '$auth',
    'userService',
    function ($scope, $location, $auth, userService) {
        $scope.handleRegBtnClick = function(registrationForm) {
            var validationResult = userService.validateRegisterInput(registrationForm);
            if(validationResult.errors.length !== 0) {
                $scope.errors = validationResult.errors;
            }else{
                $auth.submitRegistration(registrationForm)
                    .then(function() {
                        $auth.submitLogin({
                            email: registrationForm.email,
                            password: registrationForm.password
                        });
                    });
            }
        };

        $scope.$on('auth:registration-email-error', function(ev, reason) {
            $scope.errors = reason.errors.full_messages;
        });
    }
]);