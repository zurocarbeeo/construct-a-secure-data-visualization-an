Solidity
pragma solidity ^0.8.0;

contract DataVisualizationAnalyzer {
    // Mapping of data points to their respective owners
    mapping (address => DataPoint[]) public dataPoints;

    // Struct to represent a single data point
    struct DataPoint {
        uint256 value;
        uint256 timestamp;
        string label;
    }

    // Event emitted when a new data point is added
    event NewDataPoint(address indexed owner, uint256 value, uint256 timestamp, string label);

    // Modifier to ensure only the owner of the data point can access it
    modifier onlyOwner(address _owner) {
        require(msg.sender == _owner, "Only the owner of the data point can access it");
        _;
    }

    // Function to add a new data point
    function addDataPoint(uint256 _value, uint256 _timestamp, string memory _label) public {
        dataPoints[msg.sender].push(DataPoint(_value, _timestamp, _label));
        emit NewDataPoint(msg.sender, _value, _timestamp, _label);
    }

    // Function to get a data point by label
    function getDataPointByLabel(string memory _label) public view returns (DataPoint[] memory) {
        DataPoint[] memory points = new DataPoint[](0);
        for (uint256 i = 0; i < dataPoints[msg.sender].length; i++) {
            if (keccak256(abi.encodePacked(dataPoints[msg.sender][i].label)) == keccak256(abi.encodePacked(_label))) {
                points.push(dataPoints[msg.sender][i]);
            }
        }
        return points;
    }

    // Function to visualize data points as a graph
    function visualizeDataPoints() public view returns (string memory) {
        string memory graph = "";
        for (uint256 i = 0; i < dataPoints[msg.sender].length; i++) {
            graph = string(abi.encodePacked(graph, "(", dataPoints[msg.sender][i].value, ", ", dataPoints[msg.sender][i].timestamp, "), "));
        }
        return graph;
    }

    // Test case: Add a few data points and visualize them
    function testDataVisualization() public {
        addDataPoint(10, 1643723400, "Point 1");
        addDataPoint(20, 1643723500, "Point 2");
        addDataPoint(30, 1643723600, "Point 3");
        string memory graph = visualizeDataPoints();
        assert(keccak256(abi.encodePacked(graph)) == keccak256(abi.encodePacked("(10, 1643723400), (20, 1643723500), (30, 1643723600), ")));
    }
}