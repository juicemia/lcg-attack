#! /usr/bin/env ruby

# HW3 - linear congruential generator

if ARGV.length < 5
	puts "usage: linear_congruential_test.rb <x0> <x1> <x2> <x3> <max_modulo>"
	exit
end

# this also acts as our x_init
accumulator = 0

x = [ARGV[0], ARGV[1], ARGV[2], ARGV[3]]

# this keeps us from going into an infinite loop
max_modulo = ARGV[4]

def generator_function(x, coefficient, increment, modulo)
	(coefficient * x + increment) % modulo
end

# If we find the first x value, we need to see if the function can generate the
# rest of them from what was passed in. Ruby is pass-by-value, but all values
# are references, so the accumulator needs to be copied before it goes in for
# the testing, if not it will be modified for the rest of the candidate values.
def test_candidates(accumulator, coefficient, increment, modulo)
	accumulator = generator_function(accumulator, coefficient, increment, modulo)
	return false if accumulator != x[1]

	accumulator = generator_function(accumulator, coefficient, increment, modulo)
	return false if accumulator != x[2]

	accumulator = generator_function(accumulator, coefficient, increment, modulo)
	return false if accumulator != x[3]

	return true
end

# Convenience function.
def report_success_for(coefficient, increment, modulo)
	puts "match #{x[0]} #{x[1]} #{x[2]} #{x[3]}"
	puts "coefficient #{coefficient}"
	puts "increment #{increment}"
	puts "modulo #{modulo}"
	exit
end

# Loop until we get a match for our first X, or if the number generated is
# bigger than the first X.
(max_modulo + 1).times do |modulo|
	modulo.times do |coefficient|
		modulo.times do |increment|
			accumulator = generator_function(
				accumulator, coefficient, increment, modulo
			)

			# If we skipped over the first x value, there's no point in continuing.
			if accumulator > x[0]
				next
			elsif accumulator == x[0]
				if test_candidates(accumulator.copy)
					report_success_for coefficient, increment, modulo
				end
			end
		end
	end
end

puts "found no matches"
