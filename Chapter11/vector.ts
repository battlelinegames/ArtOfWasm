export class Vector2D {
	private x: f32;
	private y: f32;
	constructor(x: f32, y: f32) {
		this.x = x;
		this.y = y;
	}
	Magnitude(): f32 {
		return Mathf.sqrt(this.x * this.x + this.y * this.y);
	}
}