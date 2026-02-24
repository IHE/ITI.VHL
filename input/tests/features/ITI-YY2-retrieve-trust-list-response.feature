Feature: ITI-YY2 Retrieve Trust List Response
  As a Trust Anchor (Responder)
  I want to serve DID Documents to authorized trust network participants
  So that VHL Sharers and VHL Receivers can obtain the public key material they need

  Background:
    Given the Trust Anchor has a registry of cataloged, active DID Documents
    And the retrieval endpoint is accessible to all trust network participants

  # ─── Success Responses ───────────────────────────────────────────────────────

  Scenario: Trust Anchor returns HTTP 200 with a single DID Document for a known DID
    Given a request for DID "did:example:vhl-sharer-123456" is received
    And the DID is registered and active in the registry
    When the Trust Anchor processes the request
    Then the response SHALL be HTTP 200 OK
    And the response body SHALL be a single DID Document conforming to W3C DID Core
    And the response SHALL include the header "Content-Type: application/did+json"

  Scenario: Trust Anchor returns HTTP 200 with a collection of DID Documents for a bulk query
    Given a request for all registered DIDs is received
    When the Trust Anchor processes the request
    Then the response SHALL be HTTP 200 OK
    And the response body SHALL be a JSON object with a "didDocuments" array
    And each element in "didDocuments" SHALL be a valid W3C DID Core document

  # ─── Response Content Integrity ──────────────────────────────────────────────

  Scenario: Each returned DID Document contains the mandatory @context element
    Given the Trust Anchor is preparing a response
    When the response DID Documents are assembled
    Then each DID Document SHALL contain a "@context" element
    And the "@context" SHALL include "https://www.w3.org/ns/did/v1"

  Scenario: Each returned DID Document contains a valid id element
    Given the Trust Anchor is preparing a response
    When the response DID Documents are assembled
    Then each DID Document SHALL contain exactly one "id" element with a valid DID value

  Scenario: Each returned DID Document contains at least one verification method
    Given the Trust Anchor is preparing a response
    When the response DID Documents are assembled
    Then each DID Document SHALL contain a "verificationMethod" array with at least one entry

  Scenario: Returned verification methods contain sufficient key material for signature validation
    Given the Trust Anchor is assembling a DID Document for a response
    When the verification methods are included
    Then each verification method SHALL include either "publicKeyJwk" or "publicKeyMultibase"
    And no "publicKeyJwk" SHALL include the "d" (private key) parameter

  # ─── Filtering: Active Documents Only ────────────────────────────────────────

  Scenario: Trust Anchor does not return revoked DID Documents
    Given the registry contains a revoked DID Document for "did:example:revoked-001"
    When a requester queries for all DID Documents
    Then the response SHALL NOT include the revoked DID Document

  Scenario: Trust Anchor does not return expired DID Documents
    Given the registry contains an expired DID Document for "did:example:expired-001"
    When a requester queries for all DID Documents
    Then the response SHALL NOT include the expired DID Document

  Scenario: Trust Anchor returns only active documents when status filter is "active"
    Given the registry contains active, revoked, and expired DID Documents
    When a requester queries with "status=active"
    Then the response SHALL contain only DID Documents with active status

  # ─── Authentication and Authorization ────────────────────────────────────────

  Scenario: Trust Anchor rejects an unauthenticated retrieval request with 401
    Given a retrieval request arrives without authentication credentials
    When the Trust Anchor processes the request
    Then the response SHALL be HTTP 401 Unauthorized

  Scenario: Trust Anchor rejects a retrieval request from an unauthorized participant with 403
    Given a retrieval request arrives from an authenticated entity
    But the entity is not authorized to retrieve trust material
    When the Trust Anchor processes the request
    Then the response SHALL be HTTP 403 Forbidden

  # ─── Not Found ────────────────────────────────────────────────────────────────

  Scenario: Trust Anchor returns 404 when the requested DID is not in the registry
    Given a request for DID "did:example:unknown-999" is received
    And the DID is not present in the registry
    When the Trust Anchor processes the request
    Then the response SHALL be HTTP 404 Not Found

  # ─── Optional Response Signing ───────────────────────────────────────────────

  Scenario: Trust Anchor may sign the response payload for integrity protection
    Given the Trust Anchor supports response signing
    When it assembles a successful Retrieve Trust List response
    Then the Trust Anchor MAY include a digital signature over the response payload
    And clients SHALL be able to verify that signature using the Trust Anchor's public key

  # ─── mCSD Response Format ────────────────────────────────────────────────────

  Scenario: Trust Anchor returns a FHIR searchset Bundle for mCSD-based queries
    Given a request using the mCSD query pattern is received
    When the Trust Anchor processes the request
    Then the response SHALL be HTTP 200 OK
    And the response body SHALL be a FHIR Bundle with type "searchset"
    And the response SHALL include the header "Content-Type: application/fhir+json"

  # ─── Receiver Expected Actions after Response ─────────────────────────────────

  Scenario: Receiver parses a single DID Document response and extracts public keys
    Given the Trust Anchor has returned a single DID Document response
    When the VHL Receiver or VHL Sharer processes the response
    Then it SHALL extract all verification methods from the DID Document
    And it SHALL store the public key material for use in signature verification

  Scenario: Receiver parses a bulk DID Document response and processes each entry
    Given the Trust Anchor has returned a "didDocuments" array with multiple entries
    When the VHL Receiver or VHL Sharer processes the response
    Then it SHALL iterate over each DID Document in the array
    And it SHALL extract and store public key material from each entry

  Scenario: Receiver checks revocation status of retrieved DID Documents before trusting them
    Given DID Documents have been retrieved from the Trust Anchor
    When the receiver applies them to trust decisions
    Then the receiver SHOULD verify each DID Document has not been revoked before trusting it

  Scenario: Receiver implements periodic refresh of cached Trust Anchor material
    Given the receiver has cached DID Documents from a prior retrieval
    When the cache reaches its expiry threshold
    Then the receiver SHALL issue a new Retrieve Trust List request to refresh the material
