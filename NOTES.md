# Character Movement


Several factors impact motion

* `physics_process` with delta vs. `process` without using delta
* Camera smoothing

Fiddling with camera position smoothing, and physics process delta with a speed formula (arbitrary speed * arbitrary speed scale * delta)


## Taking Damage

Setting Area2D shape on/off as the animated spikes pop up so that the player takes damage for as long as they stand on the trap.


## Patrols (Navigation)

Rudimentary system ...doesn't seem to work in any meaningful way.

* home position
* waypoints
* place them all in a single list
* randomly pick a position and move towards it.
* can always reset to the home position.

Checkout this guide instead: 
https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_2d.html
