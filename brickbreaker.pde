// Number of lives
var lives;

// Ball
var ball;

// Paddle
var paddle;

// Brick array
var bricks;

// Controls the stage of the game (beginning, end, etc)
var gameStage;


void setup() {
	size(400, 400);
	paddle = new Paddle();
	bricks = [];
	var numCols = 10;
	var numRows = 3;
	for (var i = 1; i < numCols; i++) {
		var x = i * (width / numCols);
		for (var j = 1; j < numRows + 1; j++) {
			var y = j * (width / numCols);
			bricks.push(new Brick(x, y));
		}
	}
	lives = 3;
	ball = new Ball();
	gameStage = 0;
	console.log("setup complete");
}

void draw() {
	mover[gameStage]();
	drawer[gameStage]();
}

void keyPressed() {
	keyDown[gameStage]();
}

void keyReleased() {
	keyUp[gameStage]();
}

void mousePressed() {
	clicker[gameStage]();
}

// Object containing action methods for different stages of the game
var mover = {
	"0": function() {
	
	},
	"1": function() {
		ball.collision(paddle);
		for (var i = 0; i < bricks.length; i++) {
			if (!bricks[i].isDead) {
				ball.collision(bricks[i]);
			}
		}
		paddle.move();
		ball.move();
	},
	"2": function() {
	
	}
};

// Object containing draw methods for different stages of the game
var drawer = {
	"0": function() {
		background(128);
	},
	"1": function() {
		background(128);
		paddle.draw();
		ball.draw();
		for (var i = 0; i < bricks.length; i++) {
			if (!bricks[i].isDead) {
				bricks[i].draw();
			}
		}
	},
	"2": function() {
		
	}
};

// Object containing click methods for different stages of the game
var clicker = {
	"0": function() {
		gameStage++;
	},
	"1": function() {
		
	},
	"2": function() {
		
	}
};

var keyDown = {
	"0": function() {
		
	},
	"1": function() {
		switch (keyCode) {
			case 37:
				paddle.dx = -paddle.speed;
				break;
			case 39:
				paddle.dx = paddle.speed;
				break;
		}
	},
	"2": function() {
	
	}
};

var keyUp = {
	"0": function() {
		
	},
	"1": function() {
		switch (keyCode) {
			case 37:
				paddle.dx = 0;
			case 39:
				paddle.dx = 0;
				break;
		}
	},
	"2": function() {
		
	}
};

function Paddle() {
	this.x = width / 2;
	this.y = height - 2;
	this.dx = 0;
	this.speed = 3;
	this.width = 40;
	this.height = 10;
	this.hwidth = this.width / 2;
	this.hheight = this.height / 2;
	this.c = color(0, 255, 0);
	this.draw = function() {
		rectMode(CENTER);
		fill(this.c);
		rect(this.x, this.y, this.width, this.height);
	}
	this.move = function() {
		if (this.x + this.dx + (this.width / 2) >= width) {
			this.x = width - (this.width / 2);
		} else if (this.x + this.dx - (this.width / 2) <= 0) {
			this.x = (this.width / 2);
		} else {
			this.x += this.dx;
		}
	}
	this.bounce = function(inBall) {
		inBall.v.x = inBall.x - this.x;
		inBall.v.y = inBall.y - this.y;
		inBall.v.normalize();
		inBall.v.mult(inBall.speed);
	}
}

function Ball() {
	this.radius = 7;
	this.x = width / 2;
	this.y = height / 2;
	this.speed = 3;
	this.v = new PVector(0, this.speed);
	this.c = color(0, 0, 255);
	this.move = function() {
		if (this.x + this.v.x - this.radius < 0 || this.x + this.v.x + this.radius > width) {
			this.v.x *= -1;
		}
		if (this.y + this.v.y - this.radius < 0 || this.y + this.v.y + this.radius > height) {
			this.v.y *= -1;
		}
		this.x += this.v.x;
		this.y += this.v.y;
	}
	this.draw = function() {
		fill(this.c);
		ellipse(this.x, this.y, this.radius * 2, this.radius * 2);
	}
	this.collision = function(rct) {
		//vertical top side collision
		if (this.y + this.radius >= rct.y - rct.hheight) {
			//vertical bottom side collision
			if (this.y - this.radius <= rct.y + rct.hheight) {
				//horizontal left side collision
				if (this.x + this.radius >= rct.x - rct.hwidth) {
					//horizontal right side collision
					if (this.x - this.radius <= rct.x + rct.width) {
						rct.bounce(this);
					}
				}
			}
		}
	}
}

function Brick(x, y) {
	this.x = x;
	this.y = y;
	this.width = 30;
	this.height = 10;
	this.hwidth = this.width / 2;
	this.hheight = this.height / 2;
	this.c = color(255, 0, 0);
	this.isDead = false;
	this.draw = function() {
		fill(this.c);
		rectMode(CENTER);
		rect(this.x, this.y, this.width, this.height);
	}
	this.bounce = function(inBall) {
		this.isDead = true;
		//eight different sectors that the ball can be in
		//if it is in the corners, should reverse x and y
		//if above or below, should reverse y but not x
		//if on the sides, should reverse x but not y
		var inVertical = (inBall.y <= this.y + this.hheight && inBall.y >= this.y - this.hheight);
		var inHorizontal = (inBall.x <= this.x + this.hwidth && inBall.x >= this.x - this.hwidth);
		if (!inVertical && !inHorizontal) {
			inBall.v.x *= -1;
			inBall.v.y *= -1;
			console.log("corner collision");
		} else if (inVertical && !inHorizontal) {
			inBall.v.x *= -1;
			console.log("side collision");
		} else if (!inVertical && inHorizontal) {
			inBall.v.y *= -1;
			console.log("top/bottom collision");
		} else {
			console.log("WATWATWAT");
		}
		inBall.move();
	}
}