#! /usr/bin/env ruby

load 'nb_classifier.rb'
load 'discretizer.rb'

PREDICTORS = (1..11).to_a
TARGET = 13
TRAINING_SET = '../flights.small'
MODEL_FILE = 'model2'
TEST_SET = '../held_out.tsv'

classifier = NaiveBayes::Classifier.new(MODEL_FILE, PREDICTORS)
test_set = File.open(TEST_SET, 'r')
discretizer = Discretize::Discretizer.new 'ranges'

num_right = 0
num_wrong = 0
right_by_class = {}
wrong_by_class = {}
test_set.each_line do |example|
  example = example[0..-2]
  example = example.split "\t"
  example = discretizer.disc_example example
  prediction = classifier.classify example
  if prediction == example[TARGET]
    num_right +=1
    right_by_class[example[TARGET]] ||= 0
    right_by_class[example[TARGET]] += 1
  else
    num_wrong +=1
    wrong_by_class[example[TARGET]] ||= 0
    wrong_by_class[example[TARGET]] += 1
  end
end
puts "#{num_right} right out of #{num_right + num_wrong}"
puts "#{(num_right.to_f/(num_right +num_wrong))*100}% accuracy"
right_by_class.keys.each do |key|
  puts "Wrong on class #{key} #{wrong_by_class[key]} times"
  puts "Right on class #{key} #{right_by_class[key]} times"
end

