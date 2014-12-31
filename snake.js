//increments 60 times per second
var counter;

// Integer representing the stage of the game
var gameStage;

// Number of horizontal blocks in the grid
var gridWidth;
// Number of vertical blocks in the grid
var gridHeight;

// Object that contains the snake pieces, food, etc
var grid;

// Current direction of the snake
var dir;
// Next direction of the snake determined by user input
var nextDirection;

// Snake's head
var snake;

// Reference to piece of food in the grid
var food;

// boolean to determine if should add another piece on the snake when it moves
var addSnake;

// Width and height of each grid square
var gridWidthpx, gridHeightpx;

// Score that accumulates at the bottom
var score;


void setup() {
	console.log("snake setup started");
	size(400, 450);
	gameWidth = 400;
	gameHeight = 400;
	counter = 0;
	score = 0;
	initParticles();
	gameStage = 0;
	gridWidth = 30;
	gridHeight = 30;
	gridWidthpx = gameWidth / gridWidth;
	gridHeightpx = gameHeight / gridHeight;
	addSnake = false;
	grid.init();
	snake = new Snake(9, 9);
	grid.setLoc(9, 9, snake);
	snake.nextSnake = new Snake(9, 8);
	grid.setLoc(9, 8, snake.nextSnake);
	snake.nextSnake.nextSnake = new Snake(9, 7);
	grid.setLoc(9, 7, snake.nextSnake.nextSnake);
	dir = direction.DOWN;
	food = new Food(15, 15);
	grid.setLoc(food.x, food.y, food);
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
	this.c = color(0, 255, 0);
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
	this.c = color(255, 0, 0);
	this.x = x;
	this.y = y;
	this.eat = function() {
		//check to see if the user won the game, in which case there are no spots left
		if (grid.isFull()) {
			gameWin();
		}
		//place self in a new spot in the grid
		var prevx = this.x;
		var prevy = this.y;
		//search for a new place to put the food
		var newx;
		var newy;
		while (!newx) {
			var randx = Math.floor(Math.random() * gridWidth);
			var randy = Math.floor(Math.random() * gridHeight);
			if (!grid.getLoc(randx, randy)) {
				newx = randx;
				newy = randy;
			}
		}
		this.x = newx;
		this.y = newy;
		grid.setLoc(newx, newy, this);
		grid.setLoc(prevx, prevy, null);
		addSnake = true;
		score += 50;
		particles.push(new Particle(prevx * gridWidthpx + gridWidthpx / 2, prevy * gridHeightpx + gridHeightpx / 2, color(0, 255, 0), 15));
	}
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
	if (nextx > gridWidth - 1 || nextx < 0 || nexty > gridHeight - 1 || nexty < 0) {
		gameOver();
	}
	//check for collision with other objects
	var nextObject = grid.getLoc(nextx, nexty);
	if (nextObject == null /*|| nextObject == snake.getLast()*/) {
		//good to go, do nothing
	} else if (nextObject instanceof Snake) {
		//ran into itself
		gameOver();
	} else if (nextObject instanceof Food) {
		//eat the food
		food.eat();
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
	if (addSnake) {
		currentSnake.nextSnake = new Snake(prevx, prevy);
		grid.setLoc(currentSnake.nextSnake.x, currentSnake.nextSnake.y, currentSnake.nextSnake);
		addSnake = false;
	}
}

// Draws the scoreboard that appears at the bottom
function drawScore() {
	fill(0);
	rectMode(CORNER);
	rect(0, gameHeight, width, height);
	rectMode(CENTER);
	fill(color(0, 255, 0));
	
	text("Score: " + score, 10, gameHeight + 10);
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
		for (var i = 0; i < gridWidth; i++) {
			this.array.push([]);
			for (var j = 0; j < gridHeight; j++) {
				this.array[i].push(null);
			}
		}
	},
	"getLoc": function(x, y) {
		return this.array[x][y];
	},
	"setLoc": function(x, y, input) {
		this.array[x][y] = input;
	},
	"isFull": function() {
		for (var i = 0; i < gridWidth; i++) {
			for (var j = 0; j < gridHeight; j++) {
				if (!this.array[i][j]) {
					return false;
				}
			}
		}
		return true;
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
		if (counter % 5 == 0) {
			if (nextDirection)
				dir = nextDirection;
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
		fill(255);
		text("click to play snake", width / 2, height / 2);
	},
	"1": function() {
		background(128);
		//draw snake
		fill(snake.c);
		var nextSnake = snake;
		while (nextSnake) {
			rect(nextSnake.x * gridWidthpx, nextSnake.y * gridHeightpx, gridWidthpx, gridHeightpx);
			nextSnake = nextSnake.nextSnake;
		}
		//draw food
		fill(food.c);
		rect(food.x * gridWidthpx, food.y * gridHeightpx, gridWidthpx, gridHeightpx);
		drawScore();
		//draw particles
		drawParticles();
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
			if (dir != direction.RIGHT)
				nextDirection = direction.LEFT;
			break;
		case 38:
			if (dir != direction.DOWN)
				nextDirection = direction.UP;
			break;
		case 39:
			if (dir != direction.LEFT)
				nextDirection = direction.RIGHT;
			break;
		case 40:
			if (dir != direction.UP)
				nextDirection = direction.DOWN;
			break;
	}
}