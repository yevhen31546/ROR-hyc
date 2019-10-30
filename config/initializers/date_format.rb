Time::DATE_FORMATS.merge!(
  :longdate => '%d %B %Y',
  :default => '%d/%b/%Y %H:%M',
  :short => '%d/%b %H:%M',
  :long => '%d %B %Y %H:%M',
  :ordinal => lambda { |time| time.strftime("#{time.day.ordinalize} %B %Y") },
)
Date::DATE_FORMATS.merge!(
  :default => '%d/%b/%Y',
  :short => '%d/%b',
  :long => '%d %B %Y',
  :ordinal => lambda { |time| time.strftime("#{time.day.ordinalize} %B %Y") },
  :short_ordinal => lambda { |time| time.strftime("#{time.day.ordinalize} %b %Y") },
)
