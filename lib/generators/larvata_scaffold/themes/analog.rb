module LarvataScaffold
  module Generators
    module Themes
      module Analog

        private

        # 子標頭標籤（開始）
        def begin_subheader_tags
          _eof_content = <<-EOF
<div class="an-body-topbar wow fadeIn" style="visibility: visible; animation-name: fadeIn;">
          EOF
          _eof_content.rstrip
        end

        # 子標頭標籤（結束）
        def end_subheader_tags
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # 功能標題標籤（開始）
        def begin_page_title_tags
          _eof_content = <<-EOF
<div class="an-page-title">
        <h2>
          EOF
          _eof_content.rstrip
        end

        # 功能標題標籤（結束）
        def end_page_title_tags
          _eof_content = <<-EOF
    </h2>
    </div>
          EOF
          _eof_content.rstrip
        end

        # 頁面內容標籤（開始）
        # m-content
        def begin_page_content_tags
          _eof_content = <<-EOF
<div>
          EOF
          _eof_content.rstrip
        end
        
        # 頁面內容標籤（結束）
        def end_page_content_tags
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # datatables 內容標籤（開始）
        def begin_datatables_panel_tags
          _eof_content = <<-EOF
<div class="panel">
          EOF
          _eof_content.rstrip
        end
        
        # datatables 內容標籤（結束）
        def end_datatables_panel_tags
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # datatables 標頭標籤（開始）
        def begin_datatables_panel_header_tags 
          _eof_content = <<-EOF
<div class="panel-heading">
          EOF
          _eof_content.rstrip
        end

        # datatables 標頭標籤（結束）
        def end_datatables_panel_header_tags 
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # datatables 標頭 caption 標籤（開始）
        def begin_datatables_panel_header_caption_tags
          _eof_content = <<-EOF
<div class="panel-heading-caption">
          EOF
          _eof_content.rstrip
        end

        # datatables 標頭 caption 標籤（結束）
        def end_datatables_panel_header_caption_tags
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # datatables 標頭 tools 標籤（開始）
        def begin_datatables_panel_header_tools_tags 
          _eof_content = <<-EOF
<div class="panel-heading-tools">
          EOF
          _eof_content.rstrip
        end

        # datatables 標頭 tools 標籤（結束）
        def end_datatables_panel_header_tools_tags 
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # 查詢條件區塊包覆標籤（開始）
        def begin_search_wrapper_tags 
          _eof_content = <<-EOF
<div class="search_wrapper">
          EOF
          _eof_content.rstrip
        end

        # 查詢條件區塊包覆標籤（結束）
        def end_search_wrapper_tags
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # 頁面內容區塊標籤（開始） 
        def begin_datatables_panel_body_tags
          _eof_content = <<-EOF
<div class="panel-body">
          EOF
          _eof_content.rstrip
        end

        # 頁面內容區塊標籤（開始） 
        def end_datatables_panel_body_tags
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # 按鈕區塊標籤（開始）
        def begin_helper_block_tags
          _eof_content = <<-EOF
<div class="an-helper-block">
          EOF
          _eof_content.rstrip
        end

        # 按鈕區塊標籤（開始）
        def end_helper_block_tags
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # tab 區塊標籤（開始）
        def begin_tabs_block_tags
          _eof_content = <<-EOF
<div class="an-bootstrap-custom-tab">
          EOF
          _eof_content.rstrip
        end

        # tab 區塊標籤（結束）
        def end_tabs_block_tags
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # tab 控制標籤（開始）
        def begin_tabs_control_tags
          _eof_content = <<-EOF
<div class="an-tab-control">
          EOF
          _eof_content.rstrip
        end

        # tab 控制標籤（結束）
        def end_tabs_control_tags
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # tab 內容標籤（開始）
        def begin_tabs_content_tags
          _eof_content = <<-EOF
<div class="tab-content">
          EOF
          _eof_content.rstrip
        end

        # tab 內容標籤（結束）
        def end_tabs_content_tags
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # 查詢區塊標籤（開始）
        def begin_filter_condition_panel_tags
          _eof_content = <<-EOF
<div class="panel panel-default an-sidebar-search filter-condition-panel">
          EOF
          _eof_content.rstrip
        end

        # 查詢區塊標籤（結束）
        def end_filter_condition_panel_tags
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # 查詢區塊標頭標籤（開始）
        def begin_filter_condition_panel_header_tags(controller_file_path)
          _eof_content = <<-EOF
