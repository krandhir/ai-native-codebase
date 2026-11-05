# ADR 002: Stream Processing and Top-K Sorting Strategy
## Status
Accepted
## Context
Processing financial datasets can exhaust memory if fully loaded.
## Decision
Enforce lazy stream evaluation and use a bounded PriorityQueue (Min-Heap) structure.
## Consequences
Deterministic space complexity capped at O(1) and time complexity at O(N log K).
