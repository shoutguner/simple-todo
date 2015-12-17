'use strict';

controllers.controller('CommentsController', [
    '$scope',
    'Upload',
    'commentService',
    'Comments',
    'Comment',
    'attachmentService',
    function($scope, Upload, commentService, Comments, Comment, attachmentService) {
        // comments operations -----------------------------------------------------------------------------------------
        $scope.getComments = function(task) {
            task.showComments = true;
            task.comments = Comments.query({project_id: task.project_id, task_id: task.id});
        };

        $scope.addComment = function(task) {
            if (task.newComment.attachments && task.newComment.attachments.length) {
                // create comment with attachment
                $scope.saveCommentAndAttachment(task);
            }else{
                // create comment without attachment
                $scope.saveComment(task);
            }
        };

        $scope.removeComment = function(task, comment) {
            var removed_comment = new Comment({id: comment.id, task_id: task.id, project_id: task.project_id});
            Comment.delete(removed_comment, function(response) {
                if(response.errors) {
                    task.commentFail = true;
                    task.errors = response.errors;
                }else{
                    task.commentFail = false;
                    task.comments.splice(task.comments.indexOf(comment), 1);
                }
            }, function(error) {
                if(error.status >= 404) {
                    $scope.reloadProjects();
                }
            });
        };

        $scope.saveCommentAndAttachment = function(task) {
            // with attachment text can be empty
            // frontend validation
            task.commentFail = false;
            var textValidationResult = commentService.validateMaxCommentTextLength(task.newComment);
            task.commentFail = textValidationResult.fail;
            var errors = textValidationResult.errors;
            var validationResult = attachmentService.validateAttachments(task.newComment.attachments);
            task.commentFail = task.commentFail ? true : validationResult.fail;
            errors = errors.concat(validationResult.errors);
            if(!task.commentFail) {
                // passed frontend validation
                Upload.upload({
                    url: "/projects/"+task.project_id+"/tasks/"+task.id+"/comments.json",
                    fields: {project_id: task.project_id, task_id: task.id, 'comment[text]': task.newComment.text},
                    file: validationResult.files
                }).progress(function(p) {
                    task.newComment.progress = parseInt(100.0 * p.loaded / p.total);
                }).success(function(response) {
                    if(response.errors) {
                        // not passed backend validation
                        task.commentFail = true;
                        task.errors = response.errors;
                        task.newComment.progress = -1;
                    }else{
                        // no errors on backend
                        task.commentFail = false;
                        task.errors = errors = [];
                        task.comments.push(response);
                        task.newComment = {};
                    }
                }).error(function(error) {
                    if(error.status >= 404) {
                        $scope.reloadProjects();
                    }
                });
            }else{
                // not passed frontend validation
                task.errors = errors;
            }
        };

        $scope.saveComment = function(task) {
            task.commentFail = false;
            // without attachment text cannot be empty
            // frontend validation
            var validationResult = commentService.validateComment(task.newComment);
            task.commentFail = validationResult.fail;
            if(!task.commentFail) {
                // passed frontend validation
                var added_comment = new Comments({
                    project_id: task.project_id, task_id: task.id, text: task.newComment.text
                });
                added_comment.$save(function (response) {
                    if (response.errors) {
                        // not passed backend validation
                        task.commentFail = true;
                        task.errors = response.errors;
                    } else {
                        // no errors on backend
                        task.commentFail = false;
                        task.comments.push(response);
                        task.newComment.text = null;
                    }
                }, function (error) {
                    if (error.status >= 404) {
                        $scope.reloadProjects();
                    }
                });
            }else{
                // not passed frontend validation
                task.errors = validationResult.errors;
            }
        };
        // end comments operations -------------------------------------------------------------------------------------

        // attachments -------------------------------------------------------------------------------------------------
        // attachment upload is performed by saveCommentAndAttachment method
        // attachment download is performed by download directive
        // end attachments ---------------------------------------------------------------------------------------------
    }]);
