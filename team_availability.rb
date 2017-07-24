#!/usr/bin/ruby
require 'time'

# definition of class Day
#
# This class holds constance regarding the work day, as well as determining
# a proper time for appointments.
class Day
  # Constants
  HALF_HOUR  = 30 * 60
  WORK_HOURS = ['8:30', '5:00']
  LUNCH      = ['12:00', '1:00']

  # Class variables
  @@available  = []

  def initialize( work_hours: WORK_HOURS, lunch: LUNCH )
    # Instance variables
    @work_hours = work_hours
    @lunch      = lunch
    @@available = half_hour_blocks( @work_hours[0], @work_hours[1] )
  end

  ##
  # Prints out an array of half-hour blocks that the whole team in available.
  def team_availability( appointments )
    return unless appointments.is_a? Array
    # Add lunch to the list of appointments, remove duplicate appointments.
    appointments.push( @lunch )
    appointments.uniq

    appointment_blocks = []
    # Remove appointments from the list of available times.
    appointments.each do |appointment|
      appointment_blocks.push( half_hour_blocks( appointment[0], appointment[1] ) )
    end
    # Remove any duplicate blocks of time.
    appointment_blocks.flatten!(1)
    appointment_blocks.uniq
    # Remove appointments from available
    appointment_blocks.each do |appointment_block|
      @@available.delete appointment_block
    end
    puts "#{@@available}"
  end

  private

  ##
  # Adds am or pm to the end of the time string.
  # Assumes that 12 and times less then the end of the work day is pm.
  # Assumes that times greater than the start of the work day is am.
  # @return String
  def am_pm( time )
    if time.to_i == 12 || time.to_i <= @work_hours[1].to_i
      time + "pm"
    elsif time.to_i >= @work_hours[0].to_i
      time + "am"
    end
  end

  ##
  # Builds an array of all the half-hour blocks between time_start and time_stop.
  # @return Array
  def half_hour_blocks( time_start, time_end )
    time_start = am_pm( time_start )
    time_end   = am_pm( time_end )
    # Parse time to make adding to it easier.
    time_start = Time.parse( time_start )
    time_end   = Time.parse( time_end )
    blocks = []
    # Make a 2d array representing the each half-hour segment.
    begin
      block = []
      block.push( time_start.strftime( '%l:%M' ).lstrip )
      time_start = time_start + HALF_HOUR
      block.push( time_start.strftime( '%l:%M' ).lstrip )
      blocks.push( block )
    end until time_start >= time_end
    blocks
  end
end

appointments = [['9:00', '9:30'], ['9:00', '11:30'], ['10:00', '11:00'], ['2:30', '3:00'], ['2:30', '3:30']]

new_day = Day.new
new_day.team_availability( appointments )
