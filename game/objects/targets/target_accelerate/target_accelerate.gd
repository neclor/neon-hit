extends Target

const ACCELERATION = PI / 4

const SPEED_MIN = - PI
const SPEED_MAX = PI

var acceleration := ACCELERATION

func move(delta: float):
	if speed <= SPEED_MIN:
		acceleration = ACCELERATION

	elif speed >= SPEED_MAX:
		acceleration = -ACCELERATION

	move_with_acceleration(delta)

func move_with_acceleration(delta: float):
	speed = speed + (acceleration * delta)
	rotation += speed * delta
