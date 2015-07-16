'use strict';

controllers.controller('ProjectsController', [
    '$scope',
    'projectService',
    'Projects',
    'Project',
    function($scope, projectService, Projects, Project) {

        $scope.reloadProjects = function() {
            $scope.projects = Projects.query();
        };

        // initial load
        $scope.reloadProjects();
        $scope.fail = false;

        // projects operations -----------------------------------------------------------------------------------------
        $scope.saveProject = function(project) {
            $scope.fail = false;
            // frontend project validation
            var validationResult = projectService.validateProject(project);
            $scope.fail = validationResult.fail;
            if(!$scope.fail) {
                //passed frontend validation
                var edited_project = new Project({id: project.id, name: project.name});
                Project.update(edited_project, function(response) {
                    if(response.errors) {
                        //not passed backend validation
                        $scope.fail = true;
                        project.errors = response.errors;
                    }else{
                        $scope.fail = project.editable = false;
                        project = response;
                    }
                }, function(error) {
                    if(error.status >= 404) {
                        $scope.reloadProjects();
                    }
                });
            }else{
                // not passed frontend validation
                project.errors = validationResult.errors;
            }
        };

        $scope.removeProject = function(project) {
            var removed_project = new Project({id: project.id});
            Project.delete(removed_project, function(response) {
                if(response.errors) {
                    $scope.fail = true;
                    project.errors = response.errors;
                }else{
                    $scope.fail = false;
                    // переделать чтоб не обновлять аж весь скоуп
                    $scope.projects.splice($scope.projects.indexOf(project), 1);
                }
            }, function(error) {
                if(error.status >= 404) {
                    $scope.reloadProjects();
                }
            });
        };

        // watch added by ModalInstanceController new project
        $scope.$watch(function() { return projectService.getProject(); }, function(project) {
            if(project.length != 0) {
                $scope.projects.push(project);
            }
        });
        // end projects operations -------------------------------------------------------------------------------------
    }]);