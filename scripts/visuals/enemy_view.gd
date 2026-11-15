extends Node2D
## Replace this child with a Sprite2D/AnimatedSprite2D without changing Enemy.
var flash := 0.0
var clock := 0.0

func _init() -> void:
	name = "EnemyView"

func _process(delta: float) -> void:
	clock += delta
	flash = maxf(0.0, flash - delta * 6.0)
	queue_redraw()

func _draw() -> void:
	var enemy := get_parent() as Enemy
	var data: Dictionary = GameData.ENEMIES[enemy.kind]
	var r: float = data.radius
	var bob := sin(clock * enemy.speed * 0.15) * 2.0
	draw_ellipse_shadow(r)
	draw_circle(Vector2(-r * 0.4, r - 1), 4, Color("#49384b"))
	draw_circle(Vector2(r * 0.4, r - 1), 4, Color("#49384b"))
	draw_circle(Vector2(0, bob), r + 2, Color("#49384b"))
	draw_circle(Vector2(0, bob - 1), r, (data.color as Color).lerp(Color.WHITE, flash))
	for x in [-4.0, 4.0]:
		draw_circle(Vector2(x, bob - 3), 3.5, Color.WHITE)
		draw_circle(Vector2(x + 1, bob - 3), 1.7, Color("#302d43"))
	draw_arc(Vector2(0, bob + 2), 4, 0.0, PI, 10, Color("#633e50"), 1.7)
	if enemy.kind == "tank":
		draw_line(Vector2(-r, -r + bob), Vector2(r, -r + bob), Color("#6b588e"), 6)
	if enemy.health < enemy.max_health:
		draw_rect(Rect2(-18, -r - 13, 36, 5), Color("#523d4a"))
		draw_rect(Rect2(-17, -r - 12, 34 * maxf(enemy.health / enemy.max_health, 0), 3), Color("#95ed83"))

func draw_ellipse_shadow(radius: float) -> void:
	draw_set_transform(Vector2(0, radius), 0, Vector2(1, 0.3))
	draw_circle(Vector2.ZERO, radius, Color(0.08, 0.15, 0.1, 0.25))
	draw_set_transform(Vector2.ZERO)
