var counter;

var gameStage;

var gameWidth;

var gameHeight;

var grid;

var direction;

// Snake's head
var snake;

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
	snake = new Snake();
	
}

void draw() {
	counter++;
	drawer[gameStage]();
}

// Linked List snake
function Snake() {
	this.nextSnake = null;
	this.getLast = function() {
		var output = this;
		while (output.nextSnake != null) {
			output = output.nextSnake;
		}
		return output;
	}
}

// Moves the snake, and if hasNewPart is true, adds a new part to the snake
function moveSnake(hasNewPart) {
	if (hasNewPart) {
		
	}
}

var grid = {
	this.array = [];
	for (var i = 0; i < gameWidth; i++) {
		array.push([]);
		for (var j = 0; j < gameHeight; j++) {
			array[i].push(null);
		}
	}
	this.getLoc = function(x, y) {
		return array[x][y];
	}
	this.putLoc = function(input) {
		array[x][y] = input;
	}
};

//enum for directions
var direction = {
	this.UP = "UP";
	this.DOWN = "DOWN";
	this.RIGHT = "RIGHT";
	this.LEFT = "LEFT";
};

var drawer = {
	"0": function() {
		background(128);
	},
	"1": function() {
		background(128);
	},
	"2": function() {
		
	}
};

var clicker = {
	"0": function() {
		gameStage++;
	},
	"1": function() {
		
	},
	"2": function() {
		
	}
};

void mousePressed() {
	clicker[gameStage]();
}