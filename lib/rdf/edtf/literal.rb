require "edtf"

module RDF::EDTF
  ##
  # An EDTF Date literal
  #
  # @example Initializing an EDTF literal with {RDF::Literal}
  #    RDF::Literal('107x', datatype: RDF::EDTF::Literal::DATATYPE)
  #
  class Literal < RDF::Literal
    DATATYPE = RDF::URI("http://id.loc.gov/datatypes/edtf/EDTF")

    YEAR = %r(-*[0-9]{4})
    ONETHRU12 = %r{(01|02|03|04|05|06|07|08|09|10|11|12)}
    ONETHRU13 = Regexp.union(ONETHRU12, /13/).freeze
    ONETHRU23 = Regexp.union(ONETHRU13, %r{(14|15|16|17|18|19|20|21|22|23)})
      .freeze
    ZEROTHRU23 = Regexp.union(/00/, ONETHRU23).freeze
    ONETHRU29 = Regexp.union(ONETHRU23, %r{(24|25|26|27|28|29)}).freeze
    ONETHRU30 = Regexp.union(ONETHRU29, /30/).freeze
    ONETHRU31 = Regexp.union(ONETHRU30, /31/).freeze

    ONETHRU59 = Regexp.union(ONETHRU31,
      %r{(32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59)})
      .freeze
    ZEROTHRU59 = Regexp.union(/00/, ONETHRU59).freeze

    POSITIVEDIGIT = %r{(1|2|3|4|5|6|7|8|9)}
    DIGIT = Regexp.union(POSITIVEDIGIT, /0/).freeze

    DAY = ONETHRU31
    MONTH = ONETHRU12
    MONTHDAY = %r{((01|03|05|07|08|10|12)-#{ONETHRU31})|((04|06|09|11)-#{ONETHRU30})|(02-#{ONETHRU29})}

    YEARMONTH = %r{#{YEAR}-#{MONTH}}
    YEARMONTHDAY = %r{#{YEAR}-#{MONTHDAY}}
    HOUR = ZEROTHRU23
    MINUTE = ZEROTHRU59
    SECOND = ZEROTHRU59

    POSITIVEYEAR = %r{(#{POSITIVEDIGIT}#{DIGIT}#{DIGIT}#{DIGIT})|(#{DIGIT}#{POSITIVEDIGIT}#{DIGIT}#{DIGIT})|(#{DIGIT}#{DIGIT}#{POSITIVEDIGIT}#{DIGIT})|(#{DIGIT}#{DIGIT}#{DIGIT}#{POSITIVEDIGIT})}
    NEGATIVEYEAR = %r{-#{POSITIVEYEAR}}
    YYEAR = %r{(#{POSITIVEYEAR}|#{NEGATIVEYEAR}|0000)}
    DATE = %r{(#{YYEAR}|#{YEARMONTH}|#{YEARMONTHDAY})}

    BASETIME = %r{(#{HOUR}:#{MINUTE}:#{SECOND}|(24:00:00))}
    # Zone offset is specified loosely, due to the issue documented here:
    #   https://github.com/inukshuk/edtf-ruby/issues/14
    # The correct specification is:
    # ZONEOFFSET = %r(Z|((\+|\-))(#{ONETHRU13}((\:#{MINUTE})|$)|14\:00|00\:#{ONETHRU59})).freeze
    ZONEOFFSET = %r{Z|((\+|-))(#{ONETHRU13}((:#{MINUTE})|$)|14:00|00:#{MINUTE})}
    TIME = %r{#{BASETIME}(#{ZONEOFFSET}|$)}
    DATEANDTIME = %r{#{DATE}T#{TIME}}

    L0INTERVAL = %r{#{DATE}/#{DATE}}

    LEVEL0EXPRESSION = Regexp.union(/^#{DATE}$/, /^#{DATEANDTIME}/, /^#{L0INTERVAL}$/).freeze

    UASYMBOL = %r{(\?|~|\?~)}
    SEASONNUMBER = %r{(21|22|23|24)}
    SEASON = %r{#{YYEAR}-#{SEASONNUMBER}}
    DATEORSEASON = %r{(#{DATE}|#{SEASON})}

    UNCERTAINORAPPROXDATE = %r{#{DATE}#{UASYMBOL}}
    YEARWITHONEORTWOUNSPECIFEDDIGITS = %r{#{DIGIT}#{DIGIT}(#{DIGIT}|u)u}
    MONTHUNSPECIFIED = %r{#{YEAR}-uu}
    DAYUNSPECIFIED = %r{#{YEARMONTH}-uu}
    DAYANDMONTHUNSPECIFIED = %r{#{YEAR}-uu-uu}
    UNSPECIFIED = Regexp.union(YEARWITHONEORTWOUNSPECIFEDDIGITS,
      MONTHUNSPECIFIED,
      DAYUNSPECIFIED,
      DAYANDMONTHUNSPECIFIED).freeze

    L1START = %r{(#{DATEORSEASON}(#{UASYMBOL})*)|unknown}
    L1END = %r{(#{L1START}|open)}

    L1INTERVAL = %r{#{L1START}/#{L1END}}

    LONGYEARSIMPLE = %r{y-?#{POSITIVEDIGIT}#{DIGIT}#{DIGIT}#{DIGIT}#{DIGIT}+}

    LEVEL1EXPRESSION = %r{^(#{UNCERTAINORAPPROXDATE}|#{UNSPECIFIED}|#{L1INTERVAL}|#{LONGYEARSIMPLE}|#{SEASON})$}

    IUABASE = %r{(#{YEAR}#{UASYMBOL}-#{MONTH}(-\(#{DAY}\)#{UASYMBOL})?|#{YEAR}#{UASYMBOL}-#{MONTHDAY}#{UASYMBOL}?|#{YEAR}#{UASYMBOL}?-\(#{MONTH}\)#{UASYMBOL}(-\(#{DAY}\)#{UASYMBOL})?|#{YEAR}#{UASYMBOL}?-\(#{MONTH}\)#{UASYMBOL}(-#{DAY})?|#{YEARMONTH}#{UASYMBOL}-\(#{DAY}\)#{UASYMBOL}|#{YEARMONTH}#{UASYMBOL}-#{DAY}|#{YEARMONTH}-\(#{DAY}\)#{UASYMBOL}|#{YEAR}-\(#{MONTHDAY}\)#{UASYMBOL}|#{SEASON}#{UASYMBOL})}

    INTERNALUNCERTAINORAPPROXIMATE = %r{#{IUABASE}|\(#{IUABASE}\)#{UASYMBOL}}

    POSITIVEDIGITORU = %r{#{POSITIVEDIGIT}|u}
    DIGITORU = %r{#{POSITIVEDIGITORU}|0}
    ONETHRU3 = %r{1|2|3}

    YEARWITHU = %r{u#{DIGITORU}#{DIGITORU}#{DIGITORU}|#{DIGITORU}u#{DIGITORU}#{DIGITORU}|#{DIGITORU}#{DIGITORU}u#{DIGITORU}|#{DIGITORU}#{DIGITORU}#{DIGITORU}u}
    DAYWITHU = %r{#{ONETHRU31}|u#{DIGITORU}|#{ONETHRU3}u}
    MONTHWITHU = %r{#{ONETHRU12}|0u|1u|(u#{DIGITORU})}

    # these allow days out of range for the month given (e.g. 2013-02-31)
    # is this a bug in the EDTF BNF?
    YEARMONTHWITHU = %r{(#{YEAR}|#{YEARWITHU})-#{MONTHWITHU}|#{YEARWITHU}-#{MONTH}}
    MONTHDAYWITHU = %r{(#{MONTH}|#{MONTHWITHU})-#{DAYWITHU}|#{MONTHWITHU}-#{DAY}}
    YEARMONTHDAYWITHU = %r{(#{YEARWITHU}|#{YEAR})-#{MONTHDAYWITHU}|#{YEARWITHU}-#{MONTHDAY}}

    INTERNALUNSPECIFIED = Regexp.union(YEARWITHU, YEARMONTHWITHU, YEARMONTHDAYWITHU).freeze

    DATEWITHINTERNALUNCERTAINTY = Regexp.union(INTERNALUNCERTAINORAPPROXIMATE, INTERNALUNSPECIFIED).freeze

    EARLIER = %r{\.\.#{DATE}}
    LATER = %r{#{DATE}\.\.}
    CONSECUTIVES = %r{#{YEARMONTHDAY}\.\.#{YEARMONTHDAY}|#{YEARMONTH}\.\.#{YEARMONTH}|#{YEAR}\.\.#{YEAR}}

    LISTELEMENT = %r{#{DATE}|#{DATEWITHINTERNALUNCERTAINTY}|#{UNCERTAINORAPPROXDATE}|#{UNSPECIFIED}|#{CONSECUTIVES}}
    # list contents are specified here to allow spaces:
    #  e.g. [1995, 1996, 1997]
    # this is not allowed in the specification's grammar
    # see: https://github.com/inukshuk/edtf-ruby/issues/15
    LISTCONTENT = %r{(#{EARLIER}(,\s?#{LISTELEMENT})*|(#{EARLIER},\s?)?(#{LISTELEMENT},\s?)*#{LATER}|#{LISTELEMENT}(,\s?#{LISTELEMENT})+|#{CONSECUTIVES})}

    CHOICELIST = %r{\[#{LISTCONTENT}\]}
    INCLUSIVELIST = %r(\{#{LISTCONTENT}\})

    MASKEDPRECISION = %r{#{DIGIT}#{DIGIT}((#{DIGIT}x)|xx)}

    L2INTERVAL = %r{(#{DATEORSEASON}/#{DATEWITHINTERNALUNCERTAINTY})|(#{DATEWITHINTERNALUNCERTAINTY}/#{DATEORSEASON})|(#{DATEWITHINTERNALUNCERTAINTY}/#{DATEWITHINTERNALUNCERTAINTY})}

    POSITIVEINTEGER = %r{#{POSITIVEDIGIT}#{DIGIT}*}
    LONGYEARSCIENTIFIC = %r{y-?#{POSITIVEINTEGER}e#{POSITIVEINTEGER}(p#{POSITIVEINTEGER})?}

    QUALIFYINGSTRING = %r{\S+}
    SEASONQUALIFIED = %r{#{SEASON}\^#{QUALIFYINGSTRING}}

    LEVEL2EXPRESSION = %r{^(#{INTERNALUNCERTAINORAPPROXIMATE}|#{INTERNALUNSPECIFIED}|#{CHOICELIST}|#{INCLUSIVELIST}|#{MASKEDPRECISION}|#{L2INTERVAL}|#{LONGYEARSCIENTIFIC}|#{SEASONQUALIFIED})$}

    ##
    # Grammar is articulated according to the BNF in the EDTF 1.0 pre-submission
    # specification, except where noted above.
    #
    # @todo investigate the allowance for out-of-range days (e.g. 2013-02-31) in
    #   `INTERNALUNSPECIFIED`
    # @todo follow up on zone offset `00:00`; disallow, if appropriate, once
    #   {https://github.com/inukshuk/edtf-ruby/issues/14} is closed
    # @todo disallow spaces in LISTCONTENT when
    #   {https://github.com/inukshuk/edtf-ruby/issues/15} is closed
    #
    # @see http://www.loc.gov/standards/datetime/pre-submission.html#bnf
    GRAMMAR = Regexp.union(LEVEL0EXPRESSION, LEVEL1EXPRESSION, LEVEL2EXPRESSION).freeze

    ##
    # Initializes an RDF::Literal with EDTF datatype.
    #
    # @see RDF::Literal
    def initialize(value, datatype: nil, lexical: nil, **options)
      @datatype = RDF::URI(datatype || self.class.const_get(:DATATYPE))
      @object = begin
        EDTF.parse!(value.respond_to?(:edtf) ? value.edtf : value)
      rescue
        value
      end
      if !lexical.nil?
        # A lexical value was directly provided.
        @string = lexical.to_s.freeze
      elsif value.is_a?(String)
        # No lexical value was explicitly provided, but the given value is a
        # +String+; it is used directly as the lexical value.
        #
        # This does **not** coerce the string. Use +#canonicalize!+ to ensure a
        # canonical EDTF form.
        @string = value.dup.freeze
      elsif @object.respond_to?(:edtf)
        # No lexical value was explicitly provided, but the computed object
        # responds to +:edtf+; the return value is used as the lexical value.
        @string = object.edtf.to_s.freeze
      else # standard:disable Style/EmptyElse
        # +@string+ is not defined if none of the above cases hold.
        #
        # This is intentional; the implementation of +RDF::Literal+ checks to
        # see if +@string+ has been defined in several places, with specific
        # fallbacks if it is not.
      end
    end

    ##
    # Converts this literal into its canonical lexical representation.
    #
    # If the +value+ of this literal is not an EDTF date, this method does
    # nothing.
    #
    # @return [RDF::Literal] `self`
    def canonicalize!
      @string = @object.respond_to?(:edtf) ? @object.edtf : @string
      self
    end

    ##
    # Returns the string representation of the literal (its EDTF string, if
    # defined, or the string value of +#object+ otherwise).
    #
    # Following the behaviour of +RDF::Literal+, this does not necessarily match
    # the actual lexical value (use +#value+ for that).
    def to_s
      (@object.respond_to?(:edtf) ? @object.edtf : @object.to_s).freeze
    end
  end
end
