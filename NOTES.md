# Godot Notes

## Animated Tilesets

Very awkward, unintuitive and undocumented feature. 

Setup a tileset as you usually would BUT ... DESELECT ALL BUT THE FIRST FRAMES OF EACH ANIMATED SPRITE. For example, if you have a 5x15 sheet of sprites, with each frame aligned vertically, then the first row of frames would be selected and the rest of the the tileset deselected. 

Assuming the frames are aligned vertically, select the first frame on the top left. Go to the 'Select' section of the tileset editor. Under animation, be sure you have 1 column. Count the number of frames BETWEEN the start and end frame. That's your y-axis separation.

Click 'Add Element'. 

Example: https://github.com/godotengine/godot/issues/70860


## Scenes and nodes

- `$Object` refers to the current scene's tree. If you run
- signals are pretty incredible. of note: sprite signals, timer signals.

Its usually better to control things in the affirmative instead of as exceptions. For example, a projectile
is fired when the player is in view. But what about when the player is out of view? Code an `on_exit` event 
for that to separate it from any default state, rather than using `else` statements to swap between 'in zone/out zone'.

## Screen Size and Resolutions 

https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html
https://ask.godotengine.org/27004/techniques-for-changing-the-limits-of-camera2d

## Shaders

Beware that adding shader material to a prefab will cause it to animate on all instances of that object. To stop this:

1. Go to the shader material and "Make Unique (recursive)"
2. Open the "Resources" sub menu below it.
3. Tick the "Local" box.

https://www.reddit.com/r/godot/comments/f82hv1/animation_is_shared_between_all_instances_of_a/

Example shaders:
- https://godotshaders.com/shader/pixelate-into-view-texture-resolution/


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

