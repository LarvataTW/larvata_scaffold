var current_datatable;
var datatables = {};

var addRowClickEvent = function(row) {
    var id = $(row).attr('data-id')

    $(row).find('td:last-child').off('click').on('click', function() {
    });
};

var change_current_datatable = function(tab_key){
    current_datatable = datatables[tab_key];
}

var submit_filter = function(){
    current_datatable.draw();
};

var clear_filter = function(){
    current_datatable.search('').columns().search('').draw();
};

$(function() {
    $.fn.dataTable.ext.errMode = function(s,h,m){}

    var datatables_language = {
        "aria": {
            "sortAscending": ": activate to sort column ascending",
            "sortDescending": ": activate to sort column descending"
        },
        "emptyTable": I18n.t('datatables.empty_table'),
        "info": I18n.t('datatables.info'),
        "infoEmpty": I18n.t('datatables.info_empty'),
        "infoFiltered": I18n.t('datatables.info_filtered'),
        "lengthMenu": I18n.t('datatables.length_menu'),
        "zeroRecords": I18n.t('datatables.zero_records'),
        "processing": I18n.t('datatables.processing'),
        "paginate": {
            "previous": I18n.t('datatables.previous'),
            "next": I18n.t('datatables.next'),
            "last": I18n.t('datatables.last'),
            "first": I18n.t('datatables.first')
        },
    };

    // 列表頁的 datatables 設定
    $('.<%= controller_file_name %>_table').each(function(){
        var table = $(this);
        var tab_key = table.data('tab_key');

        var editor = new $.fn.dataTable.Editor({
            ajax: {
                url: '<%= '/admin' if admin? %>/<%= controller_file_path %>/update_row',
                type: 'PATCH'
            },
            table: "#"+ tab_key +"_<%= controller_file_name %>_table",
            idSrc: "DT_RowId",
            fields: [
                <%= editable_attributes_and_except_sorting.map{ |attr| 
                    component = "{\n                "

                    if attr.type == 'datetime'
                        component += "type: 'datetime',\n                "
                        component += "format: 'YYYY/MMM/D HH:mm',\n                "
                    end

                    component += "fieldInfo: '',\n                "
                    component += "label: '#{attr.name}',\n                "
                    component += "label: I18n.t('activerecord.attributes.#{singular_name}.#{attr.name}'),\n                "
                    component += "name: '#{attr.name}',\n            "
                    component += "},"
                    component 
                }.join("\n            ") 
                %>
            ],
        });

        var datatable = table.DataTable({
            language: datatables_language,
            paging: true,
            responsive: true,
            searching: true,
            processing: false,
            serverSide: true,
            stateSave: false,
            autoWidth: false,
            select: true,
            deferLoading: false,
            dom: 'Brtip"bottom"l',
            ajax: {
                url: '<%= '/admin' if admin? %>/<%= controller_file_path %>/datatables.json',
                dataSrc: 'data',
                type: 'POST',
                data: {
                },
            },
            columns:[
<% if contains_sorting_column? -%>
                {
                    // 排序
                    data: 'sorting',
                    name: 'sorting',
                    visible: true,
                    orderable: true,
                    className: 'reorder'
                },
<% end -%>
                <%= editable_attributes_and_except_sorting.map{ |attr| 
                    belongs_to_assoc = association_by_foreign_key(attr)

                    component = "{\n                "

                    if is_enum? attr
                        component += "data: '#{attr.name}_i18n',\n                "
                    else
                        component += "data: '#{attr.name}',\n                "
                    end

                    if belongs_to_assoc 
                        component += "name: '#{attr.name}_eq',\n                "
                    elsif is_enum? attr
                        component += "name: '#{attr.name}_enum',\n                "
                    elsif %w(string text).include? attr.type.to_s
                        component += "name: '#{attr.name}_cont',\n                "
                    elsif %w(boolean).include? attr.type.to_s
                        component += "name: '#{attr.name}_true',\n                "
                    elsif %w(integer float decimal datetime).include? attr.type.to_s
                        component += "name: '#{attr.name}_between',\n                "
                    end

                    component += "visible: true,\n                "
                    component += "orderable: true,\n                "
                    component += "className: 'editable col-#{attr.name}',\n            "
                    component += "editField: '#{attr.name}',\n            "
                    component += "},"
                    component 
                }.join("\n            ") 
                %>
                {
                    // 操作
                    data: null,
                    visible: true,
                    orderable: false,
                    render: function ( data, type, full, meta ) {
                        var id = data.id;
                        var master_show_tab_value = typeof master_show_tab !== 'undefined' ? master_show_tab : '';
                        var actions = '<a href="<%= '/admin' if admin? %>/<%= controller_file_path %>/' + id + '/edit?master_show_tab='+ master_show_tab_value +'" class="btn btn-default m-r-5"><span class="glyphicon glyphicon-pencil"></span></a>';
                        actions += '<a href="<%= '/admin' if admin? %>/<%= controller_file_path %>/' + id + '" data-confirm="確定刪除?" class="btn btn-default" rel="nofollow" data-method="delete"><span class="glyphicon glyphicon-trash"></span></a>';
                        return actions;
                    },
                },
            ],
            lengthMenu: [
                [10, 20, 50, 100, -1],
                [10, 20, 50, 100, I18n.t('helpers.datatables.length_menu_all')]
            ],
            buttons: [
                { extend: 'edit', editor: editor, text: 'Edit', className: 'btn btn-default datatables_buttons' },
                { extend: 'copy', text: 'Copy', className: 'btn btn-default datatables_buttons' },
                { extend: 'csv', text: 'CSV', className: 'btn btn-default datatables_buttons' },
                { extend: 'excel', text: 'Excel', className: 'btn btn-default datatables_buttons' },
                { extend: 'pdf', text: 'PDF', className: 'btn btn-default datatables_buttons' },
                { extend: 'print', text: 'Print', className: 'btn btn-default datatables_buttons' },
            ],
<% if contains_sorting_column? -%>
            rowReorder: {
                dataSrc: 'sorting'
            },
<% end -%>
            iDisplayLength: 10,
            rowCallback: function( row, data, index ) {
                $(row).attr('data-id', data.id);
                addRowClickEvent(row);
            },
            fnPreDrawCallback: function(){
                $('.dataTables_processing').css("visibility","visible");
                $('.dataTables_processing').css({"display": "block", "z-index": 10000 })
            },
        });

        // Activate an inline edit on click of a table cell
        $("#"+ tab_key +"_<%= controller_file_name %>_table").on( 'click', 'tbody td.editable', function (e) {
            // 如果有遇到「Cannot read property 'contents' of undefined datatables editor」的錯誤，需要調整成 editor.inline( datatable.cell(this), {
            editor.inline( this, {
                onBlur: 'submit'
            } );
        } );

        datatable.on('row-reorder', function(e, diff, edit){
            var data = {rows_sorting:{}}
            var result = '';

            for ( var i=0, ien=diff.length ; i<ien ; i++ ) {
                data['rows_sorting'][$(diff[i].node).data('id')] = diff[i].newData;
            }

            $.ajax({
                type: 'patch',
                url: '<%= '/admin' if admin? %>/<%= controller_file_path %>/update_row_sorting',
                data: data,
                datatype: 'json'
            });
        });

        editor.on( 'initEdit', function () {
            // Disable for edit (re-ordering is performed by click and drag)
<% if contains_sorting_column? -%>
            editor.field( 'sorting' ).disable();
<% end -%>
        } );

        datatables[tab_key] = datatable;
    });

    // 關鍵字查詢
    $('#keyword_search').keyup(function(e){
        datatablesUtils.keyword_filter(datatables, $(this).val());
    });

    // 查詢條件值更新事件處理器
    $('.filter-condition-panel .filter-condition').change(function(e){
        datatablesUtils.column_string_filter(datatables, e.target.name);
    });

    $('.filter-condition-panel .filter-range-condition').change(function(e){
        datatablesUtils.column_range_filter(datatables, e.target.name);
    });

    $('.filter-condition-panel .filter-select-condition').select2({theme:'bootstrap',width:'100%',placeholder: I18n.t('helpers.select.prompt'),allowClear: true,})
        .on('select2:close', function(e){
            datatablesUtils.column_select_filter(datatables, e.target.name);
        });

    // 送出查詢
    $('button.filter-button').click(function(e){
        submit_filter();
    });

    // 清空查詢
    $('button.reset-button').click(function(e){
        $('input').val('');
        $('select').val('').trigger('change.select2');
        clear_filter();
    });

    // 點擊頁籤
    $('.<%= singular_name %>_<%= tab %>_tab').on('click', function(){
        var tab = $(this);
        var tab_key = tab.data('tab_key');
        change_current_datatable(tab_key);
        datatablesUtils.column_filter(current_datatable, '<%= tab %>', tab_key == "all" ? '' : tab_key);
        submit_filter();
    });

    // 初次進入頁面
    change_current_datatable('all');
    clear_filter();
});
