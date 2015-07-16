'use strict';

services.service('attachmentService', [
    function() {
        var validateAttachments = function(attachments) {
            var allowedAttachmentExtensions = [
                'jpg', 'jpeg', 'gif', 'png', 'bmp', 'txt', 'doc', 'docx', 'xls', 'rtf', 'otd', 'pdf', 'mp3', '3gp',
                'wav', 'raw', 'ico', 'avi', 'mp4', 'mpg', 'mpeg', 'ppt', 'zip', 'rar', '7z', 'gz', 'gzip'
            ];
            // Megabytes
            var maxFileSize = 50;
            var result = {fail: false, errors: [], files: []};
            var extension = '';
            for (var i = attachments.length-1; i >= 0; --i) {
                if(attachments[i].size > maxFileSize * 1048576){ // 1024 * 1024 = 1048576
                    result.fail = true;
                    result.errors.push('Attachment ' + attachments[i].name + ' is too large (maximum ' + maxFileSize + ' MB per file)');
                }
                extension = attachments[i].name.substring(attachments[i].name.lastIndexOf('.')+1);
                if(allowedAttachmentExtensions.indexOf(extension) === -1) {
                    result.fail = true;
                    result.errors.push('Attachments You are not allowed to upload "' +
                        attachments[i].name.substring(attachments[i].name.lastIndexOf('.')+1) + '" files, allowed types: ' +
                        allowedAttachmentExtensions.join(', '));
                }
                if(!result.fail) {
                    result.files.push(attachments[i]);
                }else{
                    result.files = [];
                }
            }
            return result;
        };

        return {
            validateAttachments: validateAttachments
        };
    }
]);