// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║  ITI VHL – Unit Test Plans                                                  ║
// ║  One TestPlan per actor; one suite per transaction.                         ║
// ║  Feature files live under input/tests/features/                             ║
// ║  Uses fhir.uv.testing#0.1.0-SNAPSHOT TestPlan profile                      ║
// ╚══════════════════════════════════════════════════════════════════════════════╝
Alias: $UVTestPlan = http://hl7.org/fhir/StructureDefinition/TestPlan|0.1.0-SNAPSHOT



// ─────────────────────────────────────────────────────────────────────────────
// Trust Anchor
//   Transactions:
//     ITI-YY1  Submit PKI Material with DID    – Responder role
//     ITI-YY2  Retrieve Trust List with DID    – Responder role
// ─────────────────────────────────────────────────────────────────────────────

Instance:   TestPlan-TrustAnchor
InstanceOf: $UVTestPlan
Title:      "Test Plan – Trust Anchor"
Usage:      #definition
* url         = "https://profiles.ihe.net/ITI/VHL/TestPlan/TestPlan-TrustAnchor"
* name        = "TestPlan_TrustAnchor"
* status      = #active
* description = """
Unit test plan for the **Trust Anchor** actor of the IHE ITI Verifiable Health Links (VHL) profile.

Scope: tests validate all behaviour expected of a Trust Anchor as described in the transaction
specifications ITI-YY1 and ITI-YY2. Each test suite corresponds to one transaction and exercises
the responder-side requirements using the associated Gherkin feature file.
"""
* scope[+] = Reference(TrustAnchor)


// ── Suite 1 : ITI-YY1  Submit PKI Material with DID (Responder) ──────────────
* suite[+].name        = "ITI-YY1-TrustAnchor-Responder"
* suite[=].description = """
ITI-YY1 Submit PKI Material with DID – Trust Anchor (Responder).
Validates that the Trust Anchor correctly receives, validates, stores, and responds to DID
Document submissions from VHL Sharers and VHL Receivers. Covers structural validation,
cryptographic material checks, identity authentication, cataloguing, revocation support,
and all defined HTTP error responses (400, 401, 403, 422).
"""
* suite[=].test[+].name        = "gherkin-feature"
* suite[=].test[=].description = """
Execute all scenarios in the Gherkin feature file
`ITI-YY1-submit-pki-material-response.feature`.

Each scenario maps directly to a MUST/SHALL/SHOULD requirement stated in section
2:3.YY1.4.1.3 (Trust Anchor Expected Actions) and 2:3.YY1.4.2 (Response Message) of the
transaction specification.  A SUT is compliant when all SHALL scenarios pass and all SHOULD
scenarios are at least acknowledged.
"""
* suite[=].test[=].operation          = "gherkin"
* suite[=].test[=].input[+].name      = "ITI-YY1 Submit PKI Material Response – Gherkin Feature"
* suite[=].test[=].input[=].file      = "https://profiles.ihe.net/ITI/VHL/tests/features/ITI-YY1-submit-pki-material-response.feature"


// ── Suite 2 : ITI-YY2  Retrieve Trust List with DID (Responder) ──────────────
* suite[+].name        = "ITI-YY2-TrustAnchor-Responder"
* suite[=].description = """
ITI-YY2 Retrieve Trust List with DID – Trust Anchor (Responder).
Validates that the Trust Anchor correctly responds to DID Document retrieval requests. Covers
single-DID GET, bulk GET, mCSD-based queries, active-document-only filtering, authentication
and authorisation checks (401/403), 404 handling, optional response signing, and receiver
post-processing obligations.
"""
* suite[=].test[+].name        = "gherkin-feature"
* suite[=].test[=].description = """
Execute all scenarios in the Gherkin feature file
`ITI-YY2-retrieve-trust-list-response.feature`.

Scenarios are derived from section 2:3.YY2.4.2 (Response Message) and 2:3.YY2.5 (Security
Considerations) of the transaction specification.
"""
* suite[=].test[=].operation          = "gherkin"
* suite[=].test[=].input[+].name      = "ITI-YY2 Retrieve Trust List Response – Gherkin Feature"
* suite[=].test[=].input[=].file      = "https://profiles.ihe.net/ITI/VHL/tests/features/ITI-YY2-retrieve-trust-list-response.feature"


