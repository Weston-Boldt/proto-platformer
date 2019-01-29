# proto-platfomer (name not final)
> in development platformer written for love2d
> game in pre-pre-alpha

---

## First TODOs

- strip out ALL DATA and put into a data store
    - beginning implementations are going with the player obj
        need to implement for other entities

- Make State machine objects or some kinda component thing to reuse
    some code, for instance the entities all need to launch, not just the player

- Character / Enemy Designs
    - In progress

- Design Documents
    - struggling to get to this

- Implement Core Mechanics

- Animation System Implementation
> will likely just use anim8

- level completion / advancement

## Core Mechanics

- [x] attack in all directions
    - needs tweaking

- [x] launch player if they punch a wall
    - needs tweaking

- [ ] launch enemy if they punch a enemy
    - needs design

- [ ] ricochets
    - needs design

## Installation

```sh
$ git clone https://github.com/Weston-Boldt/proto-platformer
```

## Useage
may need to git clone libs

```sh
$ cd proto-platformer
$ love .
```
