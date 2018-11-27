require_relative 'instance_counter'

class Route
  include InstanceCounter
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    register_instance
  end

  def add_intermediate_station(station)
    @stations.insert(-2, station)
  end
  
  def del_intermediate_station(station)
    @stations.delete(station)
  end
  
  def output_stations
    @stations.each { |station| puts station.name }
  end
end
