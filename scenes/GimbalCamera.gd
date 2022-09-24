extends Spatial

onready var _gimbal_in = $GimbalIn as Spatial

var cam_speed := PI / 2
var zoom_speed := 0.1
var zoom := 0.5

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("cam_zoom_in"):
        zoom -= zoom_speed
    if event.is_action_pressed("cam_zoom_out"):
        zoom += zoom_speed

func _process(delta: float) -> void:
    zoom = clamp(zoom, 0.1, 2)
    scale = Vector3.ONE * zoom

    if Input.is_action_pressed("cam_left"):
        rotate_y(-cam_speed * delta)
    if Input.is_action_pressed("cam_right"):
        rotate_y(cam_speed * delta)
    if Input.is_action_pressed("cam_up"):
        _gimbal_in.rotate_x(-cam_speed * delta)
    if Input.is_action_pressed("cam_down"):
        _gimbal_in.rotate_x(cam_speed * delta)

    _gimbal_in.rotation.x = clamp(_gimbal_in.rotation.x, -PI / 2, -0.2)