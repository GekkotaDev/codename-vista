class_name SaveFileV0
extends SaveFile

func _init():
	version = 0


func checksum():
	pass


func migrate(_save):
	return OK


func downgrade():
	return self
