Feature: ITI-YY1 Submit PKI Material – Trust Anchor Expected Actions
  As the Trust Anchor (Responder) receiving DID Document submissions,
  these scenarios verify that the Trust Anchor correctly validates structure and
  cryptographic material, authenticates submitters, catalogs approved submissions,
  and returns the correct HTTP response codes.

  Background:
    Given the Trust Anchor is running at "https://trust-anchor.example.org/did"
    And the Trust Anchor has a registry of pre-authorised trust network participants

  # ─── Structural Validation ──────────────────────────────────────────────────

  @responder-actions @SHALL
  Scenario: Trust Anchor accepts a fully conformant DID Document with HTTP 201
    Given a conforming DID Document is submitted via HTTP POST
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 201 Created

  @responder-actions @SHALL
  Scenario: Trust Anchor rejects a DID Document missing the @context element
    Given a submitted DID Document has no "@context" element
    When the Trust Anchor validates the structure
    Then the Trust Anchor SHALL return HTTP 400 Bad Request
    And the response SHALL indicate the "@context" element is missing

  @responder-actions @SHALL
  Scenario: Trust Anchor rejects a DID Document whose @context does not include the W3C DID context
    Given a submitted DID Document "@context" does not include "https://www.w3.org/ns/did/v1"
    When the Trust Anchor validates the structure
    Then the Trust Anchor SHALL return HTTP 400 Bad Request

  @responder-actions @SHALL
  Scenario: Trust Anchor rejects a DID Document missing the id element
    Given a submitted DID Document has no "id" element
    When the Trust Anchor validates the structure
    Then the Trust Anchor SHALL return HTTP 400 Bad Request
    And the response SHALL indicate the "id" element is missing

  @responder-actions @SHALL
  Scenario: Trust Anchor rejects a DID Document with a malformed DID identifier
    Given a submitted DID Document has "id" value "not-a-valid-did"
    When the Trust Anchor validates the structure
    Then the Trust Anchor SHALL return HTTP 400 Bad Request

  @responder-actions @SHALL
  Scenario: Trust Anchor rejects a DID Document with an empty verificationMethod array
    Given a submitted DID Document has an empty "verificationMethod" array
    When the Trust Anchor validates the structure
    Then the Trust Anchor SHALL return HTTP 400 Bad Request
    And the response SHALL indicate at least one verification method is required

  @responder-actions @SHALL
  Scenario: Trust Anchor rejects a verification method missing the id element
    Given a submitted DID Document has a verification method with no "id"
    When the Trust Anchor validates the structure
    Then the Trust Anchor SHALL return HTTP 422 Unprocessable Entity

  @responder-actions @SHALL
  Scenario: Trust Anchor rejects a verification method missing the type element
    Given a submitted DID Document has a verification method with no "type"
    When the Trust Anchor validates the structure
    Then the Trust Anchor SHALL return HTTP 422 Unprocessable Entity

  @responder-actions @SHALL
  Scenario: Trust Anchor rejects a verification method missing the controller element
    Given a submitted DID Document has a verification method with no "controller"
    When the Trust Anchor validates the structure
    Then the Trust Anchor SHALL return HTTP 422 Unprocessable Entity

  # ─── Cryptographic Material Validation ──────────────────────────────────────

  @responder-actions @SHALL
  Scenario: Trust Anchor verifies public key is properly formatted as JWK per RFC 7517
    Given a submitted DID Document includes a publicKeyJwk element
    When the Trust Anchor validates the cryptographic material
    Then the Trust Anchor SHALL verify the public key conforms to RFC 7517

  @responder-actions @SHALL
  Scenario: Trust Anchor rejects a verification method containing a private key parameter
    Given a submitted DID Document has a publicKeyJwk with a "d" parameter
    When the Trust Anchor validates the cryptographic material
    Then the Trust Anchor SHALL return HTTP 422 Unprocessable Entity

  @responder-actions @SHALL
  Scenario: Trust Anchor rejects a malformed publicKeyJwk value
    Given a submitted DID Document contains a malformed publicKeyJwk
    When the Trust Anchor validates the cryptographic material
    Then the Trust Anchor SHALL reject the submission

  @responder-actions @SHALL
  Scenario: Trust Anchor rejects key types or curves not acceptable per trust framework policy
    Given a submitted DID Document uses a prohibited key type or curve
    When the Trust Anchor validates the cryptographic material
    Then the Trust Anchor SHALL reject the submission

  @responder-actions @SHALL
  Scenario: Trust Anchor rejects an EC key below P-256 strength
    Given a submitted DID Document contains an EC key weaker than P-256
    When the Trust Anchor validates the key size
    Then the Trust Anchor SHALL reject the submission as not meeting minimum key size requirements

  @responder-actions @SHALL
  Scenario: Trust Anchor rejects a submission using a prohibited cryptographic algorithm
    Given a submitted DID Document uses an algorithm not on the Trust Anchor's approved list
    When the Trust Anchor validates the cryptographic material
    Then the Trust Anchor SHALL reject the submission

  # ─── Identity and Authentication ────────────────────────────────────────────

  @responder-actions @SHALL
  Scenario: Trust Anchor authenticates the submitting entity via the secure connection
    Given a DID Document submission is received over a secure connection
    When the Trust Anchor verifies the identity of the submitter
    Then the Trust Anchor SHALL authenticate the entity through the secure connection

  @responder-actions @SHALL
  Scenario: Trust Anchor verifies the proof or signature on a signed DID Document
    Given the submitted DID Document carries a proof or digital signature
    When the Trust Anchor verifies the identity of the submitter
    Then the Trust Anchor SHALL verify the proof or signature on the DID Document

  @responder-actions @SHALL
  Scenario: Trust Anchor validates the submitter against pre-registered organisational identifiers
    Given the Trust Anchor has a registry of authorised participants
    When the Trust Anchor verifies the identity of the submitter
    Then the Trust Anchor SHALL validate the submitter against pre-registered organisational identifiers

  @responder-actions @SHALL
  Scenario: Trust Anchor returns HTTP 401 when authentication fails
    Given the submitter has not provided valid authentication credentials
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 401 Unauthorized

  @responder-actions @SHALL
  Scenario: Trust Anchor returns HTTP 403 when the entity is not authorised to submit
    Given the submitter is authenticated but not in the list of authorised submitters
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 403 Forbidden

  @responder-actions @SHALL
  Scenario: Trust Anchor rejects a submission from an entity not in the trust network
    Given the submitting entity is not a known trust network participant
    When the Trust Anchor attempts to verify identity
    Then the Trust Anchor SHALL reject the submission

  @responder-actions @SHALL
  Scenario: Trust Anchor rejects a submission lacking required provenance information
    Given a submitted DID Document contains no provenance metadata
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL reject the submission

  # ─── Cataloging ─────────────────────────────────────────────────────────────

  @responder-actions @SHALL
  Scenario: Trust Anchor catalogs a fully validated DID Document
    Given all validation and authentication checks have passed for a submitted DID Document
    When the Trust Anchor completes processing
    Then the Trust Anchor SHALL store the DID Document in its registry

  @responder-actions @SHALL
  Scenario: Trust Anchor makes the cataloged DID Document available for retrieval
    Given the Trust Anchor has stored a validated DID Document
    When cataloging is complete
    Then the Trust Anchor SHALL make the DID Document accessible via its retrieval endpoint

  # ─── Revocation and Updates ─────────────────────────────────────────────────

  @responder-actions @SHALL
  Scenario: Trust Anchor supports updating a previously registered DID Document
    Given a DID Document is already registered for a DID
    When the same submitter sends an updated DID Document for that DID
    Then the Trust Anchor SHALL support the update and replace the stored DID Document

  @responder-actions @SHALL
  Scenario: Trust Anchor supports revoking a registered DID Document
    Given a DID Document is present in the registry
    When a valid revocation request is received
    Then the Trust Anchor SHALL mark the DID Document as revoked

  @responder-actions @SHALL
  Scenario: Trust Anchor does not distribute revoked or expired DID Documents
    Given a DID Document in the registry has been revoked or has expired
    When a participant requests that DID Document via the retrieval endpoint
    Then the Trust Anchor SHALL NOT return the revoked or expired DID Document

  @responder-actions @MAY
  Scenario: Trust Anchor may maintain a version history of DID Documents for audit purposes
    Given a DID Document has been updated or revoked
    When an audit query is made
    Then the Trust Anchor MAY provide a history of prior DID Document versions
