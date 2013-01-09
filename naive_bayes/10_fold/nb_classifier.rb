module NaiveBayes
  class Classifier

    def initialize predictors
      @predictors = predictors
      @class_counts = {}
      @feat_counts = {}
      @total = 0
    end

    def add_model model_file  
      f = File.open model_file
      f.each_line do |line|
        line = line[0..-2]
        line = line.split "\t"
        if line[0] == 'class'
          @class_counts[line[1]] ||= 0.0
          @class_counts[line[1]] += line[2].to_f
          @total += line[2].to_f
        elsif line[0] == 'feature'
          feat = line[1].to_i
          @feat_counts[feat] ||={}
          @feat_counts[feat][line[2]] ||={}
          @feat_counts[feat][line[2]][line[3]] ||= 0.0
          @feat_counts[feat][line[2]][line[3]] += line[4].to_f
        end
      end
      @priors = {}
      @class_counts.each_key do |label|
        @priors[label] = Math.log(@class_counts[label]/@total)
      end
      @labels = @priors.keys
      @log_probs = {}
      @feat_counts.each_key do |feature|
        @log_probs[feature] ||= {}
        @feat_counts[feature].each_key do |value|
          @log_probs[feature][value] ||= {}
          @feat_counts[feature][value].each_key do |label|
            @log_probs[feature][value][label] = Math.log(@feat_counts[feature][value][label]/@class_counts[label])
          end
        end
      end
    end

    def classify example
      probs = [0] * @labels.size
      # add the priors
      @labels.each_with_index do |label,index|
        probs[index] += @priors[label]
      end
      # add the other probs
      @predictors.each do |feature|
        example[feature] = example[feature].to_s
         @labels.each_with_index do |label,index|
           if @log_probs[feature].has_key? example[feature] and @log_probs[feature][example[feature]].has_key? label
               probs[index] += @log_probs[feature][example[feature]][label]
           else
              probs[index] += Math.log(1.0/@class_counts[label])
           end
         end
      end
      return @labels[probs.index(probs.max)]
    end
  end
end
