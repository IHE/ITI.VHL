Feature: ITI-YY2 Retrieve Trust List Request
  As a VHL Sharer or VHL Receiver (Requester)
  I want to retrieve DID Documents from the Trust Anchor
  So that I can obtain public key material for verifying VHL artifacts and service endpoints

  Background:
    Given the requester is a VHL Sharer or VHL Receiver
    And the Trust Anchor retrieval endpoint is known to the requester

  # ─── Preconditions ───────────────────────────────────────────────────────────

  Scenario: Requester knows the Trust Anchor retrieval endpoint before sending the request
    Given the Trust Anchor has published at least one endpoint accessible to all trust network participants
    When the requester prepares a Retrieve Trust List request
    Then the requester SHALL have identified the Trust Anchor endpoint in advance

  # ─── Option 1: HTTP GET for a specific DID ───────────────────────────────────

  Scenario: Requester retrieves a specific DID Document by DID identifier using HTTP GET
    Given the requester knows the DID "did:example:vhl-sharer-123456"
    When the requester constructs a request for that specific DID
    Then the request SHALL be an HTTP GET to "[trust-anchor-base]/did/did%3Aexample%3Avhl-sharer-123456"
    And the request SHALL include the header "Accept: application/did+json"

  Scenario: DID identifier in the URL path is URL-encoded
    Given the requester knows the DID "did:example:vhl-sharer-123456"
    When the requester constructs the request URL
    Then the DID SHALL be URL-encoded in the path (e.g., colons encoded as "%3A")

  # ─── Option 2: HTTP GET for all DIDs ─────────────────────────────────────────

  Scenario: Requester retrieves all active DID Documents using HTTP GET
    Given the requester wants all active DID Documents in the trust network
    When the requester constructs the request
    Then the request SHALL be an HTTP GET to "[trust-anchor-base]/did"
    And the request SHALL include the header "Accept: application/did+json"

  # ─── Option 3: mCSD-based Query ──────────────────────────────────────────────

  Scenario: Requester retrieves DID Documents for VHL Sharer entities using mCSD query
    Given the Trust Anchor exposes an mCSD-compliant endpoint
    When the requester constructs an mCSD-based query for VHL Sharer entities
    Then the request SHALL be an HTTP GET to "[trust-anchor-base]/Organization?_has:OrganizationAffiliation:organization:role=VHLSharer"
    And the request SHALL include the header "Accept: application/fhir+json"

  # ─── Optional Query Parameters ────────────────────────────────────────────────

  Scenario Outline: Requester may filter results by entity type
    Given the requester wants only entities of type "<entity_type>"
    When the requester adds a type filter to the request
    Then the request URL SHALL include "type=<entity_type>"

    Examples:
      | entity_type  |
      | VHLSharer    |
      | VHLReceiver  |

  Scenario Outline: Requester may filter results by status
    Given the requester wants only entities with status "<status>"
    When the requester adds a status filter to the request
    Then the request URL SHALL include "status=<status>"

    Examples:
      | status   |
      | active   |
      | revoked  |
      | expired  |

  # ─── Transport Security ───────────────────────────────────────────────────────

  Scenario: Request is sent over a secure channel
    Given the requester has constructed a valid Retrieve Trust List request
    When the requester sends the request
    Then the connection SHALL use TLS 1.3 or equivalent
    And the request SHALL NOT be sent over plain HTTP

  # ─── Response Processing ─────────────────────────────────────────────────────

  Scenario: Requester validates the integrity of the response when a signature is present
    Given the Trust Anchor has returned a response with a digital signature
    When the requester processes the response
    Then the requester SHALL verify the response signature before trusting the content

  Scenario: Requester verifies that returned DID Documents conform to W3C DID Core
    Given the Trust Anchor has returned one or more DID Documents
    When the requester parses the response
    Then each DID Document SHALL be validated against the W3C DID Core specification

  Scenario: Requester validates public keys within returned verification methods
    Given the Trust Anchor has returned DID Documents with verification methods
    When the requester extracts public key material
    Then each verification method SHALL contain a well-formed "publicKeyJwk" or "publicKeyMultibase"
    And each key type and algorithm SHALL be acceptable per the trust framework policy

  Scenario: Requester maps each verification method to its intended use
    Given the Trust Anchor has returned a DID Document with authentication and assertionMethod references
    When the requester processes the verification methods
    Then the requester SHALL associate each method with its declared use (authentication, assertionMethod, keyAgreement, etc.)

  Scenario: Requester caches retrieved DID Documents per caching policy
    Given the Trust Anchor has returned a successful response
    When the requester stores the DID Documents
    Then the requester SHALL cache the DID Documents according to the applicable caching policy
    And the requester SHALL respect any cache-control headers or expiration times provided

  Scenario: Requester tracks expiry of cached DID Documents and refreshes before expiry
    Given the requester has cached a DID Document with an expiry time
    When the expiry time approaches
    Then the requester SHALL refresh the cached material before it expires

  Scenario: Requester immediately invalidates cached DID Document upon revocation notification
    Given the requester has cached a DID Document
    When the requester receives a revocation notification for that DID Document
    Then the requester SHALL immediately invalidate the cached entry

  # ─── Error Handling ───────────────────────────────────────────────────────────

  Scenario: Requester handles 404 when a specific DID is not found
    Given the requester requests the DID "did:example:unknown-999"
    When the Trust Anchor returns HTTP 404 Not Found
    Then the requester SHALL NOT treat the absent DID as trusted material
    And the requester SHOULD inform the operator or retry with a different endpoint

  Scenario: Requester handles 401 when not authenticated
    Given the requester has not provided authentication credentials
    When the Trust Anchor returns HTTP 401 Unauthorized
    Then the requester SHALL NOT process any DID Documents from that response
    And the requester SHOULD attempt to authenticate before retrying

  Scenario: Requester handles 403 when not authorized to retrieve trust material
    Given the requester is authenticated but not authorized to retrieve trust material
    When the Trust Anchor returns HTTP 403 Forbidden
    Then the requester SHALL NOT process any DID Documents from that response
