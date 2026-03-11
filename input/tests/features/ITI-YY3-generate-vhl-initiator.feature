Feature: ITI-YY3 Generate VHL – VHL Holder Expected Actions
  As a VHL Holder (Initiator) requesting VHL generation,
  these scenarios verify the actions the VHL Holder MUST take when
  constructing the request, handling the passcode, and processing the response.
  Message format is defined in ITI-YY3-generate-vhl-message.feature.

  Background:
    Given the VHL Holder's client application is connected to the VHL Sharer service
    And the VHL Sharer base URL is "https://vhl-sharer.example.org"

  # ─── Request Construction ────────────────────────────────────────────────────

  @initiator-actions @SHALL
  Scenario: VHL Holder constructs a well-formed request with only the required parameter
    Given the patient identifier is "urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123"
    When the request URL is constructed with only the required parameter
    Then the URL SHALL be:
      """
      GET [base]/Patient/$generate-vhl?sourceIdentifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123
      """

  @initiator-actions @SHALL
  Scenario: VHL Holder includes P flag when providing a passcode
    Given the VHL Holder includes "passcode=secretpin" in the request
    When the request is assembled
    Then the "flag" parameter SHALL include "P"

  @initiator-actions @SHALL
  Scenario: VHL Holder rejects a label that exceeds 80 characters before sending
    Given the VHL Holder provides a label that is 81 characters long
    When the request is evaluated for completeness
    Then the request SHALL be considered invalid for the label parameter

  # ─── Passcode Handling ───────────────────────────────────────────────────────

  @initiator-actions @SHALL
  Scenario: VHL Holder securely stores the plaintext passcode after VHL generation
    Given the VHL Holder included a passcode in the $generate-vhl request
    When the VHL Sharer returns the QR code
    Then the VHL Holder SHALL securely store the plaintext passcode

  @initiator-actions @SHALL
  Scenario: VHL Holder uses secure transmission when sharing the passcode out-of-band
    Given the VHL Holder needs to communicate the passcode to an authorised VHL Receiver
    When the passcode is transmitted
    Then the VHL Holder SHALL use a secure out-of-band transmission method

  # ─── Pre-presentation Validity ───────────────────────────────────────────────

  @initiator-actions @SHALL
  Scenario: VHL Holder verifies the QR code has not expired before presenting it
    Given the VHL Holder has a QR code with a future CWT exp claim
    When the VHL Holder checks validity before presentation
    Then the QR code SHALL be considered valid for presentation

  @initiator-actions @SHALL
  Scenario: VHL Holder does not present an expired QR code
    Given the VHL Holder has a QR code whose CWT exp claim has already passed
    When the VHL Holder checks validity
    Then the VHL Holder SHALL NOT present the expired QR code
    And the VHL Holder SHOULD request a new VHL from the VHL Sharer