// ─────────────────────────────────────────────────────────────────────────────
// VHL Sharer
//   Transactions:
//     ITI-YY1  Submit PKI Material with DID    – Initiator role
//     ITI-YY3  Generate VHL                    – Responder role
//     ITI-YY5  Retrieve Manifest               – Responder role
// ─────────────────────────────────────────────────────────────────────────────

Instance:   TestPlan-VHLSharer
InstanceOf: $UVTestPlan
Title:      "Test Plan – VHL Sharer"
Usage:      #definition
* url         = "https://profiles.ihe.net/ITI/VHL/TestPlan/TestPlan-VHLSharer"
* name        = "TestPlan_VHLSharer"
* status      = #active
* description = """
Unit test plan for the **VHL Sharer** actor of the IHE ITI Verifiable Health Links (VHL) profile.

Scope: tests validate all behaviour expected of a VHL Sharer across the three transactions it
participates in: submitting its own PKI material (ITI-YY1 initiator), generating VHLs on demand
(ITI-YY3 responder), and serving document manifests to authorised VHL Receivers (ITI-YY5
responder).  Each test suite corresponds to one transaction and exercises the actor-specific
requirements using the associated Gherkin feature file.
"""
* scope[+] = Reference(VHLSharer)


// ── Suite 1 : ITI-YY1  Submit PKI Material with DID (Initiator) ──────────────
* suite[+].name        = "ITI-YY1-VHLSharer-Initiator"
* suite[=].description = """
ITI-YY1 Submit PKI Material with DID – VHL Sharer (Initiator).
Validates that the VHL Sharer correctly constructs and submits a DID Document to the Trust
Anchor. Covers mandatory DID Document elements (@context, id, verificationMethod), verification
method content (id, type, controller, publicKeyJwk/publicKeyMultibase), private-key exclusion,
cryptographic suite acceptability, optional fields (authentication, assertionMethod, service),
HTTP POST semantics, Content-Type, mutual TLS, provenance metadata, and secure private-key storage.
"""
* suite[=].test[+].name        = "gherkin-feature"
* suite[=].test[=].description = """
Execute all scenarios in the Gherkin feature file
`ITI-YY1-submit-pki-material-request.feature`.

Scenarios are derived from section 2:3.YY1.4.1.2 (Message Semantics) and 2:3.YY1.4.1.3
(VHL Sharer / VHL Receiver Expected Actions) of the transaction specification.
"""
* suite[=].test[=].operation          = "gherkin"
* suite[=].test[=].input[+].name      = "ITI-YY1 Submit PKI Material Request – Gherkin Feature"
* suite[=].test[=].input[=].file      = "https://profiles.ihe.net/ITI/VHL/tests/features/ITI-YY1-submit-pki-material-request.feature"


// ── Suite 2 : ITI-YY3  Generate VHL (Responder) ──────────────────────────────
* suite[+].name        = "ITI-YY3-VHLSharer-Responder"
* suite[=].description = """
ITI-YY3 Generate VHL – VHL Sharer (Responder).
Validates the complete VHL generation pipeline: accepting the $generate-vhl FHIR operation
request, passcode hashing (bcrypt/Argon2/PBKDF2), folder-ID and encryption-key generation, SHL
payload construction (url, key, exp, flag, label, v), mandatory manifest URL parameters,
HCERT/CWT encoding pipeline (COSE signing → ZLIB compression → Base45 encoding → HC1: prefix),
QR code generation (ISO/IEC 18004:2015, error-correction Q, Alphanumeric mode), and error
OperationOutcome responses.
"""
* suite[=].test[+].name        = "gherkin-feature"
* suite[=].test[=].description = """
Execute all scenarios in the Gherkin feature file
`ITI-YY3-generate-vhl-response.feature`.

Scenarios are derived from section 2:3.YY3.4.1.3 (VHL Sharer Expected Actions) and 2:3.YY3.4.2
(Generate VHL Response Message) of the transaction specification.
"""
* suite[=].test[=].operation          = "gherkin"
* suite[=].test[=].input[+].name      = "ITI-YY3 Generate VHL Response – Gherkin Feature"
* suite[=].test[=].input[=].file      = "https://profiles.ihe.net/ITI/VHL/tests/features/ITI-YY3-generate-vhl-response.feature"


