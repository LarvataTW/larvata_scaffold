class <%= 'Admin::' if admin? %><%= controller_class_name %>Controller < ApplicationController
<% if admin? -%>
  layout "admin"
<% end -%>

  before_action :set_<%= singular_name %>, only: [:show, :edit, :update, :destroy]
  before_action :class_authorize, only: [:index, :new, :create]

  def index

  end

  def datatables
<% if enable_pundit? -%>
    <%= "authorize [:admin, #{class_name}], :index?" if admin? %>
    <%= "authorize #{class_name}, :index?" unless admin? %>
<% end -%>

    respond_to do |format|
      # 設定排序條件
      unless params[:order].blank?
        @sorting_key = params[:order]['0'][:column].to_i # 排序條件
        @sorting_dir = params[:order]['0'][:dir] # 降冪升冪
        @page = (params[:start].to_i/params[:length].to_i) + 1 # 要顯示資料的頁數
      end

      @filters = DatatablesService.new({class_name: "<%= class_name %>"}).handle_filters(params)

      @keyword = params[:search][:value] unless params[:search].blank?
      @filters["id_cont".to_sym] = @keyword if @keyword

      @q = <%= class_name %>.ransack(@filters)

      @q.sorts = @sorting_key.blank? ? "updated_at desc" : "#{params[:columns][@sorting_key.to_s][:name]} #{@sorting_dir}"

      @<%= plural_name %> = @q.result.page(@page).per(params[:length])
      @filtered_count = @q.result.count
      @total_count = <%= class_name %>.count

      format.json {
        render json: {
          recordsTotal: @total_count, # 資料總筆數
          recordsFiltered: @filtered_count, # 過濾後資料筆數
          data: to_datatables(@<%= plural_name %>) # 整理查詢結果
        }
      }
    end
  end

  def new
    @<%= singular_name %> = <%= class_name %>.new
  end

  def create
    @<%= singular_name %> = <%= class_name %>.new(<%= singular_name %>_params)
    if @<%= singular_name %>.save
      redirect_to <%= 'admin_' if admin? %><%= controller_file_path %>_path(@<%= singular_name %>), notice: '已成功建立<%= human_name %>資料'
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @<%= singular_name %>.update(<%= singular_name %>_params)
      redirect_to <%= 'admin_' if admin? %><%= controller_file_path %>_path(@<%= singular_name %>), notice: '已成功更新<%= human_name %>資料'
    else
      render :edit
    end
  end

  def destroy
    @<%= singular_name %>.destroy
    redirect_to <%= 'admin_' if admin? %><%= controller_file_path %>_url, notice: '已成功刪除<%= human_name %>資料'
  end

<% if enable_row_editor? -%>
  # 更新列表的單筆 row 資料
  def update_row
    params[:data].each do |id, column_values|
      respond_to do |format|
        format.json {
          <%= singular_name %> = <%= class_name %>.find_by(id: id)

<% if enable_pundit? -%>
          <%= "authorize [:admin, #{singular_name}]" if admin? %>
          <%= "authorize #{singular_name}" unless admin? %>
<% end -%>

          <%= singular_name %>_params = <%= singular_name %>_row_params(column_values)

          if <%= singular_name %>&.update(<%= singular_name %>_params)
            <%= plural_name %> = <%= class_name %>.where(id: id)
            render json: {data: to_datatables(<%= plural_name %>)}
          end
        }
      end
    end
  end
<% end -%>

<% if contains_sorting_column? -%>
  # 更新列表的排序
  def update_row_sorting
    <%= plural_name %> = []
    params[:rows_sorting]&.each{|id, sorting|
      <%= singular_name %> = <%= class_name %>.find_by(id: id)
      <%= singular_name %>.try(:sorting=, sorting)
      <%= singular_name %>&.save
      <%= plural_name %> << <%= singular_name %>
    }
    render json: {data: to_datatables(<%= plural_name %>)}
  end
<% end -%>

<% # 建立 belongs_to associations select2 options method
editable_attributes_and_except_sorting_and_datetime_and_number.each do |attr|
  belongs_to_assoc = association_by_foreign_key(attr)
  if belongs_to_assoc
    assoc_class_name = belongs_to_assoc.name.to_s.classify
    assoc_singular_name = belongs_to_assoc.name.to_s
    assoc_plural_name = assoc_singular_name.pluralize
%>
  def <%= assoc_plural_name %>_for_select2
    per = params[:per]
    page = params[:page]
    filter = params[:search]

    q = <%= assoc_class_name %>.ransack(id_eq: filter)
    q.sorts = "created_at desc"
    <%= assoc_plural_name %> = q.result.page(page).per(per)

    filtered_count = q.result.count

    <%= assoc_plural_name %> = <%= assoc_plural_name %>.map{|<%= assoc_singular_name%>| {id: <%= assoc_singular_name%>.id, text: <%= assoc_singular_name%>.id}}

    render json: {results: <%= assoc_plural_name %>, filtered_count: filtered_count, per: per}
  end
<%
  end
end
%>

  private

  def set_<%= singular_name %>
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
<% if enable_pundit? -%>
    <%= "authorize [:admin, @#{singular_name}]" if admin? %>
    <%= "authorize @#{singular_name}" unless admin? %>
<% end -%>
  end

  def <%= singular_name %>_params
    params.require(:<%= singular_name %>).permit(<%= editable_attributes.map{ |attr| ":#{attr.name}"}.join(', ') %>)
  end

  def <%= singular_name %>_row_params(column_values)
    column_values.permit(<%= editable_attributes.map{ |attr| ":#{attr.name}"}.join(', ') %>)
  end

  # 處理呈現在datatable的資料結構
  def to_datatables(<%= plural_name %>)
    <%= plural_name %>.map do |<%= singular_name %>|
      {
        DT_RowId: "#{<%= singular_name %>.id}",
        <%= all_attributes.map{ |attr|
          if is_enum? attr
            row_attr = "#{attr.name}: #{singular_name}.#{attr.name},\n        "
            row_attr += "#{attr.name}_i18n: #{singular_name}.#{attr.name}_i18n,"
            row_attr
          elsif attr.type == 'boolean'
            "#{attr.name}: #{singular_name}.#{attr.name} == true ? I18n.t('helpers.select.true_option') : I18n.t('helpers.select.false_option'),"
          elsif attr.type == 'datetime'
            "#{attr.name}: #{singular_name}.#{attr.name}&.strftime('%Y-%m-%d %H:%M:%S'),"
          else
            "#{attr.name}: #{singular_name}.#{attr.name},"
          end
        }.join("\n        ")
        %>
      }
    end
  end

<% if enable_pundit? -%>
  def class_authorize
    <%= "authorize [:admin, #{class_name}]" if admin? %>
    <%= "authorize #{class_name}" unless admin? %>
  end
<% end -%>
end
