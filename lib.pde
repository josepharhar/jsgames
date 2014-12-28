// These represent the size of the frame in which the game is being drawn (not scoreboard)
// where particles, etc. can bounce around
var gameWidth;
var gameHeight;

// Particle system object containing subparticles
function Particle(x, y, c, numParticles) {
	this.x = x;
	this.y = y;
	this.c = c;
	this.life = 255;
	this.subParticles = [];
	for (var i = 0; i < numParticles; i++) {
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