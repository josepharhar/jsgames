// Increments every frame
var counter;

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

// Particle system array
var particles;

// Size in pixels of the frame where the ball can go
var gameWidth = 400;
var gameHeight = 400;

void setup() {
	size(400, 450);
	counter = 0;
	paddle = new Paddle();
	bricks = [];
	particles = [];
	var numCols = 10;
	var numRows = 3;
	for (var r = 0; r < numRows; r++) {
		var y = (r + 1) * (gameWidth / numCols);
		var rratio = r / (numRows + 1);
		var colr = color(128 + rratio * 128, 128 - rratio * 128, rratio * 128);
		for (var c = 0; c < numCols - 1; c++) {
			var x = (c + 1) * (gameWidth / numCols);
			bricks.push(new Brick(x, y, colr));
		}
	}
	// for (var i = 1; i < numCols; i++) {
		// var x = i * (gameWidth / numCols);
		// for (var j = 1; j < numRows + 1; j++) {
			// var y = j * (gameWidth / numCols);
			// bricks.push(new Brick(x, y));
		// }
	// }
	lives = 4;
	ball = new Ball();
	gameStage = 0;
	console.log("setup complete\u2764");
	console.log(PFont.list());
}

void draw() {
	counter++;
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
		for (var i = particles.length - 1; i >= 0; i--) {
			particles[i].move();
			if (particles[i].isDead()) {
				particles.splice(i, 1);
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
		fill(255);
		text("hello", width / 2, height / 2);
	},
	"1": function() {
		drawGame();
		drawScore();
	},
	"2": function() {
		
	}
};

// Draws the paddle, ball, bricks, particles, etc.
function drawGame() {
	background(128);
	paddle.draw();
	ball.draw();
	for (var i = 0; i < bricks.length; i++) {
		if (!bricks[i].isDead) {
			bricks[i].draw();
		}
	}
	for (var i = 0; i < particles.length; i++) {
		particles[i].draw();
	}
}

// Draws the scoreboard that appears at the bottom
function drawScore() {
	fill(0);
	rectMode(CORNER);
	rect(0, gameHeight, width, height);
	rectMode(CENTER);
	fill(color(0, 255, 0));
	
	var lifeText = "extra balls: ";
	for (var i = 0; i < lives - 1; i++) {
		lifeText += "\u25cf";
	}
	text(lifeText, 10, gameHeight + 10);
}

// Object containing click methods for different stages of the game
var clicker = {
	"0": function() {
		gameStage++;
	},
	"1": function() {
		//particles.push(new Particle(mouseX, mouseY, color(0, 0, 255)));
		
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

function gameOver() {
	console.log("game over");
	gameStage = -1;
}

function gameWin() {
	console.log("game win");
	gameStage = -2;
}

function Paddle() {
	this.x = gameWidth / 2;
	this.y = gameHeight - 2;
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
		if (this.x + this.dx + (this.width / 2) >= gameWidth) {
			this.x = gameWidth - (this.width / 2);
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
	this.x = gameWidth / 2;
	this.y = gameHeight / 2;
	this.speed = 3;
	this.v = new PVector(0, this.speed);
	this.c = color(0, 0, 255);
	this.move = function() {
		if (this.x + this.v.x - this.radius < 0 || this.x + this.v.x + this.radius > gameWidth) {
			this.v.x *= -1;
		}
		if (this.y + this.v.y - this.radius < 0) {
			this.v.y *= -1;
		}
		if (this.y + this.v.y + this.radius > gameHeight) {
			//ball went off screen down
			lives -= 1;
			for (var i = 0; i < 5; i++) {
				particles.push(new Particle(this.x, this.y, color(255, 0, 0)));
			}
			if (lives <= 0) {
				gameOver();
			} else {
				this.x = gameWidth / 2;
				this.y = gameHeight / 2;
				this.v.x = 0;
				this.v.y = this.speed;
				paddle.x = gameWidth / 2;
			}
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

function Brick(x, y, c) {
	this.x = x;
	this.y = y;
	this.width = 30;
	this.height = 10;
	this.hwidth = this.width / 2;
	this.hheight = this.height / 2;
	this.c = c;
	this.isDead = false;
	this.draw = function() {
		//var c = color(128 + Math.sin(counter/10.0) * 128, 128 - Math.sin(counter/10.0) * 128, 0);
		fill(this.c);
		rectMode(CENTER);
		rect(this.x, this.y, this.width, this.height);
	}
	this.die = function() {
		this.isDead = true;
		particles.push(new Particle(this.x, this.y, this.c));
	}
	this.bounce = function(inBall) {
		this.die();
		//eight different sectors that the ball can be in
		//if it is in the corners, should reverse x and y
		//if above or below, should reverse y but not x
		//if on the sides, should reverse x but not y
		var inVertical = (inBall.y <= this.y + this.hheight && inBall.y >= this.y - this.hheight);
		var inHorizontal = (inBall.x <= this.x + this.hwidth && inBall.x >= this.x - this.hwidth);
		if (!inVertical && !inHorizontal) {
			//inBall.v.x *= -1;
			inBall.v.y *= -1;
		} else if (inVertical && !inHorizontal) {
			inBall.v.x *= -1;
		} else if (!inVertical && inHorizontal) {
			inBall.v.y *= -1;
		} else {
			
		}
		inBall.move();
	}
}

// Particle system object containing subparticles
function Particle(x, y, c) {
	this.x = x;
	this.y = y;
	this.c = c;
	this.life = 255;
	this.subParticles = [];
	for (var i = 0; i < 20; i++) {
		this.subParticles.push(new SubParticle(this.x, this.y, this.c, this));
	}
	this.isDead = function() {
		if (this.life <= 0) {
			return true;
		}
		return false;
	}
	this.move = function() {
		this.life -= 2;
		for (var i = 0; i < this.subParticles.length; i++) {
			this.subParticles[i].move();
		}
	}
	this.draw = function() {
		noStroke();
		for (var i = 0; i < this.subParticles.length; i++) {
			this.subParticles[i].draw();
		}
		stroke(1);
	}
}

function SubParticle(x, y, c, parent) {
	this.x = x;
	this.y = y;
	this.dx = random(-7, 7);
	this.dy = random(-7, 7);
	this.radius = 3;
	this.c = c;
	this.parent = parent;
	this.move = function() {
		this.life -= 2;
		if (this.x + this.dx + this.radius >= gameWidth || this.x + this.dx - this.radius <= 0) {
			this.dx *= -1;
		}
		if (this.y + this.dy + this.radius >= gameHeight || this.y + this.dy - this.radius <= 0) {
			this.dy *= -1;
		}
		this.x += this.dx;
		this.y += this.dy;
		this.dy *= .99;
		this.dx *= .99;
	}
	this.draw = function() {
		//noStroke();
		fill(this.c, this.parent.life);
		ellipse(this.x, this.y, this.radius * 2, this.radius * 2);
		//stroke(1);
	}
}