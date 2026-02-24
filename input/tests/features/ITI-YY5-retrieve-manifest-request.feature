Feature: ITI-YY5 Retrieve Manifest Request
  As a VHL Receiver (Initiator)
  I want to send an authenticated FHIR search request to retrieve the document manifest
  So that I can discover available health documents referenced by a validated VHL

  Background:
    Given the VHL Receiver has successfully decoded and validated a VHL via ITI-YY4
    And the VHL Receiver has extracted the manifest URL and decryption key from the SHL payload
    And the VHL Receiver has its own private key and its public key is registered in the trust list

  # ─── HTTP Method and Endpoint ─────────────────────────────────────────────────

  Scenario: VHL Receiver sends an HTTP POST to the /List/_search endpoint
    Given the manifest URL is "https://vhl-sharer.example.org/List?_id=abc123&code=folder&status=current&patient.identifier=urn:oid:1.2.3|P123"
    When the VHL Receiver constructs the Retrieve Manifest request
    Then the request SHALL be an HTTP POST to "https://vhl-sharer.example.org/List/_search"

  Scenario: Request Content-Type is application/x-www-form-urlencoded
    Given the VHL Receiver is constructing the Retrieve Manifest request
    When the Content-Type header is set
    Then the header SHALL be "Content-Type: application/x-www-form-urlencoded"

  Scenario: Request Accept header is application/fhir+json
    Given the VHL Receiver is constructing the Retrieve Manifest request
    When the Accept header is set
    Then the header SHALL be "Accept: application/fhir+json"

  # ─── Required FHIR Search Parameters ─────────────────────────────────────────

  Scenario: Request body includes the _id parameter extracted from the manifest URL
    Given the manifest URL contains "_id=abc123def456"
    When the request body is assembled
    Then the body SHALL include "_id=abc123def456"

  Scenario: Request body includes the code parameter extracted from the manifest URL
    Given the manifest URL contains "code=folder"
    When the request body is assembled
    Then the body SHALL include "code=folder"

  Scenario: Request body includes the status parameter extracted from the manifest URL
    Given the manifest URL contains "status=current"
    When the request body is assembled
    Then the body SHALL include "status=current"

  Scenario: Request body includes at least one patient identification parameter
    Given the manifest URL contains "patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123"
    When the request body is assembled
    Then the body SHALL include either "patient=<reference>" or "patient.identifier=<system|value>"

  Scenario: Request body includes _include=List:item when present in manifest URL
    Given the manifest URL contains "_include=List%3Aitem"
    When the request body is assembled
    Then the body SHALL include "_include=List:item"

  # ─── Required SHL Parameters ──────────────────────────────────────────────────

  Scenario: Request body includes the recipient parameter
    Given the VHL Receiver is "Dr. Smith Hospital"
    When the SHL parameters are added to the request body
    Then the body SHALL include "recipient=Dr.+Smith+Hospital"

  Scenario: recipient parameter cardinality is [1..1]
    Given the VHL Receiver is constructing the request
    When the SHL parameters are validated
    Then exactly one "recipient" parameter SHALL be present

  Scenario: Request body includes passcode when VHL P flag is set
    Given the VHL payload "flag" contains "P"
    And the VHL Receiver has obtained the passcode "user-pin" from the VHL Holder
    When the SHL parameters are added to the request body
    Then the body SHALL include "passcode=user-pin"

  Scenario: Request body does not include passcode when VHL P flag is not set
    Given the VHL payload "flag" does NOT contain "P"
    When the SHL parameters are added to the request body
    Then the body SHALL NOT include a "passcode" parameter

  Scenario: Request body may include embeddedLengthMax as an optimization hint
    Given the VHL Receiver wants to limit embedded payload size to 10000 bytes
    When the optional SHL parameters are added
    Then the body MAY include "embeddedLengthMax=10000"

  # ─── HTTP Message Signatures (Required) ──────────────────────────────────────

  Scenario: Request includes a Content-Digest header with SHA-256 hash of the body
    Given the request body has been assembled
    When the Content-Digest header is computed
    Then the header SHALL be present in the format "Content-Digest: sha-256=<base64-encoded-hash>"
    And the hash SHALL be the SHA-256 digest of the raw request body bytes

  Scenario: Request includes a Signature-Input header with the correct components
    Given the VHL Receiver is creating the HTTP Message Signature
    When the Signature-Input header is constructed
    Then it SHALL list the signed components: "@method", "@path", "@authority", "content-type", "content-digest"
    And it SHALL include a "created" parameter with the current Unix timestamp
    And it SHALL include a "keyid" parameter identifying the receiver's public key in the trust list
    And it SHALL include an "alg" parameter specifying the signing algorithm

  Scenario: Request includes a Signature header with the computed signature
    Given the signature base has been constructed from the signed HTTP components
    When the signature is computed using the receiver's private key
    Then the request SHALL include a "Signature" header with the base64-encoded signature value

  Scenario Outline: Signature algorithm is one of the approved algorithms
    Given the VHL Receiver is choosing a signing algorithm
    When the "alg" parameter is set to "<algorithm>"
    Then the algorithm SHALL be accepted as a valid HTTP Message Signature algorithm

    Examples:
      | algorithm           |
      | ecdsa-p256-sha256   |
      | ecdsa-p384-sha384   |
      | rsa-pss-sha256      |
      | rsa-v1_5-sha256     |

  Scenario: keyid in Signature-Input uniquely identifies the receiver's public key in the trust list
    Given the VHL Receiver has a registered public key with id "receiver-key-123"
    When the Signature-Input header is set
    Then "keyid" SHALL equal "receiver-key-123"
    And that key SHALL be retrievable from the trust list

  Scenario: Signature timestamp (created) is included to prevent replay attacks
    Given the VHL Receiver is constructing the HTTP Message Signature
    When the "created" parameter is set
    Then the value SHALL be the current Unix timestamp at the time the signature was generated

  Scenario: Request is sent over HTTPS with TLS 1.2 or higher
    Given the VHL Receiver is establishing a connection to the VHL Sharer
    When the connection is made
    Then the connection SHALL use HTTPS with TLS 1.2 as a minimum
    And TLS 1.3 SHOULD be used for improved security

  # ─── OAuth with FAST Option (Optional) ───────────────────────────────────────

  Scenario: VHL Receiver may use OAuth client_credentials grant when FAST Option is supported
    Given both the VHL Receiver and VHL Sharer support the OAuth with FAST Option
    When the VHL Receiver authenticates using OAuth
    Then the grant type SHALL be "client_credentials"
    And the client authentication method SHALL be "private_key_jwt" (JWT client assertion)

  Scenario: JWT client assertion includes required claims for OAuth token request
    Given the VHL Receiver is constructing a JWT client assertion
    When the payload is assembled
    Then the JWT SHALL include "iss" (client identifier), "sub" (same as iss), "aud" (token endpoint), "exp", "iat", and "jti" claims

  Scenario: JWT client assertion jti claim is unique to prevent replay
    Given the VHL Receiver is creating a new JWT client assertion
    When the "jti" claim is set
    Then the value SHALL be a unique identifier not used in any prior assertion

  Scenario: OAuth access token request includes required FHIR scopes
    Given the VHL Receiver is requesting an access token
    When the scopes are specified
    Then the token request SHALL include at minimum "system/List.read" and "system/DocumentReference.read"

  Scenario: OAuth Bearer token is included in the Authorization header
    Given the VHL Receiver has obtained an access token
    When the Retrieve Manifest request is constructed using the OAuth option
    Then the request SHALL include "Authorization: Bearer <access-token>"

  # ─── Response Processing ─────────────────────────────────────────────────────

  Scenario: VHL Receiver identifies List resources in the response Bundle by search.mode=match
    Given the VHL Sharer has returned a searchset Bundle
    When the VHL Receiver processes the Bundle entries
    Then entries with "search.mode" equal to "match" SHALL be treated as List resources

  Scenario: VHL Receiver identifies DocumentReference resources by search.mode=include
    Given the VHL Sharer has returned a searchset Bundle with included DocumentReferences
    When the VHL Receiver processes the Bundle entries
    Then entries with "search.mode" equal to "include" SHALL be treated as included DocumentReference resources

  Scenario: VHL Receiver retrieves DocumentReferences individually when _include is not supported
    Given the response Bundle contains only the List resource (no included DocumentReferences)
    And the VHL Receiver had requested "_include=List:item"
    When the VHL Receiver processes the response
    Then the VHL Receiver SHALL retrieve each DocumentReference individually via separate read requests

  Scenario: VHL Receiver may cache OAuth access tokens for reuse until expiration
    Given the VHL Receiver has obtained an OAuth access token with a 3600-second lifetime
    When subsequent Retrieve Manifest requests are needed
    Then the VHL Receiver MAY reuse the access token until its "exp" claim is reached
