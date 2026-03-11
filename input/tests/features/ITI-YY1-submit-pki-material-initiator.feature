Feature: ITI-YY1 Submit PKI Material – Initiator Expected Actions
  As a VHL Sharer or VHL Receiver (Initiator) submitting PKI material to the Trust Anchor,
  these scenarios verify the actions the initiator MUST take when generating keys,
  constructing and submitting the DID Document, handling responses, and retaining private keys.
  Message structure conformance is defined in ITI-YY1-submit-pki-material-message.feature.

  Background:
    Given the initiator is a VHL Sharer or VHL Receiver
    And the Trust Anchor endpoint is "https://trust-anchor.example.org/did"

  # ─── Key Generation ─────────────────────────────────────────────────────────

  @initiator-actions @SHALL
  Scenario: Initiator generates a cryptographic key pair using a CSPRNG
    Given the initiator is preparing a PKI submission
    When a key pair is generated
    Then it SHALL be produced by a cryptographically secure random number generator

  # ─── Submission Pathway: Direct HTTP POST ───────────────────────────────────

  @initiator-actions @SHALL
  Scenario: Initiator submits the DID Document via HTTP POST over a secure connection
    Given the initiator has constructed a conforming DID Document
    When the initiator submits via the direct pathway
    Then the DID Document SHALL be sent as an HTTP POST to "[trust-anchor-base]/did"
    And the connection SHALL use TLS

  # ─── Submission Pathway: Indirect Publication ───────────────────────────────

  @initiator-actions @SHALL
  Scenario: Indirect submission publishes the DID Document at a well-known URL and notifies the Trust Anchor
    Given the initiator has chosen the "Indirect Publication" submission pathway
    When the DID Document is published
    Then the DID Document SHALL be made available at a well-known, resolvable URL
    And the Trust Anchor SHALL be notified of the publication URL

  # ─── Submission Pathway: Offline Submission ─────────────────────────────────

  @initiator-actions @SHALL
  Scenario: Offline submission delivers DID Document on secure physical media during a verified encounter
    Given the initiator has chosen the "Offline Submission" pathway
    When the initiator prepares the submission
    Then the DID Document SHALL be delivered on secure physical media
    And the submission SHALL occur during a verified in-person encounter with formal identity attestation

  # ─── Provenance Metadata ────────────────────────────────────────────────────

  @initiator-actions @SHOULD
  Scenario: Submission includes the asserted identity of the submitting entity
    Given the initiator is preparing provenance metadata
    When the submission is assembled
    Then the submission SHOULD include the asserted identity of the submitting entity

  @initiator-actions @SHOULD
  Scenario: Submission includes a proof of authenticity
    Given the initiator supports digital signing
    When the DID Document is finalised
    Then the submission SHOULD include a digital signature or proof establishing authenticity

  @initiator-actions @SHOULD
  Scenario: Submission includes expiry date or revocation reference when the key has a known lifetime
    Given the initiator knows the intended lifetime of the key
    When provenance metadata is assembled
    Then the submission SHOULD include an expiry date or a reference to a revocation mechanism

  # ─── Response Handling ──────────────────────────────────────────────────────

  @initiator-actions @SHALL
  Scenario: Initiator records PKI material acceptance on HTTP 201
    Given a valid DID Document has been submitted
    When the Trust Anchor returns HTTP 201 Created
    Then the initiator SHALL record that the PKI material has been accepted and is available for distribution

  @initiator-actions @SHALL
  Scenario: Initiator corrects DID Document structure and resubmits on HTTP 400
    Given the Trust Anchor returns HTTP 400 Bad Request
    When the initiator handles the error
    Then the initiator SHALL correct the DID Document structure and resubmit

  @initiator-actions @SHALL
  Scenario: Initiator resolves authentication issue before retrying on HTTP 401
    Given the Trust Anchor returns HTTP 401 Unauthorized
    When the initiator handles the error
    Then the initiator SHALL resolve the authentication issue before retrying

  @initiator-actions @SHALL
  Scenario: Initiator resolves authorization issue before retrying on HTTP 403
    Given the Trust Anchor returns HTTP 403 Forbidden
    When the initiator handles the error
    Then the initiator SHALL resolve the authorization issue before retrying

  @initiator-actions @SHALL
  Scenario: Initiator reviews validation failure and resubmits with corrected material on HTTP 422
    Given the Trust Anchor returns HTTP 422 Unprocessable Entity
    When the initiator handles the error
    Then the initiator SHALL review the validation failure details and resubmit with corrected key material

  # ─── Private Key Retention ──────────────────────────────────────────────────

  @initiator-actions @SHALL
  Scenario: Initiator retains private keys securely regardless of submission outcome
    Given the initiator has submitted a DID Document
    When the submission is complete (success or failure)
    Then the initiator SHALL retain the corresponding private keys in secure storage
    And the private keys SHALL NOT be accessible to unauthorised parties
