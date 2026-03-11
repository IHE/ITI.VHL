Feature: ITI-YY4 Provide VHL – Security Considerations
  Security requirements for the Provide VHL transaction, covering signature
  verification, trust list enforcement, PHI exclusion, and acknowledgment safety.

  # ─── Signature Verification ───────────────────────────────────────────────────

  @security @SHALL
  Scenario: VHL Receiver verifies the COSE signature before trusting the VHL payload
    Given the VHL Receiver has decoded the CWT
    When the signature is evaluated
    Then the VHL Receiver SHALL verify the COSE signature before trusting any SHL payload fields
    And SHALL reject the VHL if verification fails

  @security @SHALL
  Scenario: VHL Receiver only trusts signatures made by a DSC present in the trust list
    Given the CWT contains a "kid" identifying the signing DSC
    When the DSC is looked up
    Then only a DSC present in the current trust list SHALL be accepted
    And any VHL signed by an unknown or revoked DSC SHALL be rejected

  # ─── Expiry Enforcement ───────────────────────────────────────────────────────

  @security @SHALL
  Scenario: VHL Receiver enforces the CWT exp claim strictly
    Given the CWT exp claim is present
    When the VHL is presented
    Then the VHL Receiver SHALL reject the VHL if the current time is at or past the exp value

  @security @SHALL
  Scenario: VHL Holder does not present an expired QR code
    Given the VHL Holder has a QR code whose exp has passed
    When the VHL Holder checks validity before presentation
    Then the VHL Holder SHALL NOT present the expired QR code

  # ─── PHI Exclusion ───────────────────────────────────────────────────────────

  @security @SHALL
  Scenario: QR code payload contains no PHI
    When the QR code payload is inspected
    Then it SHALL NOT contain any protected health information
    And it SHALL contain only the SHL payload reference URL and authorization metadata

  # ─── Acknowledgment Safety ───────────────────────────────────────────────────

  @security @SHALL
  Scenario: Optional acknowledgment does not disclose sensitive health information
    Given the VHL Receiver sends an acknowledgment
    When the acknowledgment is inspected
    Then it SHALL NOT include any sensitive health information
    And it SHALL NOT be used as a security gate by the VHL Holder
