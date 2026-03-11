Feature: ITI-YY2 Retrieve Trust List – Security Considerations
  These scenarios correspond to the security considerations for ITI-YY2
  and apply to both the initiator (VHL Sharer, VHL Receiver) and the Trust Anchor.

  # ─── Transport Security ───────────────────────────────────────────────────────

  @security @SHALL
  Scenario: All Retrieve Trust List requests are sent over TLS
    Given a requester is sending a Retrieve Trust List request
    When the connection is established
    Then the connection SHALL use TLS 1.3 or equivalent
    And the request SHALL NOT be sent over plain HTTP

  # ─── Response Integrity ───────────────────────────────────────────────────────

  @security @SHALL
  Scenario: Initiator verifies the Trust Anchor response signature before trusting the content
    Given the Trust Anchor has signed its response
    When the initiator receives the response
    Then the initiator SHALL verify the response signature before applying the DID Documents to trust decisions

  @security @MAY
  Scenario: Trust Anchor may sign responses to allow integrity verification by initiators
    Given the Trust Anchor has a signing key
    When it returns a Retrieve Trust List response
    Then the Trust Anchor MAY digitally sign the response payload

  # ─── Access Control ───────────────────────────────────────────────────────────

  @security @SHALL
  Scenario: Trust Anchor restricts retrieval to authenticated and authorised participants
    Given a retrieval request is received
    When the Trust Anchor applies access control
    Then only authenticated and authorised trust network participants SHALL receive DID Documents

  # ─── Revocation Propagation ───────────────────────────────────────────────────

  @security @SHALL
  Scenario: Revoked DID Documents are never included in retrieval responses
    Given a DID Document has been revoked
    When any requester queries the trust list
    Then the revoked DID Document SHALL NOT appear in any response

  @security @SHALL
  Scenario: Initiator invalidates cached material immediately upon revocation notification
    Given the initiator has cached key material from the trust list
    When a revocation notification is received
    Then the initiator SHALL immediately remove the revoked entry from its cache
    And SHALL NOT use that key material in any subsequent trust decision
