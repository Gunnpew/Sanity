extends CharacterBody2D


@export var SPEED : float = 175.0
@export var JUMP_VELOCITY : float = -270.0
@export var double_jumped_velocity : float = -300

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
var animation_locked : bool = false
var direction :Vector2 = Vector2.ZERO
var attack_animation : bool = false
var was_in_air : bool = false


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		has_double_jumped = false
		
		if was_in_air == true:
			land()
			
			was_in_air = false

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor(): 
			#Normal jump from floor
			jump()
		elif not has_double_jumped:
			# Double jump in air
			velocity.y = double_jumped_velocity
			has_double_jumped = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right","up","down")
	attack_animation = Input.is_action_pressed("attack")
	
	if direction :
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	#ใส่ไว้ก่อนเผื่อใช้ !!อย่าลบ
	update_animation()
	update_facing_direction()
	
func  update_animation():
#ไว้อัพเดทอนิเมชั่นต่างๆ
	if not animation_locked:
		if direction.x != 0:
			animated_sprite.play("run")
		elif attack_animation :
			animated_sprite.play("attack")
		else:
			animated_sprite.play("idle")
			#ท่าทางตอนตัวลละครอยู่นิ่งๆ
			
func update_facing_direction():
#คำสั่งไว้ให้ตัวละครหันหน้าตามทิศทางที่เรากด
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h  = true
		print(1234)
func jump():
		velocity.y = JUMP_VELOCITY
		animated_sprite.play("jump")
		animation_locked = true 

func land():
		animated_sprite.play("jump")
		animation_locked = false

func _on_animated_sprite_2d_animation_finished():
	if(animated_sprite.animation == "jump"):
		animation_locked = false