// ── Suite 3 : ITI-YY5  Retrieve Manifest (Responder) ─────────────────────────
* suite[+].name        = "ITI-YY5-VHLSharer-Responder"
* suite[=].description = """
ITI-YY5 Retrieve Manifest – VHL Sharer (Responder).
Validates that the VHL Sharer correctly authenticates the VHL Receiver (HTTP Message Signatures
per RFC 9421 or OAuth with FAST Option), authorises the VHL (folder ID, expiry, revocation,
passcode), executes the FHIR search on the List resource, handles the Include DocumentReference
Option (_include=List:item), constructs a conformant searchset Bundle, and returns appropriate
error responses (400, 401, 403, 404, 422, 429, 500) with FHIR OperationOutcome.
"""
* suite[=].test[+].name        = "gherkin-feature"
* suite[=].test[=].description = """
Execute all scenarios in the Gherkin feature file
`ITI-YY5-retrieve-manifest-response.feature`.

Scenarios are derived from section 2:3.YY5.4.1.5 (VHL Sharer Expected Actions), 2:3.YY5.4.2
(Response Message), and 2:3.YY5.5 (Security Considerations) of the transaction specification.
"""
* suite[=].test[=].operation          = "gherkin"
* suite[=].test[=].input[+].name      = "ITI-YY5 Retrieve Manifest Response – Gherkin Feature"
* suite[=].test[=].input[=].file      = "https://profiles.ihe.net/ITI/VHL/tests/features/ITI-YY5-retrieve-manifest-response.feature"


// ─────────────────────────────────────────────────────────────────────────────
// VHL Receiver
//   Transactions:
//     ITI-YY1  Submit PKI Material with DID    – Initiator role  (Optional)
//     ITI-YY2  Retrieve Trust List with DID    – Initiator role
//     ITI-YY4  Provide VHL                     – Responder role
//     ITI-YY5  Retrieve Manifest               – Initiator role
// ─────────────────────────────────────────────────────────────────────────────

Instance:   TestPlan-VHLReceiver
InstanceOf: $UVTestPlan
Title:      "Test Plan – VHL Receiver"
Usage:      #definition
* url         = "https://profiles.ihe.net/ITI/VHL/TestPlan/TestPlan-VHLReceiver"
* name        = "TestPlan_VHLReceiver"
* status      = #active
* description = """
Unit test plan for the **VHL Receiver** actor of the IHE ITI Verifiable Health Links (VHL) profile.

Scope: tests validate all behaviour expected of a VHL Receiver across its four transactions:
optionally submitting its own PKI material (ITI-YY1 initiator), retrieving the trust list from the
Trust Anchor (ITI-YY2 initiator), decoding and validating a VHL QR code presented by the VHL
Holder (ITI-YY4 responder), and requesting the document manifest from the VHL Sharer (ITI-YY5
initiator).  Each test suite corresponds to one transaction and exercises the actor-specific
requirements using the associated Gherkin feature file.
"""
* scope[+] = Reference(VHLReceiver)


// ── Suite 1 : ITI-YY1  Submit PKI Material with DID (Initiator – Optional) ───
* suite[+].name        = "ITI-YY1-VHLReceiver-Initiator"
* suite[=].description = """
ITI-YY1 Submit PKI Material with DID – VHL Receiver (Initiator, Optional).
Validates that, when supported, the VHL Receiver correctly constructs and submits a DID Document
to the Trust Anchor. The test scope is identical to the VHL Sharer's initiator suite; both actors
share the same initiator feature file. A VHL Receiver that does not implement this optional
transaction must use an out-of-band mechanism to establish trust.
"""
* suite[=].test[+].name        = "gherkin-feature"
* suite[=].test[=].description = """
Execute all scenarios in the Gherkin feature file
`ITI-YY1-submit-pki-material-request.feature`.

Note: participation in this transaction is OPTIONAL for VHL Receiver actors.  Implementations
that claim support MUST pass all SHALL scenarios.
"""
* suite[=].test[=].operation          = "gherkin"
* suite[=].test[=].input[+].name      = "ITI-YY1 Submit PKI Material Request – Gherkin Feature"
* suite[=].test[=].input[=].file      = "https://profiles.ihe.net/ITI/VHL/tests/features/ITI-YY1-submit-pki-material-request.feature"


