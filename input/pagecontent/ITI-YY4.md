{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}

> **Note on Transaction Optionality**: This transaction is **REQUIRED (R)** for both the VHL Holder (Initiator) and the VHL Receiver (Responder). Optional behaviors within this transaction, such as the VC Enveloped VHL Option, are defined as actor options for this transaction.

 {% assign provideVHL = site.data.Requirements-ProvideVHL %}
 {% assign provideVHLResp = site.data.Requirements-RespondtoProvideVHL %}


### 2:3.YY4.1 Scope

{% assign provideVHLTitle = provideVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign provideVHLRespTitle = provideVHLResp.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign provideVHLDescription = provideVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign provideVHLRespDescription = provideVHLResp.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

The Provide VHL transaction enables a {{ linkvhlh }} to transmit a Verified Health Link (VHL) to a {{ linkvhlr }}. The VHL serves as a signed authorization mechanism that allows the Receiver to subsequently retrieve one or more health documents from a VHL Sharer (via ITI-YY5).

The VHL is transmitted as a QR code containing an HCERT-encoded payload with the `HC1:` prefix, OR — when the VHL Sharer supports the [VC Enveloped VHL Option](ITI-YY3.html#vc-enveloped-vhl-carrier-option--formatvc) at ITI-YY3 — as a signed W3C Verifiable Credential (`application/vc`). VHL Receivers scan the QR code or parse the VC to extract the VHL payload for subsequent document retrieval.

### 2:3.YY4.2 Actor Roles


| Actor | Role |
|-------|------|
| {{ linkvhlh }} | {{ provideVHLTitle.valueString }} |
| {{ linkvhlr }} | {{ provideVHLRespTitle.valueString }} |
{: .grid}

### 2:3.YY4.3 Referenced Standards
- **SMART Health Links Specification**: [VHL Payload Structure](https://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html)
- **RFC 4648**: Base64url Encoding

**QR Code Carrier:**
- **WHO SMART Trust HCERT Specification**: [HCERT Structure](https://smart.who.int/trust/hcert_spec.html)
- **RFC 8392**: CBOR Web Token (CWT)
- **RFC 8152**: CBOR Object Signing and Encryption (COSE)
- **RFC 1950**: ZLIB Compressed Data Format
- **RFC 1951**: DEFLATE Compressed Data Format
- **RFC 9285**: [The Base45 Data Encoding](https://www.rfc-editor.org/rfc/rfc9285.html)
- **ISO/IEC 18004:2015**: QR Code specification

**VC Enveloped VHL Option (Optional):**
- **W3C VC Data Model v2**: [Verifiable Credentials Data Model v2](https://www.w3.org/TR/vc-data-model-2.0/)
- **W3C Data Integrity**: [Verifiable Credential Data Integrity 1.0](https://www.w3.org/TR/vc-data-integrity/) — `DataIntegrityProof`
- **W3C Data Integrity ECDSA Cryptosuites**: [ecdsa-rdfc-2019 / ecdsa-jcs-2019](https://www.w3.org/TR/vc-di-ecdsa/)

### 2:3.YY4.4 Messages

<figure >
  <div style="width:35em; max-width:100%;">
     {%include ITI-YY4.svg%}
  </div>
  <p id="f2:3.YY4.4-1" class="figureTitle">Figure 2:3.YY4.4-1: Provide VHL Interaction Diagram</p>
</figure>

#### 2:3.YY4.4.1 Provide VHL Request Message

##### 2:3.YY4.4.1.1 Trigger Events
{{ provideVHLDescription.valueMarkdown}}

A VHL Holder initiates the Provide VHL transaction when:
- The VHL Holder wishes to grant access to their health documents to a VHL Receiver
- The VHL Holder has obtained a valid VHL from a VHL Sharer (via ITI-YY3 Generate VHL transaction)
- The VHL Holder encounters a VHL Receiver capable of processing VHLs in a relevant healthcare context

Before transmitting, the {{ linkvhlh }} SHALL:

**QR Code Transmission:**
1. Verify QR code validity (not expired, CWT signature valid)
2. Display QR code on device screen or provide printed copy
3. Ensure QR code is displayed at appropriate size for reliable scanning
4. Provide passcode out-of-band if VHL is passcode-protected (P flag present)

**Verifiable Credential Transmission**, where the {{ linkvhls }} supports the [VC Enveloped VHL Option](ITI-YY3.html#vc-enveloped-vhl-carrier-option--formatvc):
1. Verify the VC is valid (`validUntil` not passed, `DataIntegrityProof` intact)
2. Transmit the `application/vc` document to the {{ linkvhlr }} via an agreed channel (HTTPS, email attachment, file transfer, or NFC)
3. Provide passcode out-of-band if VHL is passcode-protected (P flag present)

The {{ linkvhlh }} MAY:
- Maintain record of VHL presentations (QR or VC)
- Revoke VHL access if supported by VHL Sharer

##### 2:3.YY4.4.1.2 Message Semantics

The VHL payload structure is defined in [ITI-YY3](ITI-YY3.html) and aligns with the SMART Health Links specification.

**QR Code Transmission**

The VHL is transmitted via QR code with the following characteristics:
- VHL encoded as HCERT QR code with `HC1:` prefix
- Suitable for in-person encounters, walk-in clinics, emergency departments
- QR code contains HCERT/CWT structure with embedded VHL payload
- Can be displayed on screen or printed on paper
- Minimum recommended diagonal size: 35-60mm

**Verifiable Credential Transmission (VC Enveloped VHL)**

When the VHL Sharer supports the [VC Enveloped VHL Option](ITI-YY3.html#vc-enveloped-vhl-carrier-option--formatvc), the VHL MAY alternatively be transmitted as a signed JSON-LD Verifiable Credential:
- Conveyed via any channel that preserves JSON (HTTPS, email attachment, file transfer, NFC with a capable reader). Where the channel carries a media type, it SHALL be `application/vc`; some channels — a file on removable media, or a blob read from NFC — carry none, in which case the document is identified by its content
- Not imaged/scanned — conveyed as a file or blob
- The VC carries the VHL as the `vhlink:` URI at `credentialSubject.id` — the same payload the QR carrier places at HCERT claim key 5, though encoded as a URI rather than as a CBOR map — and is signed by the VHL Sharer with a `DataIntegrityProof` (cryptosuite per [Cryptographic Algorithm Selection](volume-1.html#1xx53-cryptographic-algorithm-selection))
- Suitable for machine-to-machine transfer and asynchronous delivery scenarios where QR presentation is impractical

##### 2:3.YY4.4.1.3 Expected Actions

{{ provideVHLRespDescription.valueMarkdown }}

The VHL Receiver SHALL decode the received VHL using the appropriate path below. Upon receiving a VHL via QR code, the VHL Receiver SHALL perform the following 9-step decoding process. When the VHL is received as a Verifiable Credential (VC Enveloped VHL Option), see the VC Decoding section further below.

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
     - `alg` (algorithm): selected per [Cryptographic Algorithm Selection](volume-1.html#1xx53-cryptographic-algorithm-selection)
     - `kid` (key identifier): the identifier the trust framework derives from the DSC, matched against the verification methods in the trust list
   - Handle CBOR parsing errors

6. **Verify Digital Signature**:
   - Extract `kid` from CWT protected header
   - Retrieve corresponding Document Signing Certificate (DSC) from trust list
   - Verify the COSE signature (RFC 8152) using DSC public key
   - Check the DSC's revocation status where applicable
   - Confirm signature is valid and CWT has not been tampered with
   - Reject if signature invalid, DSC not trusted, or DSC revoked

7. **Extract and Validate CWT Claims**:
   - Extract CWT claims:
     - `iss` (issuer, claim key 1): ISO 3166-1 alpha-2 country code (optional)
     - `iat` (issued at, claim key 6): timestamp in NumericDate format
     - `exp` (expiration, claim key 4): timestamp in NumericDate format
     - `hcert` (health certificate, claim key -260): HCERT payload object
   - Validate `exp` - reject if current time > expiration
   - Validate `iat` is not in the future

8. **Extract VHL Payload from HCERT**:
   - Within the `hcert` claim (claim key -260), locate claim key 5
   - Claim key 5 contains the VHL payload (conforming to the SHL payload format) with:
     - `url`: manifest URL (required) - includes all mandatory FHIR search parameters
     - `key`: base64url-encoded decryption key, 43 characters (required). The {{ linkvhlr }} caches this key for the VHL session and uses it as the symmetric key for JWE `dir`/`A256GCM` decryption of document binaries retrieved via [ITI-68](https://profiles.ihe.net/ITI/MHD/ITI-68.html); see [ITI-YY5 Document Encryption](ITI-YY5.html#23yy5425-document-encryption).
     - `flag`: flags such as "L" for long-term, "P" for passcode (optional). See [ITI-YY3 Flags](ITI-YY3.html#flags)
     - `label`: human-readable description (optional)
     - `exp`: expiration timestamp in seconds since epoch (optional)
     - `v`: version number (optional)
   - Validate VHL payload structure conforms to the SHL payload format (per the SMART Health Links specification)

9. **Validate VHL Payload**:
   - Verify `url` field is present and is a valid HTTPS URL
   - Verify `key` field is present and is 43 characters (base64url-encoded 32 bytes)
   - Check the payload's `exp` (if present)
   - Note `flag` value:
     - "L" indicates long-term use
     - "P" indicates passcode required (obtain from VHL Holder)
     - "LP" indicates both long-term and passcode-protected
     - Any other flag value is not defined by this profile and SHALL be ignored
   - Validate `url` contains expected manifest endpoint format with mandatory parameters

**Verifiable Credential Decoding (VC Enveloped VHL Option):**

When the VHL is received as a Verifiable Credential instead of a QR code, the VHL Receiver SHALL instead:

1. **Parse VC**: Parse the received bytes as a JSON-LD document per [W3C VC Data Model v2](https://www.w3.org/TR/vc-data-model-2.0/). Where the channel carries a media type, the {{ linkvhlr }} SHALL reject a document whose media type is not `application/vc`. Where the channel carries no media type, the {{ linkvhlr }} SHALL identify the document by its content: a JSON object whose `@context` begins with `https://www.w3.org/ns/credentials/v2`. Reject if parsing fails or the document does not conform to the VC Data Model.
2. **Verify DataIntegrityProof**: Resolve the `proof.verificationMethod` to the VHL Sharer's key via the trust list (same DSC/trust framework used for CWT verification), then verify the `DataIntegrityProof` per [W3C Verifiable Credential Data Integrity 1.0](https://www.w3.org/TR/vc-data-integrity/). Reject if the proof is invalid or the issuer is untrusted.
3. **Validate Dates**: Reject if `validUntil` has passed or `validFrom` is in the future.
4. **Extract the VHL**: Read the `vhlink:` URI from `credentialSubject.id`, strip the `vhlink:/` prefix, base64url-decode the remainder, and parse the result as the VHL payload. This yields the same payload the QR carrier conveys as a CBOR map at HCERT claim key 5, so validation proceeds as in step 9 of the QR code path; only the decoding differs.
5. **Validate VHL Payload**: Apply the same validation as step 9 above (valid HTTPS `url`, 43-character `key`, `exp` not passed, flag handling).

The VHL Receiver then continues with Post-Decoding Actions below as in the QR code path.

**Post-Decoding Actions:**

After successfully decoding the VHL payload (from either QR code or VC), the VHL Receiver SHALL:

1. **Store Decryption Key Securely**:
   - The `key` parameter from the VHL payload is required to decrypt documents
   - Store the key securely in memory for the session
   - The key will be used during document retrieval via [Retrieve Document [ITI-68]](https://profiles.ihe.net/ITI/MHD/ITI-68.html) to decrypt document contents

2. **Parse Manifest URL**:
   - Extract the manifest URL from the VHL payload
   - The URL format from ITI-YY3 includes mandatory FHIR search parameters:
     - `_id`: The folder ID
     - `code`: Typically "folder"
     - `status`: Typically "current"
     - `patient.identifier`: Patient business identifier via FHIR chained search on the patient reference parameter, in `system|value` format. This is the same identifier the VHL Holder supplied as `sourceIdentifier` at [ITI-YY3](ITI-YY3.html).
     - `_include=List:item`: (if VHL Sharer supports Include DocumentReference Option)
   - Example: `https://vhl-sharer.example.org/List?_id=lHBSyhoJRJiO7zU0pxJLPA3traJm0sx2CsO9m6ABOAT&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item`

3. Prepare to Retrieve Manifest as per ITI-YY5

The VHL Receiver MAY:
- Prompt user for passcode if "P" flag is present (required for ITI-YY5)
- Display VHL label/description to user
- Record audit event per **[Audit Event – Received Health Data](Requirements-AuditEventReceived.html)**
- Cache VHL payload for subsequent access attempts

**Decoding Example (QR Code with HCERT):**

```
Input QR Code Content:
HC1:NCF3R0KLBBA...V8N8W.CE8WY

Step 1: Scan the QR code → HC1:NCF3R0KLBBA...V8N8W.CE8WY
Step 2: Verify and remove HC1: prefix → NCF3R0KLBBA...V8N8W.CE8WY
Step 3: Base45 decode → [compressed bytes]
Step 4: ZLIB/DEFLATE decompress → [CBOR bytes]
Step 5: Parse CBOR as CWT → Extract protected header (alg: ES256, kid: 8-byte SHA-256)
Step 6: Verify COSE signature using DSC from trust list based on kid
Step 7: Extract CWT claims:
  - iss (claim 1): "US"
  - iat (claim 6): 1704067200
  - exp (claim 4): 1735689600
  - hcert (claim -260): {...}
Step 8: Within hcert (claim -260), read claim key 5. It is a CBOR map with text keys,
        which is the VHL payload itself — no prefix to strip and nothing to decode.
        Where key 5 is instead a vhlink:/ string, as earlier drafts specified, strip
        the prefix and base64url-decode it. Either way the payload is:
  {
    "url": "https://vhl-sharer.example.org/List?_id=lHBSyhoJRJiO7zU0pxJLPA3traJm0sx2CsO9m6ABOAT&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item",
    "key": "86F8LY5LlWAa1-OS_FgrTnYNqFHJP2ey5RSKLJBN9jk",
    "flag": "LP",
    "exp": 1735689600,
    "label": "Patient Health Summary",
    "v": 1
  }
Step 9: Validate VHL payload fields (HTTPS url, 43-character key, exp not passed, flags)

Then, as Post-Decoding Actions: parse the manifest URL to extract the FHIR search
parameters, cache the key, and prepare for ITI-YY5 Retrieve Manifest.
```

**Manifest URL Parsing:**

The manifest URL from the VHL payload contains all parameters needed for [Retrieve Manifest [ITI-YY5]](ITI-YY5.html):

```
URL: https://vhl-sharer.example.org/List?_id=lHBSyhoJRJiO7zU0pxJLPA3traJm0sx2CsO9m6ABOAT&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item

Parsed FHIR Search Parameters (for ITI-YY5):
- _id=lHBSyhoJRJiO7zU0pxJLPA3traJm0sx2CsO9m6ABOAT
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

If the CWT `exp` claim has passed, the signed token is no longer valid:
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

Where the VHL is transmitted over HTTP between the two actors, the secure channel requirements in [Volume 1 Section XX.5.2 Secure Channel Requirements](volume-1.html#1xx52-secure-channel-requirements) apply. Several of the transmission mechanisms this transaction allows are not HTTP exchanges — a printed QR code, or one displayed on a screen — and for those the {{ linkvhlh }} is responsible for presenting the VHL only to an intended {{ linkvhlr }}, since no transport control stands between them.

#### 2:3.YY4.5.1 VHL Integrity and Authenticity
- Digital signature ensures VHL issued by trusted VHL Sharer
- CWT signature provides end-to-end trust verification

#### 2:3.YY4.5.2 VHL Confidentiality
- The VHL carries no clinical data, but it is not a public link. It carries the decryption `key`, the optional `label`, and a manifest URL that itself contains the patient business identifier — so the VHL as a whole is sensitive, and warrants the handling given to a credential rather than to a link. See [ITI-YY3 Encryption Key Security](ITI-YY3.html#23yy351-encryption-key-security) and [ITI-YY5 Privacy of Request Metadata](ITI-YY5.html#23yy556-privacy-of-request-metadata).
- Document content is held separately and retrieved at [Retrieve Manifest [ITI-YY5]](ITI-YY5.html), over the secure channel and encrypted to the `key`.

#### 2:3.YY4.5.3 Replay Attacks
- VHL Sharers SHOULD include expiration timestamps in both CWT and VHL payload
- The two expiration fields carry different force. The CWT `exp` claim bounds the validity of the signed token, and rejecting a VHL whose CWT has expired is required at [2:3.YY4.4.1.3 Expected Actions](#23yy4413-expected-actions). The VHL payload `exp` is a hint to the {{ linkvhlr }} per [SMART Health Links](https://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html); what denies access is deactivation of the VHL by the {{ linkvhls }}, which a {{ linkvhlr }} observes as `404 Not Found` at [ITI-YY5](ITI-YY5.html)
- VHL Sharers MAY implement single-use VHLs
- Short expiration times reduce replay attack window

#### 2:3.YY4.5.4 Passcode Protection
- Passcode communicated out-of-band (not in VHL)
- "P" flag indicates passcode required
- Passcode validated during manifest retrieval (ITI-YY5)
- VHL Sharers SHOULD implement rate limiting on passcode attempts

#### 2:3.YY4.5.5 QR Code Security

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

#### 2:3.YY4.5.6 VC Enveloped VHL Option Security
When the VHL is carried as a Verifiable Credential:
- Confidentiality is equivalent to the QR form: the VC carries the decryption `key` and SHOULD be treated as sensitive
- VHL Sharers SHOULD issue VCs with short lifetimes; single-use VCs are RECOMMENDED for high-security scenarios


