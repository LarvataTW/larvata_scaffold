var common_attachments = {};
(function(){
    this.initialize = function(attachable_type, attachable_id){
        var url = $('#fileupload').prop('action') + '?attachable_type='+ attachable_type +'&attachable_id='+ attachable_id;

        var uploadButton = $('<button/>')
        .addClass('btn btn-primary')
        .prop('disabled', true)
        .text('Processing...')
        .on('click', function () {
            var $this = $(this),
                data = $this.data();

            $this
            .off('click')
            .text('Abort')
            .on('click', function () {
                $this.remove();
                data.abort();
            });

            data.submit().always(function () {
                $this.remove();
            });
        });

        $('#fileupload').fileupload({
            url: url,
            dataType: 'json',
            autoUpload: true,
            acceptFileTypes: /(\.|\/)(gif|jpe?g|png|pdf|zip|rar|doc?x|xls?x|ppt?x|txt)$/i,
            maxFileSize: 999000,
            // Enable image resizing, except for Android and Opera,
            // which actually support image resizing, but fail to
            // send Blob objects via XHR requests:
            disableImageResize: /Android(?!.*Chrome)|Opera/
            .test(window.navigator.userAgent),
            previewMaxWidth: 100,
            previewMaxHeight: 100,
            previewCrop: true
        }).on('fileuploadadd', function (e, data) {
            data.context = $('<div/>').appendTo('#files');
            $.each(data.files, function (index, file) {
                var node = $('<p/>')
                .append($('<span/>').text(file.name));
                if (!index) {
                    node
                    .append('<br>')
                    .append(uploadButton.clone(true).data(data));
                }
                node.appendTo(data.context);
            });
        }).on('fileuploadprocessalways', function (e, data) {
            var index = data.index,
                file = data.files[index],
                node = $(data.context.children()[index]);
            if (file.preview) {
                node
                .prepend('<br>')
                .prepend(file.preview);
            }
            if (file.error) {
                node
                .append('<br>')
                .append($('<span class="text-danger"/>').text(file.error));
            }
            if (index + 1 === data.files.length) {
                data.context.find('button')
                .text('Upload')
                .prop('disabled', !!data.files.error);
            }
        }).on('fileuploadprogressall', function (e, data) {
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $('#progress .progress-bar').css(
                'width',
                progress + '%'
            );
        }).on('fileuploaddone', function (e, data) {
            $.each(data.result.files, function (index, file) {
                if (file.url) {
                    var link = $('<a>')
                    .attr('target', '_blank')
                    .prop('href', file.url);
                    $(data.context.children()[index])
                    .wrap(link);
                } else if (file.error) {
                    var error = $('<span class="text-danger"/>').text(file.error);
                    $(data.context.children()[index])
                    .append('<br>')
                    .append(error);
                }
            });
        }).on('fileuploadfail', function (e, data) {
            $.each(data.files, function (index) {
                var error = $('<span class="text-danger"/>').text('File upload failed.');
                $(data.context.children()[index])
                .append('<br>')
                .append(error);
            });
        }).bind('fileuploaddestroy', function (e, data) {
            var fileName = data.context.find('a[download]').attr('download');
            return confirm('確認要刪除 ' + fileName + ' ?');
        }).prop('disabled', !$.support.fileInput)
        .parent().addClass($.support.fileInput ? undefined : 'disabled');

        // Load existing files:
        if(url.indexOf('undefined') == -1) {
            $.getJSON(url, function (files) {
                var fu = $('.bootbox #fileupload, #fileupload').data('blueimp-fileupload'),
                    template;

                template = fu._renderDownload(files).appendTo($('#fileupload .files'));

                // Force reflow:
                fu._reflow = fu._transition && template.length && template[0].offsetWidth;
                template.addClass('in');
                $('#loading').remove();
            });
        }
    };
}).apply(common_attachments);
