require 'generators/larvata_scaffold/generator_helpers'

module LarvataScaffold
  module Generators
    class ControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      include LarvataScaffold::Generators::GeneratorHelpers

      source_root File.expand_path('../templates', __FILE__)

      desc "Generates controller, controller_spec and views for the model with the given NAME."

      class_option :skip_row_editor, type: :boolean, default: false, desc: "Skip \"Row Editor\" action"
      class_option :admin, type: :boolean, default: false, desc: "Backend function"
      class_option :attachable, type: :boolean, default: false, desc: "Can function attach files?"

      # We don’t need to call methods in the generator class. All public methods will be called one by one on generating.
      def copy_controller_and_spec_files
        controller_path = admin? ? "app/controllers/admin" : "app/controllers"
        template "controller.rb", File.join(controller_path , "#{controller_file_name}_controller.rb")
      end

      def copy_view_files
        views_path = admin? ? "app/views/admin" : "app/views"
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
        js_path = admin? ? "app/assets/javascripts/admin" : "app/assets/javascripts"
        template "assets/javascripts/datatables.js", File.join(js_path, "#{controller_file_path}_datatables.js")
      end

      def add_routes
        routes_string = ""

        routes_string += "namespace :admin do\n    " if admin?
        routes_string += "resources :#{plural_name} do\n      "
        routes_string += "collection do\n        "
        routes_string += "post :datatables\n        "
        routes_string += "patch :update_row_sorting\n        " if contains_sorting_column?
        routes_string += "patch :update_row\n      "
        routes_string += "end\n    "
        routes_string += "end\n  "
        routes_string += "end\n" if admin?

        route routes_string
      end
    end
  end
end
