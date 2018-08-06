var datatablesUtils = (function() {
    var datatables_language = function() {
        return {
            aria: {
                sortAscending: ": I18n.t('datatables.sort_ascending')",
                sortDescending: ": I18n.t('datatables.sort_descending')"
            },
            emptyTable: I18n.t('datatables.empty_table'),
            info: I18n.t('datatables.info'),
            infoEmpty: I18n.t('datatables.info_empty'),
            infoFiltered: I18n.t('datatables.info_filtered'),
            lengthMenu: I18n.t('datatables.length_menu'),
            zeroRecords: I18n.t('datatables.zero_records'),
            processing: I18n.t('datatables.processing'),
            paginate: {
                previous: I18n.t('datatables.previous'),
                next: I18n.t('datatables.next'),
                last: I18n.t('datatables.last'),
                first: I18n.t('datatables.first')
            },
            select: {
                rows: {
                    _: I18n.t('datatables.selected_rows'),
                    0: I18n.t('datatables.click_to_select'),
                    1: I18n.t('datatables.only_one_row_selected')
                }
            }
        }
    };

    // 處理字串查詢
    var column_string_filter = function(datatables, input_name) {
        var column_data = get_column_data( input_name );

        datatables = to_datatables(datatables)
        for(var tab_key in datatables) {
            var datatable = datatables[tab_key];
            datatable.columns( column_index(datatable, column_data) ).search( $('.filter-' + column_data).val() );
        }

        if(enter_keyup()){
            // datatable.draw();
        }
    };

    // 處理下拉選單、checkbox、radio查詢
    var column_select_filter = function(datatables, input_name) {
        var column_data = get_column_data( input_name );

        datatables = to_datatables(datatables)
        for(var tab_key in datatables) {
            var datatable = datatables[tab_key];
            datatable.columns( column_index(datatable, column_data) ).search( $('.filter-' + column_data).val() );
        }
    };

    // 處理區間查詢
    var column_range_filter = function(datatables, input_name) {
        var column_data = get_column_data(input_name);
        var start_filter = $('input[name="'+ column_data +'_start"]').val();
        var end_filter = $('input[name="'+ column_data +'_end"]').val();

        if(start_filter || end_filter) {
            datatables = to_datatables(datatables)
            for(var tab_key in datatables) {
                var datatable = datatables[tab_key];
                datatable.columns( column_index(datatable, column_data) ).search( start_filter + " - " + end_filter );
            }
        }

        if(enter_keyup()){
            // datatable.draw();
        }
    };

    // 關鍵字查詢
    var keyword_filter = function(datatables, input_value){
        datatables = to_datatables(datatables)
        for(var tab_key in datatables) {
            var datatable = datatables[tab_key];
            datatable.search( input_value );
        }
    };

    // 針對欄位設定查詢條件
    var column_filter = function(datatable, input_name, input_value) {
        var column_data = get_column_data( input_name );
        datatable.columns( column_index(datatable, column_data) ).search( input_value );
    };

    // 是否按下 enter 鍵
    var enter_keyup = function(){
        var keycode = (event.keyCode ? event.keyCode : event.which);
        return keycode == '13';
    };

    // 從查詢元件取得實際欄位名稱
    var get_column_data = function(input_name){
        return input_name.replace(/\_start/g, '').replace(/_end/g, '')
    };

    // 用欄位名稱查詢在 datatables 中的 index
    var column_index = function(datatable, column_data) {
        return datatable.column('.col-' + column_data).index();
    };

    // 檢查是否為 Datatable 物件
    var is_datatable = function(datatable){
        return $.fn.dataTable.isDataTable(datatable);
    };

    // to datatables JSON object
    var to_datatables = function(datatables){
        if(is_datatable(datatables)){
            datatables = {"all": datatables};
        }
        return datatables;
    };

    return {
        datatables_language: datatables_language,
        column_string_filter: column_string_filter,
        column_range_filter: column_range_filter,
        column_select_filter: column_select_filter,
        keyword_filter: keyword_filter,
        column_filter: column_filter,
        enter_keyup: enter_keyup,
        get_column_data: get_column_data,
        column_index: column_index,
    }
})();

