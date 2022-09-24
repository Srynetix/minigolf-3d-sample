extends RigidBody
class_name Ball

signal stopped()

func shoot(angle: float, power: float) -> void:
    var force := Vector3(0, 0, -1).rotated(Vector3(0, 1, 0), angle)
    apply_impulse(Vector3(), force * power / 5)

func _integrate_forces(state: PhysicsDirectBodyState):
    if state.linear_velocity.length() < 0.1:
        emit_signal("stopped")
        state.linear_velocity = Vector3()
        state.angular_velocity = Vector3()