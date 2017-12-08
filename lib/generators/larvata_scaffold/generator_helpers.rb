module LarvataScaffold
  module Generators
    module GeneratorHelpers
      attr_accessor :options, :attributes

      private 

      def model_columns_for_editable_attributes
        class_name.constantize.columns.reject do |column|
          column.name.to_s =~ /(^(id|user_id|created_at|updated_at)$)|token|password/
        end
      end

      def model_columns_for_editable_attributes_and_except_sorting
        class_name.constantize.columns.reject do |column|
          column.name.to_s =~ /(^(id|user_id|created_at|updated_at|sorting)$)|token|password/
        end
      end

      def editable_attributes
        attributes ||= model_columns_for_editable_attributes.map do |column|
          Rails::Generators::GeneratedAttribute.new(column.name.to_s, column.type.to_s)
        end
      end

      def all_attributes
        attributes ||= class_name.constantize.columns.map do |column|
          Rails::Generators::GeneratedAttribute.new(column.name.to_s, column.type.to_s)
        end
      end

      def editable_attributes_and_except_sorting
        attributes ||= model_columns_for_editable_attributes_and_except_sorting.map do |column|
          Rails::Generators::GeneratedAttribute.new(column.name.to_s, column.type.to_s)
        end
      end

      def editable_attributes_and_except_sorting_and_datetime_and_number
        model_columns_for_editable_attributes_and_except_sorting_and_datetime_and_number = model_columns_for_editable_attributes_and_except_sorting.reject do |column|
          %w(datetime integer float decimal).include? column.type.to_s and not is_enum? column and not association_by_foreign_key(column)
        end

        attributes ||= model_columns_for_editable_attributes_and_except_sorting_and_datetime_and_number.map do |column|
          Rails::Generators::GeneratedAttribute.new(column.name.to_s, column.type.to_s)
        end
      end

      def editable_datetime_and_number_attributes_and_except_sorting_and_enum_and_assoc
        model_columns_for_editable_datetime_and_number_attributes_and_except_sorting = model_columns_for_editable_attributes_and_except_sorting.select do |column|
          %w(datetime integer float decimal).include? column.type.to_s and not is_enum? column and not association_by_foreign_key(column)
        end

        attributes ||= model_columns_for_editable_datetime_and_number_attributes_and_except_sorting.map do |column|
          Rails::Generators::GeneratedAttribute.new(column.name.to_s, column.type.to_s)
        end
      end

      def contains_sorting_column?
        sorting_columns = class_name.constantize.columns.select do |column|
          column.name.to_s =~ /^(sorting)$/
        end

        sorting_columns.any?
      end

      def enable_row_editor?
        !options['skip_row_editor']
      end

      def admin?
        options['admin']
      end

      def is_enum? column
        class_const = class_name.constantize
        plural_column_name = column.name.pluralize
        
        class_const.respond_to? plural_column_name and class_const.send(plural_column_name).is_a? ActiveSupport::HashWithIndifferentAccess
      end

      def attachable?
        class_const = class_name.constantize
        options['attachable'] and class_const.instance_methods.include? :attachments
      end

      def association_by_foreign_key column
        class_const = class_name.constantize
        assocs = class_const.reflect_on_all_associations(:belongs_to)
        assocs.select{|assoc| assoc.foreign_key == column.name}&.first
      end

      def custom_controller
        options['controller']
      end

      def singular_controller_name
        options['controller'] || file_name
      end

      def controller_path 
        admin? ? "app/controllers/admin" : "app/controllers"
      end

      def views_path
        admin? ? "app/views/admin" : "app/views"
      end

      def js_path 
        admin? ? "app/assets/javascripts/admin" : "app/assets/javascripts"
      end

      def controller_file_path 
        custom_controller&.pluralize || super
      end

      def controller_class_name 
        custom_controller&.classify&.pluralize || super
      end

      def controller_file_name 
        custom_controller&.pluralize || super
      end
    end
  end
end
