# frozen_string_literal: true

require 'json'

DIAGNOSTIC_ENTRY = /^([^:]+):(\d+):(\d+): \[([a-z]+)\] (.*)$/.freeze
END_MARKER = /Detected \d+ problems? from \d+ files?/.freeze

diagnostics = []

while (line = gets)
  case line
  when DIAGNOSTIC_ENTRY
    m = Regexp.last_match
    diagnostics << { filename: m[1], line: m[2].to_i, column: m[3].to_i, level: m[4], messages: ["#{m[5]}\n"] }
  when END_MARKER
    break
  else
    diagnostics.last[:messages] << line if diagnostics.last
  end
end

rdjson = {
  source: {
    name: 'steep',
    url: 'https://github.com/soutaro/steep'
  },
  severity: 'ERROR',
  diagnostics: diagnostics.map do |d|
    {
      message: d[:messages].join,
      location: {
        path: d[:filename],
        range: {
          start: {
            line: d[:line],
            column: d[:column]
          }
        }
      },
      severity: d[:level].upcase,
      code: {
        value: d[:messages][1].split[-1]
      }
    }
  end
}

puts rdjson.to_json
