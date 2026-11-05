Act as a Lead Java Engineer. We are implementing the core Trade Data Aggregator module inside our modular monolith workspace.

Please review all Architectural Decision Records (ADRs) inside the 'docs/adr/' directory to ensure your implementation strictly adheres to our system design constraints, boundaries, and performance decisions.

Analyze the formatting structure of the file '[Insert your actual data filename, e.g., input_trades.txt]' in the root directory.

Implement the features according to the following strict technical acceptance criteria:

1. DOMAIN SPECIFICATION:
   - Create an immutable Java record `Trade` in `com.company.project.orders.domain.model` containing fields matching the assignment spec: [Insert fields, e.g., String symbol, long volume, BigDecimal price, Instant timestamp].
   - Enforce the custom parser logic based on the format seen in '[data filename]': [Specify parser details, e.g., "The columns are pipe-separated (|)"].
   - Prevent invalid domain states (e.g., negative volume or null symbols) using clean validation logic during instantiation.

2. MEMORY & STREAM CRITERIA:
   - Implement a service processing incoming data lines as a `java.util.stream.Stream<String>`.
   - Ensure the process is fully streaming; do not collect lines into a List or array at any point to guarantee O(1) space complexity.

3. ALGORITHMIC EFFICIENCY (TOP-K):
   - Aggregate cumulative volumes into a map.
   - Extract the Top 10 highest-volume symbols using a bounded PriorityQueue (Min-Heap) structure to keep the time complexity capped at O(N log K).

4. FAULT ISOLATION:
   - If a row is malformed, corrupted, or has an invalid number format based on your structural analysis of the input file, log a warning and safely skip the line. A bad row must never crash the processing of the remaining stream.

5. TESTING & QUALITY GATES:
   - UNIT TESTS: Write comprehensive unit tests in JUnit 5 using Mockito for the core parsing and aggregation service. Test edge cases explicitly: completely empty streams, strings with corrupted data, invalid numeric formats, and numerical boundary values (e.g., max values, floating point inputs).
   - ARCHITECTURAL TESTING: Write an ArchUnit test using 'com.tngtech.archunit:archunit-junit5' to programmatically guarantee that classes inside any '..domain..' package do not import or depend on framework-heavy classes inside '..infrastructure..' or 'org.springframework..'.
   - INTEGRATION TESTS: Create a slice integration test (e.g., using `@WebMvcTest` or `@SpringBootTest`) to verify the REST endpoint returns the correct Top 10 payload format.
   - ASSERTIONS: Avoid weak assertions. Use precise AssertJ assertions (like `assertThat(result).hasSize(10).isSortedAccordingTo(...)`).
   - VERIFICATION: Run `./gradlew test` via the terminal to guarantee the build passes cleanly before declaring the task complete.

6. DOCUMENTATION & REPO CONTINUITY:
   - Critically review 'README.md' and 'PROMPTS.md'. 
   - If any setup instructions, package names, API endpoints, testing commands, or prerequisites are outdated or missing based on the code you just generated, modify the 'README.md' file immediately to ensure accurate documentation.
   - Log the exact prompt used for this feature implementation chronologically at the end of 'PROMPTS.md'.
