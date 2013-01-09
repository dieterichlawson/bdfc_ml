load '/home/dlaw/dev/wukong_og/lib/wukong/parser/flatpack/flat.rb'
load '/home/dlaw/dev/wukong_og/lib/wukong/parser/flatpack/parser.rb'
load '/home/dlaw/dev/wukong_og/lib/wukong/parser/flatpack/tokens.rb'
load '/home/dlaw/dev/wukong_og/lib/wukong/parser/flatpack/lang.rb'

module Wukong
  module Streamer
    class FlatPackStreamer < Wukong::Streamer::Base
      
      def self.format format
        @@parser = Wukong::Parser::FlatPack.create_parser format
      end
      
      def recordize line
        @@parser.parse(line,true)
      end
    end
  end
end
