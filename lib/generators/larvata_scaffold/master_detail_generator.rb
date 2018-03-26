require 'generators/larvata_scaffold/generator_helpers'

module LarvataScaffold
  module Generators
    class MasterDetailGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      include LarvataScaffold::Generators::GeneratorHelpers

      source_root File.expand_path('../templates', __FILE__)

      desc "Generates master-detail for the model with the given NAME."

      class_option :admin, type: :boolean, default: false, desc: "Backend function?"
      class_option :controller, type: :string, default: nil, desc: "Specifie master resource controller name."
      class_option :detail, type: :string, default: nil, desc: "Specifie detail resource model name."
      class_option :detail_controller, type: :string, default: nil, desc: "Specifie detail resource controller name."

      # We don’t need to call methods in the generator class. All public methods will be called one by one on generating.

      # 產生 master 需要的 js.erb 檔案
      def copy_master_jserb_view_files
        directory_path = File.join(views_path, master_controller)

        master_jserb_view_files.each do |file_name|
          template "views/#{file_name}.js.erb", File.join(directory_path, "#{file_name}.js.erb")
        end
      end

      def copy_master_tab_view_file
        directory_path = File.join(views_path, controller_file_path, 'tabs')

        template "views/tabs/_detail_tab.html.erb", File.join(directory_path, "_#{detail_controller}_tab.html.erb")
      end

      def modify_master_controller_file
        master_controller_file = File.join(controller_path, "#{master_controller}_controller.rb")

        # 增加 @tabs 宣告到 show 內
        if File.readlines(master_controller_file).grep(/@tabs = tabs/).size == 0
          insert_into_file master_controller_file, after: "def show\n" do
            _eof_content = <<-EOF
            @tabs = tabs
            EOF

            _eof_content 
          end
        end
        
        # 確認 tabs 是否存在，不存在則建立
        if File.readlines(master_controller_file).grep(/def tabs/).size == 0
          insert_into_file master_controller_file, before: "  private\n" do
            _eof_content = <<-EOF
  # 設定連結所屬明細頁籤
  def tabs
    tabs_array = []
    tabs_array << {name: '#{master}'}
    tabs_array
  end

            EOF

            _eof_content 
          end
        end
        
        # 確認 change_show_tab 是否存在，不存在則建立
        if File.readlines(master_controller_file).grep(/def change_show_tab/).size == 0
          insert_into_file master_controller_file, before: "  private\n" do
            _eof_content = <<-EOF
  # 變換頁籤顯示內容
  def change_show_tab
    @current_tab = tabs.select{ |tab| tab[:name] == params[:tab] }.first

    row_count_vars_of_tab(@current_tab[:name])

    respond_to do |format|
      format.js { }
    end
  end

            EOF

            _eof_content 
          end
        end

        # 確認 render_tab_content 是否存在，不存在則建立
        if File.readlines(master_controller_file).grep(/def render_tab_content/).size == 0
          insert_into_file master_controller_file, before: "  private\n" do
            _eof_content = <<-EOF
  # 進入 master show 頁面後，依據 master_show_tab 的內容切換頁籤
  def render_tab_content
    master_show_tab = params[:master_show_tab]

    row_count_vars_of_tab(master_show_tab)

    render partial: "#{'admin/' if admin?}#{master_controller}/tabs/\#{master_show_tab}_tab", locals: { #{master}: @#{master}, master_show_tab: master_show_tab }
  end

            EOF

            _eof_content 
          end
        end

        # 增加 detail index row count variables 程式到 row_count_vars_of_tab 方法內
        if File.readlines(master_controller_file).grep(/@#{detail_controller}_status_group_row_counts/).size == 0
          insert_into_file master_controller_file, after: "when '#{master}'\n" do
            _eof_content = <<-EOF
      when '#{detail_controller}'
        @#{detail_controller}_status_group_row_counts = @#{master}.#{detail.pluralize}.group(:status).count
        @#{detail_controller}_all_row_count = @#{detail_controller}_status_group_row_counts.inject(0) { |row_count, status_group| row_count + status_group[1] }
            EOF

            _eof_content 
          end
        end

        # 增加 detail 項目到 tabs 方法內
        if File.readlines(master_controller_file).grep(/tabs_array << {name: '#{detail_controller}'}/).size == 0
          insert_into_file master_controller_file, before: "    tabs_array\n" do
            _eof_content = <<-EOF
      tabs_array << {name: '#{detail_controller}'}
            EOF

            _eof_content 
          end
        end
      end

      def modify_master_js_file
        master_js_file = File.join(js_path, "#{master_controller}.js")

        # 
        if File.readlines(master_js_file).grep(/typeof master_show_tab !== 'undefined' && master_show_tab != ""/).size == 0
          insert_into_file master_js_file, after: "$(function() {\n" do
            _eof_content = <<-EOF
    // 依據傳入的 master_show_tab 參數來切換 show 頁面的 detail 頁籤內容
    if( typeof #{master}_id !== 'undefined' && #{master}_id != "" && typeof master_show_tab !== 'undefined' && master_show_tab != "" ) {
        \$.ajax({
            url: \"/#{'admin/' if admin?}#{master_controller}/\"+ #{master}_id +\"/render_tab_content\",
            method: 'get',
            dataType: 'html',
            data: { master_show_tab: master_show_tab }
        }).success(function(tab_html){
            if(tab_html !== '') {
                $('.tab-pane.active').removeClass('active');
                $('.tab.active').removeClass('active');
                $('#'+master_show_tab+'_tab').addClass('active');
                $('#'+master_show_tab+'_tabpanel').addClass('active').html($(tab_html));
            }
        }); 
    }

            EOF

            _eof_content 
          end
        end
      end

      def modify_detail_controller_file
        detail_controller_file = File.join(controller_path, "#{detail_controller}_controller.rb")

        # 調整 create、update 的 redirect_to url
        if File.readlines(detail_controller_file).grep(/redirect_to admin_#{detail_controller}_path/).size != 0
          _eof_content = <<-EOF
      redirect_to \"\#{$navigation[:master_show_url]}?master_show_tab=\#{$navigation[:master_show_tab]}\"
          EOF

          gsub_file detail_controller_file, /redirect_to admin_#{detail_controller}_path/, _eof_content.strip
        end

        # 調整 destroy 的 redirect_to url
        if File.readlines(detail_controller_file).grep(/redirect_to admin_#{detail_controller}_url/).size != 0
          _eof_content = <<-EOF
      redirect_to \"\#{$navigation[:master_show_url]}?master_show_tab=\#{$navigation[:master_show_tab]}\"
          EOF

          gsub_file detail_controller_file, /redirect_to admin_#{detail_controller}_url/, _eof_content.strip
        end
        
        # 確認 set_navigation 相關程式是否存在，不存在則建立
        if File.readlines(detail_controller_file).grep(/navigation = /).size == 0
          insert_into_file detail_controller_file, before: "  def index\n" do
            _eof_content = <<-EOF
  before_action :set_navigation, only: [:new, :edit, :show]

  $navigation = {}

            EOF

            _eof_content 
          end

          insert_into_file detail_controller_file, after: "  private\n" do
            _eof_content = <<-EOF

  def set_navigation
    referrer = request.referrer
    $navigation[:master_show_url] = referrer[0, referrer.index('?') || referrer.length]
    $navigation[:master_show_tab] = params[:master_show_tab]
  end
            EOF

            _eof_content 
          end
        end
      end

      def modify_detail_new_btn_and_controller_action
        detail_controller_file = File.join(controller_path, "#{detail_controller}_controller.rb")
        detail_index_datatables_file = File.join(views_path, detail_controller, "_index_datatables.html.erb")

        # 增加程式到 detail 的 _index_datatables.html.erb 內，讓點擊 detail 的新增按鈕時會送出 master id
        if File.readlines(detail_index_datatables_file).grep(/new_#{'admin_' if admin?}#{detail_controller.singularize}_path,/).size != 0
          _eof_content = <<-EOF
new_#{'admin_' if admin?}#{detail_controller.singularize}_path(
                master_show_tab: (defined? master_show_tab) ? master_show_tab : '',
            ),
          EOF

          gsub_file detail_index_datatables_file, /new_#{'admin_' if admin?}#{detail_controller.singularize}_path,/, _eof_content.strip
        end

        insert_into_file detail_index_datatables_file, after: "new_#{'admin_' if admin?}#{detail_controller.singularize}_path(\n" do
          _eof_content = <<-EOF
                #{master}_id: (defined? #{master}) ? #{master}.id : '',
          EOF

          _eof_content 
        end

        # 增加程式到 new 方法內，讓新增 detail 時，會帶入 master id
        insert_into_file detail_controller_file, after: "def new\n" do
          _eof_content = <<-EOF
    #{master} = params[:#{master}_id] && #{master.classify}.find_by_id(params[:#{master}_id])
    @#{detail}= #{master}&.#{detail.pluralize}&.new
          EOF

          _eof_content 
        end

        # 調整原本 new 方法中的 ModelClass.new 程式
        if File.readlines(detail_controller_file).grep(/@#{detail} = #{detail.classify}.new/).size != 0
          _eof_content = <<-EOF
        @#{detail} ||= #{detail.classify}.new
          EOF

          gsub_file detail_index_datatables_file, /@#{detail} = #{detail.classify}.new/, _eof_content.strip
        end

        # 增加程式到 datatables 方法內，讓查詢 detail 時，會帶入 master id
        insert_into_file detail_controller_file, before: "      @q = active_record_query.ransack(@filters)\n" do
          _eof_content = <<-EOF
      active_record_query = active_record_query.includes(:#{master}).where(#{master.pluralize}: {id: params[:#{master}_id]}) unless params[:#{master}_id].blank?
          EOF

          _eof_content 
        end
      end

      def modify_detail_datatable_js_file
        detail_datatables_js_file = File.join(js_path, "#{detail_controller}_datatables.js")

        # 讓 datatable url 加上 master pk query string
        if File.readlines(detail_datatables_js_file).grep(/data: {/).size == 0
          insert_into_file detail_datatables_js_file, after: "type: 'POST',\n" do
            _eof_content = <<-EOF
                data: {
                }
            EOF

            _eof_content 
          end
        end

        insert_into_file detail_datatables_js_file, after: "data: {\n" do
          _eof_content = <<-EOF
                    #{master}_id: typeof #{master}_id === 'undefined' ? '' : #{master}_id,
          EOF

          _eof_content 
        end

        # 增加 master_show_tab_value 到 datatables column 的 render function 內
        insert_into_file detail_datatables_js_file, after: "var id = data.id;\n" do
          _eof_content = <<-EOF
                        var master_show_tab_value = typeof master_show_tab !== 'undefined' ? master_show_tab : '';
          EOF

          _eof_content 
        end

        # 調整 datatables grid 上的編輯按鈕 url
        _eof_content = <<-EOF
      /admin/#{detail_controller}/' + id + '/edit?master_show_tab='+ master_show_tab_value +'\"
        EOF

        gsub_file detail_datatables_js_file, /\/admin\/#{detail_controller}\/' \+ id \+ '\/edit"/, _eof_content.strip

        # 調整 datatables grid 上的刪除按鈕 url
        _eof_content = <<-EOF
      /admin/#{detail_controller}/' + id + '?master_show_tab='+ master_show_tab_value +'\"
        EOF

        gsub_file detail_datatables_js_file, /\/admin\/#{detail_controller}\/' \+ id \+ '"/, _eof_content.strip


      end

      # 調整 detail _form.html.erb back btn 的 url
      def modify_detail_form_back_btn
        detail_form_file = File.join(views_path, detail_controller, "_form.html.erb")

        if File.readlines(detail_form_file).grep(/admin_#{detail_controller}_path/).size != 0
          _eof_content = <<-EOF
      \"\#{$navigation[:master_show_url]}?master_show_tab=\#{$navigation[:master_show_tab]}\"
          EOF

          gsub_file detail_form_file, /admin_#{detail_controller}_path/, _eof_content.strip
        end
      end

      # 調整 master model js file
      def modify_master_model_js_file

      end

      private 

      def master_jserb_view_files
        actions = %w(change_show_tab)
        actions
      end
    end
  end
end
