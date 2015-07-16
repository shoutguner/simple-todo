'use strict';

services.factory('Tasks', [
    '$resource',
    function($resource){
        return $resource('/projects/:project_id/tasks.json', {}, {
            save: {method: 'POST', params: {project_id: '@project_id'}, isArray: false}
        });
    }
]);