Feature: ITI-YY4 Provide VHL Response
  As a VHL Receiver (Responder)
  I want to scan, decode, and validate a QR code presented by a VHL Holder
  So that I can extract the VHL payload and subsequently retrieve the referenced health documents

  Background:
    Given the VHL Receiver has a QR code scanner (camera or software library)
    And the VHL Receiver has access to the trust list (obtained via ITI-YY2)

  # ─── Step 1: Scan QR Code ─────────────────────────────────────────────────────

  Scenario: VHL Receiver scans a QR code displayed on screen or printed on paper
    Given a QR code is presented by the VHL Holder
    When the VHL Receiver scans the QR code
    Then the QR code SHALL be decoded per ISO/IEC 18004:2015 in Alphanumeric mode
    And the full encoded string SHALL be extracted

  Scenario: VHL Receiver provides visual feedback during scanning
    Given the VHL Receiver's scanning application is active
    When scanning is in progress
    Then the application SHALL provide visual feedback to the user during the scanning process

  # ─── Step 2: Verify HC1: Context Identifier ──────────────────────────────────

  Scenario: VHL Receiver accepts a QR code that begins with HC1: prefix
    Given the decoded QR code string begins with "HC1:"
    When the context identifier is verified
    Then the VHL Receiver SHALL proceed to Base45 decoding after removing the "HC1:" prefix

  Scenario: VHL Receiver rejects a QR code that does not begin with HC1: prefix
    Given the decoded QR code string does NOT begin with "HC1:"
    When the context identifier is checked
    Then the VHL Receiver SHALL reject the QR code
    And the VHL Receiver SHALL inform the user that the QR code is not a valid VHL

  # ─── Step 3: Base45 Decode ───────────────────────────────────────────────────

  Scenario: VHL Receiver successfully Base45-decodes the payload after removing HC1: prefix
    Given the HC1: prefix has been removed from the QR code string
    When Base45 decoding is applied
    Then the result SHALL be a compressed byte array
    And decoding errors SHALL be caught and reported to the user

  # ─── Step 4: ZLIB/DEFLATE Decompress ─────────────────────────────────────────

  Scenario: VHL Receiver decompresses the Base45-decoded bytes using ZLIB/DEFLATE
    Given the Base45-decoded byte array is available
    When ZLIB (RFC 1950) with DEFLATE (RFC 1951) decompression is applied
    Then the result SHALL be a CBOR-encoded CWT structure
    And decompression errors SHALL be caught and reported

  # ─── Step 5: Parse CBOR Web Token (CWT) ──────────────────────────────────────

  Scenario: VHL Receiver parses the decompressed bytes as a CBOR Web Token
    Given the decompressed bytes are available
    When the CWT is parsed per RFC 8392
    Then the protected header SHALL be extracted and SHALL contain "alg" and "kid" fields
    And the CWT claims payload SHALL be extracted

  Scenario: CWT protected header alg field is ES256 or PS256
    Given the CWT protected header is extracted
    When the "alg" field is inspected
    Then the value SHALL be "ES256" or "PS256"

  Scenario: CWT protected header kid field is 8 bytes (truncated SHA-256 of DSC)
    Given the CWT protected header is extracted
    When the "kid" field is inspected
    Then the value SHALL be 8 bytes representing the truncated SHA-256 fingerprint of the Document Signing Certificate

  # ─── Step 6: Verify Digital Signature ────────────────────────────────────────

  Scenario: VHL Receiver retrieves the DSC from the trust list using the kid
    Given the "kid" has been extracted from the CWT protected header
    When the VHL Receiver looks up the DSC
    Then the VHL Receiver SHALL retrieve the corresponding DSC from the trust list using that "kid"
    And SHALL reject the VHL if no matching DSC is found in the trust list

  Scenario: VHL Receiver verifies the COSE signature using the DSC public key
    Given the DSC has been retrieved from the trust list
    When the COSE signature (RFC 8152) is verified
    Then the signature SHALL be validated against the DSC public key
    And the VHL Receiver SHALL reject the VHL if the signature is invalid

  Scenario: VHL Receiver rejects a VHL with an invalid COSE signature
    Given the CWT has a COSE signature that does not verify against the DSC
    When signature verification is performed
    Then the VHL Receiver SHALL reject the VHL
    And the VHL Receiver SHALL NOT attempt to retrieve documents
    And the VHL Receiver SHOULD inform the user or operator of the failure
    And the VHL Receiver MAY log the failed verification event

  Scenario: VHL Receiver rejects a VHL whose DSC is not in the trust list
    Given the "kid" in the CWT does not match any DSC in the trust list
    When the DSC lookup is performed
    Then the VHL Receiver SHALL reject the VHL as untrusted
    And the VHL Receiver SHALL NOT attempt to retrieve documents

  # ─── Step 7: Extract and Validate CWT Claims ─────────────────────────────────

  Scenario: VHL Receiver extracts the exp claim and rejects an expired VHL
    Given the CWT "exp" claim (claim key 4) is present
    When the current time is past the exp value
    Then the VHL Receiver SHALL reject the VHL as expired
    And the VHL Receiver SHOULD inform the user to request a new VHL from the VHL Holder

  Scenario: VHL Receiver extracts the exp claim and accepts a non-expired VHL
    Given the CWT "exp" claim is set to a future timestamp
    When the current time is before the exp value
    Then the VHL Receiver SHALL accept the VHL as not expired

  Scenario: VHL Receiver validates that the iat claim is not in the future
    Given the CWT "iat" claim (claim key 6) is present
    When the iat value is compared to the current time
    Then the VHL Receiver SHALL reject the VHL if "iat" is in the future

  Scenario: VHL Receiver extracts the hcert claim from the CWT
    Given the CWT claims have been parsed
    When the "hcert" claim (claim key -260) is extracted
    Then it SHALL contain an object with at least claim key 5

  # ─── Step 8: Extract SHL Payload from HCERT ──────────────────────────────────

  Scenario: VHL Receiver extracts the SHL payload from claim key 5 within the hcert
    Given the hcert claim (claim key -260) has been extracted
    When claim key 5 is accessed within the hcert object
    Then the result SHALL be the SHL payload object

  Scenario: VHL Receiver rejects a VHL with a missing hcert claim
    Given the CWT does not contain the "hcert" claim (claim key -260)
    When the VHL Receiver processes the CWT
    Then the VHL Receiver SHALL reject the VHL
    And the VHL Receiver SHALL NOT attempt to retrieve documents

  Scenario: VHL Receiver rejects a VHL with a missing SHL payload at claim key 5
    Given the hcert claim is present but claim key 5 is absent
    When the VHL Receiver processes the HCERT
    Then the VHL Receiver SHALL reject the VHL

  # ─── Step 9: Validate SHL Payload ────────────────────────────────────────────

  Scenario: VHL Receiver validates that the url field is present and is a valid HTTPS URL
    Given the SHL payload has been extracted
    When the "url" field is validated
    Then the field SHALL be present
    And the value SHALL be a valid HTTPS URL

  Scenario: VHL Receiver validates that the key field is present and is 43 characters
    Given the SHL payload has been extracted
    When the "key" field is validated
    Then the field SHALL be present
    And the value SHALL be exactly 43 characters of valid base64url encoding

  Scenario: VHL Receiver rejects a VHL whose SHL payload exp has passed
    Given the SHL payload contains an "exp" field set to a past timestamp
    When the SHL payload expiry is checked
    Then the VHL Receiver SHALL reject the VHL

  Scenario Outline: VHL Receiver correctly interprets flag values
    Given the SHL payload "flag" field is "<flag>"
    When the VHL Receiver processes the flags
    Then the VHL Receiver SHALL interpret the flag as "<meaning>"

    Examples:
      | flag | meaning                                           |
      | L    | Long-term use - VHL intended for repeated access  |
      | P    | Passcode required - must obtain from VHL Holder   |
      | LP   | Long-term use and passcode required               |
      | U    | Direct file access                                |

  Scenario: VHL Receiver prompts for passcode when P flag is present
    Given the SHL payload "flag" contains "P"
    When the VHL Receiver processes the payload
    Then the VHL Receiver SHALL obtain the passcode from the VHL Holder before proceeding

  # ─── Post-Decoding Actions ────────────────────────────────────────────────────

  Scenario: VHL Receiver stores the decryption key securely in memory for the session
    Given the SHL payload has been successfully validated
    When the "key" is stored
    Then the VHL Receiver SHALL store it securely in session memory
    And the key SHALL be available for document decryption during ITI-YY6

  Scenario: VHL Receiver parses the manifest URL to extract FHIR search parameters
    Given the "url" field from the SHL payload is available
    When the manifest URL is parsed
    Then the VHL Receiver SHALL extract "_id", "code", "status", and "patient.identifier" parameters
    And SHALL note whether "_include=List:item" is present

  Scenario: VHL Receiver prepares a 3-part multipart structure for the subsequent ITI-YY5 request
    Given the manifest URL and SHL parameters are ready
    When the VHL Receiver prepares for ITI-YY5
    Then Part 1 (fhir-parameters) SHALL contain the FHIR search parameters from the manifest URL
    And Part 2 (shl-parameters) SHALL contain "recipient" and "passcode" (if P flag) and optionally "embeddedLengthMax"
    And Part 3 (signature) SHALL optionally contain a digital signature over Parts 1 and 2

  # ─── Error Handling (all decode failures) ────────────────────────────────────

  Scenario Outline: VHL Receiver rejects and reports any QR decode failure
    Given a QR code decoding step fails with error "<error_type>"
    When the VHL Receiver handles the error
    Then the VHL Receiver SHALL reject the VHL
    And the VHL Receiver SHALL inform the user with a meaningful error message
    And the VHL Receiver SHALL NOT attempt to retrieve documents

    Examples:
      | error_type                      |
      | QR code unreadable or damaged   |
      | Base45 decode error             |
      | ZLIB decompression error        |
      | CBOR parse error                |
      | Invalid CWT structure           |

  # ─── Optional Acknowledgment ─────────────────────────────────────────────────

  Scenario: VHL Receiver may send an optional acknowledgment to the VHL Holder
    Given the VHL has been successfully decoded and validated
    When the VHL Receiver sends acknowledgment (if supported)
    Then the acknowledgment SHALL NOT include any sensitive health information
    And the acknowledgment MAY include a receipt identifier, receiver identifier, and timestamp

  Scenario: VHL Holder does not rely on acknowledgment for security decisions
    Given the VHL Receiver has sent or not sent an acknowledgment
    When the VHL Holder receives or does not receive it
    Then the VHL Holder SHALL NOT use the presence or absence of acknowledgment to make security decisions
