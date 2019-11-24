extends Node2D

const Piece = preload("res://Classes/Piece.gd")

var piece: Piece

var piece_type = 0

func _unhandled_key_input(event):
  if event.pressed:
    match event.scancode:
      KEY_UP:
        piece.move_up()
      KEY_DOWN:
        piece.move_down()
      KEY_LEFT:
        piece.move_left()
      KEY_RIGHT:
        piece.move_right()
      KEY_SPACE:
        piece_type += 1
        remove_child(piece.node)
        piece = Piece.new(piece_type)
        add_child(piece.node)

func _ready():
  piece = Piece.new(piece_type)
  add_child(piece.node)
