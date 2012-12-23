#!/usr/bin/env ruby

require 'wukong'

module StdDev
  class Mapper < Wukong::Streamer::RecordStreamer
    
    def initialize
      @sum = 0.0
      @n = 0
      @sum_squared = 0.0
    end

    def process *line
      val = line[0].to_f
      @n += 1
      @sum += val
      @sum_squared += val*val
    end

    def after_stream
      emit ["stddev",@n,(@sum/@n.to_f),@sum_squared]
    end
  end
  class Reducer < Wukong::Streamer::ListReducer
  
    def start! *args
      @total = 0
      @mean = 0.0
      @sos_dev = 0.0
    end

    def accumulate *fields
      sample_n = fields[1].to_i
      sample_mean = fields[2].to_f
      sample_x_squared = fields[3].to_f
      sample_sos_dev = sample_x_squared - ((sample_mean**2)*sample_n)
      @total += sample_n
      if @mean == 0.0
        @mean = sample_mean
      else
        @mean = calc_mean(sample_mean,@mean,sample_n,@total)
      end
      if @sos_dev == 0.0
        @sos_dev = sample_sos_dev
      else
        @sos_dev = calc_sos_dev(sample_mean,@mean, sample_n, @total, sample_sos_dev, @sos_dev)
      end
    end

    def calc_mean mean_a, mean_b, n_a, n_b
      (n_a * mean_a + n_b * mean_b)/(n_a + n_b)
    end

    def calc_sos_dev mean_a, mean_b, n_a, n_b, sos_dev_a, sos_dev_b
      sos_dev_a + sos_dev_b + ((mean_b - mean_a)**2)*((n_a*n_b)/(n_a+n_b))
    end

    def finalize
      yield ["mean",@mean]
      yield ["stddev",Math.sqrt(@sos_dev/@total)]
    end
  end
end

Wukong::Script.new(
  StdDev::Mapper,
  StdDev::Reducer
).run
