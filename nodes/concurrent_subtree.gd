class_name ConcurrentSubtree
extends Node


func thread_subtree(node: Node):
	node.process_thread_group = Node.PROCESS_THREAD_GROUP_SUB_THREAD


func _ready() -> void:
	child_entered_tree.connect(thread_subtree)
