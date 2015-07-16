'use strict';

directives.directive('download', [
    '$cookies',
    function($cookies) {
        return {
            restrict: 'AE',
            scope: {
                url: '=fileUrl'
            },
            template: '<form action="{{::url}}" method="get" target="_self">' +
                      '<input type="hidden" name="XSRF-TOKEN" value="{{::xsrf}}">' +
                      '<input type="hidden" name="access-token" value="{{::token}}">' +
                      '<input type="hidden" name="client" value="{{::client}}">' +
                      '<input type="hidden" name="expiry" value="{{::expiry}}">' +
                      '<input type="hidden" name="uid" value="{{::uid}}">' +
                      '<button type="submit" class="btn-link">{{::url.substring(url.lastIndexOf("/")+1)}}</button>' +
                      '</form>',
            link: function(scope) {
                scope.xsrf = $cookies.get('XSRF-TOKEN');
                var authJson = JSON.parse($cookies.get('auth_headers'));
                scope.token = authJson['access-token'];
                scope.client = authJson['client'];
                scope.expiry = authJson['expiry'];
                scope.uid = authJson['uid'];
            }
        };
    }
]);