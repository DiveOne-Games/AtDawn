# Godot Notes

Scenes and nodes

- `$Object` refers to the current scene's tree. If you run
- signals are pretty incredible. of note: sprite signals, timer signals.

Its usually better to control things in the affirmative instead of as exceptions. For example, a projectile
is fired when the player is in view. But what about when the player is out of view? Code an `on_exit` event 
for that to separate it from any default state, rather than using `else` statements to swap between 'in zone/out zone'.


## Rigidbodies

AnimationPlayer seems to have a bug where instantiating a packedscene causes the sprite to distort. I think wrapping the position in `to_local` solved it. I think. 

## Character Movement


Several factors impact motion

* `physics_process` with delta vs. `process` without using delta
* Camera smoothing

Fiddling with camera position smoothing, and physics process delta with a speed formula (arbitrary speed * arbitrary speed scale * delta).


## Taking Damage

Setting Area2D shape on/off as the animated spikes pop up so that the player takes damage for as long as they stand on the trap.


## Patrols (Navigation)

Using the Navigation system, to setup a patrol I have to interact directly with the `NavigationServer2D`. This means setting up a couple of functions to make it easy to call for path updates from `physics_process`.

To set up a patrol, use some markers on the map to define where the unit will move. Then for a full patrol to work, you must:

1. Create a new path for the current destination - server hands you an array of points.
2. Update unit movement using the points in the path array.
3. Once destination reached, repeat for any additional points on the patrol.

Checkout this guide instead: 
https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_2d.html


## Coroutines

https://gdscript.com/solutions/coroutines-and-yield/


## Bugs

https://www.reddit.com/r/godot/comments/145i5gw/godot_4_sprite_distorting_when_instantiating/

