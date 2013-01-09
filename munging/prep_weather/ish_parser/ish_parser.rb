require 'wukong'
require 'wukong/parser/flatpack_parser'
require 'set'
require_relative './ish_lang.rb'
require_relative './rem_parser.rb'
module ISHParser
  class Parser

    attr_accessor :headers

    def initialize
      @parsers = {'REM' => ISHParser::REMParser.new}
      @main_parser = Wukong::Parser::FlatPack.create_parser ISHParser::MAIN_FORMAT
      @headers = {}
    end

    def parser_for_header header
      format = format_for_header header
      return nil if format.nil?
      puts "Initializing new parser for header #{header}" unless  @parsers.has_key? format
      @parsers[format] ||= Wukong::Parser::FlatPack.create_parser "#{format}s*"
      @parsers[format]
    end

    def format_for_header(header)
      format = ISHParser::FORMATS[header] || ISHParser::FORMATS["#{header[0..1]}#"] || ISHParser::FORMATS["#{header[0]}##"]
      puts "Could not find format for header '#{header}'" if format.nil?
      format
    end

    def parse_with_header(header, str)
      if @headers.has_key? header
        @headers[header] += 1
      else
        @headers[header] = 1
      end
      parser = parser_for_header(header)
      if parser.nil?
        puts "Could not parse '#{header}#{str}'."
        return nil
      end
      results = parser.parse str
      if results.nil?
        puts "ERROR PARSING: #{str}" 
        return nil
      end
      [results[0..-2],results[-1]]
    end

    def parse str
      results = {}
      parsed = @main_parser.parse str
      if parsed.nil?
        puts "UNABLE TO PARSE #{str}"
        exit
      end
      results[''] = parsed[0..-2]
      return results.merge(parse_additional(parsed[-1]))
    end
  
    def parse_additional str
      return {} if str.nil? or str.empty? or str.length < 3
      header = str[0..2]
      rest = str[3..-1]
      res = parse_with_header(header,rest)
      return {} if res.nil?
      return parse_additional(res[1]) if res[0].empty?
      return {header => res[0]}.merge(parse_additional(res[1]))
    end
  end
end
