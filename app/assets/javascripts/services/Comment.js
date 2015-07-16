'use strict';

services.factory('Comment', [
    '$resource',
    function($resource){
        return $resource('/projects/:project_id/tasks/:task_id/comments/:id.json', {}, {
            delete: {method: 'DELETE', params: {project_id: '@project_id', task_id: '@task_id', id: '@id'}, isArray: false}
        });
    }
]);