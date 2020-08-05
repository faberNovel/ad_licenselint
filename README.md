# ADLicenselint

The purpose of this gem is to automatically generate a summary of the licenses for the pods used in an iOS project.


## Example

```
bundle exec ad_licenselint -f term -p /path/to/Podfile -a

+-------------------+----------------------------+----------------------------------------------------+
| Pod               | License                    | Source                                             |
+-------------------+----------------------------+----------------------------------------------------+
| Alamofire         | MIT                        | https://github.com/Alamofire/Alamofire             |
| Firebase          | Apache                     | https://github.com/firebase/firebase-ios-sdk       |
| ObjectivePGP      | BSD for non-commercial use | https://github.com/krzyzanowskim/ObjectivePGP      |
| SwiftGen          | MIT                        | https://github.com/SwiftGen/SwiftGen               |
| SwiftLint         | MIT                        | https://github.com/realm/SwiftLint                 |
+-------------------+----------------------------+----------------------------------------------------+
```

## Installation

Add this line to your Gemfile:

```ruby
gem 'ad_licenselint`
```

And then execute:
```
bundle install
```

You can also install it globally running:
```
gem install ad_licenselint
```

## Usage

### Command line:

```
cd path/to/Podfile
bundle exec ad_licenselint

# Alternatively, use the -p option
bundle exec ad_licenselint -p path/to/Podfile

+-------------------+----------------------------+----------------------------------------------------+
| Pod               | License                    | Source                                             |
+-------------------+----------------------------+----------------------------------------------------+
| ObjectivePGP      | BSD for non-commercial use | https://github.com/krzyzanowskim/ObjectivePGP      |
+-------------------+----------------------------+----------------------------------------------------+
```

This will output the licenses that are not free to use in your project. By default, `MIT`, `Apache` or `BSD` are considered valid.

If you want to see all the licenses, run:

```
bundle exec ad_licenselint -a

+-------------------+----------------------------+----------------------------------------------------+
| Pod               | License                    | Source                                             |
+-------------------+----------------------------+----------------------------------------------------+
| Alamofire         | MIT                        | https://github.com/Alamofire/Alamofire             |
| Firebase          | Apache                     | https://github.com/firebase/firebase-ios-sdk       |
| ObjectivePGP      | BSD for non-commercial use | https://github.com/krzyzanowskim/ObjectivePGP      |
| SwiftGen          | MIT                        | https://github.com/SwiftGen/SwiftGen               |
| SwiftLint         | MIT                        | https://github.com/realm/SwiftLint                 |
+-------------------+----------------------------+----------------------------------------------------+
```

By default the output format is set to `term`. You can use `md` to generate a markdown output:

```
bundle exec ad_licenselint -f md
```

The output becomes:

---

| Pod | License | Source |
| --- | --- | --- |
| ObjectivePGP | BSD for non-commercial use | https://github.com/krzyzanowskim/ObjectivePGP |

<details>
<summary>Licenses</summary>

### ObjectivePGP
```
The ObjectivePGP stays under a dual license:

====================================================================
Free for non-commercial use:

Copyright (C) 2014-2017, Marcin Krzyżanowski All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

- Non-commercial use

- Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

- Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

====================================================================
Paid for commercial use:

Commercial-use license to use in commercial products. Please contact me via email (marcin@krzyzanowskim.com) for details.
```
</details>

---

If you want to see all the options available, display help:

```
bundle exec ad_licenselint -h
```

### Ruby

If you want to use the the gem in your ruby scripts, you can generate a report like so:

```ruby
runner = ADLicenseLint::Runner.new({
  format: ADLicenseLint::Constant::MARKDOWN_FORMAT_OPTION,
  path: "/path/to/Podfile",
  all: false
})

# either print the string
puts runner.run

# either use the generated report
report = runner.create_report
```

## Tests

Run `make tests` to run the tests.

## License

The gem is available as open source under the terms of the [MIT license](http://opensource.org/licenses/mit-license.php)
