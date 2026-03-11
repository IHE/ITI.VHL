Feature: ITI-YY5 Retrieve Manifest – VHL Receiver Expected Actions
  As a VHL Receiver (Initiator) retrieving the document manifest,
  these scenarios verify the actions the VHL Receiver MUST take when constructing
  the authenticated request, handling OAuth (FAST Option), and processing the response.
  Message format is defined in ITI-YY5-retrieve-manifest-message.feature.

  Background:
    Given the VHL Receiver has decoded and validated a VHL via ITI-YY4
    And the VHL Receiver has extracted the manifest URL and decryption key from the SHL payload
    And the VHL Receiver has its own private key registered in the trust list

  # ─── Request Construction ────────────────────────────────────────────────────

  @initiator-actions @SHALL
  Scenario: VHL Receiver sends an HTTP POST to the /List/_search endpoint
    When the Retrieve Manifest request is constructed
    Then the request SHALL be HTTP POST to the /List/_search endpoint derived from the manifest URL

  @initiator-actions @SHALL
  Scenario: Request is sent over HTTPS with TLS 1.2 minimum
    When the connection to the VHL Sharer is established
    Then the connection SHALL use HTTPS with TLS 1.2 as a minimum
    And TLS 1.3 SHOULD be used for improved security

  # ─── HTTP Message Signature ───────────────────────────────────────────────────

  @initiator-actions @SHALL
  Scenario: VHL Receiver signs the request using HTTP Message Signatures per RFC 9421
    When the request is assembled
    Then the request SHALL include Content-Digest, Signature-Input, and Signature headers per RFC 9421

  @initiator-actions @SHALL
  Scenario: keyid in Signature-Input uniquely identifies the receiver's public key in the trust list
    Given the VHL Receiver has a registered public key with id "receiver-key-123"
    When the Signature-Input header is constructed
    Then "keyid" SHALL equal "receiver-key-123"
    And that key SHALL be retrievable from the trust list

  @initiator-actions @SHALL
  Scenario: Signature timestamp is set to the current Unix time to prevent replay attacks
    When the "created" parameter of Signature-Input is set
    Then the value SHALL be the current Unix timestamp at time of signing

  # ─── OAuth with FAST Option (Optional) ───────────────────────────────────────

  @initiator-actions @MAY
  Scenario: VHL Receiver may use OAuth client_credentials grant when FAST Option is supported
    Given both the VHL Receiver and VHL Sharer support the OAuth with FAST Option
    When the VHL Receiver authenticates using OAuth
    Then the grant type SHALL be "client_credentials"
    And the client authentication method SHALL be "private_key_jwt"

  @initiator-actions @SHALL
  Scenario: JWT client assertion includes all required claims
    Given the VHL Receiver is constructing a JWT client assertion
    When the payload is assembled
    Then the JWT SHALL include "iss", "sub" (same as iss), "aud" (token endpoint), "exp", "iat", and "jti" claims

  @initiator-actions @SHALL
  Scenario: JWT client assertion jti claim is unique to prevent replay
    When the "jti" claim is set
    Then the value SHALL be a unique identifier not used in any prior assertion

  @initiator-actions @SHALL
  Scenario: OAuth token request includes required FHIR scopes
    When the scopes are specified in the token request
    Then the request SHALL include at minimum "system/List.read" and "system/DocumentReference.read"

  @initiator-actions @SHALL
  Scenario: OAuth Bearer token is included in the Authorization header
    Given the VHL Receiver has obtained an access token via the FAST Option
    When the Retrieve Manifest request is constructed
    Then the request SHALL include "Authorization: Bearer <access-token>"

  @initiator-actions @MAY
  Scenario: VHL Receiver may cache OAuth access tokens for reuse until expiration
    Given the VHL Receiver has obtained an OAuth access token with a lifetime
    When subsequent Retrieve Manifest requests are needed within that lifetime
    Then the VHL Receiver MAY reuse the access token until its "exp" claim is reached

  # ─── Response Processing ─────────────────────────────────────────────────────

  @initiator-actions @SHALL
  Scenario: VHL Receiver identifies List resources in the response Bundle by search.mode=match
    Given the VHL Sharer has returned a searchset Bundle
    When the VHL Receiver processes the Bundle entries
    Then entries with "search.mode" equal to "match" SHALL be treated as List resources

  @initiator-actions @SHALL
  Scenario: VHL Receiver identifies included DocumentReferences by search.mode=include
    Given the response Bundle contains included DocumentReferences
    When the VHL Receiver processes the Bundle entries
    Then entries with "search.mode" equal to "include" SHALL be treated as DocumentReference resources

  @initiator-actions @SHALL
  Scenario: VHL Receiver retrieves DocumentReferences individually when _include is unsupported by the responder
    Given the response Bundle contains only the List resource despite the _include parameter being sent
    When the VHL Receiver processes the response
    Then the VHL Receiver SHALL retrieve each DocumentReference individually via separate read requests
