require 'generators/larvata_scaffold/generator_helpers'

module LarvataScaffold
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc "Generates require files of larvata_scaffold."

      # We don’t need to call methods in the generator class. All public methods will be called one by one on generating.

      # 產生需要的檔案
      def copy_require_files
        copy_file "assets/javascripts/datatables.utils.js", "app/assets/javascripts/datatables.utils.js"
        copy_file "assets/javascripts/common/attachments.js", "app/assets/javascripts/common/attachments.js"
        copy_file "assets/javascripts/common/modals.js", "app/assets/javascripts/common/modals.js"
        copy_file "assets/javascripts/froala.js", "app/assets/javascripts/froala.js"
        copy_file "assets/javascripts/froala_plugins.js", "app/assets/javascripts/froala_plugins.js"

        copy_file "assets/stylesheets/froala_plugins.css.scss", "app/assets/stylesheets/froala_plugins.css.scss"

        copy_file "views/common/modals/open.js.erb", "app/views/common/modals/open.js.erb"
        copy_file "views/common/_attachments.html.erb", "app/views/common/_attachments.html.erb"

        copy_file "controllers/common/modals_controller.rb", "app/controllers/common/modals_controller.rb"
        copy_file "controllers/attachments_controller.rb", "app/controllers/attachments_controller.rb"

        copy_file "services/datatables_service.rb", "app/services/datatables_service.rb"

        copy_file "config/locales/zh-TW.yml", "config/locales/zh-TW.yml"
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

      # 補上缺少的 JS 設定
      def add_js_settings
        admin_js_file = File.join("app", "assets", "javascripts", "admin.js")

        if File.readlines(admin_js_file).grep(/jquery-fileupload/).size == 0
          insert_into_file admin_js_file, before: "$(function() {" do
            _eof_content = <<~EOF
  //= require jquery-fileupload

            EOF

            _eof_content
          end
        end

        if File.readlines(admin_js_file).grep(/common\/modals/).size == 0
          insert_into_file admin_js_file, before: "$(function() {" do
            _eof_content = <<~EOF
  //= require common/modals

            EOF

            _eof_content
          end
        end

        if File.readlines(admin_js_file).grep(/common\/attachments/).size == 0
          insert_into_file admin_js_file, before: "$(function() {" do
            _eof_content = <<~EOF
  //= require common/attachments

            EOF

            _eof_content
          end
        end

        if File.readlines(admin_js_file).grep(/froala_editor/).size == 0
          insert_into_file admin_js_file, before: "$(function() {" do
            _eof_content = <<~EOF
  //= require froala_editor.min
  //= require froala_plugins
  //= require froala
            EOF

            _eof_content
          end
        end
      
      end


      # 補上缺少的 CSS 設定
      def add_css_settings
        admin_css_file = File.join("app", "assets", "stylesheets", "admin.css.scss")

        if File.readlines(admin_css_file).grep(/jquery.fileupload/).size == 0
          append_to_file admin_css_file do
            _eof_content = <<~EOF

  @import "jquery.fileupload";
  @import "jquery.fileupload-ui";
            EOF

            _eof_content
          end
        end

        if File.readlines(admin_css_file).grep(/froala_editor/).size == 0
          append_to_file admin_css_file do
            _eof_content = <<~EOF

  @import "froala_editor.min";
  @import "froala_style.min";
  @import "froala_plugins";
            EOF

            _eof_content
          end
        end

      end

      # 確認是否存在 attachments model 和表格，如果不存在則建立之
      def create_attachments_model_and_table
        # 執行 rails g model attachment 指令
        if ActiveRecord::Base.connection.table_exists? 'attachments'
          generate "migration CreateAttachments attachable_id:integer attachable_type:string attachable_additional_type:string attachment_file_name:string attachment_file_size:integer attachment_content_type:string attachment_updated_at:datetime"
          copy_file "models/attachment.rb", "app/models/attachment.rb"
        end
      end
    end
  end
end
