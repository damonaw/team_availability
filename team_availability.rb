#!/usr/bin/ruby

# Constants
WORK_HOURS = ['8:30', '17:00']
LUNCH      = ['12:00', '13:00']

# Ask user for the teams availability.
puts "Work is from #{WORK_HOURS[0]} to #{WORK_HOURS[1]}."
puts 'Please enter the team availability:'
availability = gets.chomp
require 'byebug';byebug
puts "The team is availabile form #{WORK_HOURS[0]} to #{WORK_HOURS[1]}."
puts "Lunch is at #{LUNCH[0]} and ends at #{LUNCH[1]}."
