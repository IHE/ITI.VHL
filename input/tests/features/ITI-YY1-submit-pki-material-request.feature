Feature: ITI-YY1 Submit PKI Material Request
  As a VHL Sharer or VHL Receiver (Initiator)
  I want to submit my public key material to the Trust Anchor using a DID Document
  So that my cryptographic identity can be registered and used for trust establishment

  Background:
    Given the initiator is a VHL Sharer or VHL Receiver
    And the Trust Anchor endpoint is "https://trust-anchor.example.org/did"

  # ─── DID Document Structure ───────────────────────────────────────────────────

  Scenario: DID Document contains the mandatory @context element
    Given the initiator has generated a cryptographic key pair
    When the initiator constructs a DID Document
    Then the DID Document SHALL contain the "@context" element
    And the "@context" element SHALL include "https://www.w3.org/ns/did/v1"

  Scenario: DID Document contains a unique DID identifier
    Given the initiator has generated a cryptographic key pair
    When the initiator constructs a DID Document
    Then the DID Document SHALL contain exactly one "id" element
    And the "id" value SHALL be a valid DID (e.g., matching "did:<method>:<method-specific-id>")

  Scenario: DID Document contains at least one verification method
    Given the initiator has generated a cryptographic key pair
    When the initiator constructs a DID Document
    Then the DID Document SHALL contain a "verificationMethod" array
    And the "verificationMethod" array SHALL contain at least one entry

  Scenario: Each verification method contains required elements
    Given the initiator has constructed a DID Document with a verification method
    When the DID Document is inspected
    Then each verification method SHALL contain an "id" element
    And each verification method SHALL contain a "type" element
    And each verification method SHALL contain a "controller" element
    And each verification method SHALL contain either "publicKeyJwk" or "publicKeyMultibase"

  Scenario: Verification method id references the parent DID
    Given the initiator has constructed a DID Document with id "did:example:vhl-sharer-123"
    When the verification method "id" is inspected
    Then the verification method "id" SHALL be of the form "did:example:vhl-sharer-123#<fragment>"

  Scenario: Verification method controller matches the DID Document id
    Given the initiator has constructed a DID Document with id "did:example:vhl-sharer-123"
    When the verification method is inspected
    Then the "controller" element SHALL equal "did:example:vhl-sharer-123"

  Scenario: Public key is expressed in JWK format when publicKeyJwk is used
    Given the initiator has chosen to express the public key in JWK format
    When the initiator constructs the verification method
    Then the "publicKeyJwk" element SHALL conform to RFC 7517
    And the "publicKeyJwk" SHALL NOT include any private key parameters (e.g., "d")

  Scenario: Public key is expressed in multibase format when publicKeyMultibase is used
    Given the initiator has chosen to express the public key in multibase format
    When the initiator constructs the verification method
    Then the "publicKeyMultibase" value SHALL be a valid multibase-encoded public key
    And the "publicKeyJwk" element SHALL NOT be present

  Scenario: Private key material is never included in the DID Document
    Given the initiator has generated an EC key pair
    When the initiator constructs the DID Document
    Then the DID Document SHALL NOT contain any private key material
    And no "publicKeyJwk" object SHALL include the "d" parameter

  # ─── Cryptographic Acceptability ──────────────────────────────────────────────

  Scenario Outline: Cryptographic suite type is a recognised value
    Given the initiator is constructing a verification method
    When the "type" element is set to "<suite_type>"
    Then the verification method SHALL be accepted as using a recognised cryptographic suite

    Examples:
      | suite_type                            |
      | JsonWebKey2020                        |
      | EcdsaSecp256k1VerificationKey2019     |

  Scenario: Key material meets minimum cryptographic strength for EC keys
    Given the initiator is using an EC key
    When the DID Document is constructed
    Then the key curve SHALL be "P-256" or stronger (e.g., P-384, P-521)

  # ─── Optional DID Document Elements ──────────────────────────────────────────

  Scenario: DID Document may include authentication references
    Given the initiator has a verification method "did:example:vhl-sharer-123#signing-key-1"
    When the initiator constructs the DID Document with authentication references
    Then the "authentication" array MAY reference the verification method id

  Scenario: DID Document may include assertionMethod references
    Given the initiator has a verification method "did:example:vhl-sharer-123#signing-key-1"
    When the initiator constructs the DID Document with assertion method references
    Then the "assertionMethod" array MAY reference the verification method id

  Scenario: Service endpoint is well-formed when present
    Given the initiator includes a service endpoint in the DID Document
    When the "service" array is inspected
    Then each service entry SHALL contain an "id" element
    And each service entry SHALL contain a "type" element
    And each service entry SHALL contain a "serviceEndpoint" element with a valid URI

  # ─── Submission Pathway: Direct HTTP POST ────────────────────────────────────

  Scenario: Direct HTTP POST submission uses the correct HTTP method
    Given the initiator has constructed a valid DID Document
    And the submission pathway is "Direct HTTP POST"
    When the initiator submits the DID Document
    Then the initiator SHALL issue an HTTP POST to the Trust Anchor endpoint

  Scenario: Direct HTTP POST submission uses the correct Content-Type
    Given the initiator has constructed a valid DID Document
    And the submission pathway is "Direct HTTP POST"
    When the initiator submits the DID Document
    Then the HTTP request SHALL include the header "Content-Type: application/did+json"

  Scenario: Direct HTTP POST submission uses mutually authenticated TLS
    Given the initiator has constructed a valid DID Document
    And the submission pathway is "Direct HTTP POST"
    When the initiator establishes a connection to the Trust Anchor
    Then the connection SHALL use TLS 1.3 or later
    And the TLS session SHALL be mutually authenticated

  # ─── Submission Pathway: Indirect Publication ────────────────────────────────

  Scenario: Indirect publication places DID Document at a well-known URL
    Given the initiator has chosen the "Indirect Publication" submission pathway
    When the initiator publishes the DID Document
    Then the DID Document SHALL be accessible at a well-known URL under the initiator's domain
    And the initiator SHALL notify the Trust Anchor of the publication URL

  # ─── Provenance Metadata ─────────────────────────────────────────────────────

  Scenario: Submission includes the asserted identity of the submitting entity
    Given the initiator is preparing a submission
    When provenance metadata is added
    Then the submission SHOULD include the asserted identity of the submitting entity

  Scenario: Submission includes intended usage scope of the key(s)
    Given the initiator is preparing a submission with a signing key
    When the DID Document references are set
    Then the key usage SHALL be declared via at least one of "authentication", "assertionMethod", or "keyAgreement"

  Scenario: Submission includes a proof of authenticity when applicable
    Given the initiator supports digital signing of the submission
    When the DID Document is finalised
    Then the submission SHOULD include a digital signature or proof establishing the authenticity of the submission

  # ─── Key Lifecycle ────────────────────────────────────────────────────────────

  Scenario: Initiator maintains private keys securely
    Given the initiator has submitted a DID Document
    When the submission is complete
    Then the initiator SHALL retain the corresponding private keys in secure storage
    And the private keys SHALL NOT be accessible to unauthorised parties

  Scenario: DID Document includes an expiry date or revocation reference when applicable
    Given the initiator knows the intended lifetime of the key
    When provenance metadata is set
    Then the submission SHOULD include an expiry date or reference to a revocation mechanism