<div class="panel-heading" role="tab">
            <h4 class="panel-title">
                <a class="collapsed" role="button" href="##{controller_file_path}_search_panel" data-toggle="collapse" 
                    data-parent="#accordion" aria-expanded="false" aria-controls="#{controller_file_path}_search_panel">
          EOF
          _eof_content.rstrip
        end

        # 查詢區塊標頭標籤（結束）
        def end_filter_condition_panel_header_tags
          _eof_content = <<-EOF
        </a>
            </h4>
        </div>
          EOF
          _eof_content.rstrip
        end

        # 查詢區塊內容標籤（開始）
        def begin_filter_condition_panel_content_tags(controller_file_path)
          _eof_content = <<-EOF
<div id="#{controller_file_path}_search_panel" class="panel-collapse collapse" role="search panel">
            <div class="panel-body">
          EOF
          _eof_content.rstrip
        end

        # 查詢區塊內容標籤（結束）
        def end_filter_condition_panel_content_tags
          _eof_content = <<-EOF
    </div>
        </div>
          EOF
          _eof_content.rstrip
        end

        # panel or portlet 標籤（開始）
        def begin_panel_tags 
          _eof_content = <<-EOF
<div class="panel">
          EOF
          _eof_content.rstrip
        end

        # panel or portlet 標籤（結束）
        def end_panel_tags 
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # panel or portlet header（開始）
        def begin_panel_header_tags
          _eof_content = <<-EOF
<div class="panel-heading">
          EOF
          _eof_content.rstrip
        end

        # panel or portlet header（結束）
        def end_panel_header_tags
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # panel or portlet 標頭 caption 標籤（開始）
        def begin_panel_header_caption_tags
          _eof_content = <<-EOF
<div class="m-portlet__head-caption"><h3 class="m-portlet__head-text">
          EOF
          _eof_content.rstrip
        end

        # panel or portlet 標頭 caption 標籤（結束）
        def end_panel_header_caption_tags
          _eof_content = <<-EOF
</h3></div>
          EOF
          _eof_content.rstrip
        end

        # panel or portlet 標頭 tools 標籤（開始）
        def begin_panel_header_tools_tags 
          _eof_content = <<-EOF
<div class="m-portlet__head-tools">
          EOF
          _eof_content.rstrip
        end

        # panel or portlet 標頭 tools 標籤（結束）
        def end_panel_header_tools_tags 
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end
        # panel or portlet body（開始）
        def begin_panel_body_tags
          _eof_content = <<-EOF
<div class="panel-body">
          EOF
          _eof_content.rstrip
        end

        # panel or portlet body（結束）
        def end_panel_body_tags
          _eof_content = <<-EOF
</div>
          EOF
          _eof_content.rstrip
        end

        # 表單輸入元件的 form-control class
        def form_control_class
          "an-form-control"
        end

        # 查詢表單的輸入元件 class
        def input_class_of_search_form
          "no-redius border-bottom m-0 text_color"
        end

        # 維護表單的輸入元件 class
        def input_class_of_form
          ""
        end

        # 表單的 form-group 標籤 class
        def form_group_class_of_form
          "form-group"
        end

        # 表單的輸入元件 label class
        def input_label_class_of_form
          "control-label"
        end

        # 查詢表單的區間輸入元件結構（開始）
        def begin_range_tags_of_search_form
          _eof_content = <<-EOF
<div class='col-sm-5 no-padding'>
                            <div class='col-sm-12 no-padding'>
          EOF
          _eof_content.rstrip
        end
        
        # 查詢表單的區間輸入元件結構（至）
        def append_range_tags_of_search_form
          _eof_content = <<-EOF
</div>
                        </div>
                        <div class='col-sm-1 no-padding t-center'> ~ </div>
                        <div class='col-sm-6 no-padding'>
                            <div class='col-sm-12 no-padding'>
          EOF
          _eof_content.rstrip
        end
        
        # 查詢表單的區間輸入元件結構（結束）
        def end_range_tags_of_search_form
          _eof_content = <<-EOF
    </div>
                        </div>
                        <div class='clear'></div>
                    </div>
          EOF
          _eof_content.rstrip
        end
      end
    end
  end
end
