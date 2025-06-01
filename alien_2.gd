extends Node2D

@export var speed := 200.0
var target_position: Vector2
var mouse_held := false

func _ready():
	# Print a header so we know _ready() ran and on which node
	print("=== _ready() called on node: “", name, "” (", self, ") ===")

	# List all direct children of this node
	print("Direct children of “", name, "”:")
	for child in get_children():
		print("  • “", child.name, "” (", child, ")")

	# Attempt to grab the Camera2D child
	var camera_node = get_node_or_null("Camera2D")
	if camera_node:
		print("Found Camera2D as child: “", camera_node.name, "” (", camera_node, ")")
		camera_node.current = true
		print("  → Set Camera2D.current = true")
	else:
		print("ERROR: Could not find a direct child named “Camera2D” under “", name, "”.")
		print("       Make sure the Camera node is named exactly “Camera2D” and is a child of this node.")
		# Print the entire subtree for further debugging
		_print_subtree(self, 1)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		mouse_held = event.pressed
		print("Mouse right‐button pressed state changed:", mouse_held)

func _physics_process(delta):
	var direction = Vector2.ZERO

	# Keyboard input
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	# Mouse‐hold movement
	if direction == Vector2.ZERO and mouse_held:
		target_position = get_global_mouse_position()
		direction = (target_position - global_position).normalized()
		print("Moving toward mouse at", target_position, "; current position:", global_position)

	# Move the node
	if direction != Vector2.ZERO:
		global_position += direction.normalized() * speed * delta
		print("Moved to", global_position, "using direction", direction.normalized())

# Helper function to recursively print the entire subtree for debugging
func _print_subtree(node: Node, indent_level: int) -> void:
	# Create an indent string of (indent_level * 2) spaces
	var indent = " ".repeat(indent_level * 2)
	for child in node.get_children():
		print(indent, "↳ “", child.name, "” (", child, ")")
		_print_subtree(child, indent_level + 1)
