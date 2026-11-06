# CLAUDE.md - Developer Guide & Project Directives

## Build & Test Toolchain
- Build: `./gradlew build`
- Unit & Architecture Tests: `./gradlew test`
- Run Application: `./gradlew bootRun`
- Format & Quality Verification: Run `./gradlew test` before declaring any task complete.

## Architecture & Code Conventions
- **Pattern:** Modular Monolith.
- **Domain Purity:** Classes in `..domain..` packages must NEVER depend on `..infrastructure..`, Spring (`org.springframework..`), or external I/O libraries. (Strictly enforced via ArchUnit).
- **Domain Modeling:** Use immutable Java `record` types with defensive constructor validation.
- **Financial Precision:** Currency/Prices strictly as `BigDecimal`; Volumes/Quantities as `long`.
- **Fault-Tolerant Streaming:** Malformed or corrupted rows in data streams must be logged as warnings and skipped; a bad row must never terminate the stream.
- **Algorithmic Bound:** For Top-K aggregations, avoid loading full streams into memory lists. Use streaming processing with a bounded Min-Heap (`PriorityQueue`) to preserve memory bounds.
- **Testing Standard:** JUnit 5 with AssertJ (`assertThat(...)`). Avoid weak assertions. Mock external dependencies with Mockito.

## Repository Hygiene & Tracking
- **Prompt Audit:** Every feature implementation prompt must be logged chronologically at the end of `PROMPTS.md`.
- **Docs Sync:** If package names, endpoints, or setup commands change, update `README.md` immediately.
- **No Hallucinations:** Always review existing ADRs in `docs/adr/` before introducing new design patterns or dependencies.