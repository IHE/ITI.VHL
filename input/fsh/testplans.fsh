// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║  ITI VHL – Test Plans                                                        ║
// ║                                                                              ║
// ║  Unit test plans (one per actor):                                            ║
// ║    TestPlan-TrustAnchor   – responder role in ITI-YY1 and ITI-YY2           ║
// ║    TestPlan-VHLSharer     – initiator in YY1/YY2, responder in YY3/YY5      ║
// ║    TestPlan-VHLReceiver   – initiator in YY1/YY2/YY5, responder in YY4      ║
// ║                                                                              ║
// ║  Integration test plans:                                                     ║
// ║    TestPlan-TrustEstablishment – YY1 + YY2 cross-actor trust workflow        ║
// ║    TestPlan-QRCodeFlow         – YY3 + YY4 + YY5 QR code pipeline           ║
// ║                                                                              ║
// ║  Atomic feature file pattern per transaction (4 files per transaction):      ║
// ║    ITI-YYn-{name}-message.feature    – message semantics (shared)           ║
// ║    ITI-YYn-{name}-initiator.feature  – initiator expected actions           ║
// ║    ITI-YYn-{name}-responder.feature  – responder expected actions           ║
// ║    ITI-YYn-{name}-security.feature   – security considerations (shared)     ║
// ║                                                                              ║
// ║  Feature files live under input/tests/features/                              ║
// ╚══════════════════════════════════════════════════════════════════════════════╝

Alias: $gherkin = urn:ietf:bcp:13  // IANA media-type registry used as language system

// ─────────────────────────────────────────────────────────────────────────────
// Trust Anchor
//   ITI-YY1  Submit PKI Material with DID    – Responder role
//   ITI-YY2  Retrieve Trust List with DID    – Responder role
// ─────────────────────────────────────────────────────────────────────────────

Instance:   TestPlan-TrustAnchor
InstanceOf: TestPlan
Title:      "Test Plan – Trust Anchor"
Usage:      #definition
* url         = "https://profiles.ihe.net/ITI/VHL/TestPlan/TestPlan-TrustAnchor"
* name        = "TestPlan_TrustAnchor"
* status      = #active
* description = """
Unit test plan for the **Trust Anchor** actor of the IHE ITI Verifiable Health Links (VHL) profile.

Scope: validates all behaviour expected of a Trust Anchor as described in ITI-YY1 (responder)
and ITI-YY2 (responder). Each test suite (testCase) corresponds to one transaction and exercises
three atomic feature files: message semantics (shared), responder expected actions, and security
considerations.
"""
* scope[+] = Reference(TrustAnchor)


// ── Suite 1 : ITI-YY1  Submit PKI Material with DID (Responder) ──────────────

* testCase[+].sequence = 1
* testCase[=].testRun[+].narrative = """
**ITI-YY1 Message Semantics** – Verifies the DID Document message format that the Trust Anchor
must validate: mandatory @context / id / verificationMethod fields, verification method structure,
public key format (JWK/RFC 7517), private key exclusion, accepted cryptographic suites, key
strength (P-256+), and HTTP POST / Content-Type requirements.
Source: section 2:3.YY1.4.1.2 (Message Semantics).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY1-submit-pki-material-message.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY1 Submit PKI Material – Message Semantics"

* testCase[=].testRun[+].narrative = """
**ITI-YY1 Trust Anchor Expected Actions** – Verifies structural and cryptographic validation,
identity authentication and authorisation, cataloguing, rejection criteria, revocation and
update support, and correct HTTP response codes (201 / 400 / 401 / 403 / 422).
Source: sections 2:3.YY1.4.1.3 (Responder) and 2:3.YY1.4.2 (Response Message).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY1-submit-pki-material-responder.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY1 Submit PKI Material – Trust Anchor Expected Actions"

