'use strict';

directives.directive('focusInput', [
    '$timeout',
    '$parse',
    function($timeout, $parse) {
        return {
            link: function(scope, element, attrs) {
                var model = $parse(attrs.focusInput);
                scope.$watch(model, function(value) {
                    if(value === true) {
                        $timeout(function() {
                            element[0].focus();
                            element[0].select();
                        }, 0, false);
                    }
                });
            }
        };
    }
]);