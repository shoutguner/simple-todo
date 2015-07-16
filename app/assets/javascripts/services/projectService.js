'use strict';

// for transfer new created project from ModalInstanceController to ProjectsController and project validation
services.service('projectService', [
    function() {
        // transfer project
        var project = [];
        var addProject = function(newProject) {
            project = newProject;
        };
        var getProject = function() {
            return project;
        };

        // validate project
        var validateProject = function(project) {
            var maxNameLength = 50;
            var result = {fail: false, errors: []};
            if(project.name.length < 1) {
                result.fail = true;
                result.errors.push("'Name can't be blank'");
                result.errors.push('Name is too short (minimum is 1 character)');
            }
            if(project.name.length > maxNameLength) {
                result.fail = true;
                result.errors.push('Name is too long (maximum is ' + maxNameLength + ' characters)');
            }
            return result;
        };
        return {
            addProject: addProject,
            getProject: getProject,
            validateProject: validateProject
        };
    }
]);