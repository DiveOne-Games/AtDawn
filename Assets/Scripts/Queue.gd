class_name Queue 

var data : Array 

func _init(items = null):
	print_debug('Queue init ', items)
	if not items:
		items = []
	data = items
		
func enqueue(item):
	print_debug('Added to queue: ', item)
	data.append(item) 


func dequeue():
	print_debug('Popped queue.')
	return data.pop_front() 

func is_empty():
	return len(data) == 0 

func peek():
	return data[0] 

