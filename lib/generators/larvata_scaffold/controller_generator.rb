require 'generators/larvata_scaffold/generator_helpers'

module LarvataScaffold
  module Generators
    class ControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      include LarvataScaffold::Generators::GeneratorHelpers

      source_root File.expand_path('../templates', __FILE__)

      desc "Generates controller, controller_spec and views for the model with the given NAME."

      class_option :skip_row_editor, type: :boolean, default: false, desc: "Skip \"Row Editor\" action"
      class_option :skip_pundit, type: :boolean, default: false, desc: "Skip Pundit setting."
      class_option :admin, type: :boolean, default: false, desc: "Backend function?"
      class_option :attachable, type: :boolean, default: false, desc: "Can function attach files?"
      class_option :controller, type: :string, default: nil, desc: "Specifie controller class name."

      # We don’t need to call methods in the generator class. All public methods will be called one by one on generating.
      def copy_controller_and_spec_files
        template "controller.rb", File.join(controller_path, "#{controller_file_name}_controller.rb")
      end

      def copy_view_files
        directory_path = File.join(views_path, controller_file_path)
        empty_directory directory_path

        view_files.each do |file_name|
          template "views/#{file_name}.html.erb", File.join(directory_path, "#{file_name}.html.erb")
        end
      end

      def view_files
        actions = %w(index _table new edit _form)
        actions
      end

      def copy_js_files
        template "assets/javascripts/datatables.js", File.join(js_path, "#{controller_file_path}_datatables.js")
        template "assets/javascripts/model.js", File.join(js_path, "#{controller_file_path}.js")
      end

      def pundit_file
        template "policies/pundit.rb", File.join(policies_path, "#{singular_name}_policy.rb")
      end

      def add_routes
        routes_string = ""

        routes_string += "namespace :admin do\n    " if admin?
        routes_string += "resources :#{controller_file_name} do\n      "
        routes_string += "collection do\n        "
        routes_string += "post :datatables\n        "
        routes_string += "patch :update_row_sorting\n        " if contains_sorting_column?
        routes_string += "patch :update_row\n      "

        # 建立 belongs_to associations select2 options route
        editable_attributes_and_except_sorting_and_datetime_and_number.each do |attr| 
          belongs_to_assoc = association_by_foreign_key(attr)
          if belongs_to_assoc 
            routes_string += "  "

            assoc_singular_name = belongs_to_assoc.name.to_s
            assoc_plural_name = assoc_singular_name.pluralize
            routes_string += "post :#{assoc_plural_name}_for_select2\n      "
          end
        end

        routes_string += "end\n    "
        routes_string += "end\n  "
        routes_string += "end\n" if admin?

        route routes_string
      end
    end
  end
end
