class Common::ModalsController < ApplicationController 
  def open
    respond_to do |format|
      format.js {
        @controller_name = params[:controller_name]
        @partial_page = params[:partial_page]
        @model_name = params[:model_name]
        @model_scope = params[:model_scope]
        @id = params[:id]
        @action_name = params[:action_name]
        @tab = params[:tab]
        @associate_model_name = params[:associate_model_name]
        @associate_id = params[:associate_id]

        begin
          unless @model_name.blank?
            model_class = @model_name.classify.constantize
            model_class = model_class.send(@model_scope) unless @model_scope.blank?
            controller_class = "#{@controller_name}_controller".classify.constantize
            @page_title = params[:page_title] || t("helpers.page_title.#{@action_name}", model: model_class.model_name.human)

            if @action_name != 'index' # 如果開啟的頁面是 edit, show, new 頁面
              # 設定是否唯讀
              @readonly = ['show'].include? @action_name

              # 設定關連資料的 master 物件
              instance_variable_set("@#{@model_name}", model_class.find_by(id: @id)) unless @id.blank?
              instance_variable_set("@#{@model_name}", model_class.new) if @id.blank?

              # 設定頁面內不同資料來源的頁籤
              instance_variable_set("@tabs", controller_class.new.tabs) unless @tab.blank?
            else # 如果開啟的頁面是 index 列表頁 
              unless @associate_model_name.blank? # 設定關連資料的 master 物件
                associate_class = @associate_model_name.classify.constantize 
                instance_variable_set( "@#{@associate_model_name}", associate_class.find_by(id: @associate_id) ) 
              end

              # 設定頁籤
              if @tab.present? and ActiveRecord::Base.connection.column_exists?(@model_name.pluralize.to_sym, @tab.to_sym)
                tabs_group_row_counts = model_class.group(@tab.to_sym).count
                all_row_count = tabs_group_row_counts.inject(0) { |row_count, tabs_group| row_count + tabs_group[1] }
                instance_variable_set("@#{controller_without_namespace}_#{@tab}_group_row_counts", tabs_group_row_counts) 
                instance_variable_set("@#{controller_without_namespace}_all_row_count", all_row_count) 
              end
            end
          end
        rescue => ex
          @error_message = ex.to_s
        end
      }
    end
  end

  private 

  def controller_without_namespace
    @controller_name.remove('admin/')
  end
end


