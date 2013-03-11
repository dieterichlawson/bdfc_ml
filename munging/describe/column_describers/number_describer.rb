require_relative 'default_describer.rb'

module ColumnDescribers

  MISSING_VALS = [-999.0, -9999.0]

  class NumberMapper < DefaultMapper

    def initialize index, name, type
      super index, name, type
      @min = Float::INFINITY
      @max = -Float::INFINITY
      @sum = 0.0
      @num = 0
      @num_missing = 0
      @sum_squared = 0.0
    end

    def process val
      val = val.to_f
      if MISSING_VALS.include? val
        @num_missing += 1
      else
        @num += 1
        @sum += val
        @sum_squared += val*val
        @max = val if val > @max
        @min = val if val < @min
      end
    end

    def attributes
      super.merge({
        num: @num,
        num_missing: @num_missing,
        min: @min,
        max: @max,
        mean: @sum/@num.to_f,
        sum_squared: @sum_squared,
      })
    end
  end
  class NumberReducer < DefaultReducer
    
    def start! first
      super first
      @min = Float::INFINITY
      @max = -Float::INFINITY
      @num = 0
      @num_missing = 0
      @mean = nil
      @sos_dev = nil
    end

    def accumulate attrs
      sample_min = attrs['min']
      sample_max = attrs['max']
      sample_n = attrs['num']
      num_missing = attrs['num_missing']
      sample_mean = attrs['mean']
      sample_x_squared = attrs['sum_squared']

      @num += sample_n
      @num_missing += num_missing
      @min = sample_min if sample_min < @min
      @max = sample_max if sample_max > @max
      sample_sos_dev = sample_x_squared - ((sample_mean**2)*sample_n)
      @mean = calc_mean(sample_mean,@mean,sample_n,@num) 
      @sos_dev = calc_sos_dev(sample_mean,@mean,sample_n,@num,sample_sos_dev,@sos_dev)
    end

    def calc_mean mean_a, mean_b, n_a, n_b
      return mean_a if mean_b.nil?
      return mean_b if mean_a.nil?
      (n_a * mean_a + n_b * mean_b)/(n_a + n_b)
    end

    def calc_sos_dev mean_a, mean_b, n_a, n_b, sos_dev_a, sos_dev_b
      return sos_dev_a if sos_dev_b.nil?
      return sos_dev_b if sos_dev_a.nil?
      sos_dev_a + sos_dev_b + ((mean_b - mean_a)**2) * ((n_a * n_b) / (n_a + n_b))
    end

    def finalize
      super.merge({
        num: @num,
        num_missing: @num_missing,
        max: @max,
        min: @min,
        mean: @mean,
        std_dev: Math.sqrt(@sos_dev/@num),
      })
    end
  end
end
