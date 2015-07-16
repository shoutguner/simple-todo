'use strict';

directives.directive('fileRead', [
    function () {
        return {
            scope: {
                fileRead: '='
            },
            link: function (scope, element) {
                element.bind('change', function (changeEvent) {
                    scope.$apply(function () {
                        scope.fileRead = changeEvent.target.files;
                    });
                });
            }
        }
    }
]);