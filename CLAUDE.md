# CLAUDE.md - Developer Guide & Rules
## Build & Test Commands
* Build: `./gradlew build`
* Test: `./gradlew test`
* Run: `./gradlew bootRun`
## Code Style Guidelines
* Pattern: Modular Monolith
* Domain: Zero external framework code in domain packages
* Models: Use immutable records
* Financials: Always use BigDecimal
