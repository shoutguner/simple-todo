'use strict';

angular.module('controllers').controller('ModalInstanceController', [
    '$scope',
    '$modalInstance',
    'projectService',
    'Project',
    function ($scope, $modalInstance, projectService, Project) {
        // default name
        $scope.newProjectName = 'New TODO';

        $scope.addProject = function() {
            $scope.addProjectFail = false;
            // frontend project validation
            var validationResult = projectService.validateProject({name: $scope.newProjectName});
            $scope.addProjectFail = validationResult.fail;
            if(!$scope.addProjectFail) {
                // passed frontend validation
                $scope.project = new Project({name: $scope.newProjectName});
                $scope.project.$save(function(response) {
                    if(response.errors) {
                        // not passed backend validation
                        $scope.addProjectFail = true;
                        $scope.errors = response.errors
                    }else{
                        // passed backend validation
                        projectService.addProject(response);
                        $modalInstance.close($scope.newProjectName);
                    }
                }, function(error) {
                    //handle request error
                    $scope.addProjectFail = true;
                    $scope.errors.push('Server error, please try reload page now or later, maybe it will be gone.');
                });
            }else{
                // not passed frontend validation
                $scope.errors = $scope.addProjectFail = validationResult.errors;
            }
        };

        $scope.cancel = function () {
            $modalInstance.dismiss('cancel');
        };
    }]);