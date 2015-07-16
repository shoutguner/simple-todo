'use strict';

services.factory('Comments', [
    '$resource',
    function($resource){
        return $resource('/projects/:project_id/tasks/:task_id/comments.json', {}, {
            save: {method: 'POST', params: {project_id: '@project_id', task_id: '@task_id'}, isArray: false},
            query: {method: 'GET', params: {project_id: '@project_id', task_id: '@task_id'}, isArray: true}
        });
    }
]);