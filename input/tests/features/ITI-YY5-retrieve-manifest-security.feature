Feature: ITI-YY5 Retrieve Manifest – Security Considerations
  Security requirements for the Retrieve Manifest transaction, covering
  transport security, replay prevention, passcode protection, and audit logging.

  # ─── Transport Security ───────────────────────────────────────────────────────

  @security @SHALL
  Scenario: All Retrieve Manifest requests are sent over HTTPS with TLS 1.2 minimum
    Given the VHL Receiver is sending a Retrieve Manifest request
    When the connection is established
    Then the connection SHALL use HTTPS with TLS 1.2 as a minimum
    And TLS 1.3 SHOULD be used

  # ─── Replay Prevention ───────────────────────────────────────────────────────

  @security @SHALL
  Scenario: Signature timestamp prevents replay attacks older than 2 minutes
    Given a Retrieve Manifest request is received with an HTTP Message Signature
    When the "created" timestamp in Signature-Input is evaluated
    Then the VHL Sharer SHALL reject any request whose "created" timestamp is more than 2 minutes old

  @security @SHALL
  Scenario: OAuth JWT client assertion jti prevents replay
    Given the VHL Receiver has sent a JWT client assertion
    When the "jti" claim is evaluated
    Then the authorization server SHALL reject any assertion whose "jti" has been seen before

  # ─── Passcode Protection ─────────────────────────────────────────────────────

  @security @SHALL
  Scenario: VHL Sharer uses constant-time comparison for passcode validation
    Given the VHL requires a passcode
    When the submitted passcode is validated against the stored hash
    Then the VHL Sharer SHALL use constant-time comparison to prevent timing attacks

  @security @SHALL
  Scenario: Passcode is never logged in audit trails
    Given a Retrieve Manifest request includes a passcode
    When the audit event is recorded
    Then the plaintext passcode SHALL NOT appear in any audit log entry

  # ─── Authentication Enforcement ──────────────────────────────────────────────

  @security @SHALL
  Scenario: VHL Sharer only serves manifests to receivers whose public key is in the trust list
    Given a Retrieve Manifest request is received
    When the VHL Sharer verifies the receiver's identity
    Then only a receiver whose public key is present in the current trust list SHALL be served
    And requests from unknown or untrusted receivers SHALL be rejected with HTTP 401

  # ─── Audit Logging ───────────────────────────────────────────────────────────

  @security @SHOULD
  Scenario: VHL Sharer logs all manifest access attempts including failures
    Given any Retrieve Manifest request is processed
    When the audit event is written
    Then the log SHOULD include receiver identity, folder ID, authentication method, authorization result, and timestamp

  @security @SHALL
  Scenario: VHL Sharer does not log the plaintext passcode
    Given a request includes a passcode
    When the audit event is written
    Then the plaintext passcode SHALL NOT appear in the log entry
