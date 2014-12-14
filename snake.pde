var counter;

var gameStage;

var gameWidth;

var gameHeight;

var grid;

var direction;

void setup() {
	size(400, 400);
	counter = 0;
	gameStage = 0;
	gameWidth = 20;
	gameHeight = 20;
	grid = [];
	for (var i = 0; i < gameWidth; i++) {
		grid.push([]);
		for (var j = 0; j < gameHeight; j++) {
			grid[i].push(null);
		}
	}
}

void draw() {
	counter++;
	drawer[gameStage]();
}

var drawer = {
	"0": function() {
		background(128);
	},
	"1": function() {
		background(128);
	},
	"2": function() {
		
	}
}

var clicker = {
	"0": function() {
		gameStage++;
	},
	"1": function() {
		
	},
	"2": function() {
		
	}
}

void mousePressed() {
	clicker[gameStage]();
}