# RDF::EDTF

This is an `RDF::Literal` implementation around [Extended Date Time
Format][EDTF].

The underlying EDTF parser and implementation is provided by
[`edtf-ruby`][edtf-ruby]. ~~The parser supports all EDTF features, with caveats
noted below.~~ EDTF has been updated (2019) since the original publishing of
this library, and not all features currently use the new syntax. More complete
documentation about what is supported (and what isn’t) TBD.

## Usage

```ruby
require 'rdf/edtf'

RDF::EDTF::Literal.new('1076?')
# or
RDF::Literal('1076?', datatype: RDF::EDTF::Literal::DATATYPE)
```

## Contribution Guidelines

Please observe the following guidelines:

- Write tests for your contributions.
- Document methods you add using YARD annotations.
- Run `standardb` before committing.
- Use well formed commit messages.

## License

The original (`v1.0`; 2015) implementation of this package by DPLA was public
domain software / licenced under the Unlicense.

Present additions & contributions (2023 and beyond) are licensed under the [MIT
license](./LICENSE). By making contributions to this repository, you agree to
license them thusly.

[EDTF]: https://www.loc.gov/standards/datetime/
[edtf-ruby]: https://github.com/inukshuk/edtf-ruby/