* testCase[=].testRun[+].narrative = """
**ITI-YY1 Security Considerations** – Verifies §2:3.YY1.5 requirements: DID Document integrity
(signed submissions), key material security (private key exclusion, minimum strength), identity
verification (TLS, authentication mechanisms), DID Document validation (approved algorithms,
usage arrays), and revocation distribution controls.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY1-submit-pki-material-security.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY1 Submit PKI Material – Security Considerations"


// ── Suite 2 : ITI-YY2  Retrieve Trust List with DID (Responder) ──────────────

* testCase[+].sequence = 2
* testCase[=].testRun[+].narrative = """
**ITI-YY2 Message Semantics** – Verifies the request message options (single-DID GET,
bulk GET, mCSD query, URL encoding, optional query parameters) and response message
formats (single DID Document, collection, mCSD searchset Bundle, returned DID Document
content requirements).
Source: section 2:3.YY2.4 (Request and Response Messages).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY2-retrieve-trust-list-message.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY2 Retrieve Trust List – Message Semantics"

* testCase[=].testRun[+].narrative = """
**ITI-YY2 Trust Anchor Expected Actions** – Verifies active-document-only filtering (no
revoked/expired DID Documents), authentication and authorisation enforcement (401/403),
404 handling for unknown DIDs, and optional response signing.
Source: sections 2:3.YY2.4.2 (Response Message) and 2:3.YY2.5 (Security Considerations).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY2-retrieve-trust-list-responder.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY2 Retrieve Trust List – Trust Anchor Expected Actions"

* testCase[=].testRun[+].narrative = """
**ITI-YY2 Security Considerations** – Verifies TLS enforcement, response integrity
verification, access control restrictions, and revocation propagation requirements.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY2-retrieve-trust-list-security.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY2 Retrieve Trust List – Security Considerations"


// ─────────────────────────────────────────────────────────────────────────────
// VHL Sharer
//   ITI-YY1  Submit PKI Material with DID    – Initiator role
//   ITI-YY2  Retrieve Trust List with DID    – Initiator role
//   ITI-YY3  Generate VHL                    – Responder role
//   ITI-YY5  Retrieve Manifest               – Responder role
// ─────────────────────────────────────────────────────────────────────────────

Instance:   TestPlan-VHLSharer
InstanceOf: TestPlan
Title:      "Test Plan – VHL Sharer"
Usage:      #definition
* url         = "https://profiles.ihe.net/ITI/VHL/TestPlan/TestPlan-VHLSharer"
* name        = "TestPlan_VHLSharer"
* status      = #active
* description = """
Unit test plan for the **VHL Sharer** actor of the IHE ITI Verifiable Health Links (VHL) profile.

Scope: validates all behaviour expected of a VHL Sharer across its four transactions:
submitting its own PKI material (ITI-YY1 initiator), retrieving the trust list to obtain peer
keys (ITI-YY2 initiator), generating VHLs on demand (ITI-YY3 responder), and serving document
manifests to authorised VHL Receivers (ITI-YY5 responder). Each test suite corresponds to one
transaction and exercises three atomic feature files.
"""
* scope[+] = Reference(VHLSharer)


// ── Suite 1 : ITI-YY1  Submit PKI Material with DID (Initiator) ──────────────

* testCase[+].sequence = 1
* testCase[=].testRun[+].narrative = """
**ITI-YY1 Message Semantics** – Shared message format file (same as Trust Anchor suite 1).
Verifies the DID Document structure the VHL Sharer must construct.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY1-submit-pki-material-message.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY1 Submit PKI Material – Message Semantics"

* testCase[=].testRun[+].narrative = """
**ITI-YY1 VHL Sharer Initiator Expected Actions** – Verifies key pair generation, submission
pathways (direct HTTP POST, indirect publication, offline), provenance metadata, response
handling (201/400/401/403/422), and secure private key retention.
Source: sections 2:3.YY1.4.1.2 (Message Semantics) and 2:3.YY1.4.1.3 (Initiator Expected Actions).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY1-submit-pki-material-initiator.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY1 Submit PKI Material – VHL Sharer Initiator Expected Actions"

* testCase[=].testRun[+].narrative = """
**ITI-YY1 Security Considerations** – Shared security file (same as Trust Anchor suite 1).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY1-submit-pki-material-security.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY1 Submit PKI Material – Security Considerations"


// ── Suite 2 : ITI-YY2  Retrieve Trust List with DID (Initiator) ──────────────

* testCase[+].sequence = 2
* testCase[=].testRun[+].narrative = """
**ITI-YY2 Message Semantics** – Shared message format file.
Verifies the request/response format for the trust list retrieval.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY2-retrieve-trust-list-message.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY2 Retrieve Trust List – Message Semantics"

