{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}


 {% assign reqGenerateVHLRequest = site.data.Requirements-InitiateVHLGenerationRequest %}
 {% assign reqGenerateVHLResponse = site.data.Requirements-RespondtoGenerateVHLRequest %}


### 2:3.YY3.1 Scope

{% assign reqGenerateVHLRequestTitle = reqGenerateVHLRequest.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqGenerateVHLResponseTitle = reqGenerateVHLResponse.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign reqGenerateVHLRequestDescription = reqGenerateVHLRequest.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign reqGenerateVHLResponseDescription = reqGenerateVHLResponse.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

### 2:3.YY3.2 Actor Roles

| Actor | Role |
|-------|------|
| {{ linkvhlh}} | {{ reqGenerateVHLRequestTitle.valueString }}     |
| {{ linkvhls }}            | {{ reqGenerateVHLResponseTitle.valueString }} |
{: .grid}


### 2:3.YY3.3 Referenced Standards

- **SMART Health Links Specification**: [SMART Health Links and SMART Health Cards](https://build.fhir.org/ig/HL7/smart-health-cards-and-links/links-specification.html)
- **RFC 4648**: Base64url Encoding
- **RFC 7515**: JSON Web Signature (JWS)
- **ISO/IEC 18004:2015**: QR Code specification
- **FHIR R4**: [HL7 FHIR Release 4](http://hl7.org/fhir/R4/)


### 2:3.YY3.4 Messages

<figure >
  <div style="width:35em; max-width:100%;">
     {%include ITI-YY3.svg%}
  </div>
  <p id="figure-2.3.YY3-1" class="figureTitle">Figure 2:3.YY3-1: Generate VHL Interaction Diagram</p>
</figure>
<br clear="all">

#### 2:3.YY3.4.1 Generate VHL Request Message
This message is implemented as an HTTP GET operation from the client app used by the Holder to the VHL Sharer using the FHIR $generate-vhl operation described in [2:3.YY3.4.1.2 Message Semantics](#23yy3412-message-semantics).


##### 2:3.YY3.4.1.1 Trigger Events
{{ reqGenerateVHLRequestDescription.valueMarkdown}}

{% include requirements-list-statements.liquid site=site req=reqGenerateVHLRequest  %}
##### 2:3.YY3.4.1.2 Message Semantics

The Generate VHL message is a FHIR operation request as defined in FHIR (<http://hl7.org/fhir/operations.html>) with the [$generate-vhl operation definition](OperationDefinition-generate-vhl.html).

Given that the parameters are not complex types, the HTTP GET operation shall be used as defined in FHIR (<http://hl7.org/fhir/operations.html#request>).

The name of the operation is `$generate-vhl`, and it is applied to FHIR Patient Resource type.

The URL for this operation is: `[base]/Patient/$generate-vhl`

Where **[base]** is the URL of VHL Sharer Service provider.

The Generate VHL message is performed by an HTTP GET command shown below:

```
GET [base]/Patient/$generate-vhl?sourceIdentifier=[token]{&targetSystem=[uri]}{&exp=[integer]}{&flag=[string]}{&label=[string]}{&passcode=[string]}
```

**Note:** The `goal` parameter has been removed. The operation always generates a QR code containing the VHL encoded as an HCERT/CWT structure.

**Table 2:3.YY3.4.1.2-1: $generate-vhl Message HTTP query Parameters**

| Query parameter Name | Cardinality | Type | Description |
| -------------------- | ----------- | ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| sourceIdentifier     | [1..1]    | token       | The Patient Identifier that will be used to find documents associated with the Patient |
| targetSystem         | [0..*]   | uri         | The Assigning Authorities for the Patient Identifier Domains from which the returned identifiers shall be selected |
| exp      |  [0..1]  | integer        | Optional. Number representing expiration time in Epoch seconds, as a hint to help the SHL Receiving Application determine if this QR is stale. |
| flag |  [0..1]  | string        | Optional. String created by concatenating single-character flags in alphabetical order. L (long-term use), P (Passcode required), U (direct file access). |
| label |  [0..1]  | string        | Optional. String no longer than 80 characters that provides a short description of the data behind the SHLink. |
| passcode |  [0..1]  | string        | Optional. User-supplied passcode for passcode-protected VHLs. If provided, the VHL Sharer SHALL securely hash and store this passcode for validation during manifest retrieval (ITI-YY5). The 'P' flag SHALL be included in the flag parameter when a passcode is set. |


##### 2:3.YY3.4.1.3 Expected Actions
{{ reqGenerateVHLResponseDescription.valueMarkdown }}

{% include requirements-list-statements.liquid req=reqGenerateVHLResponse site=site  %}

The {{linkvhls}} generates a QR code containing the VHL. The QR code is encoded as an HCERT/CWT structure per the [WHO SMART Trust HCERT specification](https://smart.who.int/trust/hcert_spec.html) and contains the SHL payload embedded at claim key 5 within the hcert claim (claim key -260).

The generation process is as follows:

**Passcode Handling (if provided)**

If the `passcode` parameter is provided:
1. The VHL Sharer SHALL securely hash the passcode using a strong one-way hash function (e.g., bcrypt, Argon2, PBKDF2)
2. The VHL Sharer SHALL store the hashed passcode associated with the folder ID for later validation during ITI-YY5 Retrieve Manifest
3. The VHL Sharer SHALL include the 'P' flag in the `flag` parameter of the SHL payload
4. The passcode itself SHALL NOT be included in the VHL URL or QR code
5. The VHL Holder SHALL securely store the plaintext passcode for future use by the VHL Receiver during manifest retrieval

**VHL Payload Construction**

The VHL payload SHALL be constructed in alignment with the [SMART Health Links specification](https://build.fhir.org/ig/HL7/smart-health-cards-and-links/links-specification.html#construct-a-smart-health-link-payload). The VHL Sharer SHALL:

1. Generate a unique folder ID with 256-bit entropy to serve as the List resource identifier

2. Generate a 32-byte (256-bit) random encryption key, base64url-encode it (resulting in 43 characters) - this is the 'key' parameter

3. Construct the manifest URL as a query on the base List resource:
   - **If VHL Sharer supports the Include DocumentReference Option:**
     ```
     [base]/List?_id=[folder-id]&code=folder&status=current&patient.identifier=[patient-id]&_include=List:item
     ```
   - **If VHL Sharer does NOT support the Include DocumentReference Option:**
     ```
     [base]/List?_id=[folder-id]&code=folder&status=current&patient.identifier=[patient-id]
     ```
   
   Note: The manifest URL includes all mandatory FHIR search parameters (_id, code, status, patient.identifier) and optionally includes `_include=List:item` if the VHL Sharer supports the Include DocumentReference Option.

4. Create the SHL payload as a JSON object with:
   - `url`: the manifest URL from step 3
   - `key`: the base64url-encoded encryption key from step 2 (43 characters)
   - `exp`: (optional) expiration time in Epoch seconds
   - `flag`: (optional) flags string (e.g., 'P' for passcode, 'L' for long-term, 'U' for direct file access)
   - `label`: (optional) description string (max 80 characters)
   - `v`: version number (defaults to 1)



**Example VHL Construction:**

```json
// Step 4: SHL Payload JSON
{
  "url": "https://vhl-sharer.example.org/List/_search?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item",
  "key": "dGhpcyBpcyBhIHNlY3JldCBrZXkgdXNlZCBmb3IgZW5j",
  "exp": 1735689600,
  "flag": "LP",
  "label": "Patient Health Summary",
  "v": 1
}

// The SHL payload from step 4 will be embedded in the HCERT structure (see QR Code Generation below)
```

**QR Code Generation (HCERT/CWT Encoding)**

After constructing the SHL payload (steps 1-4 above), the VHL Sharer SHALL encode it within an HCERT structure:

5. Create a CBOR Web Token (CWT) structure per RFC 8392 with protected header containing:
   - `alg` (algorithm): ES256 (ECDSA with SHA-256, primary) or PS256 (RSASSA-PSS with SHA-256, secondary)
   - `kid` (key identifier): truncated SHA-256 fingerprint of DSC (first 8 bytes)

6. Add CWT claims:
   - `iss` (issuer, claim key 1): optional ISO 3166-1 alpha-2 country code
   - `iat` (issued at, claim key 6): timestamp in NumericDate format
   - `exp` (expiration, claim key 4): timestamp in NumericDate format
   - `hcert` (health certificate, claim key -260): object containing:
     - claim key 5: the SHL payload object from step 4

7. Sign the CWT using asymmetric signature algorithm (COSE, RFC 8152) with VHL Sharer's private key

8. Compress the signed CWT using ZLIB (RFC 1950) with Deflate (RFC 1951) compression

9. Encode the compressed CWT as Base45

10. Prefix with context identifier `HC1:`

11. Generate QR code using ISO/IEC 18004:2015:
    - Error correction level: Q (25% recommended)
    - Mode: Alphanumeric (Mode 2)
    - Recommended diagonal size: 35-60mm for physical QR codes

**Example HCERT/CWT Structure:**

```json
// CWT Claims
{
  "1": "US",                    // iss: issuer country code
  "4": 1735689600,              // exp: expiration timestamp
  "6": 1704067200,              // iat: issued at timestamp
  "-260": {                     // hcert: health certificate claim
    "5": {                      // SHL payload at claim key 5
      "url": "https://vhl-sharer.example.org/List/_search?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item",
      "key": "dGhpcyBpcyBhIHNlY3JldCBrZXkgdXNlZCBmb3IgZW5j",
      "exp": 1735689600,
      "flag": "LP",
      "label": "Patient Health Summary",
      "v": 1
    }
  }
}

// After signing, compressing, and Base45 encoding:
HC1:NCF3R0KLBBA...V8N8W.CE8WY
```

**Manifest URL Construction Notes:**

The manifest URL constructed in step 3 MUST include all mandatory FHIR search parameters required by ITI-YY5:
- `_id`: The unique folder ID (required)
- `code`: The List type, typically "folder" (required)
- `status`: The List status, typically "current" (required)
- `patient.identifier`: The patient identifier in system|value format (required)
- `_include=List:item`: Include DocumentReferences (optional - only if VHL Sharer supports Include DocumentReference Option)

The VHL Receiver will use this exact manifest URL when performing the ITI-YY5 Retrieve Manifest transaction, adding the SHL manifest parameters (recipient, passcode, embeddedLengthMax) separately in Part 2 of the multipart request.


#### 2:3.YY3.4.2  Generate VHL Response Message 
The {{ linkvhls }} returns failure, or generates and returns a QR code containing the VHL encoded as an HCERT/CWT structure.

##### 2:3.YY3.4.2.1 Trigger Events
This message shall be sent when a request initiated by the {{linkvhlh}} has been processed successfully. 

##### 2:3.YY3.4.2.2  Message Semantics

See [ITI TF-2: Appendix Z.6](https://profiles.ihe.net/ITI/TF/Volume2/ch-Z.html#z.6-populating-the-expected-response-format) for more details on response format handling.

The response message is a FHIR operation response (<http://hl7.org/fhir/operations.html#response>).

On Failure, the response message is an HTTP status code of 4xx or 5xx
indicates an error, and an OperationOutcome Resource shall be returned
with details.

**Success Response:**

The response SHALL include a single output parameter:

| Parameter | Type | Cardinality | Description |
|-----------|------|-------------|-------------|
| qrcode | Binary | [1..1] | QR code image containing HCERT-encoded VHL |
{: .grid}

**QR Code Output:**
- SHALL be encoded as HCERT with `HC1:` prefix
- SHALL contain the SHL payload embedded in HCERT claim structure (claim key -260, key 5)
- SHALL be suitable for camera scanning
- SHALL be in PNG or SVG format

##### 2:3.YY3.4.2.3 Expected Actions

The VHL Holder SHALL:
- Display or print the QR code for scanning by VHL Receivers
- Cache the encryption key securely (extracted from SHL payload) for future document decryption
- If a passcode was provided during generation:
  - Securely store the plaintext passcode separately from the QR code
  - Provide the passcode to authorized VHL Receivers for manifest retrieval (ITI-YY5)
  - Use secure transmission methods when sharing the passcode out-of-band

The VHL Holder MAY:
- Maintain record of QR code presentations
- Revoke VHL access if supported by VHL Sharer


### 2:3.YY3.5 Security Considerations 

#### 2:3.YY3.5.1 Encryption Key Security
- The 32-byte encryption key MUST be generated using a cryptographically secure random number generator
- The key is embedded in the SHL payload within the QR code and MUST be kept confidential
- Loss of the key means loss of access to encrypted documents
- The encryption key is not directly visible in the QR code as it is embedded within the signed and compressed HCERT structure

#### 2:3.YY3.5.2 QR Code Security
- QR codes contain the complete VHL including the encryption key
- QR codes can be photographed or copied - use time-limited expiration
- QR codes SHALL be encoded as HCERT with digital signatures for authenticity
- Display QR codes in controlled environments when possible
- Consider short expiration times (minutes to hours) for high-security scenarios

#### 2:3.YY3.5.3 Passcode Security
- If a passcode is provided, it MUST be securely hashed before storage using industry-standard algorithms (bcrypt, Argon2, PBKDF2)
- The plaintext passcode MUST NOT be included in the VHL URL or QR code
- The plaintext passcode MUST NOT be stored by the VHL Sharer
- The VHL Holder SHOULD securely store the plaintext passcode for sharing with authorized VHL Receivers
- During ITI-YY5 Retrieve Manifest, the VHL Receiver provides the passcode which the VHL Sharer validates against the stored hash
- Use of passcode adds an additional authentication factor beyond VHL possession

#### 2:3.YY3.5.4 Manifest URL Construction
- The manifest URL MUST include all mandatory FHIR search parameters
- The `_include` parameter SHOULD only be included if the VHL Sharer supports the Include DocumentReference Option
- This ensures VHL Receivers can successfully retrieve the manifest using ITI-YY5
