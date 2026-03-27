{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}

## 2:3.YY4 Provide VHL
 {% assign provideVHL = site.data.Requirements-ProvideVHL %}
 {% assign provideVHLResp = site.data.Requirements-RespondtoProvideVHL %}


### 2:3.YY4.1 Scope

{% assign provideVHLTitle = provideVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign provideVHLRespTitle = provideVHLResp.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign provideVHLDescription = provideVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign provideVHLRespDescription = provideVHLResp.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

The Provide VHL transaction enables a {{ linkvhlh }} to transmit a Verified Health Link (VHL) to a {{ linkvhlr }}. The VHL serves as a signed authorization mechanism that allows the Receiver to subsequently retrieve one or more health documents from a VHL Sharer (via ITI-YY5).

The VHL is transmitted as a QR code containing an HCERT-encoded payload with the HC1: prefix. VHL Receivers scan the QR code to extract the VHL payload for subsequent document retrieval.

### 2:3.YY4.2 Actor Roles


| Actor | Role |
|-------|------|
| {{ linkvhlh }} | Provides the VHL to a VHL Receiver through a supported transmission mechanism |
| {{ linkvhlr }} | Receives the VHL from a VHL Holder and prepares to retrieve the referenced health documents |
{: .grid}

### 2:3.YY4.3 Referenced Standards
- **RFC 7515**: JSON Web Signature (JWS)
- **RFC 7519**: JSON Web Token (JWT)  
- **RFC 4648**: Base64url Encoding
- **RFC 8392**: CBOR Web Token (CWT)
- **RFC 8152**: CBOR Object Signing and Encryption (COSE)
- **RFC 1950**: ZLIB Compressed Data Format
- **RFC 1951**: DEFLATE Compressed Data Format
- **ISO/IEC 18004:2015**: QR Code specification
- **SMART Health Links Specification**: [VHL Payload Structure](https://build.fhir.org/ig/HL7/smart-health-cards-and-links/links-specification.html)
- **WHO SMART Trust HCERT Specification**: [HCERT Structure](https://smart.who.int/trust/hcert_spec.html)

### 2:3.YY4.4 Messages

<figure >
  <div style="width:35em; max-width:100%;">
     {%include ITI-YY4.svg%}
  </div>
  <p id="fX.X.X.X-4" class="figureTitle">Figure X.X.X.X-4: Provide VHL Interaction Diagram</p>
</figure>

#### 2:3.YY4.4.1 Provide VHL Request Message

##### 2:3.YY4.4.1.1 Trigger Events
{{ provideVHLDescription.valueMarkdown}}

A VHL Holder initiates the Provide VHL transaction when:
- The VHL Holder wishes to grant access to their health documents to a VHL Receiver
- The VHL Holder has obtained a valid VHL from a VHL Sharer (via ITI-YY3 Generate VHL transaction)
- The VHL Holder encounters a VHL Receiver capable of processing VHLs in a relevant healthcare context

##### 2:3.YY4.4.1.2 Message Semantics

The VHL payload structure is defined in [ITI-YY3](ITI-YY3.html) and aligns with the SMART Health Links specification.

**QR Code Transmission**

The VHL is transmitted via QR code with the following characteristics:
- VHL encoded as HCERT QR code with `HC1:` prefix
- Suitable for in-person encounters, walk-in clinics, emergency departments
- QR code contains HCERT/CWT structure with embedded SHL payload
- Can be displayed on screen or printed on paper
- Minimum recommended diagonal size: 35-60mm

##### 2:3.YY4.4.1.3 Expected Actions - VHL Holder

The VHL Holder SHALL:
1. Verify QR code validity (not expired, CWT signature valid)
2. Display QR code on device screen or provide printed copy
3. Provide passcode out-of-band if VHL is passcode-protected (P flag present)
4. Ensure QR code is displayed at appropriate size for reliable scanning

The VHL Holder MAY:
- Maintain record of QR code presentations
- Revoke VHL access if supported by VHL Sharer

##### 2:3.YY4.4.1.4 Expected Actions - VHL Receiver

{{ provideVHLRespDescription.valueMarkdown }}

Upon receiving a VHL via QR code, the VHL Receiver SHALL perform the following 9-step decoding process:

1. **Scan QR Code**:
   - Use QR code scanner (camera, dedicated scanner, or software library)
   - Capture QR code image displayed on screen or printed on paper
   - Decode the QR code per ISO/IEC 18004:2015 in Alphanumeric mode
   - Provide visual feedback to user during scanning process

2. **Verify Context Identifier**:
   - Extract the complete string from the QR code
   - Verify the string begins with `HC1:` prefix (HCERT context identifier)
   - If prefix is missing or incorrect, reject and inform user
   - Remove the `HC1:` prefix from the string

3. **Base45 Decode**:
   - Decode the remaining string using Base45 decoding algorithm
   - Result is a compressed byte array
   - Handle any Base45 decoding errors appropriately

4. **Decompress ZLIB/DEFLATE**:
   - Decompress the byte array using ZLIB (RFC 1950) with DEFLATE (RFC 1951)
   - Result is a CBOR-encoded CWT structure
   - Handle decompression errors (corrupted data, invalid format)

5. **Parse CBOR Web Token (CWT)**:
   - Parse the decompressed bytes as CBOR per RFC 8392
   - Extract the CWT structure containing protected header and claims
   - Protected header contains:
     - `alg` (algorithm): ES256 or PS256
     - `kid` (key identifier): 8-byte truncated SHA-256 of DSC
   - Handle CBOR parsing errors

6. **Verify Digital Signature**:
   - Extract `kid` from CWT protected header
   - Retrieve corresponding Document Signing Certificate (DSC) from trust list
   - Verify the COSE signature (RFC 8152) using DSC public key
   - Confirm signature is valid and CWT has not been tampered with
   - Reject if signature invalid or DSC not trusted

7. **Extract and Validate CWT Claims**:
   - Extract CWT claims:
     - `iss` (issuer, claim key 1): ISO 3166-1 alpha-2 country code (optional)
     - `iat` (issued at, claim key 6): timestamp in NumericDate format
     - `exp` (expiration, claim key 4): timestamp in NumericDate format
     - `hcert` (health certificate, claim key -260): HCERT payload object
   - Validate `exp` - reject if current time > expiration
   - Validate `iat` is not in the future

8. **Extract SHL Payload from HCERT**:
   - Within the `hcert` claim (claim key -260), locate claim key 5
   - Claim key 5 contains the SHL payload object with:
     - `url`: manifest URL (required) - includes all mandatory FHIR search parameters
     - `key`: base64url-encoded decryption key, 43 characters (required)
     - `flag`: flags such as "L" for long-term, "P" for passcode (optional)
     - `label`: human-readable description (optional)
     - `exp`: expiration timestamp in seconds since epoch (optional)
     - `v`: version number (optional)
   - Validate SHL payload structure conforms to SMART Health Links specification

9. **Validate SHL Payload**:
   - Verify `url` field is present and is a valid HTTPS URL
   - Verify `key` field is present and is 43 characters (base64url-encoded 32 bytes)
   - Check SHL `exp` (if present) - reject if current time > expiration
   - Note `flag` value:
     - "L" indicates long-term use
     - "P" indicates passcode required (obtain from VHL Holder)
     - "LP" indicates both long-term and passcode-protected
   - Validate `url` contains expected manifest endpoint format with mandatory parameters

**Post-Decoding Actions:**

After successfully decoding the VHL payload, the VHL Receiver SHALL:

1. **Store Decryption Key Securely**:
   - The `key` parameter from the SHL payload is required to decrypt documents
   - Store the key securely in memory for the session
   - The key will be used during document retrieval (ITI-YY6) to decrypt document contents

2. **Parse Manifest URL**:
   - Extract the manifest URL from the SHL payload
   - The URL format from ITI-YY3 includes mandatory FHIR search parameters:
     - `_id`: The folder ID
     - `code`: Typically "folder"
     - `status`: Typically "current"
     - `patient.identifier`: Patient identifier via FHIR chained search on the patient reference parameter, in system|value format
     - `_include=List:item`: (if VHL Sharer supports Include DocumentReference Option)
   - Example: `https://vhl-sharer.example.org/List?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item`

3. **Prepare to Retrieve Manifest**:
   - The VHL Receiver will use ITI-YY5 Retrieve Manifest with 3-part multipart request:
     - **Part 1 (fhir-parameters):** FHIR search parameters from the manifest URL
     - **Part 2 (shl-parameters):** JSON object with `recipient`, `passcode` (if P flag), `embeddedLengthMax`
     - **Part 3 (signature):** Optional digital signature over Parts 1 and 2
   - Store manifest URL and prepare SHL parameters for ITI-YY5 request

The VHL Receiver MAY:
- Prompt user for passcode if "P" flag is present (required for ITI-YY5)
- Display VHL label/description to user
- Record audit event per **[Audit Event – Received Health Data](Requirements-AuditEventReceived.html)**
- Cache VHL payload for subsequent access attempts

**Decoding Example (QR Code with HCERT):**

```
Input QR Code Content:
HC1:NCF3R0KLBBA...V8N8W.CE8WY

Step 1: Verify and remove HC1: prefix → NCF3R0KLBBA...V8N8W.CE8WY
Step 2: Base45 decode → [compressed bytes]
Step 3: ZLIB/DEFLATE decompress → [CBOR bytes]
Step 4: Parse CBOR as CWT → Extract protected header (alg: ES256, kid: 8-byte SHA-256)
Step 5: Verify COSE signature using DSC from trust list based on kid
Step 6: Extract CWT claims:
  - iss (claim 1): "US"
  - iat (claim 6): 1704067200
  - exp (claim 4): 1735689600
  - hcert (claim -260): {...}
Step 7: Within hcert (claim -260), extract claim key 5 (SHL payload):
  {
    "url": "https://vhl-sharer.example.org/List/_search?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item",
    "key": "dGhpcyBpcyBhIHNlY3JldCBrZXkgdXNlZCBmb3IgZW5j",
    "flag": "LP",
    "exp": 1735689600,
    "label": "Patient Health Summary",
    "v": 1
  }
Step 8: Validate SHL payload fields
Step 9: Parse manifest URL to extract FHIR search parameters
Step 10: Prepare for ITI-YY5 Retrieve Manifest with 3-part multipart request
```

**Manifest URL Parsing:**

The manifest URL from the SHL payload contains all parameters needed for ITI-YY5 Part 1 (fhir-parameters):

```
URL: https://vhl-sharer.example.org/List?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item

Parsed FHIR Search Parameters (for ITI-YY5 Part 1):
- _id=abc123def456
- code=folder
- status=current
- patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123
- _include=List:item (if present, indicates VHL Sharer supports Include DocumentReference Option)
```

**Error Handling:**

If QR code scanning or decoding fails:
- QR unreadable or damaged
- Invalid HC1: prefix
- Base45 decode error
- ZLIB decompression error
- CBOR parse error
- Invalid CWT structure
- Missing hcert claim or claim key 5
- Signature verification failure

VHL Receiver SHALL:
- Reject the VHL
- Inform user with specific error message
- Request user to rescan QR code
- NOT attempt to retrieve documents

If signature verification fails:
- VHL Receiver SHALL reject the VHL
- VHL Receiver SHALL NOT attempt to retrieve documents
- VHL Receiver SHOULD inform user/operator
- VHL Receiver MAY log failed verification

If VHL expired (either exp in CWT or SHL payload):
- VHL Receiver SHALL reject the VHL
- VHL Receiver SHOULD inform user/operator
- User may request new VHL from VHL Holder

#### 2:3.YY4.4.2  Provide VHL Response Message 

##### 2:3.YY4.4.2.1 Trigger Events
The VHL Receiver MAY provide optional acknowledgment to VHL Holder confirming receipt and validation. This is transmission-mechanism dependent.

##### 2:3.YY4.4.2.2 Message Semantics

For transmission mechanisms supporting bidirectional communication, response MAY include:

| Element | Cardinality | Description |
|---------|-------------|-------------|
| Acknowledgment | 0..1 | Confirmation VHL received and validated |
| Receipt Identifier | 0..1 | Unique identifier for receipt transaction |
| Receiver Identifier | 0..1 | Identifier of VHL Receiver organization |
| Timestamp | 0..1 | ISO 8601 timestamp of receipt |
{: .grid}

##### 2:3.YY4.4.2.3 Expected Actions

**VHL Receiver:**
- MAY send acknowledgment if supported
- SHALL NOT include sensitive health information

**VHL Holder:**
- MAY receive and store receipts
- SHALL NOT rely on acknowledgment for security decisions

### 2:3.YY4.5 Security Considerations

#### 2:3.YY4.5.1 VHL Integrity and Authenticity
- Digital signature ensures VHL issued by trusted VHL Sharer
- VHL Receivers SHALL verify COSE signatures before trusting content
- CWT signature provides end-to-end trust verification

#### 2:3.YY4.5.2 VHL Confidentiality
- VHL does NOT contain PHI
- VHL only contains reference (URL) to retrieve documents
- Actual documents retrieved over secure channel (ITI-YY5)
- Encryption key in VHL enables document decryption (ITI-YY6)

#### 2:3.YY4.5.3 Replay Attacks
- VHL Sharers SHOULD include expiration timestamps in both CWT and SHL payload
- VHL Receivers SHOULD enforce expiration validation
- VHL Sharers MAY implement single-use VHLs
- Short expiration times reduce replay attack window

#### 2:3.YY4.5.4 Passcode Protection
- Passcode communicated out-of-band (not in VHL)
- "P" flag indicates passcode required
- Passcode validated during manifest retrieval (ITI-YY5 Part 2)
- VHL Sharers SHOULD implement rate limiting on passcode attempts

#### 2:3.YY4.5.5 Trust Network Validation
VHL Receivers SHALL:
- Validate VHL Sharer is current participant in trust network
- Retrieve DSC from trust list using kid from CWT protected header
- Check certificate revocation status where applicable
- Reject VHLs from untrusted participants

#### 2:3.YY4.5.6 QR Code Security

**QR Code Characteristics:**
- Can be photographed/copied - use time-limited expiration
- Suitable for supervised encounters (in-person, on-screen display)
- Digital signature provides authenticity verification
- Recommended for higher security scenarios

**Best Practices:**
- Include short expiration times in CWT exp claim
- Use passcode protection (P flag) for sensitive data
- Display QR codes in controlled environments
- Avoid printing QR codes for long-term use unless necessary
- Implement single-use VHLs where appropriate