* testCase[=].testRun[+].narrative = """
**ITI-YY2 VHL Sharer Initiator Expected Actions** – Verifies that the VHL Sharer correctly
constructs retrieval requests, sends them over TLS, validates and caches returned DID Documents,
maps verification methods, tracks expiry, handles revocation notifications, and processes
error responses (401/403/404).
Source: sections 2:3.YY2.4.1 (Request Message) and 2:3.YY2.4.2.3 (Initiator Expected Actions).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY2-retrieve-trust-list-initiator.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY2 Retrieve Trust List – VHL Sharer Initiator Expected Actions"

* testCase[=].testRun[+].narrative = """
**ITI-YY2 Security Considerations** – Shared security file.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY2-retrieve-trust-list-security.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY2 Retrieve Trust List – Security Considerations"


// ── Suite 3 : ITI-YY3  Generate VHL (Responder) ───────────────────────────────

* testCase[+].sequence = 3
* testCase[=].testRun[+].narrative = """
**ITI-YY3 Message Semantics** – Verifies the $generate-vhl request parameter definitions
(sourceIdentifier, exp, flag, label, passcode) and the response format
(HTTP 200, FHIR Parameters, Binary qrcode, HC1: prefix).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY3-generate-vhl-message.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY3 Generate VHL – Message Semantics"

* testCase[=].testRun[+].narrative = """
**ITI-YY3 VHL Sharer Responder Expected Actions** – Verifies the complete VHL generation
pipeline: passcode hashing (bcrypt/Argon2/PBKDF2), folder ID (256-bit entropy) and 32-byte
encryption key generation, SHL payload construction (url/key/flag/v), mandatory manifest URL
parameters, HCERT/CWT encoding (COSE signing → ZLIB → Base45 → HC1: prefix), QR code
generation (ISO/IEC 18004:2015 Alphanumeric mode Q), and error OperationOutcome responses.
Source: sections 2:3.YY3.4.1.3 (Responder Expected Actions) and 2:3.YY3.4.2 (Response Message).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY3-generate-vhl-responder.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY3 Generate VHL – VHL Sharer Responder Expected Actions"

* testCase[=].testRun[+].narrative = """
**ITI-YY3 Security Considerations** – Verifies HTTPS enforcement, passcode security
(no plaintext storage, no embedding in QR code), key entropy requirements, and PHI exclusion.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY3-generate-vhl-security.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY3 Generate VHL – Security Considerations"


// ── Suite 4 : ITI-YY5  Retrieve Manifest (Responder) ─────────────────────────

* testCase[+].sequence = 4
* testCase[=].testRun[+].narrative = """
**ITI-YY5 Message Semantics** – Verifies request format (HTTP POST /List/_search,
Content-Type, Accept, FHIR search parameters, SHL parameters, HTTP Message Signature
headers) and response format (searchset Bundle structure, search.mode, error codes).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY5-retrieve-manifest-message.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY5 Retrieve Manifest – Message Semantics"

* testCase[=].testRun[+].narrative = """
**ITI-YY5 VHL Sharer Responder Expected Actions** – Verifies HTTP Message Signature
verification (keyid lookup, RFC 9421 signature base, Content-Digest), OAuth FAST Option
token validation, VHL authorisation (folder ID, expiry, revocation, passcode hash comparison),
FHIR search execution (_include support), Bundle construction, error codes (400/401/403/404/422/429/500),
rate limiting, and audit logging.
Source: sections 2:3.YY5.4.1.5 (Responder Expected Actions), 2:3.YY5.4.2 (Response Message),
and 2:3.YY5.5 (Security Considerations).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY5-retrieve-manifest-responder.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY5 Retrieve Manifest – VHL Sharer Responder Expected Actions"

* testCase[=].testRun[+].narrative = """
**ITI-YY5 Security Considerations** – Verifies TLS requirements, replay prevention (signature
timestamp freshness, OAuth jti uniqueness), passcode timing-attack protection, trust list
enforcement, and audit logging (no plaintext passcode in logs).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY5-retrieve-manifest-security.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY5 Retrieve Manifest – Security Considerations"


