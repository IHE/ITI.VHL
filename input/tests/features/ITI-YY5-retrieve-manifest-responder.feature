Feature: ITI-YY5 Retrieve Manifest – VHL Sharer Expected Actions
  As a VHL Sharer (Responder) serving document manifest requests,
  these scenarios verify that the VHL Sharer correctly authenticates the receiver,
  authorizes the VHL, executes the FHIR search, and returns the manifest Bundle.

  Background:
    Given the VHL Sharer has received an HTTP POST to "/List/_search"
    And the VHL Sharer has access to the trust list

  # ─── HTTP Message Signature Verification ─────────────────────────────────────

  @responder-actions @SHALL
  Scenario: VHL Sharer extracts keyid from the Signature-Input header
    Given the request includes a valid "Signature-Input" header
    When the VHL Sharer processes the authentication headers
    Then the VHL Sharer SHALL extract the "keyid" value from the Signature-Input header

  @responder-actions @SHALL
  Scenario: VHL Sharer retrieves the receiver's public key from the trust list using keyid
    Given the "keyid" has been extracted from the Signature-Input header
    When the VHL Sharer looks up the key
    Then the VHL Sharer SHALL retrieve the receiver's public key from the trust list
    And SHALL return HTTP 401 Unauthorized if no key matches the keyid

  @responder-actions @SHALL
  Scenario: VHL Sharer verifies the ECDSA or RSA signature per RFC 9421
    Given the receiver's public key has been retrieved
    When signature verification is performed
    Then the VHL Sharer SHALL reconstruct the signature base from the signed HTTP components
    And SHALL verify the signature using the receiver's public key per RFC 9421

  @responder-actions @SHALL
  Scenario: VHL Sharer verifies the Content-Digest header matches the actual request body
    Given the request includes a "Content-Digest" header
    When the digest is verified
    Then the VHL Sharer SHALL compute the SHA-256 hash of the actual request body
    And the computed hash SHALL match the value in the Content-Digest header
    And the request SHALL be rejected with HTTP 401 if they do not match

  @responder-actions @SHALL
  Scenario: VHL Sharer returns HTTP 401 for a request with an invalid HTTP signature
    Given the request carries a "Signature" header that fails verification
    When signature verification is performed
    Then the VHL Sharer SHALL return HTTP 401 Unauthorized
    And the response SHALL include a FHIR OperationOutcome with issue.code "security"

  @responder-actions @SHALL
  Scenario: VHL Sharer enforces signature timestamp freshness within 2 minutes
    Given the "created" timestamp in Signature-Input is more than 2 minutes in the past
    When the timestamp is validated
    Then the VHL Sharer SHALL reject the request as a potential replay
    And the response SHALL be HTTP 401 Unauthorized

  @responder-actions @SHALL
  Scenario: VHL Sharer accepts a request whose signature timestamp is within the 2-minute window
    Given the "created" timestamp is within 2 minutes of the current server time
    When the timestamp is validated
    Then the VHL Sharer SHALL proceed with processing the request

  # ─── OAuth with FAST Option Verification (Optional) ──────────────────────────

  @responder-actions @SHALL
  Scenario: VHL Sharer validates an OAuth Bearer token when FAST Option is supported
    Given the request includes "Authorization: Bearer <token>" and the FAST Option is supported
    When the token is validated
    Then the VHL Sharer SHALL verify the token signature against the authorization server's public key
    And SHALL verify "exp" has not passed
    And SHALL verify "scope" includes "system/List.read"
    And SHALL verify "iss" is a trusted authorization server

  @responder-actions @SHALL
  Scenario: VHL Sharer returns HTTP 401 for an expired OAuth token
    Given the Bearer token "exp" claim has passed
    When the token is validated
    Then the VHL Sharer SHALL return HTTP 401 Unauthorized

  @responder-actions @SHALL
  Scenario: VHL Sharer returns HTTP 401 for an OAuth token with insufficient scope
    Given the Bearer token does not include "system/List.read"
    When the token scope is validated
    Then the VHL Sharer SHALL return HTTP 401 Unauthorized

  # ─── VHL Authorization ────────────────────────────────────────────────────────

  @responder-actions @SHALL
  Scenario: VHL Sharer validates that the folder ID corresponds to a valid VHL
    Given the request body includes "_id=abc123def456"
    When the VHL Sharer performs VHL authorization
    Then the VHL Sharer SHALL confirm a valid VHL with that folder ID exists
    And SHALL return HTTP 403 Forbidden if no matching VHL is found

  @responder-actions @SHALL
  Scenario: VHL Sharer rejects a request for an expired VHL with HTTP 403
    Given the VHL associated with the folder ID has an expired "exp" claim
    When the VHL Sharer checks expiry
    Then the VHL Sharer SHALL return HTTP 403 Forbidden

  @responder-actions @SHALL
  Scenario: VHL Sharer rejects a request for a revoked VHL with HTTP 403
    Given the VHL associated with the folder ID has been revoked
    When the VHL Sharer checks revocation status
    Then the VHL Sharer SHALL return HTTP 403 Forbidden

  @responder-actions @SHALL
  Scenario: VHL Sharer validates passcode using constant-time comparison when P flag is set
    Given the VHL has a P flag and the request includes "passcode=user-pin"
    When the passcode is validated
    Then the VHL Sharer SHALL compare using constant-time comparison against the stored hash
    And SHALL return HTTP 422 Unprocessable Entity if the passcode is incorrect

  @responder-actions @SHALL
  Scenario: VHL Sharer returns HTTP 422 when a required passcode is missing
    Given the VHL has a P flag and the request body includes no "passcode" parameter
    When the VHL Sharer processes the request
    Then the VHL Sharer SHALL return HTTP 422 Unprocessable Entity

  # ─── FHIR Search Execution ────────────────────────────────────────────────────

  @responder-actions @SHALL
  Scenario: VHL Sharer executes a FHIR search matching _id code status and patient.identifier
    Given authentication and VHL authorization have succeeded
    When the VHL Sharer executes the search
    Then the VHL Sharer SHALL search for a List resource matching "_id", "code", "status", and "patient.identifier"
    And SHALL apply VHL scope filters to include only documents authorized by the VHL

  @responder-actions @SHALL
  Scenario: VHL Sharer returns HTTP 404 when no List resource matches the search parameters
    Given the FHIR search finds no List resource for the given "_id"
    When the search is executed
    Then the VHL Sharer SHALL return HTTP 404 Not Found
    And the response SHALL include a FHIR OperationOutcome with issue.code "not-found"

  @responder-actions @SHALL
  Scenario: VHL Sharer includes DocumentReferences when Include DocumentReference Option is supported and _include is present
    Given the VHL Sharer supports the Include DocumentReference Option and the request includes "_include=List:item"
    When the FHIR search is executed
    Then the response Bundle SHALL include the List resource with search.mode="match"
    And SHALL include each referenced DocumentReference with search.mode="include"

  @responder-actions @SHALL
  Scenario: VHL Sharer ignores _include when Include DocumentReference Option is not supported
    Given the VHL Sharer does NOT support the Include DocumentReference Option
    When the FHIR search is executed with "_include=List:item"
    Then the VHL Sharer SHALL ignore the "_include" parameter
    And the response Bundle SHALL contain only the List resource

  # ─── Rate Limiting and Audit ─────────────────────────────────────────────────

  @responder-actions @SHALL
  Scenario: VHL Sharer returns HTTP 429 when a receiver exceeds the request rate limit
    Given the VHL Receiver has exceeded the rate limit for a given time window
    When the next request arrives
    Then the VHL Sharer SHALL return HTTP 429 Too Many Requests
    And the response SHALL include a FHIR OperationOutcome with issue.code "throttled"

  @responder-actions @SHOULD
  Scenario: VHL Sharer logs all manifest access requests including failed ones
    Given a Retrieve Manifest request has been processed
    When the audit event is recorded
    Then the VHL Sharer SHOULD log receiver identity, folder ID, authentication method, authorization decision, and timestamp
