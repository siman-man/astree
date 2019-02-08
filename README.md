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
<SCOPE> [1:0-3:3]
├───── [] (local table)
├───── nil (arguments)
└───── <ITER> [1:0-3:3]
       ├───── <CALL> [1:0-1:8]
       │      ├───── <LIT> [1:0-1:2]
       │      │      └───── 10 (value)
       │      ├───── :times (method id)
       │      └───── nil (arguments)
       └───── <SCOPE> [1:9-3:3]
              ├───── [:i] (local table)
              ├───── <ARGS> [1:13-1:14]
              │      ├───── 1 (pre_num)
              │      ├───── nil (pre_init)
              │      ├───── nil (opt)
              │      ├───── nil (first_post)
              │      ├───── 0 (post_num)
              │      ├───── nil (post_init)
              │      ├───── nil (rest)
              │      ├───── nil (kw)
              │      ├───── nil (kwrest)
              │      └───── nil (block)
              └───── <FCALL> [2:2-2:8]
                     ├───── :puts (method id)
                     └───── <ARRAY> [2:7-2:8]
                            ├───── <DVAR> [2:7-2:8]
                            │      └───── :i (variable name)
                            └───── nil (unknown)
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