// ─────────────────────────────────────────────────────────────────────────────
// VHL Receiver
//   ITI-YY1  Submit PKI Material with DID    – Initiator role
//   ITI-YY2  Retrieve Trust List with DID    – Initiator role
//   ITI-YY4  Provide VHL                     – Responder role
//   ITI-YY5  Retrieve Manifest               – Initiator role
// ─────────────────────────────────────────────────────────────────────────────

Instance:   TestPlan-VHLReceiver
InstanceOf: TestPlan
Title:      "Test Plan – VHL Receiver"
Usage:      #definition
* url         = "https://profiles.ihe.net/ITI/VHL/TestPlan/TestPlan-VHLReceiver"
* name        = "TestPlan_VHLReceiver"
* status      = #active
* description = """
Unit test plan for the **VHL Receiver** actor of the IHE ITI Verifiable Health Links (VHL) profile.

Scope: validates all behaviour expected of a VHL Receiver across its four transactions:
submitting its own PKI material (ITI-YY1 initiator), retrieving the trust list (ITI-YY2
initiator), decoding and validating a VHL QR code (ITI-YY4 responder), and requesting the
document manifest (ITI-YY5 initiator). Each test suite exercises three atomic feature files.
"""
* scope[+] = Reference(VHLReceiver)


// ── Suite 1 : ITI-YY1  Submit PKI Material with DID (Initiator) ──────────────

* testCase[+].sequence = 1
* testCase[=].testRun[+].narrative = """
**ITI-YY1 Message Semantics** – Shared message format file.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY1-submit-pki-material-message.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY1 Submit PKI Material – Message Semantics"

* testCase[=].testRun[+].narrative = """
**ITI-YY1 VHL Receiver Initiator Expected Actions** – The VHL Receiver shares the same
initiator requirements as the VHL Sharer: key pair generation, submission pathway, provenance
metadata, response handling, and private key retention.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY1-submit-pki-material-initiator.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY1 Submit PKI Material – VHL Receiver Initiator Expected Actions"

* testCase[=].testRun[+].narrative = """
**ITI-YY1 Security Considerations** – Shared security file.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY1-submit-pki-material-security.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY1 Submit PKI Material – Security Considerations"


// ── Suite 2 : ITI-YY2  Retrieve Trust List with DID (Initiator) ──────────────

* testCase[+].sequence = 2
* testCase[=].testRun[+].narrative = """
**ITI-YY2 Message Semantics** – Shared message format file.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY2-retrieve-trust-list-message.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY2 Retrieve Trust List – Message Semantics"

* testCase[=].testRun[+].narrative = """
**ITI-YY2 VHL Receiver Initiator Expected Actions** – Verifies that the VHL Receiver correctly
constructs retrieval requests, validates and caches returned DID Documents, maps public keys to
intended uses, tracks expiry, handles revocation notifications, and processes error responses.
Source: sections 2:3.YY2.4.1, 2:3.YY2.4.2.3, and 2:3.YY2.5.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY2-retrieve-trust-list-initiator.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY2 Retrieve Trust List – VHL Receiver Initiator Expected Actions"

* testCase[=].testRun[+].narrative = """
**ITI-YY2 Security Considerations** – Shared security file.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY2-retrieve-trust-list-security.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY2 Retrieve Trust List – Security Considerations"


// ── Suite 3 : ITI-YY4  Provide VHL (Responder / Decoder) ─────────────────────

* testCase[+].sequence = 3
* testCase[=].testRun[+].narrative = """
**ITI-YY4 Message Semantics** – Verifies the VHL QR code message format: ISO/IEC 18004:2015
Alphanumeric mode, HC1: prefix, Base45 encoding, ZLIB/DEFLATE compression, CWT structure
(protected header: alg/kid, claims: exp/iat/hcert), and SHL payload fields (url/key/flag/exp).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY4-provide-vhl-message.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY4 Provide VHL – Message Semantics"

* testCase[=].testRun[+].narrative = """
**ITI-YY4 VHL Receiver Responder Expected Actions** – Verifies the complete nine-step decode
pipeline: QR scanning (ISO/IEC 18004:2015), HC1: verification, Base45 decoding, ZLIB
decompression, CWT parsing (RFC 8392), COSE signature verification (RFC 8152) using the
trust list, CWT claims validation (exp/iat), hcert extraction (claim key -260 / 5), and SHL
payload validation (url/key/flag/exp). Also covers post-decoding actions, all decode failure
rejections, and optional acknowledgment.
Source: sections 2:3.YY4.4.1.4 (Receiver Expected Actions) and 2:3.YY4.5 (Security).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY4-provide-vhl-responder.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY4 Provide VHL – VHL Receiver Responder Expected Actions"

