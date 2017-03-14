class SensorGraph
  attr_reader :nodes, :edges

  def initialize(unit)
    @nodes = unit.sensors.map do |node|
      { id: node.id, label: node.name }
    end
    @edges = unit.sensors.map do |node|
      { from: node.id, to: node.parent.id } if node.parent
    end
    @edges.reject!(&:nil?)
  end

  def to_json
    { nodes: nodes, edges: edges }.to_json
  end
end
