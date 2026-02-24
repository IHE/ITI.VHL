Feature: ITI-YY4 Provide VHL Request
  As a VHL Holder (Initiator)
  I want to present a signed VHL QR code to a VHL Receiver
  So that the receiver can retrieve my health documents from the VHL Sharer

  Background:
    Given the VHL Holder has a valid VHL QR code obtained from a VHL Sharer via ITI-YY3
    And the VHL Holder is in the presence of or connected to a VHL Receiver

  # ─── Pre-transmission Validity Checks ────────────────────────────────────────

  Scenario: VHL Holder verifies the QR code has not expired before presenting it
    Given the VHL Holder has a QR code with CWT exp claim 1735689600
    And the current time is before 1735689600
    When the VHL Holder checks validity before presentation
    Then the QR code SHALL be considered valid for presentation

  Scenario: VHL Holder does not present an expired QR code
    Given the VHL Holder has a QR code with CWT exp claim that has already passed
    When the VHL Holder checks validity
    Then the VHL Holder SHALL NOT present the expired QR code to the VHL Receiver
    And the VHL Holder SHOULD request a new VHL from the VHL Sharer

  Scenario: VHL Holder verifies the CWT signature is intact before presentation
    Given the VHL Holder has a QR code
    When the VHL Holder validates the QR code prior to presentation
    Then the CWT COSE signature SHALL be verified as valid

  # ─── QR Code Transmission Characteristics ────────────────────────────────────

  Scenario: QR code is encoded as HCERT with HC1: prefix
    Given the VHL Holder is presenting the QR code
    When the QR code content is inspected
    Then the content SHALL begin with the prefix "HC1:"
    And the remainder SHALL be a valid HCERT/CWT ZLIB+Base45 encoded payload

  Scenario: QR code is displayed at appropriate size for reliable scanning
    Given the VHL Holder is displaying the QR code on a device screen
    When the QR code is rendered
    Then the diagonal size SHALL be at least 35mm and not exceed 60mm for physical display

  Scenario: QR code is suitable for camera scanning without distortion
    Given the VHL Holder is presenting the QR code
    When the QR code is displayed or printed
    Then the QR code SHALL be in a format and condition suitable for camera scanning

  # ─── Passcode Handling ───────────────────────────────────────────────────────

  Scenario: VHL Holder provides passcode out-of-band when P flag is present
    Given the VHL has a "flag" containing "P"
    When the VHL Holder presents the QR code to the VHL Receiver
    Then the VHL Holder SHALL provide the plaintext passcode to the VHL Receiver through a separate secure channel

  Scenario: VHL Holder does not embed the passcode in the QR code
    Given the VHL Holder has a passcode-protected VHL
    When the QR code is inspected
    Then the plaintext passcode SHALL NOT be present anywhere in the QR code content

  Scenario: VHL Holder uses secure transmission when sharing the passcode
    Given the VHL Holder needs to communicate the passcode to the VHL Receiver
    When the passcode is transmitted
    Then the VHL Holder SHALL use a secure out-of-band transmission method

  # ─── Post-presentation Optional Actions ──────────────────────────────────────

  Scenario: VHL Holder may maintain a record of QR code presentations
    Given the VHL Holder has presented the QR code to a VHL Receiver
    When the presentation is complete
    Then the VHL Holder MAY record the presentation event (timestamp, receiver identity)

  Scenario: VHL Holder may revoke VHL access if supported by the VHL Sharer
    Given the VHL Holder no longer wishes to grant access
    When the VHL Holder initiates a revocation
    Then the VHL Holder MAY contact the VHL Sharer to revoke the VHL if that capability is supported

  # ─── VHL Content Requirements (Holder-side validation) ───────────────────────

  Scenario: VHL does not contain protected health information (PHI)
    Given the VHL Holder is about to present the QR code
    When the QR code payload is inspected
    Then the QR code SHALL NOT contain any PHI
    And the QR code SHALL contain only a reference URL and authorization metadata

  Scenario: VHL payload includes a url field pointing to the manifest endpoint
    Given the VHL Holder has decoded the SHL payload from the HCERT
    When the payload is inspected
    Then the "url" field SHALL be present and SHALL be a valid HTTPS URL

  Scenario: VHL payload includes a base64url-encoded decryption key of exactly 43 characters
    Given the VHL Holder has decoded the SHL payload
    When the "key" field is inspected
    Then the "key" field SHALL be present
    And the value SHALL be exactly 43 characters of valid base64url encoding
