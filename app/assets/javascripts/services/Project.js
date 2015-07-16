'use strict';

services.factory('Project', [
    '$resource',
    function($resource){
        return $resource('/projects/:id.json', {}, {
            update: {method: 'PUT', params: {id: '@id'}, isArray: false},
            delete: {method: 'DELETE', params: {id: '@id'}, isArray: true}
        });
    }
]);