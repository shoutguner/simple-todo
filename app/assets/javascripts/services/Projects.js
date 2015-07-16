'use strict';

services.factory('Projects', [
    '$resource',
    function($resource){
        return $resource('/projects.json', {}, {
            query: {method: 'GET', params: {}, isArray: true}
        });
    }
]);