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
            @page_title = params[:page_title] || t("helpers.page_title.#{@action_name}", model: model_class.model_name.human)

            if @action_name != 'index'
              @readonly = @action_name != 'edit'

              instance_variable_set("@#{@model_name}", model_class.find_by(id: @id)) unless @id.blank?
            else
              unless @associate_model_name.blank?
                associate_class = @associate_model_name.classify.constantize 
                instance_variable_set( "@#{@associate_model_name}", associate_class.find_by(id: @associate_id) ) 
              end

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

