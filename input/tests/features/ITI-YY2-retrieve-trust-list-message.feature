Feature: ITI-YY2 Retrieve Trust List – Message Semantics
  Defines the format of the ITI-YY2 request and response messages.
  Request options (single DID GET, bulk GET, mCSD query) and response formats
  (DID Document, collection, FHIR Bundle) are specified here once and
  referenced by both initiator and responder actor files.

  Background:
    Given a Retrieve Trust List exchange between an initiator and the Trust Anchor

  # ─── Request: Option 1 – HTTP GET for a specific DID ────────────────────────

  @message-semantics @SHALL
  Scenario: Single DID retrieval uses HTTP GET with URL-encoded DID in the path
    Given the requester knows DID "did:example:vhl-sharer-123456"
    When the request is constructed for that specific DID
    Then the request SHALL be HTTP GET to "[trust-anchor-base]/did/did%3Aexample%3Avhl-sharer-123456"
    And the request SHALL include "Accept: application/did+json"

  @message-semantics @SHALL
  Scenario: DID identifier in the URL path is URL-encoded
    Given the requester knows DID "did:example:vhl-sharer-123456"
    When the request URL is constructed
    Then the DID SHALL be URL-encoded in the path (colons encoded as "%3A")

  # ─── Request: Option 2 – HTTP GET for all DIDs ──────────────────────────────

  @message-semantics @SHALL
  Scenario: Bulk DID retrieval uses HTTP GET to the base /did endpoint
    Given the requester wants all active DID Documents
    When the request is constructed
    Then the request SHALL be HTTP GET to "[trust-anchor-base]/did"
    And the request SHALL include "Accept: application/did+json"

  # ─── Request: Option 3 – mCSD-based Query ───────────────────────────────────

  @message-semantics @SHALL
  Scenario: mCSD query for VHL Sharer entities uses the correct search parameter
    Given the Trust Anchor exposes an mCSD-compliant endpoint
    When the requester constructs an mCSD query for VHL Sharer entities
    Then the request SHALL be HTTP GET to "[trust-anchor-base]/Organization?_has:OrganizationAffiliation:organization:role=VHLSharer"
    And the request SHALL include "Accept: application/fhir+json"

  # ─── Request: Optional Query Parameters ─────────────────────────────────────

  @message-semantics @SHALL
  Scenario Outline: Type filter restricts results to a specific entity type
    Given the requester adds "type=<entity_type>" to the request
    When the request is sent
    Then only DID Documents associated with entities of type "<entity_type>" SHALL be returned

    Examples:
      | entity_type  |
      | VHLSharer    |
      | VHLReceiver  |

  @message-semantics @SHALL
  Scenario Outline: Status filter restricts results by document status
    Given the requester adds "status=<status>" to the request
    When the request is sent
    Then only DID Documents with status "<status>" SHALL be returned

    Examples:
      | status   |
      | active   |
      | revoked  |
      | expired  |

  # ─── Response: Single DID Document ──────────────────────────────────────────

  @message-semantics @SHALL
  Scenario: Single DID response is HTTP 200 with a DID Document body
    Given the requested DID is registered and active
    When the Trust Anchor responds to the single-DID GET
    Then the response SHALL be HTTP 200 OK
    And the response body SHALL be a single DID Document conforming to W3C DID Core
    And the response SHALL include "Content-Type: application/did+json"

  # ─── Response: Bulk DID Document Collection ─────────────────────────────────

  @message-semantics @SHALL
  Scenario: Bulk DID response is HTTP 200 with a didDocuments array
    Given there are registered and active DID Documents
    When the Trust Anchor responds to the bulk GET
    Then the response SHALL be HTTP 200 OK
    And the response body SHALL be a JSON object with a "didDocuments" array
    And each element in "didDocuments" SHALL be a valid W3C DID Core document

  # ─── Response: Returned DID Document Content ────────────────────────────────

  @message-semantics @SHALL
  Scenario: Each returned DID Document contains the mandatory @context element
    When the response DID Documents are inspected
    Then each SHALL contain "@context" including "https://www.w3.org/ns/did/v1"

  @message-semantics @SHALL
  Scenario: Each returned DID Document contains a valid id element
    When the response DID Documents are inspected
    Then each SHALL contain exactly one "id" element with a valid DID value

  @message-semantics @SHALL
  Scenario: Each returned DID Document contains at least one verification method with key material
    When the response DID Documents are inspected
    Then each SHALL contain a "verificationMethod" array with at least one entry
    And each verification method SHALL include either "publicKeyJwk" or "publicKeyMultibase"
    And no "publicKeyJwk" SHALL include the "d" parameter

  # ─── Response: mCSD Format ───────────────────────────────────────────────────

  @message-semantics @SHALL
  Scenario: mCSD query response is HTTP 200 with a FHIR searchset Bundle
    Given an mCSD-based query is received
    When the Trust Anchor responds
    Then the response SHALL be HTTP 200 OK
    And the response body SHALL be a FHIR Bundle with type "searchset"
    And the response SHALL include "Content-Type: application/fhir+json"
