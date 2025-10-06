
{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}

## 2:3.YY4 Provide VHL
 {% assign provideVHL = site.data.Requirements-ProvideVHL %}
 {% assign provideVHLResp = site.data.Requirements-RespondtoProvideVHL %}


### 2:3.YY4.1 Scope
This section corresponds to transaction [ITI-YY4] of the IHE Technical Framework. Transaction [ITI-YY4] is used by the VHL Holder, VHL Receiver and VHL Sharer Actors. This transaction is used to provide a mechanism for sharing a VHL and retrieving health documents.


{% assign provideVHLTitle = provideVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign provideVHLRespTitle = provideVHLResp.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign provideVHLDescription = provideVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign provideVHLRespDescription = provideVHLResp.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

### 2:3.YY4.2 Actor Roles
| Actor | Role |
|-------|------|
| VHL Holder | Provides the VHL to a VHL Receiver through a supported transmission mechanism |
| VHL Receiver | Receives the VHL from a VHL Holder and prepares to retrieve the referenced health documents from the VHL Sharer |
| VHL Sharer| Authenticare request from the VHL Receiver and returns requested health documents|
{: .grid}



### 2:3.YY4.3 Referenced Standards


### 2:3.YY4.4 Messages

<figure >
  <div style="width:35em; max-width:100%;">
     {%include ITI-YY4.svg%}
  </div>
  <p id="fX.X.X.X-2" class="figureTitle">Figure X.X.X.X-2: Interaction Diagram</p>
</figure>

#### 2:3.YY4.4.1 Provide VHL Request Message
The VHL Holder initiates transmission of a VHL to the VHL Receiver.
{{ provideVHLDescription.valueMarkdown}}

{% include requirements-list-statements.liquid site=site req=provideVHLDescription  %}

##### 2:3.YY4.4.1.1 Trigger Events
A VHL Holder initiates the Provide VHL transaction when:
- The VHL Holder wishes to grant access to their health documents to a VHL Receiver
- The VHL Holder has obtained a valid VHL from a VHL Sharer (via ITI-YY1 Generate VHL transaction)
- The VHL Holder encounters a VHL Receiver capable of processing VHLs in a relevant healthcare context

Implementations MAY support one or more options of transmission.

**Option 1: QR Code Rendering**

The VHL Holder renders the VHL payload as a QR code following ISO/IEC 18004:2015. The VHL Receiver scans the QR code using a camera or scanner device.

- The QR code SHALL encode either:
  - The complete VHL payload (for compact VHLs)
  - A short URL that resolves to the VHL payload
- The VHL Holder MAY display the QR code on a mobile device screen or print it on paper
- The VHL Receiver SHALL be capable of decoding QR codes and extracting the VHL payload

This option is particularly suitable for in-person care encounters, walk-in clinics, and emergency departments.

**Option 2: Deep Link Sharing**

The VHL Holder transmits the VHL as a deep link (URL) through secure messaging, email, or other electronic communication channels.

- The URL SHALL use HTTPS protocol
- The URL MAY be a short URL that redirects to the full VHL payload
- The VHL Receiver receives the URL through their communication application and opens it in a VHL-capable application or browser

This option is suitable for telehealth encounters, asynchronous care coordination, and patient-provider messaging.

**Option 3: Verifiable Credential Presentation**

The VHL Holder presents the VHL as a W3C Verifiable Credential through a digital wallet application using standard VC presentation protocols.

- The VHL SHALL be formatted as a Verifiable Credential conforming to W3C VC Data Model v1.1 or later
- Presentation MAY occur via QR code, deep link, or direct wallet-to-wallet protocols
- The VHL Receiver SHALL be capable of verifying VC signatures and extracting the VHL payload

This option is suitable for jurisdictions implementing digital identity infrastructure and wallet-based health data sharing.

**Option 4: Proximity-based Transmission (NFC/Bluetooth)**

The VHL Holder transmits the VHL using near-field communication (NFC) or Bluetooth protocols when devices are in physical proximity.

- Transmission SHALL use secure protocols (e.g., NFC NDEF, Bluetooth LE with encryption)
- The VHL Holder initiates transmission after explicit user action (tap, button press)
- The VHL Receiver accepts the transmission and extracts the VHL payload

This option is suitable for contactless check-in scenarios and high-throughput environments.

---


##### 2:3.YY4.4.1.2 Message Semantics


##### 2:3.YY4.4.1.3 Expected Actions - VHL Holder

The VHL Holder SHALL:

1. **Verify VHL Validity**: Confirm that the VHL has not expired and meets any applicable usage constraints
2. **Select Transmission Method**: Choose an appropriate transmission mechanism based on:
   - Available device capabilities
   - VHL Receiver capabilities  
   - Care encounter context
   - User preference
3. **Render/Transmit VHL**: Execute the selected transmission method
4. **Provide Passcode (if required)**: If the VHL is passcode-protected, communicate the passcode to the VHL Receiver through an out-of-band channel (verbal, printed, separate message)

The VHL Holder MAY:
- Maintain a record of VHL transmissions for personal tracking
- Revoke VHL access through mechanisms provided by the VHL Sharer (if supported)

---
##### 2:3.YY4.4.1.3 Expected Actions - VHL Receiver

1. **Parse the VHL**: 
   - Decode the VHL from the transmission format (QR code, URL, VC, NFC, etc.)
   - Extract the JWS structure including header and payload
   - Identify the VHL Sharer from the issuer identifier (`iss` claim)

2. **Validate Digital Signature Against Trusted Key**:
   - Obtain the VHL Sharer's public key from a recognized Trust Anchor using previously retrieved trust lists (ITI-YY3 Retrieve Trust List transaction)
   - Verify the JWS signature using the VHL Sharer's public key
   - Confirm that the VHL Sharer is a valid participant in the trust network
   - Ensure the VHL payload has not been tampered with

3. **Prepare to Retrieve Associated Health Documents**:
   - Extract the manifest URL from the validated VHL payload
   - If expiration timestamp is present, verify that the VHL is still valid
   - If usage constraints are present, validate that the intended use aligns with those constraints
   - Prepare to initiate document retrieval requests (typically via subsequent HTTP requests over mTLS)

The VHL Receiver MAY:
- Prompt the user to enter a passcode if the `flag` indicates passcode protection
- Display the VHL label/description to confirm the contents with the user
- Record an audit event documenting receipt of the VHL (see Section 2:3.YY4.5)
- Cache the VHL payload for subsequent access attempts within the validity period

**Failure Scenarios:**

If signature verification fails, the VHL Receiver SHALL:
- Reject the VHL
- NOT attempt to retrieve any health documents
- Inform the user/operator of the verification failure
- Record the failed verification attempt in audit logs

If the VHL has expired, the VHL Receiver SHALL:
- Reject the VHL
- Inform the user/operator that the VHL is no longer valid
- Request a new VHL from the VHL Holder if appropriate

---
#### 2:3.YY4.4.2  Provide VHL Response Message 

##### 2:3.YY4.4.2.1 Trigger Events
The VHL Receiver MAY provide an optional acknowledgment to the VHL Holder confirming receipt and validation of the VHL. This response is transmission-mechanism dependent and is typically supported only in digital channels (not QR code scanning).

##### 2:3.YY4.4.2.2 Message Semantics

For transmission mechanisms that support bidirectional communication (e.g., deep links with callback URLs, VC presentations with receipts), the response MAY include:

**Table 2:3.YY4.4.2.2-1: Optional Response Elements**

| Element | Cardinality | Description |
|---------|-------------|-------------|
| Acknowledgment | 0..1 | Confirmation that VHL was successfully received and validated |
| Receipt Identifier | 0..1 | Unique identifier for this receipt transaction |
| Receiver Identifier | 0..1 | Identifier of the VHL Receiver organization |
| Timestamp | 0..1 | ISO 8601 timestamp of receipt |
{: .grid}

The response format is transmission-mechanism specific and is defined in **[Volume 3](volume-3.html)**.

##### 2:3.YY4.4.2.3 Expected Actions

**VHL Receiver (Responder):**
- MAY send an acknowledgment if supported by the transmission mechanism
- SHALL NOT include sensitive health information in the acknowledgment

**VHL Holder (Initiator):**
- MAY receive and store acknowledgment receipts for personal records
- SHALL NOT rely on acknowledgment for security or access control decisions

---

### 2:3.YY4.5 Security Considerations

#### 2:3.YY4.5.1 VHL Integrity and Authenticity

The digital signature on the VHL ensures that:
- The VHL was issued by a trusted VHL Sharer
- The VHL payload has not been modified since issuance
- The VHL Receiver can validate the trust chain through the Trust Anchor

VHL Receivers MUST verify signatures before trusting any VHL content.

#### 2:3.YY4.5.2 VHL Confidentiality

The VHL itself is not encrypted and may be transmitted over public channels (e.g., QR codes, email). However:
- The VHL does NOT contain Protected Health Information (PHI)
- The VHL only contains a reference (URL) to retrieve health documents
- Actual health documents are retrieved over secure mTLS connections (separate transactions)

If the manifest URL itself is considered sensitive, implementers MAY use short URLs or encryption wrappers.

#### 2:3.YY4.5.3 Replay Attacks

To mitigate replay attacks:
- VHL Sharers SHOULD include expiration timestamps in all VHLs
- VHL Receivers SHOULD enforce expiration validation
- VHL Sharers MAY implement single-use VHLs that become invalid after first access
- VHL Sharers MAY implement access quotas limiting the number of retrievals

#### 2:3.YY4.5.4 Passcode Protection

When VHLs are passcode-protected:
- The passcode SHALL be communicated through an out-of-band channel (not in the VHL itself)
- The passcode is required during document retrieval, not during VHL reception
- VHL Sharers SHOULD implement rate limiting and account lockout for passcode attempts
- Passcodes SHOULD have sufficient entropy to resist brute-force attacks

#### 2:3.YY4.5.5 Trust Network Validation

VHL Receivers MUST:
- Validate that the VHL Sharer is a current participant in the trust network
- Check certificate revocation status where applicable  
- Reject VHLs from untrusted or expired participants

#### 2:3.YY4.5.6 Audit Logging

VHL Receivers MAY record audit events when receiving VHLs, including:
- Timestamp of receipt
- VHL Holder identifier (if available)
- VHL Sharer identifier
- VHL identifier or manifest URL
- Outcome of signature verification
- Subsequent document retrieval attempts

Audit events SHALL comply with the [Audit Event – Received Health Data](Requirements-AuditEventReceived.html) requirement and SHOULD conform to ATNA audit message formats.

#### 2:3.YY4.5.7 User Consent and Authorization

The act of a VHL Holder providing a VHL to a VHL Receiver represents authorization for access. However:
- Jurisdictional policies may require additional consent verification
- VHL Sharers may have recorded consent during VHL generation (ITI-YY1)
- VHL Holders retain the right to revoke access where supported

#### 2:3.YY4.5.8 Transmission Security

Different transmission mechanisms have different security profiles:

**QR Codes:**
- Can be photographed or copied without detection
- Should be used for time-limited access scenarios
- Are suitable for supervised in-person encounters

**Deep Links:**
- Should use HTTPS to prevent interception
- May be forwarded or shared unintentionally
- Should include expiration and single-use constraints where appropriate

**Verifiable Credentials:**
- Provide strongest binding to holder identity
- May include holder authentication mechanisms
- Are suitable for long-term use cases

**Proximity Transmission:**
- Provides physical access control (must be present)
- Should use encrypted transport protocols
- Is suitable for high-security environments

---

### 2:3.YY4.6 Conformance

To claim conformance with this transaction:

**VHL Holder:**
- SHALL support at least one transmission option defined in Section 2:3.YY4.4.1.2.2
- SHALL transmit VHL payloads conforming to the structure defined in Volume 3
- SHALL provide passcodes through out-of-band channels when required

**VHL Receiver:**
- SHALL support at least one transmission option defined in Section 2:3.YY4.4.1.2.2
- SHALL verify VHL digital signatures before trusting VHL content
- SHALL validate VHL expiration when present
- SHALL retrieve public keys from trusted Trust Anchors
- SHALL reject VHLs with invalid signatures or expired validity periods

---
# DRAFT: ITI-YY4 Retrieve VHL Documents Transaction

---

## 2:3.YY4 Retrieve VHL Documents

### 2:3.YY4.1 Scope

The Retrieve VHL Documents transaction enables a VHL Receiver to retrieve health documents from a VHL Sharer using a previously obtained and validated Verified Health Link (VHL). This transaction occurs after the VHL Receiver has received a VHL from a VHL Holder (through out-of-scope mechanisms such as QR code scanning, deep links, or verifiable credential presentation).

This transaction SHALL be conducted over a secure channel as defined by the IHE Audit Trail and Node Authentication (ATNA) Profile. Both the VHL Receiver and VHL Sharer SHALL authenticate each other's participation in the trust network. The VHL Sharer validates that the requesting VHL Receiver is authorized to access the documents before responding.

The transaction supports two primary patterns:
1. **Manifest-based retrieval**: Retrieving a manifest/search set of available documents (similar to MHD ITI-67)
2. **Direct document retrieval**: Retrieving specific document content (similar to MHD ITI-68)

---

### 2:3.YY4.2 Actor Roles

**Table 2:3.YY4.2-1: Actor Roles**

| Actor | Role |
|-------|------|
| VHL Receiver | Initiates requests to retrieve health documents using a validated VHL as authorization |
| VHL Sharer | Responds to document retrieval requests after authenticating and authorizing the VHL Receiver |
{: .grid}

---

### 2:3.YY4.3 Referenced Standards

This transaction references the following standards and specifications:

**Core Standards:**
- **RFC 8446**: The Transport Layer Security (TLS) Protocol Version 1.3
- **RFC 5280**: Internet X.509 Public Key Infrastructure Certificate and Certificate Revocation List (CRL) Profile
- **RFC 7515**: JSON Web Signature (JWS)
- **RFC 7519**: JSON Web Token (JWT)
- **RFC 9110**: HTTP Semantics

**FHIR Specifications:**
- **FHIR R4**: [HL7 FHIR Release 4](http://hl7.org/fhir/R4/)
- **FHIR DocumentReference**: For document metadata representation
- **FHIR Bundle**: For search set responses

**IHE Profiles:**
- **ITI TF-2: Mobile Health Document Sharing (MHD)**: Transaction patterns for document search and retrieval
- **ITI TF-1: Section 9**: Audit Trail and Node Authentication (ATNA) Profile
- **ITI TF-2: 3.19**: Authenticate Node transaction

---

### 2:3.YY4.4 Messages

The Retrieve VHL Documents transaction consists of two message types:
1. **Retrieve VHL Manifest Request/Response** - Retrieve list of available documents
2. **Retrieve VHL Document Request/Response** - Retrieve specific document content

<div>
<img src="http://www.plantuml.com/plantuml/png/bLLDRzim33rFNt7YWsWKkj30qgYbL2WCfGEG9jcxasbHPn6Nzxx6YxRxQafAqgqIRVRyx-zySt__6k9IxgaG8A8OSIQ0j9rWm8j0L5Q0Sm2BmC07-W0b0ca1ac8L0-i0ZW5X0O820h1U4ZCe5iWIYGaU4G4jQGWjUGmmU4mDk4GWj0I4-W7W8U0U8Y8mD5jc1ZcC4-K88YC8-C48Y88YC8-C4YC88YC8-C4C88YC8-C48" />
</div>

**Figure 2:3.YY4.4-1: Retrieve VHL Documents Interaction Diagram**

---

#### 2:3.YY4.4.1 Retrieve VHL Manifest Request Message

The VHL Receiver initiates a request to retrieve a manifest (search set) of available health documents.

##### 2:3.YY4.4.1.1 Trigger Events

A VHL Receiver initiates the Retrieve VHL Manifest Request when:
- The VHL Receiver has received and validated a VHL containing a manifest URL
- The VHL Receiver has established an mTLS connection with the VHL Sharer
- The VHL Receiver needs to discover what documents are available before retrieving specific content

##### 2:3.YY4.4.1.2 Message Semantics

**Transport and Security**

The request SHALL be transmitted over HTTPS using mutually authenticated TLS (mTLS):
- **Protocol**: HTTPS
- **Method**: POST
- **TLS Version**: TLS 1.2 or higher
- **Client Certificate**: VHL Receiver SHALL present a valid X.509 certificate
- **Server Certificate**: VHL Sharer SHALL present a valid X.509 certificate
- Both certificates MUST be validated against keys published by the Trust Anchor

**Request Structure**

The request SHALL be a POST to the manifest URL extracted from the VHL, with the following structure:

**HTTP Headers:**

```http
POST /vhl/manifest/{manifest-id} HTTP/1.1
Host: vhl-sharer.example.org
Content-Type: application/jose+json
Authorization: Bearer {vhl-token}
Accept: application/fhir+json
```

**Table 2:3.YY4.4.1.2-1: Required HTTP Headers**

| Header | Description |
|--------|-------------|
| Content-Type | SHALL be `application/jose+json` for JWS-signed requests |
| Authorization | SHALL contain the VHL token obtained from the VHL Holder |
| Accept | SHALL be `application/fhir+json` for FHIR Bundle responses |
{: .grid}

**Request Body - Signed Search Parameters**

To enable the VHL Sharer to authenticate the request, the VHL Receiver SHALL sign the search parameters using JWS. This provides:
- **Authentication**: Proof that the request comes from a trusted VHL Receiver
- **Integrity**: Assurance that search parameters haven't been tampered with
- **Non-repudiation**: Audit trail of who requested what documents

**Option 1: JWS-Signed Search Request (RECOMMENDED)**

The request body SHALL be a JWS Compact Serialization containing the search parameters:

```json
{
  "header": {
    "alg": "ES256",
    "kid": "receiver-key-123",
    "typ": "vhl-request+jwt"
  },
  "payload": {
    "iss": "https://receiver.example.org",
    "aud": "https://vhl-sharer.example.org",
    "iat": 1704067200,
    "jti": "req-unique-id-456",
    "vhl": "{original-vhl-token}",
    "search": {
      "type": "DocumentReference",
      "patient": "Patient/123",
      "status": "current",
      "category": "summary"
    },
    "passcode": "user-provided-pin"
  }
}
```

Serialized as JWS Compact:
```
eyJhbGciOiJFUzI1NiIsImtpZCI6InJlY2VpdmVyLWtleS0xMjMiLCJ0eXAiOiJ2aGwtcmVxdWVzdCtqd3QifQ.eyJpc3MiOiJodHRwczovL3JlY2VpdmVyLmV4YW1wbGUub3JnIiwiYXVkIjoiaHR0cHM6Ly92aGwtc2hhcmVyLmV4YW1wbGUub3JnIiwiaWF0IjoxNzA0MDY3MjAwLCJqdGkiOiJyZXEtdW5pcXVlLWlkLTQ1NiIsInZobCI6IntvcmlnaW5hbC12aGwtdG9rZW59Iiwic2VhcmNoIjp7InR5cGUiOiJEb2N1bWVudFJlZmVyZW5jZSIsInBhdGllbnQiOiJQYXRpZW50LzEyMyIsInN0YXR1cyI6ImN1cnJlbnQiLCJjYXRlZ29yeSI6InN1bW1hcnkifSwicGFzc2NvZGUiOiJ1c2VyLXByb3ZpZGVkLXBpbiJ9.MEUCIQDxyz...
```

**Table 2:3.YY4.4.1.2-2: Signed Request Payload Elements**

| Element | Cardinality | Description |
|---------|-------------|-------------|
| iss | 1..1 | Identifier of the VHL Receiver |
| aud | 1..1 | Identifier of the VHL Sharer |
| iat | 1..1 | Timestamp when request was issued |
| jti | 1..1 | Unique request identifier for replay protection |
| vhl | 1..1 | The original VHL token for authorization verification |
| search | 0..1 | FHIR search parameters (DocumentReference, patient, status, etc.) |
| passcode | 0..1 | User-provided passcode if VHL requires it |
{: .grid}

**Option 2: HTTP Signature (ALTERNATIVE)**

Alternatively, implementations MAY use HTTP Message Signatures (RFC 9421) to sign the request:

```http
POST /vhl/manifest/{manifest-id} HTTP/1.1
Host: vhl-sharer.example.org
Content-Type: application/x-www-form-urlencoded
Authorization: Bearer {vhl-token}
Signature-Input: sig1=("@method" "@target-uri" "content-type" "authorization");created=1704067200;keyid="receiver-key-123"
Signature: sig1=:MEUCIQDxyz...:
Content-Digest: sha-256=:X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=:

type=DocumentReference&patient=Patient/123&status=current
```

**Implementation Guidance:**
- Option 1 (JWS-signed body) is RECOMMENDED for broader interoperability
- Option 2 (HTTP Signatures) MAY be used where HTTP-native signing is preferred
- Implementations SHALL support at least Option 1

---

##### 2:3.YY4.4.1.3 Expected Actions - VHL Receiver

The VHL Receiver SHALL:

1. **Establish mTLS Connection**:
   - Initiate TLS handshake presenting valid X.509 client certificate
   - Validate VHL Sharer's server certificate against Trust Anchor keys
   - Ensure successful mutual authentication

2. **Prepare Signed Request**:
   - Extract manifest URL from validated VHL
   - Construct search parameters (if filtering documents)
   - Sign the request payload using VHL Receiver's private key
   - Include original VHL token for authorization
   - Include passcode if VHL is passcode-protected

3. **Submit Request**:
   - POST signed request to manifest URL
   - Include appropriate HTTP headers
   - Handle HTTP responses (200, 401, 403, 404, 500)

4. **Process Response** (see 2:3.YY4.4.2):
   - Parse FHIR Bundle containing DocumentReference resources
   - Validate response signature if present
   - Cache manifest for subsequent document retrievals

The VHL Receiver MAY:
- Record an audit event documenting the document access attempt per **[Audit Event – Received Health Data](Requirements-AuditEventReceived.html)**

---

##### 2:3.YY4.4.1.3 Expected Actions - VHL Sharer

Upon receiving a Retrieve VHL Manifest Request, the VHL Sharer SHALL:

1. **Authenticate mTLS Connection**:
   - Validate VHL Receiver's client certificate against Trust Anchor keys
   - Confirm VHL Receiver is a valid participant in the trust network
   - Reject connection if certificate validation fails

2. **Verify Request Signature**:
   - Extract `kid` from JWS header to identify VHL Receiver's key
   - Retrieve VHL Receiver's public key from Trust Anchor (via cached trust list)
   - Verify JWS signature to authenticate request
   - Reject request if signature validation fails

3. **Authorize Request**:
   - Extract and validate the VHL token from request payload
   - Verify VHL signature using VHL Sharer's own previous issuance
   - Confirm VHL has not expired
   - Verify VHL has not been revoked
   - If passcode-protected, validate provided passcode
   - Confirm VHL authorizes access to requested documents

4. **Execute Search**:
   - Apply search parameters from request payload
   - Query document repository for matching documents
   - Filter results based on VHL scope and consent

5. **Prepare Response**:
   - Construct FHIR Bundle (type: searchset) with DocumentReference resources
   - Include document metadata (type, creation date, format, etc.)
   - MAY sign the response Bundle for additional integrity

6. **Return Response**:
   - Send HTTP 200 with FHIR Bundle
   - Handle error conditions appropriately (401, 403, 404)

The VHL Sharer MAY:
- Record an audit event per **[Audit Event – Accessed Health Data](Requirements-AuditEventAccess.html)**
- Implement rate limiting to prevent abuse
- Log failed authentication/authorization attempts

**Error Conditions:**

| HTTP Status | Condition |
|-------------|-----------|
| 401 Unauthorized | mTLS authentication failed or signature invalid |
| 403 Forbidden | VHL expired, revoked, or doesn't authorize requested documents |
| 404 Not Found | Manifest ID not found or VHL invalid |
| 422 Unprocessable Entity | Invalid passcode provided |
| 429 Too Many Requests | Rate limit exceeded |
| 500 Internal Server Error | Server-side processing error |
{: .grid}

---

#### 2:3.YY4.4.2 Retrieve VHL Manifest Response Message

##### 2:3.YY4.4.2.1 Trigger Events

The VHL Sharer returns the manifest response after successfully authenticating and authorizing the VHL Receiver's request.

##### 2:3.YY4.4.2.2 Message Semantics

**Success Response (HTTP 200)**

```http
HTTP/1.1 200 OK
Content-Type: application/fhir+json
ETag: "W/\"version-123\""
```

**Response Body - FHIR Bundle:**

```json
{
  "resourceType": "Bundle",
  "type": "searchset",
  "total": 2,
  "link": [
    {
      "relation": "self",
      "url": "https://vhl-sharer.example.org/vhl/manifest/abc123"
    }
  ],
  "entry": [
    {
      "fullUrl": "https://vhl-sharer.example.org/DocumentReference/doc1",
      "resource": {
        "resourceType": "DocumentReference",
        "id": "doc1",
        "status": "current",
        "type": {
          "coding": [{
            "system": "http://loinc.org",
            "code": "60591-5",
            "display": "Patient Summary Document"
          }]
        },
        "subject": {
          "reference": "Patient/123"
        },
        "date": "2024-01-15T10:30:00Z",
        "content": [
          {
            "attachment": {
              "contentType": "application/fhir+json",
              "url": "https://vhl-sharer.example.org/vhl/document/doc1",
              "size": 15234,
              "hash": "07a2f6e5f8b3c9d4..."
            },
            "format": {
              "system": "http://ihe.net/fhir/ValueSet/IHE.FormatCode.codesystem",
              "code": "urn:ihe:iti:xds:2017:mimeTypeSufficient"
            }
          }
        ]
      }
    },
    {
      "fullUrl": "https://vhl-sharer.example.org/DocumentReference/doc2",
      "resource": {
        "resourceType": "DocumentReference",
        "id": "doc2",
        "status": "current",
        "type": {
          "coding": [{
            "system": "http://loinc.org",
            "code": "82593-5",
            "display": "Immunization Summary Document"
          }]
        },
        "subject": {
          "reference": "Patient/123"
        },
        "date": "2024-01-10T08:00:00Z",
        "content": [
          {
            "attachment": {
              "contentType": "application/pdf",
              "url": "https://vhl-sharer.example.org/vhl/document/doc2",
              "size": 45678,
              "hash": "3b8c9f2e1a7d6..."
            }
          }
        ]
      }
    }
  ]
}
```

##### 2:3.YY4.4.2.3 Expected Actions

**VHL Sharer:**
- Return FHIR Bundle with search results
- Include all matching DocumentReference resources
- Provide document URLs for subsequent retrieval

**VHL Receiver:**
- Parse FHIR Bundle
- Extract DocumentReference resources
- Cache manifest for subsequent document retrievals
- Prepare to retrieve specific documents using URLs from attachment elements

---

#### 2:3.YY4.4.3 Retrieve VHL Document Request Message

The VHL Receiver retrieves specific document content after obtaining the manifest.

##### 2:3.YY4.4.3.1 Trigger Events

After receiving the manifest, the VHL Receiver initiates document retrieval for specific documents.

##### 2:3.YY4.4.3.2 Message Semantics

**Request Structure:**

```http
GET /vhl/document/{document-id} HTTP/1.1
Host: vhl-sharer.example.org
Authorization: Bearer {vhl-token}
Accept: application/fhir+json, application/pdf
If-None-Match: "W/\"version-123\""
```

Alternatively, for signed requests:

```http
POST /vhl/document/{document-id} HTTP/1.1
Host: vhl-sharer.example.org
Content-Type: application/jose+json
Accept: application/fhir+json, application/pdf

{signed-request-with-vhl-token}
```

##### 2:3.YY4.4.3.3 Expected Actions

**VHL Receiver:**
- Extract document URL from manifest DocumentReference
- Submit GET or signed POST request
- Validate retrieved document (integrity, signature if present)
- MAY verify document signature per **[Verify Document Signature](Requirements-VerifyDocumentSignature.html)**

**VHL Sharer:**
- Re-validate VHL authorization
- Retrieve document content
- Return document with appropriate Content-Type
- MAY include digital signature on document

---

#### 2:3.YY4.4.4 Retrieve VHL Document Response Message

##### 2:3.YY4.4.4.1 Trigger Events

VHL Sharer returns document after authorization.

##### 2:3.YY4.4.4.2 Message Semantics

```http
HTTP/1.1 200 OK
Content-Type: application/fhir+json
Content-Length: 15234
ETag: "W/\"doc-version-456\""

{document-content}
```

---

### 2:3.YY4.5 Security Considerations

#### 2:3.YY4.5.1 Mutual TLS Authentication

All document retrieval requests MUST occur over mTLS:
- Both VHL Receiver and VHL Sharer present X.509 certificates
- Certificates validated against Trust Anchor-published keys
- Failed certificate validation results in connection rejection

#### 2:3.YY4.5.2 Request Authentication via JWS

Signing the request payload provides:
- **Authentication**: Proves request origin from trusted VHL Receiver
- **Integrity**: Ensures request parameters haven't been modified
- **Replay Protection**: Unique `jti` prevents request reuse
- **Audit Trail**: Non-repudiable record of who requested what

#### 2:3.YY4.5.3 VHL Token Validation

VHL Sharers MUST:
- Validate VHL signature using their own issuance keys
- Check VHL expiration timestamp
- Verify VHL hasn't been revoked
- Confirm VHL scope authorizes requested documents
- Validate passcode if VHL is passcode-protected

#### 2:3.YY4.5.4 Passcode Handling

When VHLs are passcode-protected:
- Passcode included in signed request payload
- VHL Sharer validates passcode server-side
- Implement rate limiting on failed attempts
- Consider account lockout after threshold failures

#### 2:3.YY4.5.5 Audit Logging

Both actors SHOULD record:
- All document access attempts (successful and failed)
- Authentication failures
- Authorization denials
- Timestamps and requesting entity identifiers

Audit events SHALL comply with ATNA requirements.

#### 2:3.YY4.5.6 Replay Attack Prevention

- Include unique `jti` in each request
- VHL Sharer MAY cache recent `jti` values to detect replays
- Short validity windows for signed requests
- VHL expiration limits replay window

---

### 2:3.YY4.6 Conformance

**VHL Receiver SHALL:**
- Establish mTLS connections presenting valid certificates
- Sign document requests using JWS (Option 1) or HTTP Signatures (Option 2)
- Include VHL token in all requests
- Validate VHL Sharer responses

**VHL Sharer SHALL:**
- Accept mTLS connections and validate client certificates
- Verify request signatures
- Validate VHL tokens before authorizing access
- Return FHIR-conformant responses
- Implement appropriate error responses

---

### 2:3.YY4.7 Relationship to Other Transactions

**ITI-YY1 Generate VHL**: VHL used in this transaction was generated via ITI-YY1

**ITI-YY3 Retrieve Trust List**: Public keys for certificate and signature validation obtained via ITI-YY3

**Out-of-Scope VHL Transmission**: VHL Holder provides VHL to VHL Receiver through mechanisms not defined in this transaction (QR code, URL, VC, etc.)

---

## PlantUML Diagram Source

(New diagram reflecting document retrieval flow to be created)