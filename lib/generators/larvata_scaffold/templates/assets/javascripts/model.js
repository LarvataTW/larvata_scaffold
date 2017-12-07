<% # 建立 belongs_to associations select2 options method
editable_attributes_and_except_sorting_and_datetime_and_number.each do |attr| 
  belongs_to_assoc = association_by_foreign_key(attr)
  if belongs_to_assoc 
    assoc_class_name = belongs_to_assoc.name.to_s.classify
    assoc_singular_name = belongs_to_assoc.name.to_s
    assoc_plural_name = assoc_singular_name.pluralize
%>
var <%= singular_name %>_<%= attr.name %>_select2;
<% 
  end 
end 
%>

$(function() {

<% # 建立 belongs_to associations select2 options method
editable_attributes_and_except_sorting_and_datetime_and_number.each do |attr| 
  belongs_to_assoc = association_by_foreign_key(attr)
  if belongs_to_assoc 
    assoc_class_name = belongs_to_assoc.name.to_s.classify
    assoc_singular_name = belongs_to_assoc.name.to_s
    assoc_plural_name = assoc_singular_name.pluralize
%>
    <%= singular_name %>_<%= attr.name %>_select2 = $('#<%= singular_name %>_<%= attr.name %>').select2({
        theme: 'bootstrap',
        width: '100%',
        placeholder: I18n.t('helpers.select.prompt'),
        allowClear: true,
        ajax: {
            url: '/admin/<%= plural_name %>/<%= assoc_plural_name %>_for_select2',
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

});
