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
    And each verification method SHALL contain a "publicKeyJwk" element

  Scenario: Verification method id references the parent DID
    Given the initiator has constructed a DID Document with id "did:example:vhl-sharer-123"
    When the verification method "id" is inspected
    Then the verification method "id" SHALL be of the form "did:example:vhl-sharer-123#<fragment>"

  Scenario: Verification method controller matches the DID Document id
    Given the initiator has constructed a DID Document with id "did:example:vhl-sharer-123"
    When the verification method is inspected
    Then the "controller" element SHALL equal "did:example:vhl-sharer-123"

  Scenario: Public key is expressed in JWK format conforming to RFC 7517
    Given the initiator has chosen to express the public key in JWK format
    When the initiator constructs the verification method
    Then the "publicKeyJwk" element SHALL conform to RFC 7517
    And the "publicKeyJwk" SHALL NOT include any private key parameters (e.g., "d")

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

  # ─── Submission Pathway: Offline Submission ──────────────────────────────────

  Scenario: Offline submission delivers DID Document on secure physical media
    Given the initiator has chosen the "Offline Submission" submission pathway
    When the initiator prepares the submission
    Then the DID Document SHALL be delivered on secure physical media
    And the submission SHALL occur during a verified in-person encounter with formal identity attestation

  # ─── Provenance Metadata ─────────────────────────────────────────────────────

  Scenario: Submission includes the asserted identity of the submitting entity
    Given the initiator is preparing a submission
    When provenance metadata is added
    Then the submission SHOULD include the asserted identity of the submitting entity

  Scenario: Submission declares intended usage scope of the key(s)
    Given the initiator is preparing a submission with a signing key
    When the DID Document references are set
    Then the key usage SHALL be declared via at least one of "authentication", "assertionMethod", or "keyAgreement"

  Scenario: Submission includes a proof of authenticity when applicable
    Given the initiator supports digital signing of the submission
    When the DID Document is finalised
    Then the submission SHOULD include a digital signature or proof establishing the authenticity of the submission

  Scenario: Submission includes expiry date or revocation reference when applicable
    Given the initiator knows the intended lifetime of the key
    When provenance metadata is set
    Then the submission SHOULD include an expiry date or reference to a revocation mechanism

  # ─── Key Lifecycle ────────────────────────────────────────────────────────────

  Scenario: Initiator maintains private keys securely after submission
    Given the initiator has submitted a DID Document
    When the submission is complete
    Then the initiator SHALL retain the corresponding private keys in secure storage
    And the private keys SHALL NOT be accessible to unauthorised parties

  # ─── Trust Anchor: Response Messages ─────────────────────────────────────────

  Scenario: Trust Anchor returns HTTP 201 on successful DID Document submission
    Given a valid DID Document has been submitted via HTTP POST
    When the Trust Anchor accepts and catalogs the submission
    Then the Trust Anchor SHALL return HTTP status 201 Created

  Scenario: Trust Anchor returns HTTP 400 for a malformed DID Document
    Given a DID Document that does not conform to W3C DID Core specification has been submitted
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP status 400 Bad Request

  Scenario: Trust Anchor returns HTTP 401 when authentication fails
    Given the initiator has not provided valid authentication credentials
    When the initiator submits a DID Document
    Then the Trust Anchor SHALL return HTTP status 401 Unauthorized

  Scenario: Trust Anchor returns HTTP 403 when the entity is not authorised to submit
    Given the initiator has authenticated but is not in the list of authorised submitters
    When the initiator submits a DID Document
    Then the Trust Anchor SHALL return HTTP status 403 Forbidden

  Scenario: Trust Anchor returns HTTP 422 for a structurally valid but semantically invalid submission
    Given a DID Document that is well-formed JSON but fails validation rules has been submitted
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP status 422 Unprocessable Entity

  # ─── Trust Anchor: Expected Actions ──────────────────────────────────────────

  Scenario: Trust Anchor validates DID Document structure against W3C DID Core
    Given the Trust Anchor has received a DID Document submission
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL verify the DID Document conforms to the W3C DID Core specification

  Scenario: Trust Anchor verifies public key is properly formatted as JWK
    Given the Trust Anchor has received a DID Document with a publicKeyJwk element
    When the Trust Anchor validates the cryptographic material
    Then the Trust Anchor SHALL verify the public key is properly formatted per RFC 7517

  Scenario: Trust Anchor rejects key types or curves not acceptable per trust framework policy
    Given the Trust Anchor has received a DID Document with a prohibited key type or curve
    When the Trust Anchor validates the cryptographic material
    Then the Trust Anchor SHALL reject the submission

  Scenario: Trust Anchor verifies key sizes meet minimum security requirements
    Given the Trust Anchor has received a DID Document with an EC key below P-256 strength
    When the Trust Anchor validates the cryptographic material
    Then the Trust Anchor SHALL reject the submission as not meeting minimum key size requirements

  Scenario: Trust Anchor authenticates the submitting entity via secure connection
    Given the Trust Anchor has received a DID Document submission over a secure connection
    When the Trust Anchor verifies the identity of the submitting entity
    Then the Trust Anchor SHALL authenticate the entity through the secure connection

  Scenario: Trust Anchor verifies the proof or signature on the DID Document
    Given the Trust Anchor has received a signed DID Document
    When the Trust Anchor verifies the identity of the submitting entity
    Then the Trust Anchor SHALL verify the proof or signature on the DID Document

  Scenario: Trust Anchor validates submitter against pre-registered organisational identifiers
    Given the Trust Anchor maintains a registry of authorised participants
    When the Trust Anchor verifies the identity of the submitting entity
    Then the Trust Anchor SHALL validate the submitter against pre-registered organisational identifiers

  Scenario: Trust Anchor catalogs the validated DID Document in its registry
    Given the Trust Anchor has successfully validated a DID Document submission
    When all validation checks pass
    Then the Trust Anchor SHALL store the DID Document in its registry

  Scenario: Trust Anchor makes the cataloged DID Document available for retrieval
    Given the Trust Anchor has stored a validated DID Document
    When the DID Document has been cataloged
    Then the Trust Anchor SHALL make the DID Document accessible via its retrieval endpoint

  # ─── Trust Anchor: Rejection Criteria ────────────────────────────────────────

  Scenario: Trust Anchor rejects submission that does not conform to W3C DID Core
    Given a submitted DID Document is missing required W3C DID Core elements
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL reject the submission

  Scenario: Trust Anchor rejects submission with invalid or malformed cryptographic material
    Given a submitted DID Document contains a malformed publicKeyJwk value
    When the Trust Anchor validates the cryptographic material
    Then the Trust Anchor SHALL reject the submission

  Scenario: Trust Anchor rejects submission that cannot be authenticated to a known participant
    Given the submitting entity is not a known trust network participant
    When the Trust Anchor attempts to verify the identity
    Then the Trust Anchor SHALL reject the submission

  Scenario: Trust Anchor rejects submission using prohibited cryptographic algorithms
    Given a submitted DID Document uses an algorithm not on the Trust Anchor's approved list
    When the Trust Anchor validates the cryptographic material
    Then the Trust Anchor SHALL reject the submission

  Scenario: Trust Anchor rejects submission lacking required provenance information
    Given a submitted DID Document contains no provenance metadata
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL reject the submission

  # ─── Trust Anchor: Revocation and Updates ────────────────────────────────────

  Scenario: Trust Anchor supports updating a previously registered DID Document
    Given a DID Document has been previously registered by an initiator
    When the initiator submits an updated DID Document for the same DID
    Then the Trust Anchor SHALL support the update and replace the stored DID Document

  Scenario: Trust Anchor supports revoking a registered DID Document
    Given a DID Document is registered in the Trust Anchor registry
    When the DID Document is revoked
    Then the Trust Anchor SHALL mark the DID Document as revoked

  Scenario: Trust Anchor does not distribute revoked or expired DID Documents
    Given a DID Document has been revoked or has expired
    When a participant requests the DID Document via the retrieval endpoint
    Then the Trust Anchor SHALL NOT return the revoked or expired DID Document
