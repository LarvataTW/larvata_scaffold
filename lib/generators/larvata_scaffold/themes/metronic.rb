module LarvataScaffold
  module Generators
    module Themes
      module Metronic

        private

        # 子標頭標籤（開始）
        def begin_subheader_tags
          _eof_content = <<-EOF
<div class="m-subheader">
    <div class="d-flex align-items-center">
          EOF
          _eof_content.rstrip
        end

        # 子標頭標籤（結束）
        def end_subheader_tags
          _eof_content = <<-EOF
    </div>
</div>
          EOF
          _eof_content.rstrip
        end

        # 功能標題標籤（開始）
        def begin_page_title_tags(page_title)
          _eof_content = <<-EOF
    <div class="mr-auto">
            <h4 class="m-subheader__title m-subheader__title--separator">
                <%= t('helpers.page_title.#{page_title}', model: #{class_name}.model_name.human) %>
          EOF
          _eof_content.rstrip
        end

        # 功能標題標籤（結束）
        def end_page_title_tags
          _eof_content = <<-EOF
        </h4>
        </div>
          EOF
          _eof_content.rstrip
        end

        # 頁面內容標籤（開始）
        # m-content
        def begin_page_content_tags
          _eof_content = <<-EOF
<div class="m-content">
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
<div class="m-portlet m-portlet--mobile">
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
<div class="m-portlet__head">
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
<div class="m-portlet__head-caption"><h3 class="m-portlet__head-text">
          EOF
          _eof_content.rstrip
        end

        # datatables 標頭 caption 標籤（結束）
        def end_datatables_panel_header_caption_tags
          _eof_content = <<-EOF
</h3></div>
          EOF
          _eof_content.rstrip
        end

        # datatables 標頭 tools 標籤（開始）
        def begin_datatables_panel_header_tools_tags 
          _eof_content = <<-EOF
<div class="m-portlet__head-tools">
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
<div class="">
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
<div class="m-portlet__body">
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
<div class="m-accordion m-accordion--default filter-condition-panel" role="tablist">
    <div class="m-accordion__item">
          EOF
          _eof_content.rstrip
        end

        # 查詢區塊標籤（結束）
        def end_filter_condition_panel_tags
          _eof_content = <<-EOF
    </div>
</div>
          EOF
          _eof_content.rstrip
        end

        # 查詢區塊標頭標籤（開始）
        def begin_filter_condition_panel_header_tags(controller_file_path)
          _eof_content = <<-EOF
<div class="m-accordion__item-head collapsed" role="tab" id="#{controller_file_path}_search_panel_header" data-toggle="collapse" href="##{controller_file_path}_search_panel_body" aria-expanded="false">
            <span class="m-accordion__item-icon">
                <i class="fa flaticon-search"></i>
            </span>
            <span class="m-accordion__item-title">
          EOF
          _eof_content.rstrip
        end

        # 查詢區塊標頭標籤（結束）
        def end_filter_condition_panel_header_tags
          _eof_content = <<-EOF
    </span>
            <span class="m-accordion__item-mode"></span>
        </div>
          EOF
          _eof_content.rstrip
        end

        # 查詢區塊內容標籤（開始）
        def begin_filter_condition_panel_content_tags(controller_file_path)
          _eof_content = <<-EOF
<div class="m-accordion__item-body collapse" id="#{controller_file_path}_search_panel_body" role="tabpanel" aria-labelledby="#{controller_file_path}_search_panel_header" style="">
            <div class="m-accordion__item-content">
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
<div class="m-portlet m-portlet--mobile">
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
<div class="m-portlet__head">
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
        def begin_panel_header_caption_tags(page_title)
          _eof_content = <<-EOF
<div class="m-portlet__head-caption"><h4 class="m-portlet__head-text">
                <%= t("#{class_name}.model_name.human") %>
          EOF
          _eof_content.rstrip
        end

        # panel or portlet 標頭 caption 標籤（結束）
        def end_panel_header_caption_tags
          _eof_content = <<-EOF
</h4></div>
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
<div class="m-portlet__body">
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
          "form-control"
        end

        # 查詢表單的輸入元件 class
        def input_class_of_search_form
          "m-input"
        end

        # 維護表單的輸入元件 class
        def input_class_of_form
          ""
        end

        # 表單的 form-group 標籤 class
        def form_group_class_of_form
          "form-group m-form__group row"
        end

        # 表單的輸入元件 label class
        def input_label_class_of_form
          "col-form-label"
        end

        # 查詢表單的區間輸入元件結構（開始）
        def begin_range_tags_of_search_form
          _eof_content = <<-EOF
<div class="input-daterange input-group">
          EOF
          _eof_content.rstrip
        end

        # 查詢表單的區間輸入元件結構（至）
        def append_range_tags_of_search_form
          _eof_content = <<-EOF
<div class="input-group-append">
                                <span class="input-group-text">
                                    <i class="la la-ellipsis-h"></i>
                                </span>
                            </div>
          EOF
          _eof_content.rstrip
        end
        
        # 查詢表單的區間輸入元件結構（結束）
        def end_range_tags_of_search_form
          _eof_content = <<-EOF
</div>
                </div>
          EOF
          _eof_content.rstrip
        end
      end
    end
  end
end
