#!/usr/bin/ruby
require 'time'

# definition of class Scheduler
#
# This class holds sonstants regarding the work day, as well as methods for determining
# a possible times for appointments.
class Scheduler
  # Constants
  HALF_HOUR  = 30 * 60
  WORK_HOURS = ['8:30', '5:00']
  LUNCH      = ['12:00', '1:00']

  def initialize( )
    # Instance variables
    @available = half_hour_blocks( *WORK_HOURS )
  end

  ##
  # Prints out an array of half-hour blocks that the whole team in available.
  def team_availability( appointments )
    raise "Appointments param is not an Array" unless appointments.is_a? Array
    # Add lunch to the list of appointments, remove duplicate appointments.
    appointments.push( LUNCH )
    appointments.uniq

    # Remove appointments from the list of available times.
    appointment_blocks = appointments.map do |appointment|
      half_hour_blocks( *appointment )
    end

    # Remove any duplicate blocks of time.
    appointment_blocks.flatten!(1)
    appointment_blocks.uniq
    # Remove appointments from available
    appointment_blocks.each do |appointment_block|
      @available.delete appointment_block
    end
    puts "#{@available}"
    @available
  end

  ##
  # Adds am or pm to the end of the time string.
  # Assumes that 12 and times less then the end of the work day are pm.
  # Assumes that times greater than the start of the work day are am.
  # @return String
  def parse_time( time )
    # Give time am or pm.
    if time.to_i == 12 || time.to_i <= WORK_HOURS[1].to_i
      time = time + "pm"
    elsif time.to_i >= WORK_HOURS[0].to_i
      time = time + "am"
    end
    time = Time.parse( time )
    work_start = Time.parse( "#{WORK_HOURS[0]}am" )
    work_end   = Time.parse( "#{WORK_HOURS[1]}pm" )
    raise "Time outside of work hours" if time < work_start || time > work_end
    time
  end

  ##
  # Builds an array of all the half-hour blocks between time_start and time_stop.
  # @return Array
  def half_hour_blocks( time_start, time_end )
    # Parse time to make adding to it easier.
    time_start = parse_time( time_start )
    time_end   = parse_time( time_end )
    raise "End time before start time" unless time_start < time_end
    blocks = []
    # Make a 2d array representing each half-hour segment.
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

# appointments = [['9:00', '9:30'], ['9:00', '11:30'], ['10:00', '11:00'], ['2:30', '3:00'], ['2:30', '3:30']]
#
# new_day = Scheduler.new
# new_day.team_availability( appointments )
