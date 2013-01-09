module ISHParser
  class REMParser
    def parse str
      results = []
      length = str[0..2].to_i
      results << length
      results << str[3..2+length]
      results << str[3+length..-1]
      results
    end
  end
end
