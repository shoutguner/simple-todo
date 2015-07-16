'use strict';

angular.module('controllers').controller('ProjectModalsController', [
    '$scope',
    '$modal',
    function ($scope, $modal) {
    $scope.newProjectName = "New TODO";
    $scope.animationsEnabled = true;

    $scope.open = function(size) {
        var modalInstance = $modal.open({
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