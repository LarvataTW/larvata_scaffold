class <%= 'Admin::' if admin? %><%= controller_class_name %>Controller < ApplicationController
<% if admin? -%>
  layout "admin"
<% end -%>

  before_action :set_<%= singular_name %>, only: [:show, :edit, :update, :destroy]

  def index

  end

  def datatables
    respond_to do |format|
      # 設定排序條件
      unless params[:order].blank?
        @sorting_key = params[:order]['0'][:column].to_i # 排序條件
        @sorting_dir = params[:order]['0'][:dir] # 降冪升冪
        @page = (params[:start].to_i/params[:length].to_i) + 1 # 要顯示資料的頁數
      end
      

      @filters = DatatablesService.new.handle_filters(params)

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
      redirect_to <%= 'admin_' if admin? %><%= plural_name %>_path(@<%= singular_name %>), notice: '已成功建立<%= human_name %>資料'
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @<%= singular_name %>.update(<%= singular_name %>_params)
      redirect_to <%= 'admin_' if admin? %><%= plural_name %>_path(@<%= singular_name %>), notice: '已成功更新<%= human_name %>資料'
    else
      render :edit
    end
  end
  
  def destroy
    @<%= singular_name %>.destroy
    redirect_to <%= 'admin_' if admin? %><%= plural_name %>_url, notice: '已成功刪除<%= human_name %>資料'
  end

<% if enable_row_editor? -%>
  # 更新列表的單筆 row 資料
  def update_row
    params[:data].each do |id, column_values|
      respond_to do |format|
        format.json {
          <%= singular_name %> = <%= class_name %>.find_by(id: id)

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

  private

  def set_<%= singular_name %>
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
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
        <%= all_attributes.map{ |attr| "#{attr.name}: #{singular_name}.#{attr.name}" }.join(",\n        ") %>
      }
    end
  end
end
