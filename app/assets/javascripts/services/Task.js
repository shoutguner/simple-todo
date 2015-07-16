'use strict';

services.factory('Task', [
    '$resource',
    function($resource){
        return $resource('/projects/:project_id/tasks/:id.json', {}, {
            delete: {method: 'DELETE', params: {project_id: '@project_id', id: '@id'}, isArray: false},
            update_multiple: {method: 'PUT', params: {project_id: '@project_id', id: '@id'}, isArray: true},
            update_one: {method: 'PUT', params: {project_id: '@project_id', id: '@id'}, isArray: false}
        });
    }
]);