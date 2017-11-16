# LarvataScaffold

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'larvata_scaffold', git: "https://github.com/LarvataTW/larvata_scaffold.git"

```
And then execute:

    $ bundle

## Usage

需要先建立好 Model 之後，才能使用此 controller scaffold 功能：

$ rails g larvata_scaffold:controller model_name [--admin] [--skip-row-editor]

--admin 表示為後台功能，會將功能放置在 namespace admin 下。
--skip-row-editor 表示會將 datatables 的 inline editing 功能關閉。

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/snowild/larvata_scaffold. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the LarvataScaffold project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/snowild/larvata_scaffold/blob/master/CODE_OF_CONDUCT.md).
