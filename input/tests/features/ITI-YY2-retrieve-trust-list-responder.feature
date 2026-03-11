Feature: ITI-YY2 Retrieve Trust List – Trust Anchor Expected Actions
  As the Trust Anchor (Responder) serving trust list requests,
  these scenarios verify that the Trust Anchor correctly filters out inactive documents,
  authenticates and authorises requesters, constructs conformant responses,
  and returns appropriate error codes.

  Background:
    Given the Trust Anchor has a registry of cataloged DID Documents
    And the retrieval endpoint is accessible to all trust network participants

  # ─── Active Document Filtering ───────────────────────────────────────────────

  @responder-actions @SHALL
  Scenario: Trust Anchor does not return revoked DID Documents in a bulk query
    Given the registry contains a revoked DID Document for "did:example:revoked-001"
    When a requester queries for all DID Documents
    Then the response SHALL NOT include the revoked DID Document

  @responder-actions @SHALL
  Scenario: Trust Anchor does not return expired DID Documents in a bulk query
    Given the registry contains an expired DID Document for "did:example:expired-001"
    When a requester queries for all DID Documents
    Then the response SHALL NOT include the expired DID Document

  @responder-actions @SHALL
  Scenario: Trust Anchor returns only active documents when status filter is active
    Given the registry contains active, revoked, and expired DID Documents
    When a requester queries with "status=active"
    Then the response SHALL contain only DID Documents with active status

  # ─── Authentication and Authorization ────────────────────────────────────────

  @responder-actions @SHALL
  Scenario: Trust Anchor returns HTTP 401 for an unauthenticated retrieval request
    Given a retrieval request arrives without authentication credentials
    When the Trust Anchor processes the request
    Then the response SHALL be HTTP 401 Unauthorized

  @responder-actions @SHALL
  Scenario: Trust Anchor returns HTTP 403 for a retrieval request from an unauthorised participant
    Given a retrieval request arrives from an authenticated entity
    But the entity is not authorised to retrieve trust material
    When the Trust Anchor processes the request
    Then the response SHALL be HTTP 403 Forbidden

  # ─── Not Found ───────────────────────────────────────────────────────────────

  @responder-actions @SHALL
  Scenario: Trust Anchor returns HTTP 404 when the requested DID is not in the registry
    Given a request for DID "did:example:unknown-999" is received
    And the DID is not present in the registry
    When the Trust Anchor processes the request
    Then the response SHALL be HTTP 404 Not Found

  # ─── Optional Response Signing ───────────────────────────────────────────────

  @responder-actions @MAY
  Scenario: Trust Anchor may sign the response payload for integrity protection
    Given the Trust Anchor supports response signing
    When it assembles a successful Retrieve Trust List response
    Then the Trust Anchor MAY include a digital signature over the response payload
    And clients SHALL be able to verify that signature using the Trust Anchor's public key

  # ─── Security ────────────────────────────────────────────────────────────────

  @security @SHALL
  Scenario: Trust Anchor restricts retrieval to authenticated and authorised participants
    Given a retrieval request is received
    When the Trust Anchor applies access control
    Then only authenticated and authorised trust network participants SHALL receive DID Documents
