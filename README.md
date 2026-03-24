# Experimenting with Boids

> In this project, I experimented with simulating 2D Boids. The term Boid, coined by Craig Reynolds in 1987, refers to
> bird-like agents which move based on a simple set of rules. These rules are chosen in a way that the collection of Boids shows natural looking emergent movement patterns.

https://github.com/user-attachments/assets/17474c5e-5cf5-4ac8-b334-b3822c138aae

---

## Inspiration & Sources

This project was primarily inspired by a video made by Sebastian Lague: \
https://www.youtube.com/watch?v=bqtqltqcQhw

Other sources: \
[Flocks, Herds, and Schools: A Distributed Behavioral Model](https://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/)

---

## The Premise: How Boids Move

The original paper describes three simple rules:

> **Collision Avoidance:** avoid collisions with nearby flockmates \
> **Velocity Matching:** attempt to match velocity with nearby flockmates \
> **Flock Centering:** attempt to stay close to nearby flockmates \
> — Reynolds, 1987

(For simplicity, we will call them separation, alignment and cohesion, respectively)

Unfortunately, the paper does not go into much detail on how each of these rules is implemented.
After looking around for a while and trying various approaches, I decided to more or less re-implement the approach that Sebastian Lague used for his video, which works roughly as follows:

### Movement Rules

Let $`\mathcal{N}`$ denote the set of neighboring agents within perception range. For each neighbor $`n \in \mathcal{N}`$, let $`\mathbf{p}_n`$ and $`\mathbf{v}_n`$ denote its position and velocity respectively. The current agent's position and velocity are denoted $`\mathbf{p}`$ and $`\mathbf{v}`$.
The parameter $`r`$ represents the perception radius (used for scaling), $`v_{\text{min}}`$ is the minimum speed, $`f_{\text{max}}`$ is the maximum steering force, and $`w`$ are the respective weights, used for accumulating the three force components.

**Separation** \
Steers the agent away from nearby neighbors to avoid crowding:

$`\mathbf{f}_{\text{sep}} = \text{steer\_towards}\left(-\sum_{n \in \mathcal{N}} \frac{(\mathbf{p}_n - \mathbf{p}) / |\mathbf{p}_n - \mathbf{p}|}{(|\mathbf{p}_n - \mathbf{p}| / r)^2}\right) \cdot w_{\text{sep}}`$

**Alignment** \
Steers the agent toward the average velocity of its neighbors:

$`\mathbf{f}_{\text{ali}} = \text{steer\_towards}\left(\frac{1}{|\mathcal{N}|} \sum_{n \in \mathcal{N}} \mathbf{v}_n\right) \cdot w_{\text{ali}}`$

**Cohesion** \
Steers the agent toward the center of mass of its neighbors:

$`\mathbf{f}_{\text{coh}} = \text{steer\_towards}\left(\frac{1}{|\mathcal{N}|} \sum_{n \in \mathcal{N}} \mathbf{p}_n - \mathbf{p}\right) \cdot w_{\text{coh}}`$

**Steering** \
$`\text{steer\_towards}(\mathbf{target}) = \text{clamp}\left(\mathbf{target}_{\text{norm}} \cdot v_{\text{min}} - \mathbf{v},\ 0,\ f_{\text{max}}\right)`$

**Accumulation** \
Accumulating the force components into a single steering force again uses the perception range as a scaling factor, to make sure the forces have a reasonable order of magnitude.

$`\mathbf{f} = (\mathbf{f}_{\text{sep}} + \mathbf{f}_{\text{ali}} + \mathbf{f}_{\text{coh}}) \cdot r`$

