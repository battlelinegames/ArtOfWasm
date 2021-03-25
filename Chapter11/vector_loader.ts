export class Vector2D {
	x: f32;
	y: f32;
	constructor(x: f32, y: f32) {
		this.x = x;
		this.y = y;
	}
	Magnitude(): f32 {
		return Mathf.sqrt(this.x * this.x + this.y * this.y);
	}
	add(vec2: Vector2D): Vector2D {
		this.x += vec2.x;
		this.y += vec2.y;
		return this;
	}
}

export class Vector3D extends Vector2D {
	z: f32;
	constructor(x: f32, y: f32, z: f32) {
		super(x, y);
		this.z = z;
	}
	Magnitude(): f32 {
		return Mathf.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
	}
	add(vec3: Vector3D): Vector3D {
		super.add(vec3);
		this.z += vec3.z;
		return this;
	}
}