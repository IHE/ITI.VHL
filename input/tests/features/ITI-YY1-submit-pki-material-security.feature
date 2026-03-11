Feature: ITI-YY1 Submit PKI Material – Security Considerations
  These scenarios correspond to section 2:3.YY1.5 (Security Considerations) of the
  ITI-YY1 transaction specification. They apply to both submitting actors
  (VHL Sharer, VHL Receiver) and the Trust Anchor and are tested independently
  of functional message or action compliance.

  # ─── §2:3.YY1.5.1 DID Document Integrity ───────────────────────────────────

  @security @SHOULD
  Scenario: Submitting entity signs the DID Document using its own verification method
    Given the submitting entity has a private signing key
    When the DID Document is finalised for submission
    Then the DID Document SHOULD be signed by the submitting entity using its verification method

  @security @SHALL
  Scenario: Trust Anchor verifies the authenticity of submitted DID Documents
    Given the Trust Anchor has received a DID Document submission
    When the Trust Anchor processes the submission
    Then the Trust Anchor SHALL verify the authenticity of the DID Document

  @security @SHALL
  Scenario: HTTP submissions use a secure TLS connection
    Given a DID Document is being submitted via HTTP POST
    When the connection is established
    Then the connection SHALL use TLS
    And plain HTTP SHALL NOT be used

  # ─── §2:3.YY1.5.2 Key Material Security ────────────────────────────────────

  @security @SHALL
  Scenario: Only the public key is included in the submitted DID Document
    Given the submitting entity has a key pair
    When the DID Document is constructed
    Then only the public key SHALL be present in the DID Document
    And the private key SHALL NOT be included in any form

  @security @SHALL
  Scenario: Submitting entity stores private keys with appropriate access controls
    Given the submitting entity has generated a key pair for submission
    When the private key is stored after submission
    Then the private key SHALL be stored with appropriate access controls
    And it SHALL NOT be accessible to unauthorised parties

  @security @SHOULD
  Scenario: Key material meets minimum cryptographic strength EC P-256 or stronger
    Given a key pair is generated for inclusion in a DID Document
    When the key strength is evaluated
    Then the key SHOULD meet minimum cryptographic strength (EC P-256 or stronger)

  # ─── §2:3.YY1.5.3 Identity Verification ────────────────────────────────────

  @security @SHALL
  Scenario: Trust Anchor authenticates the identity of every submitting entity
    Given a DID Document submission is received
    When the Trust Anchor evaluates the submission
    Then the Trust Anchor SHALL authenticate the identity of the submitting entity

  @security @MAY
  Scenario: Trust Anchor may authenticate using pre-registered certificates
    Given the Trust Anchor is authenticating a submitter
    When pre-registered certificates are available for that submitter
    Then the Trust Anchor MAY authenticate using those certificates over the secure connection

  @security @MAY
  Scenario: Trust Anchor may use out-of-band identity verification for initial registration
    Given a submitter is registering for the first time and no prior credentials exist
    When the Trust Anchor performs identity verification
    Then the Trust Anchor MAY use out-of-band identity verification

  # ─── §2:3.YY1.5.4 DID Document Validation ──────────────────────────────────

  @security @SHALL
  Scenario: Trust Anchor rejects cryptographic algorithms not on the approved list
    Given a DID Document is submitted with an algorithm that is not approved
    When the Trust Anchor validates the submission
    Then the Trust Anchor SHALL reject the submission

  @security @SHALL
  Scenario: Verification methods intended for signing are referenced in authentication or assertionMethod
    Given a DID Document includes verification methods intended for signing
    When the Trust Anchor validates the DID Document
    Then each such method SHALL be referenced in "authentication" or "assertionMethod"

  # ─── §2:3.YY1.5.5 Revocation and Updates ───────────────────────────────────

  @security @SHALL
  Scenario: Revoked or expired DID Documents are never distributed
    Given a DID Document in the registry has been revoked or has expired
    When any participant requests that DID Document
    Then the Trust Anchor SHALL NOT distribute it

  @security @MAY
  Scenario: Trust Anchor may maintain a version history of DID Documents for audit purposes
    Given multiple versions of a DID Document exist over time
    When an audit query is received
    Then the Trust Anchor MAY provide a history of DID Document versions
