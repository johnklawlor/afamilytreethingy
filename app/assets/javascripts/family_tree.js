var ready;
ready = function() {

	$('div.node > img').on('dragstart', function(event) {
		event.preventDefault(); 
	});

	$("#tree").html("");

	var labelType, useGradients, nativeTextSupport, animate;

	(function() {
	  var ua = navigator.userAgent,
		  iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
		  typeOfCanvas = typeof HTMLCanvasElement,
		  nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
		  textSupport = nativeCanvasSupport 
			&& (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
	  //I'm setting this based on the fact that ExCanvas provides text support for IE
	  //and that as of today iPhone/iPad current text support is lame
	  labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
	  nativeTextSupport = labelType == 'Native';
	  useGradients = nativeCanvasSupport;
	  animate = !(iStuff || !nativeCanvasSupport);
	})();

	function init(){
		//init data
		var json = $("#tree").data("family");

		//init Spacetree
		//Create a new ST instance
		var st = new $jit.ST({
				//id of viz container element
			injectInto: 'tree',
				//set duration for the animation
			duration: 800,
				//set animation transition type
			transition: $jit.Trans.Quart.easeInOut,
				//set distance between node and its children
			levelDistance: 50,
				//enable panning
			Navigation: {
			  enable:true,
			  panning:true
			},

			Events: {
				enable: true,
				onDragStart: function(node, eventInfo, e){
					e.preventDefault();
				},
				onRightClick: function(node, eventInfo, e){
					console.log (node.id);
					st.onClick( node.id, { Move: {offsetY:150} });
				}
			},
			
			orientation: 'top',
			siblingOffset: 12,
			
				//set node and edge styles
				//set overridable=true for styling individual
				//nodes or edges
			Node: {
				height: 160,
				width: 350,
				type: 'rectangle',
				color: 'transparent',
				overridable: false
			},
		
			Edge: {
				type: 'bezier',
				overridable: true
			},
				
				//This method is called on DOM label creation.
				//Use this method to add event handlers and styles to
				//your node.
			onCreateLabel: function(label, node){
				label.id = node.id;            
				label.innerHTML = node.name;
				label.onclick = function(){

				};
				//set label styles
				var style = label.style;
				style.width = 350 + 'px';
				style.height = 100 + 'px';          
				style.cursor = 'pointer';
				style.color = '#000';
				style.fontSize = '2em';
				style.textAlign= 'center';
				style.paddingTop = '3px';
				style.lineHeight = '0.8';
				style.fontFamily = 'Georgia';
			},
		
			//This method is called right before plotting
			//a node. It's useful for changing an individual node
			//style properties before plotting it.
			//The data properties prefixed with a dollar
			//sign will override the global node style properties.
			onBeforePlotNode: function(node){
				//add some color to the nodes in the path between the
				//root node and the selected node.
				if (node.selected) {
					node.data.$color = "#ff7";
				}
				else {
					delete node.data.$color;
					//if the node belongs to the last plotted level
					if(!node.anySubnode("exist")) {
						//count children number
						var count = 0;
						node.eachSubnode(function(n) { count++; });
						//assign a node color based on
						//how many children it has
						node.data.$color = ['#aaa', '#baa', '#caa', '#daa', '#eaa', '#faa'][count];                    
					}
				}
			},
		
			//This method is called right before plotting
			//an edge. It's useful for changing an individual edge
			//style properties before plotting it.
			//Edge data proprties prefixed with a dollar sign will
			//override the Edge global style properties.
			onBeforePlotLine: function(adj){
				if (adj.nodeFrom.selected && adj.nodeTo.selected) {
					adj.data.$color = "#000";
					adj.data.$lineWidth = 3;
				}
				else {
					delete adj.data.$color;
					delete adj.data.$lineWidth;
				}
			}
		});
			//load json data
		st.loadJSON(json);
			//compute node positions and layout
		st.compute();
			//optional: make a translation of the tree
		st.geom.translate(new $jit.Complex(-400, -150), "current");
			//emulate a click on the root node.
		st.onClick(st.root, { Move: {offsetY: 150} });
			//end

	}
	
	if ($("#tree").length) {
		init();
	}
};

$(document).ready(ready);
$(document).on('page:load', ready);