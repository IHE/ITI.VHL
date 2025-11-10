{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}

## 2:3.YY5 Retrieve Manifest

{% assign reqRequestVHLDocs = site.data.Requirements-RequestVHLDocuments %}

{% assign reqRequestVHLDocsTitle = reqRequestVHLDocs.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqRequestVHLDocsDescription = reqRequestVHLDocs.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

### 2:3.YY5.1 Scope

The Retrieve Manifest transaction enables a {{ linkvhlr }} to retrieve a manifest (search set) of available health documents from a {{ linkvhls }} using a previously obtained and validated Verified Health Link (VHL). 

This transaction occurs after the {{ linkvhlr }} has received a VHL from a VHL Holder (via ITI-YY4 Provide VHL) and validated the VHL signature.

Both the {{ linkvhlr }} and {{ linkvhls }} SHALL authenticate each other's participation in the trust network. The {{ linkvhls }} validates that the requesting {{ linkvhlr }} is authorized to access the documents before responding.This transaction MAY be optionally conducted over a secure channel as defined by the IHE Audit Trail and Node Authentication (ATNA) Profile. 

### 2:3.YY5.2 Actor Roles

| Actor | Role |
|-------|------|
| {{ linkvhlr }} | Initiates request to retrieve document manifest using validated VHL as authorization |
| {{ linkvhls }} | Responds to manifest request after authenticating and authorizing the VHL Receiver |
{: .grid}

### 2:3.YY5.3 Referenced Standards

**Core Standards:**
- **RFC 8446**: TLS Protocol Version 1.3
- **RFC 5280**: X.509 PKI Certificate and CRL Profile
- **RFC 7515**: JSON Web Signature (JWS)
- **RFC 7519**: JSON Web Token (JWT)
- **RFC 9110**: HTTP Semantics

**FHIR Specifications:**
- **FHIR R4**: [HL7 FHIR Release 4](http://hl7.org/fhir/R4/)
- **FHIR DocumentReference**: For document metadata
- **FHIR Bundle**: For search set responses

**IHE Profiles:**
- **ITI TF-2: Mobile Health Document Sharing (MHD)**: Transaction patterns for document search
- **ITI TF-1: Section 9**: ATNA Profile
- **ITI TF-2: 3.19**: Authenticate Node transaction

### 2:3.YY5.4 Messages

<figure >
  <div style="width:35em; max-width:100%;">
     {%include ITI-YY5.svg%}
  </div>
  <p id="fX.X.X.X-5" class="figureTitle">Figure X.X.X.X-5: Retrieve Manifest Interaction Diagram</p>
</figure>

#### 2:3.YY5.4.1 Retrieve Manifest Request Message

##### 2:3.YY5.4.1.1 Trigger Events

{{ reqRequestVHLDocsDescription.valueMarkdown }}

A {{ linkvhlr }} initiates the Retrieve Manifest Request when:
- The {{ linkvhlr }} has received and validated a VHL containing a manifest URL
- The {{ linkvhlr }} needs to discover available documents before retrieving specific content

##### 2:3.YY5.4.1.2 Message Semantics

This message is implemented as a FHIR operation request using the [$retrieve-manifest operation definition](OperationDefinition-retrieve-manifest.html).

**Request Structure**

POST to the DocumentReference endpoint:

```http
POST [base]/DocumentReference/$retrieve-manifest HTTP/1.1
Host: vhl-sharer.example.org
Content-Type: application/fhir+json
Accept: application/fhir+json
```

Where **[base]** is the URL of the VHL Sharer Service provider.

**Table 2:3.YY5.4.1.2-1: $retrieve-manifest Operation Input Parameters**

| Parameter Name | Cardinality | Type | Description |
|----------------|-------------|------|-------------|
| vhlToken | [1..1] | string | The VHL token obtained from the VHL Holder, used to authorize access to documents |
| passcode | [0..1] | string | User-provided passcode if the VHL is passcode-protected |
| receiverSignature | [1..1] | string | JWS signature from the VHL Receiver containing issuer (iss), issued-at timestamp (iat), unique request identifier (jti), and optional passcode |
| searchParams | [0..*] | string | Optional FHIR search parameters to filter the document manifest (e.g., type, date, status) |
{: .grid}

**Request Example:**

```json
{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "vhlToken",
      "valueString": "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9..."
    },
    {
      "name": "passcode",
      "valueString": "123456"
    },
    {
      "name": "receiverSignature",
      "valueString": "eyJhbGciOiJFUzI1NiIsImtpZCI6InJlY2VpdmVyLWtleS0xMjMiLCJ0eXAiOiJ2aGwtcmVxdWVzdCtqd3QifQ..."
    }
  ]
}
```

**Signed Request Payload (receiverSignature content):**

The {{ linkvhlr }} SHALL sign the request using JWS to enable {{ linkvhls }} to authenticate:

```json
{
  "header": {
    "alg": "ES256",
    "kid": "receiver-key-123",
    "typ": "vhl-request+jwt"
  },
  "payload": {
    "iss": "https://receiver.example.org",
    "iat": 1704067200,
    "jti": "req-unique-id-456",
    "passcode": "user-provided-pin"
  }
}
```

**Signed Request Payload Elements:**

| Element | Cardinality | Description |
|---------|-------------|-------------|
| iss | 1..1 | Identifier of VHL Receiver |
| iat | 1..1 | Timestamp when request issued |
| jti | 1..1 | Unique request identifier (replay protection) |
| passcode | 0..1 | User-provided passcode if VHL requires it |
{: .grid}

##### 2:3.YY5.4.1.3 Expected Actions - VHL Receiver

The {{ linkvhlr }} SHALL:


2. **Prepare Signed Request**:
   - Extract manifest URL from validated VHL
   - Construct search parameters (if filtering)
   - Sign request payload using {{ linkvhlr }} private key
   - Include original VHL token
   - Include passcode if VHL is passcode-protected

3. **Submit Request**:
   - POST signed request to manifest URL
   - Handle HTTP responses (200, 401, 403, 404, 500)

4. **Process Response**:
   - Parse FHIR Bundle with DocumentReference resources
   - Cache manifest for subsequent document retrievals

The {{ linkvhlr }} MAY:
- Record audit event per **[Audit Event – Received Health Data](Requirements-AuditEventReceived.html)**

##### 2:3.YY5.4.1.3 Expected Actions - VHL Sharer

Upon receiving Retrieve Manifest Request, the {{ linkvhls }} SHALL:



2. **Verify Request Signature**:
   - Extract `kid` from JWS header
   - Retrieve {{ linkvhlr }} public key from Trust Anchor (cached trust list from ITI-YY2)
   - Verify JWS signature
   - Reject if signature invalid

3. **Authorize Request**:
   - Extract and validate VHL token
   - Verify VHL signature using {{ linkvhls }} own issuance keys
   - Confirm VHL not expired
   - Verify VHL not revoked
   - Validate passcode if required
   - Confirm VHL authorizes requested documents

4. **Execute Search**:
   - Apply search parameters
   - Query document repository
   - Filter based on VHL scope and consent

5. **Prepare Response**:
   - Construct FHIR Bundle (type: searchset) with DocumentReference resources
   - Include document metadata
   - MAY sign response Bundle

6. **Return Response**:
   - Send HTTP 200 with FHIR Bundle
   - Handle errors appropriately

The {{ linkvhls }} MAY:
- Record audit event per **[Audit Event – Accessed Health Data](Requirements-AuditEventAccess.html)**
- Implement rate limiting
- Log failed attempts

**Error Conditions:**

| HTTP Status | Condition |
|-------------|-----------|
| 401 Unauthorized | Secure channel authentication failed or signature invalid |
| 403 Forbidden | VHL expired, revoked, or doesn't authorize documents |
| 404 Not Found | Manifest ID not found or VHL invalid |
| 422 Unprocessable Entity | Invalid passcode |
| 429 Too Many Requests | Rate limit exceeded |
| 500 Internal Server Error | Server-side error |
{: .grid}

#### 2:3.YY5.4.2 Retrieve Manifest Response Message

##### 2:3.YY5.4.2.1 Trigger Events

{{ linkvhls }} returns manifest after successfully authenticating and authorizing request.

##### 2:3.YY5.4.2.2 Message Semantics

The response is a FHIR Parameters resource containing a Bundle as specified in the [$retrieve-manifest operation definition](OperationDefinition-retrieve-manifest.html).

**Table 2:3.YY5.4.1.2-2: $retrieve-manifest Operation Output Parameters**

| Parameter Name | Cardinality | Type | Description |
|----------------|-------------|------|-------------|
| return | [1..1] | Bundle | A FHIR Bundle of type 'searchset' containing DocumentReference resources for documents authorized by the VHL |
{: .grid}

**Success Response (HTTP 200):**

```http
HTTP/1.1 200 OK
Content-Type: application/fhir+json
ETag: "W/\"version-123\""
```

**Response Body - FHIR Parameters with Bundle:**

```json
{
  "resourceType": "Parameters",
  "parameter": [
    {
      "name": "return",
      "resource": {
        "resourceType": "Bundle",
        "type": "searchset",
        "total": 2,
        "link": [{
          "relation": "self",
          "url": "https://vhl-sharer.example.org/DocumentReference/$retrieve-manifest"
        }],
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
              "subject": {"reference": "Patient/123"},
              "date": "2024-01-15T10:30:00Z",
              "content": [{
                "attachment": {
                  "contentType": "application/fhir+json",
                  "url": "https://vhl-sharer.example.org/vhl/document/doc1",
                  "size": 15234,
                  "hash": "07a2f6e5f8b3c9d4..."
                }
              }]
            }
          }
        ]
      }
    }
  ]
}
```

##### 2:3.YY5.4.2.3 Expected Actions

**VHL Sharer:**
- Return FHIR Bundle with search results
- Include matching DocumentReference resources
- Provide document URLs for subsequent retrieval

**VHL Receiver:**
- Parse FHIR Bundle
- Extract DocumentReference resources
- Cache manifest
- Prepare to retrieve specific documents

### 2:3.YY5.5 Security Considerations

#### 2:3.YY5.5.1 Secure Channel Requirements
All requests SHALL occur over ATNA-defined secure channel with mutual authentication.

#### 2:3.YY5.5.2 Request Authentication via JWS
- Proves request origin from trusted {{ linkvhlr }}
- Ensures integrity of request parameters
- Provides replay protection via unique `jti`
- Creates non-repudiable audit trail

#### 2:3.YY5.5.3 VHL Token Validation
{{ linkvhls }} MUST:
- Validate VHL signature
- Check expiration
- Verify not revoked
- Confirm scope authorizes documents
- Validate passcode if protected

#### 2:3.YY5.5.4 Audit Logging
Both actors SHOULD record:
- All access attempts
- Authentication failures
- Authorization denials
- Timestamps and identifiers

#### 2:3.YY5.5.5 Replay Attack Prevention
- Unique `jti` in each request
- {{ linkvhls }} MAY cache recent `jti` values
- Short validity windows
- VHL expiration limits replay window

### 2:3.YY5.6 Conformance

**VHL Receiver SHALL:**
- Establish secure channel per ATNA
- Sign requests using JWS
- Include VHL token in requests
- Validate {{ linkvhls }} responses

**VHL Sharer SHALL:**
- Accept secure channel connections per ATNA
- Verify request signatures
- Validate VHL tokens before authorizing
- Return FHIR-conformant responses
- Implement appropriate error responses

Both actors SHALL be grouped with ATNA Secure Node or Secure Application actor.