* testCase[=].testRun[+].narrative = """
**ITI-YY4 Security Considerations** – Verifies signature verification requirements, trust list
enforcement, expiry enforcement, PHI exclusion from the QR payload, and acknowledgment safety.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY4-provide-vhl-security.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY4 Provide VHL – Security Considerations"


// ── Suite 4 : ITI-YY5  Retrieve Manifest (Initiator) ─────────────────────────

* testCase[+].sequence = 4
* testCase[=].testRun[+].narrative = """
**ITI-YY5 Message Semantics** – Shared message format file.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY5-retrieve-manifest-message.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY5 Retrieve Manifest – Message Semantics"

* testCase[=].testRun[+].narrative = """
**ITI-YY5 VHL Receiver Initiator Expected Actions** – Verifies request construction (HTTP POST
/List/_search), HTTP Message Signature creation (Content-Digest, Signature-Input with keyid/alg/created,
Signature), OAuth with FAST Option (client_credentials, private_key_jwt, required scopes, Bearer
header, token caching), TLS requirements, and Bundle response processing (match/include search.mode,
individual DocumentReference retrieval fallback).
Source: sections 2:3.YY5.4.1 (Request Message) and 2:3.YY5.5.2 (HTTP Message Signatures).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY5-retrieve-manifest-initiator.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY5 Retrieve Manifest – VHL Receiver Initiator Expected Actions"

* testCase[=].testRun[+].narrative = """
**ITI-YY5 Security Considerations** – Shared security file.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/ITI-YY5-retrieve-manifest-security.feature"
* testCase[=].testRun[=].script.sourceReference.display = "ITI-YY5 Retrieve Manifest – Security Considerations"


// ─────────────────────────────────────────────────────────────────────────────
// Integration: Trust Establishment
//   Actors: VHL Sharer + Trust Anchor + VHL Receiver
//   Transactions: ITI-YY1 + ITI-YY2
// ─────────────────────────────────────────────────────────────────────────────

Instance:   TestPlan-TrustEstablishment
InstanceOf: TestPlan
Title:      "Integration Test Plan – Trust Establishment"
Usage:      #definition
* url         = "https://profiles.ihe.net/ITI/VHL/TestPlan/TestPlan-TrustEstablishment"
* name        = "TestPlan_TrustEstablishment"
* status      = #active
* description = """
Integration test plan for the **Trust Establishment** workflow of the IHE ITI Verifiable Health
Links (VHL) profile.

Scope: validates multi-actor, cross-transaction scenarios that span ITI-YY1 (Submit PKI Material)
and ITI-YY2 (Retrieve Trust List) and cannot be covered by unit tests. Tests verify that a DID
Document submitted in YY1 is subsequently retrievable via YY2 in the same session, that both
the VHL Sharer and VHL Receiver can retrieve peer keys, that a full round-trip signature
verification succeeds, and that revocation propagates correctly across actors.

Actors exercised: VHL Sharer, Trust Anchor, VHL Receiver.
"""
* scope[+] = Reference(VHLSharer)
* scope[+] = Reference(TrustAnchor)
* scope[+] = Reference(VHLReceiver)


// ── Suite 1 : Cross-actor Trust Establishment (YY1 + YY2) ────────────────────

