# ASTree

ASTree is like tree command for RubyVM::AbstractSyntaxTree

## Installation


```
$ gem install astree
```

## Usage

```
$ astree ruby_programfile
```

sample code

```ruby
10.times do |i|
  puts i
end
```

result

```
<SCOPE>
├───── []
├───── nil
└───── <ITER>
       ├───── <CALL>
       │      ├───── <LIT>
       │      │      └───── 10
       │      ├───── :times
       │      └───── nil
       └───── <SCOPE>
              ├───── [:i]
              ├───── <ARGS>
              │      ├───── 1
              │      ├───── nil
              │      ├───── nil
              │      ├───── nil
              │      ├───── 0
              │      ├───── nil
              │      ├───── nil
              │      ├───── nil
              │      ├───── nil
              │      └───── nil
              └───── <FCALL>
                     ├───── :puts
                     └───── <ARRAY>
                            ├───── <DVAR>
                            │      └───── :i
                            └───── nil
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/siman-man/astree. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ASTree project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/astree/blob/master/CODE_OF_CONDUCT.md).
