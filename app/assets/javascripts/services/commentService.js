'use strict';

// for comment validation and other operations
services.service('commentService', [
    function() {
        var maxCommentLength = 140;
        var validateComment = function(comment) {
            var result = {fail: false, errors: []};
            comment.text = comment.text || '';
            if(comment.text.length < 1) {
                result.fail = true;
                result.errors.push('Text is too short (minimum is 1 character)');
            }else{
                if(comment.text.length > maxCommentLength) {
                    result.fail = true;
                    result.errors.push('Text is too long (maximum is ' + maxCommentLength + ' characters)');
                }
            }
            return result;
        };

        var validateMaxCommentTextLength = function(comment) {
            var result = {fail: false, errors: []};
            if(comment.text && comment.text.length > maxCommentLength) {
                result.fail = true;
                result.errors.push('Text is too long (maximum is ' + maxCommentLength + ' characters)');
            }
            return result;
        };

        return {
            validateComment: validateComment,
            validateMaxCommentTextLength: validateMaxCommentTextLength
        };
    }
]);