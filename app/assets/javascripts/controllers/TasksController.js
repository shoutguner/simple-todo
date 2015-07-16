'use strict';

controllers.controller('TasksController', [
    '$scope',
    '$interval',
    'taskService',
    'Tasks',
    'Task',
    function($scope, $interval, taskService, Tasks, Task) {
        $scope.date = taskService.renewTime();

        // for deadlines------------------------------------------------------------------------------------------------
        $scope.renewCss = true;
        $interval(function() {
            // trigger for changing css class with respect to task's deadline
            $scope.renewCss = !$scope.renewCss;
            // renew default deadline values for tasks that not have deadline yet
            $scope.date = taskService.renewTime();
        }, 1000);

        // css style helper
        // trigger needed for just-in-time css change
        $scope.checkDeadline = function(task, trigger) {
            return taskService.checkDeadline(task, $scope.date);
        };

        // tasks operations --------------------------------------------------------------------------------------------
        $scope.saveTask = function(project, task) {
            task.saveTaskFail = false;
            //frontend task validation
            //var validationResult = $scope.validateTask(task);
            var validationResult = taskService.validateTaskText(project, task);
            task.saveTaskFail = validationResult.fail;
            var errors = validationResult.errors;
            if(!task.saveTaskFail) {
                //passed frontend validation
                var editedTask = new Task({id: task.id, text: task.text, project_id: task.project_id});
                Task.update_one(editedTask, function(response) {
                    if(response.errors) {
                        //not passed backend validation
                        task.saveTaskFail = true;
                        task.errors = response.errors;
                    }else{
                        //no errors on backend
                        task.saveTaskFail = false;
                        task.editable = false;
                        task = response;
                    }
                }, function(error) {
                    //handle request error
                    if(error.status >= 404) {
                        $scope.reloadProjects();
                    }
                });
            }else{
                task.errors = errors;
            }
        };

        $scope.changePriority = function(project, task, direction){
            // frontend validation
            if(project.tasks.length != 1) {
                var validationResult = taskService.validateTaskDirection();
                task.saveTaskFail = validationResult.fail;
                if(!task.saveTaskFail) {
                    // passed frontend validation
                    var changed_task = new Task({
                        id: task.id, project_id: task.project_id, priority: task.priority, direction: direction
                    });
                    Task.update_multiple(changed_task, function(response) {
                        if(response.errors) {
                            // not passed backend validation
                            $scope.saveTaskFail = true;
                            task.errors = response.errors;
                        }else{
                            // no errors on backend
                            $scope.saveTaskFail = false;
                            project.tasks = response;
                        }
                    }, function(error) {
                        if(error.status >= 404) {
                            $scope.reloadProjects();
                        }
                    });
                }else{
                    // not passed frontend validation
                    task.errors = validationResult.errors;
                }
            }
        };

        $scope.addTask = function(project){
            var task = {text: project.new_task_text};
            // frontend task validation
            var validationResult = taskService.validateTaskText(project, task);
            $scope.$parent.fail = validationResult.fail;
            var errors = validationResult.errors;
            if(!$scope.fail) {
                // passed frontend validation
                var added_task = new Tasks({text: project.new_task_text, project_id: project.id});
                added_task.$save(function(response) {
                    if(response.errors) {
                        // not passed backend validation
                        $scope.$parent.fail = true;
                        project.errors = response.errors;
                    }else{
                        // passed backend validation
                        $scope.$parent.fail = false;
                        project.tasks.push(response);
                        project.new_task_text = null;
                    }
                }, function(error) {
                    if(error.status >= 404) {
                        $scope.reloadProjects();
                    }
                });
            }else {
                project.errors = errors;
            }
        };

        $scope.removeTask = function(project, task){
            var removed_task = new Task({id: task.id, project_id: task.project_id});
            Task.delete(removed_task, function(response) {
                if(response.errors) {
                    $scope.removeFail = true;
                    project.errors = response.errors;
                }else{
                    $scope.removeFail = false;
                    project.tasks.splice(project.tasks.indexOf(task), 1);
                }
            }, function(error) {
                if(error.status >= 404) {
                    $scope.reloadProjects();
                }
            });
        };

        $scope.invertStatus = function(task) {
            var edited_task = new Task({id: task.id, project_id: task.project_id, invert_status: true});
            Task.update_one(edited_task, function(response) {
                if(response.errors) {
                    task.saveTaskFail = true;
                    task.errors = response.errors;
                }else{
                    task.saveTaskFail = false;
                    //task = response;
                    task.done = response.done;
                }
            }, function(error) {
                if(error.status >= 404) {
                    $scope.reloadProjects();
                }
            });
        };

        $scope.setTaskDeadline = function(task) {
            var formattedDeadline = taskService.formattedDeadline(task.year, task.month, task.day,
                task.hour, task.minute, task.second);
            // frontend validation
            task.saveTaskFail = false;
            var errors = [];
            if(!formattedDeadline) {
                task.saveTaskFail = true;
                errors.push('Invalid Date');
            }else{
                var timestamp = new Date(formattedDeadline).getTime();
                if(timestamp === 'Invalid Date') {
                    task.saveTaskFail = true;
                    errors.push('Invalid Date');
                }
            }
            if(task.saveTaskFail) {
                // not passed frontend validation
                task.errors = errors;
            }else{
                // passed frontend validation
                var updatingTask = new Task({id: task.id, project_id: task.project_id, deadline: formattedDeadline});
                Task.update_one(updatingTask, function(response) {
                    if(response.errors) {
                        //not passed backend validation
                        task.saveTaskFail = true;
                        task.errors = response.errors;
                    }else{
                        //no errors on backend
                        task.saveTaskFail = false;
                        task.deadline = response.deadline;
                        task = response;
                    }
                }, function(error) {
                    //handle request error
                    if(error.status >= 404) {
                        $scope.reloadProjects();
                    }
                });
            }
        };
        // end tasks operations ----------------------------------------------------------------------------------------
    }]);