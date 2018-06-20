require 'generators/larvata_scaffold/generator_helpers'

module LarvataScaffold
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc "Generates require files of larvata_scaffold."

      # We don’t need to call methods in the generator class. All public methods will be called one by one on generating.

      # 產生需要的檔案
      def copy_require_files
        copy_file "assets/javascripts/common/attachments.js", "app/assets/javascripts/common/attachments.js"
        copy_file "assets/javascripts/common/modals.js", "app/assets/javascripts/common/modals.js"

        copy_file "views/common/modals/open.js.erb", "app/views/common/modals/open.js.erb"
        copy_file "views/common/_attachments.html.erb", "app/views/common/_attachments.html.erb"

        copy_file "controllers/common/modals_controller.rb", "app/controllers/common/modals_controller.rb"
        copy_file "controllers/attachments_controller.rb", "app/controllers/attachments_controller.rb"
      end

      # 產生需要的 routes 設定
      def add_routes
        route "resources :attachments, only: [:index, :create, :destroy]"

        _eof_content = <<-EOF
  namespace :common do 
    namespace :modals do
      get :open
    end
  end
        EOF

        route _eof_content.strip
      end
    end
  end
end
