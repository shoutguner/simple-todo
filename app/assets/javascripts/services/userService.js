'use strict';

// user's login/register input validation
services.service('userService', [
    function() {
        var maxPasswordLength = 72;
        var validateLogin = function(login) {
            var re = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/;
            return re.test(login);
        };

        // validate user's login input
        var validateLoginInput = function(loginForm) {
            var result = {error: ''};
            if(!validateLogin(loginForm.email)) {
                result.error = 'Invalid login credentials. Please try again.'
            }else{
                if(loginForm.password.length < 8 || loginForm.password.length > maxPasswordLength) {
                    result.error = 'Invalid login credentials. Please try again.'
                }
            }
            return result;
        };

        // validate user's registration input
        var validateRegisterInput = function(registrationForm) {
            var result = {errors: []};
            if(!validateLogin(registrationForm.email)) {
                result.errors.push('Email is not an email.');
            }
            if(registrationForm.password.length < 8) {
                result.errors.push('Password is too short (minimum is 8 characters)');
            }
            if(registrationForm.password.length > maxPasswordLength) {
                result.errors.push('Password is too long (maximum is ' + maxPasswordLength + ' characters)');
            }
            if(registrationForm.password_confirmation !== registrationForm.password) {
                result.errors.push("Password confirmation doesn't match Password");
            }
            return result;
        };

        return {
            validateLoginInput: validateLoginInput,
            validateRegisterInput: validateRegisterInput
        };
    }
]);