# Larvata Rails Scaffold

客製化的 Rails scaffold 擴展套件，可以根據 Model 快速產生 CRUD 的 Controller 跟 View。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'larvata_scaffold', git: "https://github.com/LarvataTW/larvata_scaffold.git"

```

Then execute:

    $ bundle

## Install Required Files

使用以下指令來建立所需要的檔案。

    $ rails g larvata_scaffold:install

## Controller Scaffold Usage

需要先建立好 Model 之後，才能使用此功能來產生基礎 CRUD 頁面功能。

    $ rails g larvata_scaffold:controller model_name [--admin] [--skip-row-editor] [--skip-pundit] [--attachable] [--controller [controller_name]] [--tab [enum_field_name]]

>--admin 表示為後台功能，會將功能放置在 namespace admin 下。    
--skip-row-editor 表示會將 datatables 的 inline editing 功能關閉。   
--skip-pundit 表示會將 pundit 功能關閉。    
--attachable 表示會啟用附件上傳功能。    
--controller [controller_name] 表示可以產生不同於 model 名稱的 resource 功能。    
--tab [enum_field_name] 表示可以用 enum_field_name 的 Array 內容來產生 index.html.erb 的頁籤功能。    

* 啟用附件上傳功能前，需要在 Model 中設定附件關連：

```ruby
has_many :attachments, as: :attachable
accepts_nested_attributes_for :attachments, :allow_destroy => true
```

* 在 Model 中設定 enum 資料欄位的話，會在 partial page _ form.html.erb 自動產生對應的下拉選單。

## Master-Detail Scaffold Usage

需要先使用 Controller Scaffold 建立好兩個主檔頁面之後，且兩個 model 有著一對多關連性，才能使用此功能來將主檔頁面功能改變為 master-detail 模式。

    $ rails g larvata_scaffold:master_detail master_model_name [--admin] [--controller [controller_name]] [--detail [detail_model_name]] [--detail_controller [detail_controller_name]]

>--admin 表示為後台功能，會將功能放置在 namespace admin 下。     
--controller [controller_name] 表示要修改不同於 master model 名稱的 resource 功能。
--detail [detail_model_name] 表示 detail model 名稱。
--detail_controller [detail_controller_name] 表示要修改不同於 detail model 名稱的 resource 功能。

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/snowild/larvata_scaffold. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the LarvataScaffold project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/snowild/larvata_scaffold/blob/master/CODE_OF_CONDUCT.md).

