Feature: ITI-YY1 Submit PKI Material Response
  As a Trust Anchor (Responder)
  I want to validate, catalog, and respond to DID Document submissions
  So that only authenticated and well-formed PKI material enters the trust registry

  Background:
    Given the Trust Anchor is running and its endpoint is "https://trust-anchor.example.org/did"
    And the Trust Anchor has a registry of pre-authorized trust network participants

  # ─── Structural Validation ────────────────────────────────────────────────────

  Scenario: Trust Anchor accepts a fully conformant DID Document
    Given a submitter sends a valid DID Document conforming to W3C DID Core
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 201 Created

  Scenario: Trust Anchor rejects a DID Document missing the @context element
    Given a submitter sends a DID Document without an "@context" element
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 400 Bad Request
    And the response SHALL indicate that the "@context" element is missing

  Scenario: Trust Anchor rejects a DID Document whose @context does not include the W3C DID context
    Given a submitter sends a DID Document whose "@context" does not include "https://www.w3.org/ns/did/v1"
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 400 Bad Request

  Scenario: Trust Anchor rejects a DID Document missing the id element
    Given a submitter sends a DID Document without an "id" element
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 400 Bad Request
    And the response SHALL indicate that the "id" element is missing

  Scenario: Trust Anchor rejects a DID Document with a malformed DID identifier
    Given a submitter sends a DID Document where "id" is "not-a-valid-did"
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 400 Bad Request

  Scenario: Trust Anchor rejects a DID Document with no verificationMethod entries
    Given a submitter sends a DID Document with an empty "verificationMethod" array
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 400 Bad Request
    And the response SHALL indicate that at least one verification method is required

  Scenario: Trust Anchor rejects a DID Document with a verification method missing the id element
    Given a submitter sends a DID Document where a verification method has no "id"
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 422 Unprocessable Entity

  Scenario: Trust Anchor rejects a DID Document with a verification method missing the type element
    Given a submitter sends a DID Document where a verification method has no "type"
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 422 Unprocessable Entity

  Scenario: Trust Anchor rejects a DID Document with a verification method missing the controller element
    Given a submitter sends a DID Document where a verification method has no "controller"
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 422 Unprocessable Entity

  Scenario: Trust Anchor rejects a DID Document with a verification method that has neither publicKeyJwk nor publicKeyMultibase
    Given a submitter sends a DID Document where a verification method contains neither "publicKeyJwk" nor "publicKeyMultibase"
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 422 Unprocessable Entity

  # ─── Cryptographic Material Validation ───────────────────────────────────────

  Scenario: Trust Anchor rejects a DID Document containing private key material
    Given a submitter sends a DID Document where a "publicKeyJwk" object includes the "d" parameter
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 422 Unprocessable Entity
    And the response SHALL indicate that private key material must not be submitted

  Scenario: Trust Anchor rejects a DID Document with a malformed JWK
    Given a submitter sends a DID Document where "publicKeyJwk" is not valid per RFC 7517
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 422 Unprocessable Entity

  Scenario Outline: Trust Anchor rejects keys using prohibited cryptographic algorithms
    Given a submitter sends a DID Document using key algorithm "<prohibited_algorithm>"
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 422 Unprocessable Entity
    And the response SHALL indicate the algorithm is not permitted by trust framework policy

    Examples:
      | prohibited_algorithm |
      | RSA-512              |
      | EC-P192              |

  Scenario Outline: Trust Anchor accepts keys using approved cryptographic algorithms
    Given a submitter sends a DID Document using key algorithm "<approved_algorithm>"
    And the submitter is authenticated
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 201 Created

    Examples:
      | approved_algorithm |
      | EC-P256            |
      | EC-P384            |
      | EC-P521            |

  Scenario: Trust Anchor rejects keys that do not meet minimum key size requirements
    Given a submitter sends a DID Document with a key that is below the minimum required key size
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 422 Unprocessable Entity
    And the response SHALL indicate insufficient key size

  # ─── Identity and Authentication Verification ────────────────────────────────

  Scenario: Trust Anchor rejects a submission from an unauthenticated entity
    Given a submitter sends a valid DID Document
    But the submitter has not established mutual TLS authentication
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 401 Unauthorized

  Scenario: Trust Anchor rejects a submission from an entity not in the trust network registry
    Given a submitter sends a valid DID Document
    And the submitter is authenticated via mutual TLS
    But the submitter's identity is not registered as a trust network participant
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 403 Forbidden

  Scenario: Trust Anchor verifies a proof of control over the DID when present
    Given a submitter sends a DID Document with a digital proof of control
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL verify the proof signature against the submitted public key
    And SHALL reject the submission if the proof is invalid with HTTP 422 Unprocessable Entity

  Scenario: Trust Anchor accepts a submission from an authenticated and registered participant
    Given a submitter is authenticated via mutual TLS
    And the submitter's identity matches a pre-registered trust network participant
    And the submitted DID Document is structurally valid
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP 201 Created

  # ─── Cataloging and Storage ───────────────────────────────────────────────────

  Scenario: Trust Anchor stores a validated DID Document in its registry
    Given a submitter sends a valid and authenticated DID Document
    When the Trust Anchor successfully validates the submission
    Then the Trust Anchor SHALL persist the DID Document in its registry
    And the stored DID Document SHALL be retrievable by the submitter's DID

  Scenario: Trust Anchor makes the cataloged DID Document available for retrieval
    Given a DID Document has been successfully cataloged
    When a trust network participant queries the Trust Anchor for the submitter's DID
    Then the Trust Anchor SHALL return the cataloged DID Document

  Scenario: Trust Anchor exposes at least one retrieval endpoint accessible to all participants
    Given the Trust Anchor has cataloged one or more DID Documents
    Then the Trust Anchor SHALL maintain at least one endpoint accessible to all VHL Sharers and VHL Receivers
    And that endpoint SHALL allow retrieval of submitted DID Documents and PKI material

  # ─── Revocation and Updates ───────────────────────────────────────────────────

  Scenario: Trust Anchor supports updating a previously submitted DID Document
    Given a DID Document for "did:example:vhl-sharer-123" is already cataloged
    When the same submitter sends an updated DID Document for "did:example:vhl-sharer-123"
    And the submitter is authenticated
    Then the Trust Anchor SHALL replace the existing entry with the updated DID Document
    And the Trust Anchor SHALL return HTTP 201 Created

  Scenario: Trust Anchor supports revoking a previously submitted DID Document
    Given a DID Document for "did:example:vhl-sharer-123" is cataloged
    When the Trust Anchor receives a valid revocation request for "did:example:vhl-sharer-123"
    Then the Trust Anchor SHALL mark the DID Document as revoked in its registry
    And the revoked DID Document SHALL NOT be returned in subsequent retrieval responses

  Scenario: Trust Anchor does not distribute expired DID Documents
    Given a DID Document in the registry has passed its declared expiry date
    When a trust network participant queries for that DID Document
    Then the Trust Anchor SHALL NOT return the expired DID Document
    And the Trust Anchor SHALL indicate that the document is expired or unavailable

  Scenario: Trust Anchor may retain a history of DID Document versions for audit
    Given a DID Document has been updated or revoked
    When an authorised audit query is made
    Then the Trust Anchor MAY return prior versions of the DID Document for audit purposes

  # ─── Error Response Integrity ─────────────────────────────────────────────────

  Scenario Outline: Trust Anchor returns appropriate HTTP status codes for each error class
    Given a submitter sends a submission that triggers the "<error_class>" condition
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL return HTTP "<status_code>"

    Examples:
      | error_class                          | status_code                  |
      | Malformed DID Document               | 400 Bad Request              |
      | Authentication failed                | 401 Unauthorized             |
      | Entity not authorised to submit      | 403 Forbidden                |
      | Valid format but validation failed   | 422 Unprocessable Entity     |
