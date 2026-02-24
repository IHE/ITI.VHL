Feature: ITI-YY3 Generate VHL Request
  As a VHL Holder (Initiator)
  I want to request VHL generation from a VHL Sharer using the $generate-vhl operation
  So that I can receive a signed QR code that grants access to my health documents

  Background:
    Given the VHL Holder's client application is connected to the VHL Sharer service
    And the VHL Sharer base URL is "https://vhl-sharer.example.org"

  # ─── HTTP Method and Endpoint ─────────────────────────────────────────────────

  Scenario: Request is sent as an HTTP GET to the correct FHIR operation endpoint
    Given the VHL Holder wants to generate a VHL
    When the request is constructed
    Then the request SHALL be an HTTP GET
    And the request URL SHALL be "[base]/Patient/$generate-vhl"

  Scenario: Request URL uses the correct FHIR operation name
    Given the VHL Holder wants to generate a VHL
    When the request URL is constructed
    Then the operation name in the URL SHALL be "$generate-vhl"
    And the operation SHALL be applied to the "Patient" resource type

  # ─── Required Parameters ─────────────────────────────────────────────────────

  Scenario: sourceIdentifier parameter is required and present
    Given the VHL Holder has a patient identifier "urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123"
    When the request is constructed
    Then the request SHALL include the "sourceIdentifier" query parameter
    And the "sourceIdentifier" cardinality SHALL be [1..1]

  Scenario: Request without sourceIdentifier is not valid
    Given the VHL Holder constructs a request without the "sourceIdentifier" parameter
    When the request is evaluated for completeness
    Then the request SHALL be considered invalid due to missing required parameter

  Scenario: sourceIdentifier is expressed as a token (system|value)
    Given the patient identifier system is "urn:oid:2.16.840.1.113883.2.4.6.3" and value is "PASSPORT123"
    When the VHL Holder constructs the "sourceIdentifier" parameter
    Then the parameter SHALL be formatted as "urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123"

  # ─── Optional Parameters ──────────────────────────────────────────────────────

  Scenario: targetSystem parameter may be included to filter identifier domains
    Given the VHL Holder wants to restrict returned identifiers to a specific assigning authority
    When the request includes "targetSystem=urn:oid:1.2.3"
    Then the "targetSystem" parameter cardinality SHALL be [0..*]
    And multiple "targetSystem" values SHALL be accepted

  Scenario: exp parameter may be included to hint at expiration time
    Given the VHL Holder wants the VHL to expire at epoch time 1735689600
    When the request includes "exp=1735689600"
    Then the "exp" parameter SHALL be a positive integer representing Epoch seconds
    And the "exp" cardinality SHALL be [0..1]

  Scenario Outline: flag parameter encodes characteristics as single-character alphabetical flags
    Given the VHL Holder wants to set the flag "<flag_value>"
    When the request includes "flag=<flag_value>"
    Then the VHL Sharer SHALL interpret "<flag_value>" as "<description>"

    Examples:
      | flag_value | description                            |
      | L          | Long-term use                          |
      | P          | Passcode required                      |
      | U          | Direct file access                     |
      | LP         | Long-term use and passcode required    |

  Scenario: flag parameter cardinality is [0..1]
    Given the VHL Holder is constructing the request
    When the "flag" parameter is added
    Then only one "flag" parameter SHALL be present in the request

  Scenario: label parameter is a string of no more than 80 characters
    Given the VHL Holder wants to add a description "Patient Health Summary"
    When the request includes "label=Patient Health Summary"
    Then the "label" value SHALL NOT exceed 80 characters
    And the "label" cardinality SHALL be [0..1]

  Scenario: label parameter is rejected if it exceeds 80 characters
    Given the VHL Holder provides a label that is 81 characters long
    When the request is constructed with the oversized label
    Then the request SHALL be considered invalid for the label parameter

  # ─── Passcode Handling ───────────────────────────────────────────────────────

  Scenario: passcode parameter may be included to protect the VHL
    Given the VHL Holder wants the VHL to require a passcode
    When the request includes "passcode=secretpin"
    Then the "passcode" parameter cardinality SHALL be [0..1]

  Scenario: P flag must be included in the flag parameter when a passcode is provided
    Given the VHL Holder includes "passcode=secretpin" in the request
    When the request is constructed
    Then the request SHALL also include "P" in the "flag" parameter

  Scenario: passcode is not included in the VHL URL or QR code payload
    Given the VHL Holder has included "passcode=secretpin" in the request
    When the VHL Sharer generates the QR code
    Then the plaintext passcode SHALL NOT appear in the generated VHL URL
    And the plaintext passcode SHALL NOT appear in the QR code content

  Scenario: VHL Holder securely stores the plaintext passcode for sharing with authorized receivers
    Given the VHL Sharer has processed a passcode-protected VHL request
    When the VHL Holder receives the QR code
    Then the VHL Holder SHALL securely store the plaintext passcode
    And the VHL Holder SHALL use secure transmission when sharing the passcode out-of-band

  # ─── Full Request URL Structure ───────────────────────────────────────────────

  Scenario: Well-formed GET request with only the required parameter
    Given the patient identifier is "urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123"
    When the request URL is constructed with only the required parameter
    Then the URL SHALL be:
      """
      GET [base]/Patient/$generate-vhl?sourceIdentifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123
      """

  Scenario: Well-formed GET request with all optional parameters
    Given the VHL Holder provides all parameters including passcode
    When the request URL is constructed
    Then the URL SHALL include "sourceIdentifier", "exp", "flag", "label", and "passcode" parameters
    And the "flag" SHALL include "P" because a passcode is present

  # ─── Transport and Connection ─────────────────────────────────────────────────

  Scenario: Request is sent over HTTPS
    Given the VHL Holder is sending the Generate VHL request
    When the connection is established
    Then the request SHALL use HTTPS
    And plain HTTP SHALL NOT be used
