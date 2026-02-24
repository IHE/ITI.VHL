Feature: ITI-YY5 Retrieve Manifest Response
  As a VHL Sharer (Responder)
  I want to authenticate the VHL Receiver, authorize the VHL, and return the document manifest
  So that only trusted and authorized receivers can discover available health documents

  Background:
    Given the VHL Sharer has received an HTTP POST request to "/List/_search"
    And the VHL Sharer has access to the trust list (obtained via ITI-YY1/ITI-YY2)

  # ─── HTTP Message Signature Verification ─────────────────────────────────────

  Scenario: VHL Sharer extracts keyid from the Signature-Input header
    Given the request includes a valid "Signature-Input" header
    When the VHL Sharer processes the authentication headers
    Then the VHL Sharer SHALL extract the "keyid" value from the Signature-Input header

  Scenario: VHL Sharer retrieves the receiver's public key from the trust list using keyid
    Given the "keyid" has been extracted from the Signature-Input header
    When the VHL Sharer looks up the key
    Then the VHL Sharer SHALL retrieve the receiver's public key from the trust list using that keyid
    And SHALL return HTTP 401 Unauthorized if no key matches the keyid

  Scenario: VHL Sharer reconstructs the signature base and verifies the ECDSA/RSA signature
    Given the receiver's public key has been retrieved from the trust list
    When signature verification is performed
    Then the VHL Sharer SHALL reconstruct the signature base from the signed HTTP components
    And SHALL verify the signature using the receiver's public key per RFC 9421

  Scenario: VHL Sharer verifies the Content-Digest matches the request body
    Given the request includes a "Content-Digest" header
    When the digest is verified
    Then the VHL Sharer SHALL compute the SHA-256 hash of the actual request body
    And the computed hash SHALL match the value in the Content-Digest header
    And the request SHALL be rejected with HTTP 401 if they do not match

  Scenario: VHL Sharer rejects a request whose HTTP signature is invalid with 401
    Given the request carries a "Signature" header that does not verify against the receiver's public key
    When signature verification fails
    Then the VHL Sharer SHALL return HTTP 401 Unauthorized
    And the response SHALL include a FHIR OperationOutcome with issue.code "security"

  Scenario: VHL Sharer enforces signature timestamp freshness within ±2 minutes
    Given the "created" timestamp in the Signature-Input header is more than 2 minutes in the past
    When the timestamp is validated
    Then the VHL Sharer SHALL reject the request as a potential replay
    And the response SHALL be HTTP 401 Unauthorized

  Scenario: VHL Sharer accepts a request whose signature timestamp is within the ±2-minute window
    Given the "created" timestamp is within 2 minutes of the current server time
    When the timestamp is validated
    Then the VHL Sharer SHALL proceed with processing the request

  # ─── OAuth with FAST Option Verification (Optional) ──────────────────────────

  Scenario: VHL Sharer validates an OAuth Bearer token when FAST Option is supported
    Given the request includes an "Authorization: Bearer <token>" header
    And the VHL Sharer supports the OAuth with FAST Option
    When the token is validated
    Then the VHL Sharer SHALL verify the token's signature using the authorization server's public key
    And SHALL verify the token "exp" claim has not passed
    And SHALL verify the token "scope" includes "system/List.read"
    And SHALL verify the token "iss" is a trusted authorization server

  Scenario: VHL Sharer rejects an expired OAuth token with 401
    Given the Bearer token "exp" claim has passed
    When the token is validated
    Then the VHL Sharer SHALL return HTTP 401 Unauthorized

  Scenario: VHL Sharer rejects an OAuth token with insufficient scope with 401
    Given the Bearer token does not include "system/List.read"
    When the token scope is validated
    Then the VHL Sharer SHALL return HTTP 401 Unauthorized

  # ─── VHL Authorization ────────────────────────────────────────────────────────

  Scenario: VHL Sharer validates that the folder ID corresponds to a valid VHL
    Given the request body includes "_id=abc123def456"
    When the VHL Sharer performs authorization
    Then the VHL Sharer SHALL confirm that a valid VHL with that folder ID exists in its registry
    And SHALL return HTTP 403 Forbidden if no matching VHL is found

  Scenario: VHL Sharer rejects a request with an expired VHL
    Given the VHL associated with the folder ID has an expired CWT "exp" claim
    When the VHL Sharer checks the VHL expiry
    Then the VHL Sharer SHALL return HTTP 403 Forbidden

  Scenario: VHL Sharer rejects a request with a revoked VHL
    Given the VHL associated with the folder ID has been revoked
    When the VHL Sharer checks the revocation list
    Then the VHL Sharer SHALL return HTTP 403 Forbidden

  Scenario: VHL Sharer validates passcode when VHL P flag is set and passcode is provided
    Given the VHL requires a passcode (P flag present)
    And the request body includes "passcode=user-pin"
    When the passcode is validated
    Then the VHL Sharer SHALL compare the provided passcode against the stored hash using constant-time comparison
    And SHALL return HTTP 422 Unprocessable Entity if the passcode is incorrect

  Scenario: VHL Sharer rejects a request missing a required passcode with 422
    Given the VHL requires a passcode (P flag present)
    And the request body does NOT include a "passcode" parameter
    When the VHL Sharer processes the request
    Then the VHL Sharer SHALL return HTTP 422 Unprocessable Entity

  Scenario: VHL Sharer accepts a request with a correct passcode
    Given the VHL requires a passcode
    And the submitted passcode matches the stored hash
    When the passcode is validated
    Then the VHL Sharer SHALL proceed with executing the FHIR search

  # ─── FHIR Search Execution ────────────────────────────────────────────────────

  Scenario: VHL Sharer executes a FHIR search for the List resource matching the required parameters
    Given authentication and authorization have succeeded
    When the VHL Sharer executes the search
    Then the VHL Sharer SHALL search for a List resource matching "_id", "code", "status", and "patient.identifier"
    And SHALL apply VHL scope filters to include only documents authorized by the VHL

  Scenario: VHL Sharer returns HTTP 404 when no List resource matches the search parameters
    Given the FHIR search finds no List resource for the given "_id"
    When the search is executed
    Then the VHL Sharer SHALL return HTTP 404 Not Found
    And the response SHALL include a FHIR OperationOutcome with issue.code "not-found"

  Scenario: VHL Sharer includes DocumentReferences when Include DocumentReference Option is supported and _include is present
    Given the VHL Sharer supports the Include DocumentReference Option
    And the request includes "_include=List:item"
    When the FHIR search is executed
    Then the response Bundle SHALL include the matching List resource with search.mode="match"
    And SHALL include each referenced DocumentReference resource with search.mode="include"

  Scenario: VHL Sharer ignores _include parameter when Include DocumentReference Option is not supported
    Given the VHL Sharer does NOT support the Include DocumentReference Option
    And the request includes "_include=List:item"
    When the FHIR search is executed
    Then the VHL Sharer SHALL ignore the "_include" parameter
    And the response Bundle SHALL contain only the List resource

  # ─── Success Response Structure ───────────────────────────────────────────────

  Scenario: VHL Sharer returns HTTP 200 with a FHIR searchset Bundle on success
    Given the search has been executed successfully
    When the response is prepared
    Then the response SHALL be HTTP 200 OK
    And the response body SHALL be a FHIR Bundle with "type": "searchset"
    And the Content-Type SHALL be "application/fhir+json"

  Scenario: Bundle.total reflects the count of matching and included resources
    Given the Bundle contains one List and four DocumentReferences
    When the "total" element is set
    Then "Bundle.total" SHALL equal the combined count of matched and included resources

  Scenario: Bundle contains a self link reflecting the search URL
    Given the Bundle is being assembled
    When the "link" array is constructed
    Then it SHALL include a link with "relation": "self" and the search URL as the "url"

  Scenario: List resource entry in Bundle has search.mode set to match
    Given the List resource is added to the Bundle
    When the Bundle entry is created
    Then "entry[].search.mode" for the List resource SHALL be "match"

  Scenario: DocumentReference entries in Bundle have search.mode set to include
    Given DocumentReference resources are included in the Bundle
    When the Bundle entries are created
    Then each DocumentReference entry SHALL have "entry[].search.mode" equal to "include"

  # ─── Error Response Codes ────────────────────────────────────────────────────

  Scenario Outline: VHL Sharer returns the correct HTTP status code for each error condition
    Given the request triggers the "<error_condition>"
    When the VHL Sharer processes the request
    Then the response SHALL be "<http_status>"
    And the response body SHALL be a FHIR OperationOutcome

    Examples:
      | error_condition                                         | http_status                  |
      | Malformed request or missing required parameters        | 400 Bad Request              |
      | Signature verification failed or receiver not in list   | 401 Unauthorized             |
      | VHL expired, revoked, or does not authorize documents   | 403 Forbidden                |
      | List resource with specified _id not found              | 404 Not Found                |
      | Invalid or missing passcode                             | 422 Unprocessable Entity     |
      | Rate limit exceeded                                     | 429 Too Many Requests        |
      | Server-side internal error                              | 500 Internal Server Error    |

  # ─── Rate Limiting ────────────────────────────────────────────────────────────

  Scenario: VHL Sharer returns 429 when a receiver exceeds the allowed request rate
    Given the VHL Receiver has exceeded the rate limit for a given time window
    When the next request arrives
    Then the VHL Sharer SHALL return HTTP 429 Too Many Requests
    And the response SHALL include a FHIR OperationOutcome with issue.code "throttled"

  # ─── Audit Logging ────────────────────────────────────────────────────────────

  Scenario: VHL Sharer logs all document access requests including failed ones
    Given a Retrieve Manifest request has been processed (success or failure)
    When the audit event is recorded
    Then the VHL Sharer SHOULD log the receiver identity, folder ID, authentication method, authorization decision, and timestamp

  Scenario: VHL Sharer does not log the passcode in audit trails
    Given the request includes a passcode
    When the audit event is recorded
    Then the plaintext passcode SHALL NOT appear in any audit log entry
