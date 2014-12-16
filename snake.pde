//increments 60 times per second
var counter;

var gameStage;

var gameWidth;

var gameHeight;

var grid;

var dir;

// Snake's head
var snake;

void setup() {
	console.log("snake setup started");
	size(400, 400);
	counter = 0;
	gameStage = 0;
	gameWidth = 20;
	gameHeight = 20;
	grid.init();
	snake = new Snake(9, 9);
	grid.setLoc(9, 9, snake);
	snake.nextSnake = new Snake(9, 8);
	grid.setLoc(9, 8, snake.nextSnake);
	snake.nextSnake.nextSnake = new Snake(9, 7);
	grid.setLoc(9, 7, snake.nextSnake.nextSnake);
	dir = direction.DOWN;
	console.log("snake setup complete");
}

void draw() {
	counter++;
	mover[gameStage]();
	drawer[gameStage]();
}

// Linked List snake class
function Snake(x, y) {
	this.x = x;
	this.y = y;
	this.nextSnake = null;
	this.prevSnake = null;
	this.getLast = function() {
		var output = this;
		while (output.nextSnake != null) {
			output = output.nextSnake;
		}
		return output;
	}
}

function Food(x, y) {
	this.x = x;
	this.y = y;
}

// Moves the snake
function moveSnake() {
	var nextx;
	var nexty;
	if (dir == direction.DOWN) {
		nextx = snake.x;
		nexty = snake.y + 1;
	} else if (dir == direction.UP) {
		nextx = snake.x;
		nexty = snake.y - 1;
	} else if (dir == direction.RIGHT) {
		nextx = snake.x + 1;
		nexty = snake.y;
	} else if (dir == direction.LEFT) {
		nextx = snake.x - 1;
		nexty = snake.y;
	}
	// check for collision with walls
	if (nextx > gameWidth - 1 || nextx < 0 || nexty > gameHeight - 1 || nexty < 0) {
		gameOver();
	}
	//check for collision with other objects
	var nextObject = grid.getLoc(nextx, nexty);
	var eatFood;
	if (nextObject == null) {
		//good to go, do nothing
		eatFood = false;
	} else if (nextObject instanceof Snake) {
		//ran into itself
		gameOver();
	} else if (nextObject instanceof Food) {
		//eat the food
		eatFood = true;
	}
	
	//go through linkedlist snake and move each part
	var prevx = snake.x;
	var prevy = snake.y;
	var currentSnake = snake;
	while (currentSnake.nextSnake != null) {
		currentSnake.x = nextx;
		currentSnake.y = nexty;
		grid.setLoc(currentSnake.x, currentSnake.y, currentSnake);
		grid.setLoc(prevx, prevy, null);
		nextx = prevx;
		nexty = prevy;
		currentSnake = currentSnake.nextSnake;
		prevx = currentSnake.x;
		prevy = currentSnake.y;
	}
	//last snake on the chain
	currentSnake.x = nextx;
	currentSnake.y = nexty;
	grid.setLoc(currentSnake.x, currentSnake.y, currentSnake);
	grid.setLoc(prevx, prevy, null);
	if (eatFood) {
		currentSnake.nextSnake = new Snake(prevx, prevy);
		grid.setLoc(currentSnake.nextSnake.x, currentSnake.nextSnake.y, currentSnake.nextSnake);
	}
}

function gameOver() {
	gameStage = 2;
	console.log("game over");
}

function gameWin() {
	gameStage = 3;
	console.log("game won");
}

var grid = {
	"array": [],
	"init": function() {
		for (var i = 0; i < gameWidth; i++) {
			this.array.push([]);
			for (var j = 0; j < gameHeight; j++) {
				this.array[i].push(null);
			}
		}
	},
	"getLoc": function(x, y) {
		return this.array[x][y];
	},
	"settLoc": function(x, y, input) {
		this.array[x][y] = input;
	}
};

//enum for directions
var direction = {
	"UP": "UP",
	"DOWN": "DOWN",
	"LEFT": "LEFT",
	"RIGHT": "RIGHT"
};

var mover = {
	"0": function() {
	
	},
	"1": function() {
		if (counter % 30 == 0) {
			moveSnake();
		}
	},
	"2": function() {
	
	},
	"3": function() {
	
	}
};

var drawer = {
	"0": function() {
		background(128);
	},
	"1": function() {
		background(128);
		
	},
	"2": function() {
		
	},
	"3": function() {
	
	}
};

var clicker = {
	"0": function() {
		gameStage++;
	},
	"1": function() {
		
	},
	"2": function() {
		
	},
	"3": function() {
	
	}
};

void mousePressed() {
	clicker[gameStage]();
}

void keyPressed() {
	switch (keyCode) {
		case 37:
			dir = direction.LEFT;
			break;
		case 38:
			dir = direction.UP;
			break;
		case 39:
			dir = direction.RIGHT;
			break;
		case 40:
			dir = direction.DOWN;
			break;
	}
}