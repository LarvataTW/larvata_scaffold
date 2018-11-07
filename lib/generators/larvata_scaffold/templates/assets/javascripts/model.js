var <%= 'admin_' if admin? %><%= controller_file_path %> = {};

(function() {

    this.initialize = function() {
        var <%= singular_name %>_id = $('#<%= singular_name %>_id').val() || '';
        var master_show_tab = $('#master_show_tab').val() || '';

        // 依據傳入的 master_show_tab 參數來切換 show 頁面的 detail 頁籤內容
        if( typeof <%= singular_name %>_id !== 'undefined' && <%= singular_name %>_id != "" && typeof master_show_tab !== 'undefined' && master_show_tab != "" && !$('#'+master_show_tab+'_tab').hasClass('active') ) {
            $.ajax({
                url: "/<%= 'admin/' if admin? %><%= controller_file_path %>/"+ <%= singular_name %>_id +"/render_tab_content",
                method: 'get',
                dataType: 'html',
                data: { master_show_tab: master_show_tab }
            }).success(function(tab_html){
                if(tab_html !== '') {
                    $('.tab-pane.active').removeClass('active');
                    $('li[id$="_tab"].active').removeClass('active');

                    if($('#'+master_show_tab+'_tab').length === 0) {
                        master_show_tab = '<%= plural_name %>';
                    }

                    $('#'+master_show_tab+'_tab').addClass('active');
                    $('#'+master_show_tab+'_tabpanel').addClass('active').html($(tab_html));
                }
            }); 
        }

<% # 建立 belongs_to associations select2 options method
editable_attributes_and_except_sorting_and_datetime_and_number.each do |attr| 
  belongs_to_assoc = association_by_foreign_key(attr)
  if belongs_to_assoc 
    assoc_class_name = belongs_to_assoc.name.to_s.classify
    assoc_singular_name = belongs_to_assoc.name.to_s
    assoc_plural_name = assoc_singular_name.pluralize
%>
        $('#<%= singular_name %>_<%= attr.name %>').is("select") && $('#<%= singular_name %>_<%= attr.name %>').select2({
            theme: 'bootstrap',
            width: '100%',
            placeholder: I18n.t('helpers.select.prompt'),
            allowClear: true,
            ajax: {
                url: '/admin/<%= controller_file_path %>/<%= assoc_plural_name %>_for_select2',
                dataType: 'json',
                type: 'POST',
                data: function (params) {
                    var query = {
                        search: params.term,
                        page: params.page || 1,
                        per: 10,
                    }

                    return query;
                },
                processResults: function (data, params) {
                    params.page = params.page || 1;

                    return {
                        results: data.results,
                        pagination: {
                            more: (params.page * data.per) < data.filtered_count
                        }
                    };
                },
                delay: 250,
            },
        });
<% 
  end 
end 
%>

    };

}).apply(<%= 'admin_' if admin? %><%= controller_file_path %>);

$(function() {
    <%= 'admin_' if admin? %><%= controller_file_path %>.initialize();
});
