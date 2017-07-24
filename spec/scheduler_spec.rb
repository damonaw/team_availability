# spec/scheduler_spec.rb
require "scheduler"

describe Scheduler do
  before do
    @work_day = Scheduler.new
  end

  describe ".team_availability" do
    it "displays expected results for test bed case" do
      appointments = [['9:00', '9:30'], ['9:00', '11:30'], ['10:00', '11:00'], ['2:30', '3:00'], ['2:30', '3:30']]
      expected_output = [['8:30', '9:00'], ['11:30', '12:00'], ['1:00', '1:30'], ['1:30', '2:00'], ['2:00', '2:30'], ['3:30', '4:00'], ['4:00', '4:30'], ['4:30', '5:00']]
      expect( @work_day.team_availability( appointments ) ).to eql( expected_output )
    end

    it "displays expected results for appointment that goes from am to pm" do
      appointments = [['9:00', '11:00'], ['10:30', '3:00'], ['2:30', '3:30']]
      expected_output = [['8:30', '9:00'], ['3:30', '4:00'], ['4:00', '4:30'], ['4:30', '5:00']]
      expect( @work_day.team_availability( appointments ) ).to eql( expected_output )
    end

    it "displays expected results for appointment that goes all day" do
      appointments = [['8:30', '5:00']]
      expected_output = []
      expect( @work_day.team_availability( appointments ) ).to eql( expected_output )
    end

    it "raise error param is not an array" do
      appointments = '8:30, 10:00'
      expect{ @work_day.team_availability( appointments ) }.to raise_error( 'Appointments param is not an Array' )
    end
  end

  describe ".parse_time" do
    it "expect of 8:30am" do
      time = Time.parse( '8:30am' )
      expect( @work_day.parse_time( '8:30' ) ).to eq( time )
    end

    it "expect of 5:00pm" do
      time = Time.parse( '5:00pm' )
      expect( @work_day.parse_time( '5:00' ) ).to eq( time )
    end

    it "expect of 12pm" do
      time = Time.parse( '12:00pm' )
      expect( @work_day.parse_time( '12:00' ) ).to eq( time )
    end

    it "raise error time outside of work hours" do
      expect{ @work_day.parse_time( '6:00' ) }.to raise_error('Time outside of work hours')
    end

    it "raise error time outside of work hours" do
      expect{ @work_day.parse_time( '7:30' ) }.to raise_error('Time outside of work hours')
    end
  end

  describe ".half_hour_blocks" do
    it "return expected results of half hour blocks array" do
      expected_output = [['9:30', '10:00'], ['10:00', '10:30'], ['10:30', '11:00']]
      expect( @work_day.half_hour_blocks( '9:30', '11:00' ) ).to eq( expected_output )
    end

    it "raise error end time before start time" do
      expect{ @work_day.half_hour_blocks( '11:30', '10:00' ) }.to raise_error('End time before start time')
    end
  end
end
