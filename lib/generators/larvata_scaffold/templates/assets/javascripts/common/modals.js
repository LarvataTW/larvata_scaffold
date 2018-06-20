var common_modals = {};
(function(){
    var args;

    this.initialize = function(){
        args = arguments[0];
        return this;
    };

    this.open = function(){
        $.ajax({
            type: "GET",
            url: '/common/modals/open',
            dataType: 'script',
            data: $.param( args ),
            success: function(result) {
            },
            error: function(xhr, ajaxOptions, thrownError) {
                console.log(xhr);
                console.log(ajaxOptions);
                console.log(thrownError);
            }
        });
    };
}).apply(common_modals);

$(function(){
    $(document).on('click', '.js-open-modal', function(){
        var args = {
            page_title: $(this).data('page_title'), // optional：modal 的 title 名稱。
            controller_name: $(this).data('controller_name'), // required：要載入的 partial page controller，如 admin/properties。
            partial_page: $(this).data('partial_page'), // required：要載入的 partial page name，如 form。
            action_name: $(this).data('action_name'), // required：以何種方式顯示 modal 內容：edit（編輯）、show（檢視）、index（列表）。
            model_name: $(this).data('model_name'), // required：傳入該資料頁面的主要 modal name
            model_scope: $(this).data('model_scope'), // optional：設定 modal_name 所代表類別要使用的 scope 方法。
            id: $(this).data('id'), // optional：如果是載入單筆資料頁面（action_name 為 edit 或是 show），則傳入該筆資料的 id
            tab: $(this).data('tab'), // optional：如果是載入列表資料頁面（action_name 為 index），則傳入頁籤分組的欄位名稱
            associate_model_name: $(this).data('associate_model_name'), // optional：關聯 master modal name。
            associate_id: $(this).data('associate_id'), // optional：關聯 master id
        }

        common_modals.initialize(args).open();
    });
});