* testCase[+].sequence = 1
* testCase[=].testRun[+].narrative = """
Execute all scenarios in the Gherkin integration feature file
`integration-trust-establishment.feature`.

Scenario groups:
- **Group A – PKI Submission (YY1):** VHL Sharer and VHL Receiver each submit a DID Document;
  Trust Anchor validates and catalogs both.
- **Group B – Trust Retrieval by VHL Receiver (YY2):** VHL Receiver retrieves the newly
  registered VHL Sharer DID Document and all active DID Documents.
- **Group C – Trust Retrieval by VHL Sharer (YY2):** VHL Sharer retrieves its own DID Document
  and the VHL Receiver's DID Document to prepare for manifest authentication.
- **Group D – Round-trip Verification:** Verifies that the VHL Receiver can successfully verify
  a VHL Sharer signature using the public key retrieved in Group B/C; verifies rejection of
  signatures from unknown DIDs.
- **Group E – Revocation Propagation:** Verifies that a revoked DID Document is no longer
  returned by the Trust Anchor, and that the VHL Receiver's cache is invalidated.

These scenarios require shared state across ITI-YY1 and ITI-YY2 (e.g., a DID submitted in
YY1 must be retrievable in YY2 in the same test execution).
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/integration-trust-establishment.feature"
* testCase[=].testRun[=].script.sourceReference.display = "Integration – Trust Establishment"


// ─────────────────────────────────────────────────────────────────────────────
// Integration: QR Code Flow
//   Actors: VHL Holder + VHL Sharer + VHL Receiver (+ Trust Anchor via cached trust list)
//   Transactions: ITI-YY3 + ITI-YY4 + ITI-YY5
// ─────────────────────────────────────────────────────────────────────────────

Instance:   TestPlan-QRCodeFlow
InstanceOf: TestPlan
Title:      "Integration Test Plan – QR Code Generation and Validation Flow"
Usage:      #definition
* url         = "https://profiles.ihe.net/ITI/VHL/TestPlan/TestPlan-QRCodeFlow"
* name        = "TestPlan_QRCodeFlow"
* status      = #active
* description = """
Integration test plan for the **QR Code Generation and Validation Flow** of the IHE ITI
Verifiable Health Links (VHL) profile.

Scope: validates multi-actor, cross-transaction scenarios that span ITI-YY3 (Generate VHL),
ITI-YY4 (Provide VHL), and ITI-YY5 (Retrieve Manifest). Tests verify that the QR code
generated in YY3 can be decoded in YY4, that the decoded SHL payload's manifest URL is used
correctly in YY5, and that the full end-to-end pipeline including passcode handling, signature
verification, and VHL authorization succeeds.

Actors exercised: VHL Holder, VHL Sharer, VHL Receiver.
"""
* scope[+] = Reference(VHLHolder)
* scope[+] = Reference(VHLSharer)
* scope[+] = Reference(VHLReceiver)


// ── Suite 1 : QR Code Pipeline (YY3 + YY4 + YY5) ────────────────────────────

* testCase[+].sequence = 1
* testCase[=].testRun[+].narrative = """
Execute all scenarios in the Gherkin integration feature file
`integration-qrcode-flow.feature`.

Scenario groups:
- **Group A – VHL Generation (YY3):** VHL Holder requests VHL; VHL Sharer generates a valid
  HCERT-signed QR code; SHL payload URL is verifiable; passcode is retained by VHL Holder.
- **Group B – QR Presentation and Decoding (YY4):** VHL Receiver decodes the QR code
  generated in Group A using the trust list; COSE signature verified; decoded manifest URL
  matches the YY5 endpoint; passcode is obtained from VHL Holder when P flag is present.
- **Group C – Manifest Retrieval (YY5):** VHL Receiver uses the decoded folder ID and URL
  to send an authenticated HTTP POST; VHL Sharer verifies the receiver's signature using the
  trust list; correct passcode results in HTTP 200 Bundle; incorrect passcode results in 422.
- **Group D – Full End-to-End:** Complete flow from YY3 generation through YY4 decode to YY5
  manifest retrieval succeeds; passcode-protected variant succeeds end-to-end.
- **Group E – Expired and Revoked VHL Rejection:** VHL Receiver rejects an expired QR code at
  YY4 without proceeding to YY5; VHL Sharer returns 403 for a revoked VHL at YY5.

These scenarios require pipeline state: the QR code from YY3 feeds YY4, and the decoded
payload from YY4 feeds YY5.
"""
* testCase[=].testRun[=].script.language.coding.system = "urn:ietf:bcp:13"
* testCase[=].testRun[=].script.language.coding.code   = #text/x-gherkin
* testCase[=].testRun[=].script.language.text          = "Gherkin"
* testCase[=].testRun[=].script.sourceReference.reference =
    "https://build.fhir.org/ig/IHE/ITI.VHL/integration-qrcode-flow.feature"
* testCase[=].testRun[=].script.sourceReference.display = "Integration – QR Code Generation and Validation Flow"
