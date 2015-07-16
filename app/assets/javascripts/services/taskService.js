'use strict';

// for task validation and other operations
services.service('taskService', [
    function() {
        var maxTextLength = 140;
        var validateTaskText = function(project, task) {
            var result = {fail: false, errors: []};
            task.text = task.text || '';
            if(task.text.length < 1) {
                result.fail = true;
                result.errors.push("Text can't be blank");
                result.errors.push('Text is too short (minimum is 1 character)');
            }else{
                if(task.text.length > maxTextLength) {
                    result.fail = true;
                    result.errors.push('Text is too long (maximum is ' + maxTextLength + ' characters)');
                }
            }
            for(var i = project.tasks.length-1; i >= 0; --i) {
                if(project.tasks[i].text === task.text && project.tasks[i].id !== task.id) {
                    result.fail = true;
                    result.errors.push('Text has already been taken');
                    i = -1;
                }
            }
            return result;
        };

        var validateTaskDirection = function(direction) {
            var result = {fail: false, errors: []};
            if(direction === 'up' || direction === 'down') {
                result.fail = true;
                result.errors = ['Direction "' + direction + '" is wrong. Only allowed "up" or "down" directions']
            }
            return result;
        };

        var formattedDeadline = function(year, month, day, hour, minute, second) {
            try {
                return year.toString()
                    + '-'
                    + month.toString()
                    + '-'
                    + day.toString()
                    + ' '
                    + hour.toString()
                    + ':'
                    + minute.toString()
                    + ':'
                    + second.toString();
            } catch (e) {
                return false;
            }
        };

        var renewTime = function() {
            var result = {};
            var currentDate = new Date();
            result.timeZoneOffset = Math.abs(currentDate.getTimezoneOffset())*60000;
            result.currentTime = currentDate.getTime();
            result.year = currentDate.getFullYear();
            result.month = currentDate.getMonth() + 1;
            result.day = currentDate.getDate();
            result.hour = currentDate.getHours();
            result.minute = currentDate.getMinutes();
            result.second = currentDate.getSeconds();
            return result;
        };

        var checkDeadline = function(task, date) {
            if(task.done || !task.deadline) {
                return;
            }
            var deadlineTime = new Date(task.deadline).getTime();
            //hours
            var highTerm = 12;
            var lowTerm = 6;
            deadlineTime -= date.timeZoneOffset;
            var timeDifference = deadlineTime - date.currentTime;
            if (timeDifference <= highTerm * 3600000 && timeDifference > lowTerm * 3600000) {
                // 6 - 12 hours before deadline
                return 'orange';
            }
            if (timeDifference <= 21600000 && timeDifference > 0) {
                // 0 - 6 hours before deadline
                return 'red';
            }
            if (timeDifference < 0) {
                // deadline passed
                return 'black';
            }
        };

        return {
            validateTaskText: validateTaskText,
            validateTaskDirection: validateTaskDirection,
            formattedDeadline: formattedDeadline,
            renewTime: renewTime,
            checkDeadline: checkDeadline
        };
    }
]);