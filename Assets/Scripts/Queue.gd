class_name Queue 

var data : Array 

func _init(items = null):
    if not items:
        items = []
    data = items
        
func enqueue(item):
    data.append(item) 


func dequeue():
    return data.pop_front() 

func is_empty():
    return len(data) == 0 

func peek():
    return data[0] 

