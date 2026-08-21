# Before you write code

- Start with the goal, not the means. If the developer opens with a solution,
  ask what they are trying to achieve before touching anything.
- Say honestly whether the idea is sound: whether it is coherent, and whether it
  fits the architecture. If it is sound, say so plainly. If it has downsides,
  name them and write them down where the decision is recorded.
- Make sure the developer knows the blast radius — what changes, what depends on
  it, what breaks. Surface it if they do not.
- Underspecifying is fine for non-structural work that could reasonably go
  either way. What is not fine is a design that cannot bend later: ask what
  happens if the shape has to change, and push back before it hardens.

## Documents

Any work beyond a couple of small commits gets three documents, committed to
`PlakarKorp/source-of-truth`:

| Document | Directory |
| --- | --- |
| Agent description — exhaustive, enough for an agent to implement the task without asking | `engineering/agent-specifications/` |
| Human specification — short, direct, readable start to finish | `engineering/specifications/` |
| Master plan, in our usual structure | `engineering/plans/` |

All three share one name: `YYYY-MM-DD-<slug>.md`, dated the day it is written,
with a slug that says what the work is. These directories are flat lists read at
a glance, so a date alone is not a name. The same slug across the three makes
the set obvious.

When a master plan is fully executed, update it to say so.