// ── Suite 2 : ITI-YY2  Retrieve Trust List with DID (Initiator) ──────────────
* suite[+].name        = "ITI-YY2-VHLReceiver-Initiator"
* suite[=].description = """
ITI-YY2 Retrieve Trust List with DID – VHL Receiver (Initiator).
Validates that the VHL Receiver correctly constructs trust-list retrieval requests (GET by DID,
GET all, mCSD query), sets the correct Accept header, sends requests over TLS, and properly
processes the response: validates the response signature when present, checks DID Document
conformance, extracts and maps public keys, caches material, tracks expiry, and immediately
invalidates entries on revocation notification.
"""
* suite[=].test[+].name        = "gherkin-feature"
* suite[=].test[=].description = """
Execute all scenarios in the Gherkin feature file
`ITI-YY2-retrieve-trust-list-request.feature`.

Scenarios are derived from section 2:3.YY2.4.1 (Request Message), 2:3.YY2.4.2.3 (VHL Receiver
Expected Actions), and 2:3.YY2.5 (Security Considerations) of the transaction specification.
"""
* suite[=].test[=].operation          = "gherkin"
* suite[=].test[=].input[+].name      = "ITI-YY2 Retrieve Trust List Request – Gherkin Feature"
* suite[=].test[=].input[=].file      = "https://profiles.ihe.net/ITI/VHL/tests/features/ITI-YY2-retrieve-trust-list-request.feature"


// ── Suite 3 : ITI-YY4  Provide VHL (Responder / Decoder) ─────────────────────
* suite[+].name        = "ITI-YY4-VHLReceiver-Responder"
* suite[=].description = """
ITI-YY4 Provide VHL – VHL Receiver (Responder / Decoder).
Validates the complete nine-step VHL decoding pipeline: QR code scanning (ISO/IEC 18004:2015
Alphanumeric mode), HC1: prefix verification, Base45 decoding, ZLIB/DEFLATE decompression, CBOR
Web Token (CWT) parsing, COSE digital signature verification using the trust list, CWT claims
validation (exp, iat), SHL payload extraction from hcert claim key 5, and SHL payload field
validation (url, key, flag, exp). Also covers post-decoding actions, error rejection behaviour,
and optional acknowledgment semantics.
"""
* suite[=].test[+].name        = "gherkin-feature"
* suite[=].test[=].description = """
Execute all scenarios in the Gherkin feature file
`ITI-YY4-provide-vhl-response.feature`.

Scenarios are derived from section 2:3.YY4.4.1.4 (VHL Receiver Expected Actions) and 2:3.YY4.5
(Security Considerations) of the transaction specification.
"""
* suite[=].test[=].operation          = "gherkin"
* suite[=].test[=].input[+].name      = "ITI-YY4 Provide VHL Response (Receiver Decoder) – Gherkin Feature"
* suite[=].test[=].input[=].file      = "https://profiles.ihe.net/ITI/VHL/tests/features/ITI-YY4-provide-vhl-response.feature"


// ── Suite 4 : ITI-YY5  Retrieve Manifest (Initiator) ─────────────────────────
* suite[+].name        = "ITI-YY5-VHLReceiver-Initiator"
* suite[=].description = """
ITI-YY5 Retrieve Manifest – VHL Receiver (Initiator).
Validates that the VHL Receiver correctly constructs the Retrieve Manifest request: HTTP POST to
/List/_search, mandatory FHIR search parameters (_id, code, status, patient.identifier), SHL
parameters (recipient required, passcode when P flag, optional embeddedLengthMax), and HTTP
Message Signatures (Content-Digest, Signature-Input, Signature headers; approved algorithms).
Also covers the optional OAuth with FAST Option (client_credentials, JWT assertions, Bearer
token) and correct processing of the searchset Bundle response.
"""
* suite[=].test[+].name        = "gherkin-feature"
* suite[=].test[=].description = """
Execute all scenarios in the Gherkin feature file
`ITI-YY5-retrieve-manifest-request.feature`.

Scenarios are derived from section 2:3.YY5.4.1 (Request Message, including authentication
sub-sections) and 2:3.YY5.5.2 (HTTP Message Signatures security requirements) of the transaction
specification.
"""
* suite[=].test[=].operation          = "gherkin"
* suite[=].test[=].input[+].name      = "ITI-YY5 Retrieve Manifest Request – Gherkin Feature"
* suite[=].test[=].input[=].file      = "https://profiles.ihe.net/ITI/VHL/tests/features/ITI-YY5-retrieve-manifest-request.feature"
