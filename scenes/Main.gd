extends Spatial

onready var _arrow := $Arrow as Spatial
onready var _ball := $Ball as RigidBody
onready var _ui := $UI as CanvasLayer
onready var _tee := $Tee as Position3D
onready var _hole := $Hole as Area
onready var _gimbal := $GimbalOut as Spatial

var shots := 0
var state := StepState.SET_ANGLE as int
var power := 0.0
var power_change := 1.0
var power_speed := 100.0
var angle_change := 1.0
var angle_speed := 1.1
var hole_dir := 0.0

enum StepState {
    SET_ANGLE = 0,
    SET_POWER,
    SHOOT,
    WIN
}

func _ready() -> void:
    _hole.connect("body_entered", self, "_on_ball_in_hole")
    _ball.connect("stopped", self, "_on_ball_stopped")

    _arrow.hide()
    _ball.transform.origin = _tee.transform.origin
    change_state(StepState.SET_ANGLE)

func set_start_angle() -> void:
    var hole_pos := Vector2(_hole.transform.origin.z, _hole.transform.origin.x)
    var ball_pos := Vector2(_ball.transform.origin.z, _ball.transform.origin.x)
    hole_dir = (ball_pos - hole_pos).angle()
    _arrow.rotation.y = hole_dir

func change_state(new_state: int) -> void:
    state = new_state
    match state:
        StepState.SET_ANGLE:
            _arrow.transform.origin = _ball.transform.origin
            _arrow.show()
            set_start_angle()
        StepState.SET_POWER:
            power = 0
            _ui.update_powerbar(power)
        StepState.SHOOT:
            _arrow.hide()
            _ball.shoot(_arrow.rotation.y, power)
            shots += 1
            _ui.update_shots(shots)
        StepState.WIN:
            _ball.hide()
            _arrow.hide()

func _process(delta: float) -> void:
    match state:
        StepState.SET_POWER:
            animate_power_bar(delta)

    _gimbal.transform.origin = _ball.transform.origin

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        var motion_event := event as InputEventMouseMotion
        if state == StepState.SET_ANGLE:
            _arrow.rotation.y -= motion_event.relative.x / 150

    if event is InputEventMouseButton:
        var btn_event := event as InputEventMouseButton
        if btn_event.button_index in [BUTTON_LEFT, BUTTON_RIGHT] && btn_event.pressed:
            match state:
                StepState.SET_ANGLE:
                    change_state(StepState.SET_POWER)
                StepState.SET_POWER:
                    change_state(StepState.SHOOT)

func animate_angle(delta: float) -> void:
    _arrow.rotation.y += angle_speed * angle_change * delta
    if _arrow.rotation.y > hole_dir + PI/2:
        angle_change = -1
    if _arrow.rotation.y < hole_dir - -PI/2:
        angle_change = 1

func animate_power_bar(delta: float) -> void:
    power += power_speed * power_change * delta
    if power >= 100:
        power_change = -1
    if power <= 0:
        power_change = 1
    _ui.update_powerbar(power)

func _on_ball_in_hole(ball: PhysicsBody) -> void:
    if ball is Ball:
        print("WIN")
        change_state(StepState.WIN)

func _on_ball_stopped() -> void:
    if state == StepState.SHOOT:
        change_state(StepState.SET_ANGLE)
