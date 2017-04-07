(function() {

var contentWidth = document.getElementById('content').clientWidth;

var plotWidth;
  if (contentWidth >= 600) {plotWidth = contentWidth/2.05;} 
  else { plotWidth = contentWidth; }

var plotHeight;
  if (contentWidth >= 600) {plotHeight = contentWidth/2.05;} 
  else { plotHeight = contentWidth; }


var elemState = document.getElementById('stateSelect'); // Create variable element that stores value from menu 
var elemVariable = document.getElementById('variableSelect'); // Create variable element that stores value from menu 

if(elemState){ elemState.addEventListener("load", graphStateVariable('#graphResults', elemState.value, elemVariable.value, plotWidth, plotHeight), false)}; // on load, graph default value 
if(elemState){ elemState.addEventListener("change", onChangeState, false)}; // on change, run 'onSelectChange function' that graphs new country 
if(elemVariable){ elemVariable.addEventListener("change", onChangeVariable, false)}; // on change, run 'onSelectChange function' that graphs new country 

function onChangeState(){
  d3.select('#graphResults').selectAll('*').remove();
  var value = this.value;
  graphStateVariable('#graphResults', value, elemVariable.value, plotWidth, plotHeight);
}

function onChangeVariable(){
  d3.select('#graphResults').selectAll('*').remove();
  var value = this.value;
  graphStateVariable('#graphResults', elemState.value, value, plotWidth, plotHeight);
}

function graphStateVariable(id, state, variable, w, h) {

  // Set margin parameters 
  var margin = {top: 40, right: 50, bottom: 20, left: 50},
                width = w - margin.left - margin.right,
                height = h - margin.top - margin.bottom;

  // x function map the circles along the x axis
  var x = d3.scaleLinear().range([0, width]);

  // y function map the variables along the y axis
  var y = d3.scaleLinear().range([height, 0]);

  var color = d3.scaleOrdinal()
                .domain(['Trump', 'Clinton'])
                .range(['#d7191c', '#2b83ba']);

  // Create SVG item 
  // d3.select(id).selectAll('*').remove();
  var svgResults = d3.select(id)
                     .append('svg')
                     .attr('width', width + margin.left + margin.right)
                     .attr('height', height + margin.top + margin.bottom)
                     .append('g')
                     .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')');

  var svgResultsCum = d3.select(id)
                     .append('svg')
                     .attr('width', width + margin.left + margin.right)
                     .attr('height', height + margin.top + margin.bottom)
                     .append('g')
                     .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')');

  // Read in data 
  d3.csv("data/electionResultsCumulativeMargin.csv", type, function(error, data) {
      if (error) throw error;

  // Subset the data based on variables selected 
    data = data.filter(function (d) { return d.StateName == state } );
    data = data.filter(function (d) { return d.VariableName == variable } );

    // Scale the functions defined above with range from variables 
    x.domain(d3.extent(data, function(d) { return d.VariableValue; }));
    y.domain(d3.extent(data, function(d) { return d.TrumpVClintonPCT; }));

    svgResults.selectAll('.dot')
       .data(data)
       .enter().append('circle')
       .attr('class', 'dot')
       .attr('cx', function(d) { return x(d.VariableValue); })
       .attr('cy', function(d) { return y(d.TrumpVClintonPCT); })
       .attr('r', 5)
       .style('fill', function(d) { return color(d.FIPSWinner); })
       .on('mouseover', function(d) {

       //Get this bar's x/y values, then augment for the tooltip
        var xPosition = parseFloat(d3.select(this).attr('cx'));
        var yPosition = parseFloat(d3.select(this).attr('cy')) - 5;

        //Create the tooltip label
        svgResults.append('text')
          .attr('id', 'tooltip')
          .attr('x', xPosition)
          .attr('y', yPosition)
          .attr('text-anchor', 'middle')
          .attr('fill', 'black')
          .html(d['CountyName']);
          })
      //Remove the tooltip
      .on('mouseout', function() {
        d3.select('#tooltip').remove(); 
      });

    // Append x axis 
    svgResults.append("g")
        .attr('class', 'xaxis')
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(x)
        .tickFormat(d3.format(".0f")));

    // Append y axis
    svgResults.append("g")
        .attr('class', 'yaxis')
        .call(d3.axisLeft(y)
        .ticks(5));

    // Append text for y axis label
    svgResults.append('text')
        .attr('transform', 'rotate(-90)')
        .attr('y', -45)
        .attr('x', -height/2)
        .attr('dy', '.71em')
        .style('text-anchor', 'middle')
        .text('Trump vs. Clinton margin');

    // text label for the x axis
    // svgResults.append("text")
    //     .attr('x', width/2)
    //     .attr("y", height - (height * 1.03))
    //     .style('text-anchor', 'middle')
    //     .text(state + ' ' + variable);
  // console.log(data);

  // Scale the functions defined above with range from variables 
    x.domain(d3.extent(data, function(d) { return d.VariableValue; }));
    y.domain(d3.extent(data, function(d) { return d.CumTrumpVClinton; }));

    svgResultsCum.selectAll('.dot')
       .data(data)
       .enter().append('circle')
       .attr('class', 'dot')
       .attr('cx', function(d) { return x(d.VariableValue); })
       .attr('cy', function(d) { return y(d.CumTrumpVClinton); })
       .attr('r', 5)
       .style('fill', function(d) { return color(d.FIPSWinner); })
       .on('mouseover', function(d) {

       //Get this bar's x/y values, then augment for the tooltip
        var xPosition = parseFloat(d3.select(this).attr('cx'));
        var yPosition = parseFloat(d3.select(this).attr('cy')) - 5;

        //Create the tooltip label
        svgResultsCum.append('text')
          .attr('id', 'tooltip')
          .attr('x', xPosition)
          .attr('y', yPosition)
          .attr('text-anchor', 'middle')
          .attr('fill', 'black')
          .html(d['CountyName']);
          })
      //Remove the tooltip
      .on('mouseout', function() {
        d3.select('#tooltip').remove(); 
      });

    // Append x axis 
    svgResultsCum.append("g")
        .attr('class', 'xaxis')
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(x)
        .tickFormat(d3.format(".0f")));

    // Append y axis
    svgResultsCum.append("g")
        .attr('class', 'yaxis')
        .call(d3.axisLeft(y)
        .ticks(5));

    // Append text for y axis label
    svgResultsCum.append('text')
        .attr('transform', 'rotate(-90)')
        .attr('y', -45)
        .attr('x', -height/2)
        .attr('dy', '.71em')
        .style('text-anchor', 'middle')
        .text('Trump vs. Clinton cumulative margin');

    // text label for the x axis
    // svgResultsCum.append("text")
    //     .attr('x', width/2)
    //     .attr("y", height - (height * 1.03))
    //     .style('text-anchor', 'middle')
    //     .text(state + ' ' + variable);
  // console.log(data);
  });

  function type(d) {
      d.StateName = d.StateName;
      d.CountyName = d.CountyName;
      d.FIPSWinner = d.FIPSWinner;
      d.VariableName = d.VariableName;
      d.VariableValue = +d.VariableValue;
      d.TrumpVClinton = +d.TrumpVClinton;
      d.TrumpVClintonPCT = +d.TrumpVClintonPCT;
      d.CumTrumpVClinton = +d.CumTrumpVClinton;
      return d;
    }
    return this;
};
})();

