csrf_token = $('meta[name="csrf-token"]').attr('content');

$('.froala-editor').each(function(){
    var froala_editor_elmt = $(this);
    var attachable_type = $(this).data('attachable_type');
    var attachable_id = $(this).data('attachable_id');
    var license_info = $('.fr-wrapper > div:first-child > a')

    froala_editor_elmt.froalaEditor({
        key: '',
        language: 'zh_tw',
        toolbarButtons: ['fontFamily', 'fontSize', 'paragraphFormat', 'bold', 'italic', 'underline', 'strikeThrough', 'subscript', 'superscript',
            '|', 'color', 'inlineStyle', 'paragraphStyle',
            '|', 'align', 'formatOL', 'formatUL', 'outdent', 'indent',
            '|',  'insertLink', 'insertImage', 'insertTable',
            '|',  'quote', 'insertHR', 'undo', 'redo', 'clearFormatting', 'selectAll'],
        imageEditButtons: ['imageReplace', 'imageAlign', 'imageRemove', '|', 'imageLink', 'linkOpen', 'linkEdit', 'linkRemove', '-', 'imageDisplay', 'imageStyle', 'imageAlt', 'imageSize'],
        tableInsertMaxSize: 8,
        imageUploadURL: '/attachments.json',
        imageUploadMethod: 'POST',
        imageUploadParams: {
            'authenticity_token': csrf_token,
            'attachable_type': attachable_type,
            'attachable_id': attachable_id,
            'attachable_additional_type': 'froala'
        },
        imageManagerLoadURL: '/attachments.json',
        imageManagerLoadMethod: 'GET',
        imageManagerLoadParams: {
            'attachable_type': attachable_type,
            'attachable_id': attachable_id,
            'attachable_additional_type': 'froala'
        },
        imageManagerDeleteURL: '/attachments/delete_froala_image',
        imageManagerDeleteMethod: 'DELETE',
        imageManagerDeleteParams: {
            'authenticity_token': csrf_token,
        },
    })
    .on('froalaEditor.imageManager.image.removed', function (e, editor, $img) {
        console.log('Image was deleted in froala editor');
    })
    .on('froalaEditor.imageManager.beforeDeleteImage', function (e, editor, $img) {
        $.ajax({
            url: $img.data('delete_url'),
            method: 'DELETE',
        })
        .done (function (data) {
            console.log ('Froala image was deleted');
            froala_editor_elmt.froalaEditor('imageManager.hide');
            froala_editor_elmt.froalaEditor('imageManager.show');
        })
        .fail (function (err) {
            console.log ('Froala image delete problem: ' + JSON.stringify(err));
        })
    });
})
