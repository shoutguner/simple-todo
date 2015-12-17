'use strict';

angular.module('controllers').controller('ProjectModalsController', [
    '$scope',
    '$uibModal',
    function ($scope, $uibModal) {
    $scope.newProjectName = "New TODO";
    $scope.animationsEnabled = true;

    $scope.open = function(size) {
        var modalInstance = $uibModal.open({
            animation: $scope.animationsEnabled,
            templateUrl: 'addProjectModal.html',
            controller: 'ModalInstanceController',
            size: size
        });

        modalInstance.result.then(function (selectedItem) {
            $scope.selected = selectedItem;
        }, function() {
            // console.log('Modal dismissed at: ' + new Date());
        });
    };
}]);