$(function() {
    $.fn.dataTable.ext.errMode = function(s,h,m){}

    var datatables_language = {
        "aria": {
            "sortAscending": ": activate to sort column ascending",
            "sortDescending": ": activate to sort column descending"
        },
        "emptyTable": "No data available in table",
        "info": "Showing _START_ to _END_ of _TOTAL_ records",
        "infoEmpty": "No records found",
        "infoFiltered": "(filtered1 from _MAX_ total records)",
        "lengthMenu": "顯示 _MENU_",
        "zeroRecords": "找不到符合的資料",
        "processing": "搜尋中，請稍後，如久無反應請重新整理頁面。",
        "paginate": {
            "previous":"Prev",
            "next": "Next",
            "last": "Last",
            "first": "First"
        }
    };

    // 列表頁的 datatables 設定
    var editor = new $.fn.dataTable.Editor({
        ajax: {
            url: '<%= '/admin' if admin? %>/<%= plural_name %>/update_row',
            type: 'PATCH'
        },
        table: "#<%= plural_name %>_datatable",
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
                component += "name: '#{attr.name}',\n            "
                component += "},"
                component 
            }.join("\n            ") 
            %>
        ],
    });

    // Activate an inline edit on click of a table cell
    $('#<%= plural_name %>_datatable').on( 'click', 'tbody td.editable', function (e) {
        editor.inline( this );
    } );

    var <%= plural_name %>_datatable = $('#<%= plural_name %>_datatable').DataTable({
        language: datatables_language,
        paging: true,
        responsive: true,
        searching: true,
        processing: true,
        serverSide: true,
        stateSave: false,
        autoWidth: false,
        select: true,
        dom: 'Brtip',
        ajax: {
            url: '<%= '/admin' if admin? %>/<%= plural_name %>/datatables.json',
            dataSrc: 'data',
            type: 'POST',
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
                component = "{\n                "

                if is_enum? attr
                    component += "data: '#{attr.name}_i18n',\n                "
                else
                    component += "data: '#{attr.name}',\n                "
                end

                if is_enum? attr
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
                    var actions = '<a href="<%= '/admin' if admin? %>/<%= plural_name %>/' + id + '/edit" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span></a>';
                    actions += '<a href="<%= '/admin' if admin? %>/<%= plural_name %>/' + id + '" data-confirm="確定刪除?" class="btn btn-default" rel="nofollow" data-method="delete"><span class="glyphicon glyphicon-trash"></span></a>';
                    return actions;
                },
            },
        ],
        lengthMenu: [
            [10, 50, 100],
            [10, 50, 100]
        ],
        buttons: [
            { extend: 'edit', editor: editor, text: '編輯', className: 'btn btn-default' },
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

    <%= plural_name %>_datatable.on('row-reorder', function(e, diff, edit){
        var data = {rows_sorting:{}}
        var result = '';

        for ( var i=0, ien=diff.length ; i<ien ; i++ ) {
            data['rows_sorting'][$(diff[i].node).data('id')] = diff[i].newData;
        }

        $.ajax({
            type: 'patch',
            url: '<%= '/admin' if admin? %>/<%= plural_name %>/update_row_sorting',
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

    // 關鍵字查詢
    $('#keyword_search').keyup(function(e){
        var keycode = (event.keyCode ? event.keyCode : event.which);
        if(keycode == '13'){
            <%= plural_name %>_datatable.search($(this).val()).draw() ;
        }
    });

<%= editable_attributes_and_except_sorting.map{ |attr| 
        if is_enum? attr or attr.type == "boolean"
            component = "$('.filter-#{attr.name}').select2({theme:'bootstrap'}).on('select2:close', function(e){\n       "
            component += "datatablesUtils.column_select_filter(#{plural_name}_datatable, e.target.name);\n        " 
            component += "});\n"
        else
            component = "$('.filter-#{attr.name}').change(function(e){\n       "
            if %w(string text).include? attr.type.to_s
                component += "datatablesUtils.column_string_filter(#{plural_name}_datatable, e.target.name);\n    " 
            elsif %w(integer float decimal datetime).include? attr.type.to_s
                component += "datatablesUtils.column_range_filter(#{plural_name}_datatable, e.target.name);\n    " 
            end
            component += "});\n"
        end

        component 
    }.join("\n\n    ") 
%>

    // 送出查詢
    $('button.filter-button').click(function(e){
        <%= plural_name %>_datatable.draw();
    });

    // 清空查詢
    $('button.reset-button').click(function(e){
        $('input').val('');
        $('select').val('').trigger('change.select2');
        <%= plural_name %>_datatable.search('').columns().search('').draw();
    });
});

var addRowClickEvent = function(row) {
    var id = $(row).attr('data-id')

    $(row).find('td:last-child').off('click').on('click', function() {
    });
};
