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

Depending on the use case, the VHL MAY be rendered or transmitted using formats such as QR code or deep link (HTTPS URL). Actors SHALL support at least one rendering/transmission option as described in Volume 1 Section XX.2.

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
- **ISO/IEC 18004:2015**: QR Code specification
- **SMART Health Links Specification**: [VHL Payload Structure](https://build.fhir.org/ig/HL7/smart-health-cards-and-links/links-specification.html)

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

The VHL payload structure is defined in [Volume 3](volume-3.html) and aligns with the SMART Health Links specification. The VHL contains at minimum:
- Manifest URL (HTTPS URL pointing to document manifest)
- Digital Signature (JWS signature by VHL Sharer)
- Issuer Identifier (VHL Sharer identifier)
- Optional: Expiration timestamp, passcode flag, usage constraints, label

**VHL Encoding:**

The VHL payload is:
1. Serialized as compact JSON
2. Compressed using DEFLATE
3. Base64url-encoded per RFC 4648
4. Prefixed with `shlink:/`

**Transmission Options**

Implementations SHALL support at least one of the following transmission mechanisms (see Volume 1 Section XX.2 for option details):

**QR Code Rendering Option:**
- VHL encoded as QR code (ISO/IEC 18004:2015)
- Suitable for in-person encounters, walk-in clinics, emergency departments
- QR code contains the complete `shlink:/` URL string

**Deep Link Sharing Option:**
- VHL transmitted as `shlink:/` URL via secure messaging, email, or web links
- Suitable for telehealth, asynchronous coordination

##### 2:3.YY4.4.1.3 Expected Actions - VHL Holder

The VHL Holder SHALL:
1. Verify VHL validity (not expired)
2. Select appropriate transmission mechanism based on claimed options
3. Render/transmit VHL according to option requirements
4. Provide passcode out-of-band if VHL is passcode-protected

The VHL Holder MAY:
- Maintain record of VHL transmissions
- Revoke VHL access if supported by VHL Sharer

##### 2:3.YY4.4.1.3 Expected Actions - VHL Receiver

{{ provideVHLRespDescription.valueMarkdown }}

Upon receiving a VHL, the VHL Receiver SHALL decode and validate it according to the claimed option:

**For QR Code Scanning Option:**

When the VHL Receiver claims the QR Code Scanning Option, the following steps SHALL be performed to decode an HCERT-wrapped VHL:

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
     - `url`: manifest URL (required)
     - `key`: base64url-encoded decryption key, 43 characters (required)
     - `flag`: flags such as "P" for passcode, "L" for long-term (optional)
     - `label`: human-readable description (optional)
     - `exp`: expiration timestamp in seconds since epoch (optional)
   - Validate SHL payload structure conforms to SMART Health Links specification

9. **Validate SHL Payload**:
   - Verify `url` field is present and is a valid HTTPS URL
   - Verify `key` field is present and is 43 characters (base64url-encoded 32 bytes)
   - Check SHL `exp` (if present) - reject if current time > expiration
   - Note `flag` value (e.g., "P" indicates passcode required, "L" for long-term)
   - Validate `url` points to expected manifest endpoint format

**For Deep Link Processing Option:**

When the VHL Receiver claims the Deep Link Processing Option:

1. **Receive shlink:/ URL**:
   - Accept URL via secure messaging, email, web link, or direct input
   - Verify URL begins with `shlink:/` prefix

2. **Extract Base64url-encoded Payload**:
   - Remove the `shlink:/` prefix from the string
   - The remaining string is the base64url-encoded minified JSON payload
   - Example: `shlink:/eyJ1cmwiOiJodHRwczovL...` → `eyJ1cmwiOiJodHRwczovL...`

3. **Base64url Decode**:
   - Decode the base64url-encoded string per RFC 4648
   - Result is a minified JSON string (UTF-8 encoded)
   - Handle any base64url decoding errors appropriately

4. **Parse JSON Payload**:
   - Parse the JSON string to extract SHL payload object containing:
     - `url`: manifest URL (required)
     - `key`: base64url-encoded decryption key, 43 characters (required)
     - `flag`: flags such as "P" for passcode (optional)
     - `label`: human-readable description (optional)
     - `exp`: expiration timestamp in seconds since epoch (optional)
     - `v`: version number (optional, defaults to 1)
   - Validate JSON structure conforms to SMART Health Links specification

5. **Validate SHL Payload**:
   - Verify `url` field is present and is a valid HTTPS URL
   - Verify `key` field is present and is 43 characters
   - Check `exp` (if present) - reject if current time > expiration
   - Note `flag` value (e.g., "P" indicates passcode required)
   - Validate `url` points to expected manifest endpoint format

**Common Post-Decoding Actions (Both Options):**

After successfully decoding the VHL payload, the VHL Receiver SHALL:

1. **Store Decryption Key Securely**:
   - The `key` parameter from the SHL payload is required to decrypt documents
   - Store the key securely in memory for the session
   - The key will be used during document retrieval (ITI-YY5) to decrypt file contents

2. **Prepare to Retrieve Associated Health Documents**:
   - Extract manifest URL from validated SHL payload
   - Validate usage constraints if present
   - Prepare to initiate document retrieval [(ITI-YY5)](ITI-YY5.html) using the manifest URL and decryption key

The VHL Receiver MAY:
- Prompt user for passcode if required by flag (validated during document retrieval)
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
Step 4: Parse CBOR as CWT → Extract protected header and claims
Step 5: Verify signature using kid from header
Step 6: Extract CWT claims (iss, iat, exp, hcert)
Step 7: Within hcert (claim -260), extract claim 5 (SHL payload):
  {
    "url": "https://vhl-sharer.example.org/List?_id=abc123&_include=List:item",
    "key": "dGhpcyBpcyBhIHNlY3JldCBrZXkgdXNlZCBmb3IgZW5j",
    "flag": "LP",
    "exp": 1735689600,
    "label": "Patient Health Summary"
  }
Step 8: Validate SHL payload fields and prepare for document retrieval
```

**Decoding Example (Deep Link):**

```
Input Deep Link:
shlink:/eyJ1cmwiOiJodHRwczovL3ZobC1zaGFyZXIuZXhhbXBsZS5vcmcvTGlzdD9faWQ9YWJjMTIzJl9pbmNsdWRlPUxpc3Q6aXRlbSIsImtleSI6ImRHaHBjeUJwY3lCaElITmxZM0psZENCclpYa2dkWE5sWkNCbWIzSWdaVzVqIiwiZmxhZyI6IkxQIiwiZXhwIjoxNzM1Njg5NjAwLCJsYWJlbCI6IlBhdGllbnQgSGVhbHRoIFN1bW1hcnkifQ

Step 1: Remove shlink:/ prefix
Step 2: Base64url decode → JSON string
Step 3: Parse JSON:
  {
    "url": "https://vhl-sharer.example.org/List?_id=abc123&_include=List:item",
    "key": "dGhpcyBpcyBhIHNlY3JldCBrZXkgdXNlZCBmb3IgZW5j",
    "flag": "LP",
    "exp": 1735689600,
    "label": "Patient Health Summary"
  }
Step 4: Validate SHL payload fields and prepare for document retrieval
```

**Error Handling:**

If decoding fails:
- **QR Code Option**: QR unreadable, invalid HC1: prefix, Base45 decode error, ZLIB decompression error, CBOR parse error, invalid CWT structure
- **Deep Link Option**: Invalid shlink:/ prefix, base64url decode error, JSON parse error, invalid SHL structure
- VHL Receiver SHALL reject the VHL
- VHL Receiver SHOULD inform user with specific error message
- VHL Receiver MAY request user to rescan or re-enter VHL

If signature verification fails (QR Code Option):
- VHL Receiver SHALL reject the VHL
- VHL Receiver SHALL NOT attempt to retrieve documents
- VHL Receiver SHOULD inform user/operator
- VHL Receiver MAY log failed verification

If VHL expired:
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
- VHL Receivers MUST verify signatures before trusting content

#### 2:3.YY4.5.2 VHL Confidentiality
- VHL does NOT contain PHI
- VHL only contains reference (URL) to retrieve documents
- Actual documents retrieved over secure channel (ITI-YY5)

#### 2:3.YY4.5.3 Replay Attacks
- VHL Sharers SHOULD include expiration timestamps
- VHL Receivers SHOULD enforce expiration validation
- VHL Sharers MAY implement single-use VHLs

#### 2:3.YY4.5.4 Passcode Protection
- Passcode communicated out-of-band (not in VHL)
- Passcode validated during document retrieval (ITI-YY5)
- VHL Sharers SHOULD implement rate limiting

#### 2:3.YY4.5.5 Trust Network Validation
VHL Receivers MUST:
- Validate VHL Sharer is current participant in trust network
- Check certificate revocation status where applicable
- Reject VHLs from untrusted participants

#### 2:3.YY4.5.6 Transmission Security

**QR Codes:**
- Can be photographed/copied
- Use for time-limited scenarios
- Suitable for supervised encounters

**Deep Links:**
- Use HTTPS for transmission
- May be forwarded unintentionally
- Include expiration/single-use constraints to mitigate risks

### 2:3.YY4.6 Conformance

**VHL Holder SHALL:**
- Support at least one VHL rendering option (QR Code Rendering or Deep Link Sharing)
- Provide passcodes out-of-band when required

**VHL Receiver SHALL:**
- Support at least one VHL processing option (QR Code Scanning or Deep Link Processing)
- Verify VHL digital signatures before trusting content
- Validate VHL expiration when present
- Retrieve public keys from trusted Trust Anchors
- Reject VHLs with invalid signatures or expired validity
