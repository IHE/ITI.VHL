{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}

## 2:3.YY5 Retrieve Manifest

{% assign reqRequestVHLDocs = site.data.Requirements-RequestVHLDocuments %}

{% assign reqRequestVHLDocsTitle = reqRequestVHLDocs.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqRequestVHLDocsDescription = reqRequestVHLDocs.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

### 2:3.YY5.1 Scope

The Retrieve Manifest transaction enables a {{ linkvhlr }} to retrieve a manifest (searchset Bundle) of available health documents from a {{ linkvhls }} using a previously obtained and validated Verified Health Link (VHL). 

This transaction occurs after the {{ linkvhlr }} has received a VHL from a VHL Holder (via ITI-YY4 Provide VHL) and validated the VHL signature.

**FHIR Search Transaction:** This transaction uses a standard FHIR search on the List resource, following the same pattern as MHD ITI-66 Find Document Lists. The manifest URL from the VHL payload contains all necessary FHIR search parameters. No custom operation is required.

**Authentication:** All requests SHALL be authenticated using **HTTP Message Signatures (RFC 9421)**. This provides cryptographic proof of the receiver's identity, request integrity, and non-repudiation. The VHL Sharer validates the signature using the receiver's public key from the trust list before processing the request.

**OAuth with SSRAA Option:** Implementations MAY additionally support the **OAuth with SSRAA Option** which uses OAuth 2.0 tokens for authentication as defined in the [HL7 Security for Scalable Registration, Authentication, and Authorization IG](http://hl7.org/fhir/us/udap-security/) (SSRAA). When this option is supported, implementations use OAuth Backend Services with JWT client assertions for system-to-system authentication.

**Include DocumentReference Option:** A {{ linkvhls }} that supports the **Include DocumentReference Option** SHALL process the `_include=List:item` parameter to retrieve both the List and the referenced DocumentReference resources in a single response. This optimization reduces the number of round trips required by the {{ linkvhlr }}. If a {{ linkvhls }} does not support this option, it SHALL ignore the `_include` parameter, and the {{ linkvhlr }} SHALL retrieve each DocumentReference individually using separate read requests.

Both the {{ linkvhlr }} and {{ linkvhls }} SHALL authenticate each other's participation in the trust network. The {{ linkvhls }} validates that the requesting {{ linkvhlr }} is authorized to access the documents before responding.

**Capability Statements:** 
- {{ linkvhlr }} capabilities are defined in [VHL Receiver Client Capability Statement](CapabilityStatement-VHLReceiverCapabilityStatement.html)
- {{ linkvhls }} capabilities are defined in [VHL Sharer Server Capability Statement](CapabilityStatement-VHLSharerCapabilityStatement.html)

### 2:3.YY5.2 Actor Roles

| Actor | Role |
|-------|------|
| {{ linkvhlr }} | Initiates FHIR search request to retrieve document manifest using validated VHL as authorization |
| {{ linkvhls }} | Responds to search request after authenticating and authorizing the VHL Receiver |
{: .grid}

### 2:3.YY5.3 Referenced Standards

**Core Standards:**
- **RFC 8446**: TLS Protocol Version 1.3
- **RFC 5280**: X.509 PKI Certificate and CRL Profile
- **RFC 9110**: HTTP Semantics
- **RFC 9421**: HTTP Message Signatures
- **RFC 6234**: SHA-256 Hash Function

**FHIR Specifications:**
- **FHIR R4**: [HL7 FHIR Release 4](http://hl7.org/fhir/R4/)
- **FHIR List Resource**: [List Resource](http://hl7.org/fhir/R4/list.html)
- **FHIR DocumentReference**: [DocumentReference Resource](http://hl7.org/fhir/R4/documentreference.html)
- **FHIR Bundle**: [Bundle Resource](http://hl7.org/fhir/R4/bundle.html)
- **FHIR Search**: [Search Parameters](http://hl7.org/fhir/R4/search.html)
- **FHIR _include**: [_include Parameter](http://hl7.org/fhir/R4/search.html#include)

**IHE Profiles:**
- **ITI TF-2: Mobile Health Document Sharing (MHD)**: [ITI-66 Find Document Lists](https://profiles.ihe.net/ITI/MHD/ITI-66.html)
- **ITI TF-1: Section 9**: ATNA Profile
- **ITI TF-2: 3.19**: Authenticate Node transaction

**OAuth with SSRAA (Optional):**
- **RFC 7515**: JSON Web Signature (JWS) - for OAuth with SSRAA Option
- **RFC 7519**: JSON Web Token (JWT) - for OAuth with SSRAA Option
- **SMART App Launch Backend Services**: [Backend Services](http://hl7.org/fhir/smart-app-launch/backend-services.html)
- **HL7 Security for Scalable Registration, Authentication, and Authorization IG**: [SSRAA](http://hl7.org/fhir/us/udap-security/)
- **ITI Internet User Authorization (IUA)**: [IUA Profile](https://profiles.ihe.net/ITI/IUA/)

**SHL Specifications:**
- **SHL Manifest Request**: [SHL Manifest Request](https://build.fhir.org/ig/HL7/smart-health-cards-and-links/links-specification.html#smart-health-link-manifest-request)

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

This transaction uses a standard FHIR search on the List resource. The request is sent to the manifest URL decoded from the VHL (from ITI-YY4). The manifest URL contains all necessary FHIR search parameters.

**Manifest URL Structure**

The {{ linkvhlr }} performs an HTTP POST to the `_search` endpoint with the manifest URL parameters from the VHL payload:

**Example Manifest URL from VHL:**
```
https://vhl-sharer.example.org/List?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item
```

**FHIR Search Parameters**

The following FHIR search parameters are extracted from the manifest URL:

| Parameter | Type | Cardinality | Description | Example |
|-----------|------|-------------|-------------|---------|
| _id | token | [1..1] | The folder ID (with 256-bit entropy) from the VHL - primary authorization mechanism | `_id=abc123def456` |
| code | token | [1..1] | The type of List (typically "folder") | `code=folder` |
| status | token | [1..1] | The status of the List (typically "current") | `status=current` |
| patient | reference | [0..1] | The patient whose documents are referenced; either patient or patient.identifier SHALL be included | `patient=Patient/9876` |
| patient.identifier | token (chained) | [0..1] | FHIR chained search on the patient reference parameter; resolves the patient by identifier (system\|value) without requiring a direct Patient resource reference; either patient or patient.identifier SHALL be included | `patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123` |
| identifier | token | [0..1] | Business identifier for the List | `identifier=folder-2024-001` |
| _include | special | [0..1] | Include referenced DocumentReference resources; SHALL be "List:item" if used. Only processed if VHL Sharer supports Include DocumentReference Option | `_include=List:item` |
{: .grid}

**SHL Manifest Request Parameters**

In addition to the FHIR search parameters in the URL, the following SHL-specific parameters SHALL be included in the request body:

| Parameter | Type | Cardinality | Description |
|-----------|------|-------------|-------------|
| recipient | string | [1..1] | Identifier of the requesting organization or person (e.g., "Dr. Smith Hospital", "Emergency Department - General Hospital") |
| passcode | string | [0..1] | User-provided passcode if the VHL is passcode-protected (P flag present in VHL) |
| embeddedLengthMax | integer | [0..1] | Integer upper bound on the length of embedded payloads (optional optimization hint) |
{: .grid}

##### 2:3.YY5.4.1.3 Authentication - HTTP Message Signatures (Required)

All requests SHALL be authenticated using **HTTP Message Signatures** per RFC 9421. This provides cryptographic proof of the receiver's identity, request integrity, and non-repudiation.

**Request Structure:**

```http
POST /List/_search HTTP/1.1
Host: vhl-sharer.example.org
Content-Type: application/x-www-form-urlencoded
Content-Length: 234
Content-Digest: sha-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=
Signature-Input: sig1=("@method" "@path" "@authority" "content-type" "content-digest");created=1735689600;keyid="receiver-key-123";alg="ecdsa-p256-sha256"
Signature: sig1=:K2qGT5srn2OGbOIDzQ6kYT+ruaycnDAAUpKv+ePFfD6...:
Accept: application/fhir+json

_id=abc123def456&code=folder&status=current&patient.identifier=urn%3Aoid%3A2.16.840.1.113883.2.4.6.3%7CPASSPORT123&_include=List%3Aitem&recipient=Dr.+Smith+Hospital&passcode=user-pin&embeddedLengthMax=10000
```

**HTTP Signature Components:**

1. **Content-Digest Header:**
   - SHA-256 hash of the request body
   - Format: `sha-256=<base64-encoded-hash>`
   - MUST be included for POST requests with body

2. **Signature-Input Header:**
   - Metadata about the signature
   - Components signed: `@method`, `@path`, `@authority`, `content-type`, `content-digest`
   - `created`: Unix timestamp when signature was created
   - `keyid`: Identifier of receiver's public key (used to locate key in trust list)
   - `alg`: Signature algorithm (ecdsa-p256-sha256, ecdsa-p384-sha384, rsa-pss-sha256, rsa-v1_5-sha256)

3. **Signature Header:**
   - Contains the actual cryptographic signature
   - Format: `sig1=:<base64-encoded-signature>:`
   - Signature is computed over the signature base constructed from the signed components

**Signature Base Construction:**

The signature base is constructed per RFC 9421 from the signed components:

```
"@method": POST
"@path": /List/_search
"@authority": vhl-sharer.example.org
"content-type": application/x-www-form-urlencoded
"content-digest": sha-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=
"@signature-params": ("@method" "@path" "@authority" "content-type" "content-digest");created=1735689600;keyid="receiver-key-123";alg="ecdsa-p256-sha256"
```

**Signing Process:**

1. {{ linkvhlr }} constructs request body with FHIR search parameters and SHL parameters
2. {{ linkvhlr }} computes Content-Digest (SHA-256 of body)
3. {{ linkvhlr }} constructs signature base from HTTP components
4. {{ linkvhlr }} signs signature base using their private key
5. {{ linkvhlr }} includes Content-Digest, Signature-Input, and Signature headers in request

**Verification Process:**

1. {{ linkvhls }} extracts `keyid` from Signature-Input header
2. {{ linkvhls }} retrieves receiver's public key from trust list using `keyid`
3. {{ linkvhls }} reconstructs signature base from request components
4. {{ linkvhls }} verifies signature using receiver's public key
5. {{ linkvhls }} verifies Content-Digest matches request body
6. {{ linkvhls }} checks `created` timestamp is within acceptable range (±2 minutes recommended)
7. If valid, {{ linkvhls }} processes request and returns Bundle
8. If invalid, {{ linkvhls }} returns 401 Unauthorized

**Signature Algorithms:**

The following signature algorithms SHALL be supported:

| Algorithm | Key Type | Description |
|-----------|----------|-------------|
| ecdsa-p256-sha256 | ECDSA P-256 | Recommended - efficient and secure |
| ecdsa-p384-sha384 | ECDSA P-384 | Higher security level |
| rsa-pss-sha256 | RSA 2048+ | RSA with PSS padding |
| rsa-v1_5-sha256 | RSA 2048+ | RSA with PKCS#1 v1.5 padding (legacy support) |
{: .grid}

**Security Considerations for HTTP Signatures:**

- Private keys MUST be stored securely (Hardware Security Module recommended)
- Public keys MUST be obtained from trust list (ITI-YY2)
- `keyid` MUST uniquely identify receiver's public key in trust list
- Signatures MUST include timestamp (`created`) to prevent replay attacks
- Signature verification MUST enforce timestamp freshness (±2 minutes recommended)
- HTTPS (TLS 1.2+) MUST be used for all requests

##### 2:3.YY5.4.1.4 OAuth with SSRAA Option (Optional)

Implementations that support the **OAuth with SSRAA Option** MAY use OAuth 2.0 access tokens for authentication instead of HTTP Message Signatures. This option provides interoperability with systems implementing the [HL7 Security for Scalable Registration, Authentication, and Authorization IG](http://hl7.org/fhir/us/udap-security/) (SSRAA).

**Preconditions: SSRAA Discovery and Registration**

Before an access token can be obtained, the {{ linkvhlr }} and {{ linkvhls }} MUST complete SSRAA Discovery and Registration. These steps MUST take place at least once per {{ linkvhlr }} and {{ linkvhls }} pair. They MAY take place in advance or just in time.

**Discovery (SSRAA Section 2):** Given the FHIR Base URL of the {{ linkvhls }} (included in the VHL payload), the {{ linkvhlr }} performs UDAP Discovery per Section 2 of the HL7 Security for Scalable Registration, Authentication, and Authorization IG. The {{ linkvhlr }} validates that the {{ linkvhls }} supports UDAP and determines the {{ linkvhls }}'s UDAP capabilities. If the {{ linkvhlr }} accepts the {{ linkvhls }}'s capabilities, it proceeds to Registration.

**Registration (SSRAA Section 3):** The {{ linkvhlr }} performs UDAP Dynamic Client Registration per Section 3 of the HL7 Security for Scalable Registration, Authentication, and Authorization IG. The {{ linkvhlr }} uses the X.509 certificate it obtained from the trust community PKI to register with the {{ linkvhls }} and obtain a client ID. This client ID is required when requesting OAuth access tokens.

**Option Requirements:**

When both {{ linkvhlr }} and {{ linkvhls }} support the OAuth with SSRAA Option:
- SSRAA Discovery and Registration SHALL be completed before requesting access tokens
- OAuth 2.0 Backend Services authentication MAY be used
- JWT client assertions SHALL be used for client authentication
- Access token scope vocabulary is determined by trust community policies per the HL7 Security for Scalable Registration, Authentication, and Authorization IG

**Step 1: Obtain Access Token**

```http
POST /oauth/token HTTP/1.1
Host: authorization-server.example.org
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials
&scope=system/List.r system/DocumentReference.r system/Binary.r
&client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer
&client_assertion=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InJlY2VpdmVyLWtleS0xMjMifQ.eyJpc3MiOiJodHRwczovL3ZobC1yZWNlaXZlci5leGFtcGxlLm9yZyIsInN1YiI6Imh0dHBzOi8vdmhsLXJlY2VpdmVyLmV4YW1wbGUub3JnIiwiYXVkIjoiaHR0cHM6Ly9hdXRob3JpemF0aW9uLXNlcnZlci5leGFtcGxlLm9yZyIsImV4cCI6MTczNTY4OTkwMCwiaWF0IjoxNzM1Njg5NjAwLCJqdGkiOiJyYW5kb20tdW5pcXVlLWlkIn0.signature-here
```

**JWT Client Assertion:**
- Algorithm: RS256, ES256, or ES384
- Header: `{"alg":"RS256","typ":"JWT","x5c":["<base64-encoded-client-cert>","<base64-encoded-intermediate>"]}`
  - `x5c`: The receiver's X.509 certificate (and optionally the full chain) from the trust community PKI, per the HL7 Security for Scalable Registration, Authentication, and Authorization IG
- Payload:
  - `iss`: Client ID assigned to the {{ linkvhlr }} during SSRAA Registration (same as `sub`)
  - `sub`: Client ID assigned to the {{ linkvhlr }} during SSRAA Registration (same as `iss`)
  - `aud`: Authorization server token endpoint
  - `exp`: Expiration time (typically 5 minutes from iat)
  - `iat`: Issued at time
  - `jti`: Unique identifier for this JWT (prevents replay)
  - `extensions`: An object containing an `hl7-b2b` member with the business-to-business identity context, per Section 5.2.1 of the HL7 Security for Scalable Registration, Authentication, and Authorization IG
- Signature: Signed with receiver's private key associated with the X.509 certificate in the `x5c` header

**Token Response:**
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2F1dGhvcml6YXRpb24tc2VydmVyLmV4YW1wbGUub3JnIiwic3ViIjoiaHR0cHM6Ly92aGwtcmVjZWl2ZXIuZXhhbXBsZS5vcmciLCJleHAiOjE3MzU2OTMyMDAsImlhdCI6MTczNTY4OTYwMCwic2NvcGUiOiJzeXN0ZW0vTGlzdC5yZWFkIHN5c3RlbS9Eb2N1bWVudFJlZmVyZW5jZS5yZWFkIHN5c3RlbS9CaW5hcnkucmVhZCJ9.token-signature-here",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "system/List.r system/DocumentReference.r system/Binary.r"
}
```

**Step 2: Retrieve Manifest with Token**

```http
POST /List/_search HTTP/1.1
Host: vhl-sharer.example.org
Content-Type: application/x-www-form-urlencoded
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
Accept: application/fhir+json

_id=abc123def456&code=folder&status=current&patient.identifier=urn%3Aoid%3A2.16.840.1.113883.2.4.6.3%7CPASSPORT123&_include=List%3Aitem&recipient=Dr.+Smith+Hospital&passcode=user-pin&embeddedLengthMax=10000
```

**OAuth Process:**

1. {{ linkvhlr }} creates JWT client assertion signed with the receiver's private key associated with the receiver's X.509 certificate within the trust community
2. {{ linkvhlr }} requests access token from authorization server
3. Authorization server validates the JWT signature and the associated certificate validity, including that the certificate chains to a trust anchor in the trust community, then issues access token
4. {{ linkvhlr }} includes access token in Authorization header
5. {{ linkvhls }} validates token signature, expiration, and scope
6. If valid, {{ linkvhls }} processes request and returns Bundle

**OAuth Token Requirements:**

- Grant Type: `client_credentials`
- Client Authentication: `private_key_jwt` (JWT client assertion)
- Required Scopes (SMART v2 vocabulary; specific scope requirements are determined by trust community policies per the HL7 Security for Scalable Registration, Authentication, and Authorization IG):
  - `system/List.r` - Read List resources
  - `system/DocumentReference.r` - Read DocumentReference resources
  - `system/Binary.r` - Read Binary resources (document content)
- Token Lifetime: Typically 1 hour (3600 seconds)
- Token Reuse: Access token MAY be reused for multiple requests until expiration

**Security Considerations for OAuth:**

- JWT client assertions MUST be signed with the receiver's private key associated with the receiver's X.509 certificate within the trust community
- JWT `jti` claim SHOULD be checked to prevent replay attacks
- Access tokens MUST include appropriate FHIR scopes
- Access tokens MUST be validated for signature, expiration, and scope
- Token lifetime SHOULD be limited (recommended: 1 hour maximum)
- Authorization server MUST validate the JWT signature and the associated certificate validity, including that the certificate chains to a trust anchor in the trust community

##### 2:3.YY5.4.1.5 Expected Actions - VHL Receiver

The {{ linkvhlr }} SHALL:

1. **Extract Manifest URL from VHL**:
   - Obtain manifest URL from VHL payload (ITI-YY4)
   - URL contains all FHIR search parameters (_id, code, status, and the patient identifier via chained search as patient.identifier, plus optional _include)
   - Parse URL to extract search parameters

2. **Prepare Request Parameters**:
   - Construct request body with FHIR search parameters from URL
   - Add SHL parameters:
     - recipient (required) - identifier of requesting organization/person
     - passcode (if P flag in VHL) - user-provided passcode
     - embeddedLengthMax (optional) - size hint for embedded content
   - Encode parameters as `application/x-www-form-urlencoded`

3. **Authenticate Request**:
   - **Default (Required)**: Create HTTP Message Signature
     - Compute Content-Digest (SHA-256 of request body)
     - Construct signature base from HTTP components
     - Sign using receiver's private key
     - Include Content-Digest, Signature-Input, and Signature headers
   - **OAuth with SSRAA Option (if supported)**:
     - Obtain access token using JWT client assertion
     - Include token in Authorization header
     - Reuse token for subsequent requests until expiration

4. **Send Request**:
   - POST to `/List/_search` endpoint at VHL Sharer's base URL
   - Include authentication credentials (HTTP signatures or OAuth token)
   - Set Content-Type: `application/x-www-form-urlencoded`
   - Set Accept: `application/fhir+json`

5. **Process Response**:
   - Receive searchset Bundle with type="searchset"
   - Identify List resources with search.mode="match"
   - Identify DocumentReference resources with search.mode="include" (if present)
   - If no DocumentReferences included and `_include` was requested:
     - VHL Sharer does not support Include DocumentReference Option
     - Use separate read requests to retrieve DocumentReferences
   - Parse List entries to identify available documents

The {{ linkvhlr }} MAY:
- Cache OAuth access tokens for reuse (OAuth with SSRAA Option)
- Implement retry logic for transient failures
- Support both HTTP Message Signatures and OAuth with SSRAA Option

##### 2:3.YY5.4.1.6 Expected Actions - VHL Sharer

Upon receiving Retrieve Manifest Request, the {{ linkvhls }} SHALL:

1. **Parse Request**:
   - Extract FHIR search parameters from request body
   - Extract SHL parameters (recipient, passcode, embeddedLengthMax)
   - Identify authentication method used (HTTP signatures or OAuth token)

2. **Authenticate Receiver**:
   - **HTTP Message Signatures**:
     - Extract `keyid` from Signature-Input header
     - Retrieve receiver's public key from trust list using `keyid`
     - Reconstruct signature base from request components
     - Verify signature using receiver's public key
     - Verify Content-Digest matches request body
     - Verify `created` timestamp is within acceptable range (±2 minutes)
     - Reject if signature invalid or receiver not in trust list (401 Unauthorized)
   - **OAuth with SSRAA Option** (if supported):
     - Extract Bearer token from Authorization header
     - Validate token signature using authorization server's public key
     - Verify token expiration (exp claim)
     - Verify token scope includes required FHIR resource types
     - Verify token issuer (iss claim) is trusted authorization server
     - Reject if token invalid or expired (401 Unauthorized)

3. **Authorize Request**:
   - Validate folder ID (_id parameter) corresponds to valid VHL
   - Verify VHL signature matches original issuance
   - Confirm VHL not expired (check against exp claim in HCERT)
   - Verify VHL not revoked (check revocation list if maintained)
   - If passcode provided:
     - Verify VHL requires passcode (P flag present)
     - Validate passcode against stored hash (secure comparison)
     - Reject if passcode incorrect (422 Unprocessable Entity)
   - Confirm VHL authorizes requested documents
   - Reject if authorization fails (403 Forbidden)

4. **Execute Search**:
   - Query for List resource matching FHIR search parameters:
     - _id (folder ID - required)
     - code (typically "folder" - required)
     - status (typically "current" - required)
     - patient.identifier (chained search on the patient reference parameter - required)
   - Validate List exists and is accessible
   - Apply VHL scope filters (only include documents authorized by VHL)
   - Apply consent filters if applicable
   - If `_include=List:item` parameter present:
     - **If {{ linkvhls }} supports Include DocumentReference Option:**
       - Retrieve DocumentReference resources referenced by List.entry.item
       - Apply VHL scope and consent filters to DocumentReferences
       - Include DocumentReferences in response Bundle with search.mode="include"
     - **If {{ linkvhls }} does NOT support Include DocumentReference Option:**
       - Ignore `_include` parameter
       - Return only List resource in response
       - {{ linkvhlr }} will retrieve DocumentReferences separately

5. **Prepare Response**:
   - Construct FHIR Bundle with type="searchset"
   - Add List resource with search.mode="match"
   - If Include DocumentReference Option supported and `_include` used:
     - Add DocumentReference resources with search.mode="include"
   - Set Bundle.total to count of matching resources
   - Include only documents authorized by VHL

6. **Return Response**:
   - Send HTTP 200 OK with FHIR Bundle (application/fhir+json)
   - Handle errors with appropriate HTTP status codes

The {{ linkvhls }} MAY:
- Record audit event per **[Audit Event – Accessed Health Data](Requirements-AuditEventAccess.html)**
- Implement rate limiting per receiver or per folder ID
- Log failed authentication/authorization attempts
- Provide OperationOutcome with error details

**Supported Search Parameters:**

Per the [VHL Sharer Server Capability Statement](CapabilityStatement-VHLSharerCapabilityStatement.html), the {{ linkvhls }} SHALL support:
- `_id` (token) - Required
- `code` (token) - Required
- `status` (token) - Required
- `patient` (reference) OR `patient.identifier` (chained search on the patient reference parameter, token) - At least one required

The {{ linkvhls }} that supports the **Include DocumentReference Option** SHALL additionally support:
- `_include=List:item` (special)

The {{ linkvhls }} SHOULD support:
- `identifier` (token) - Business identifier for List

**Error Responses:**

| HTTP Status | Condition | OperationOutcome.issue.code |
|-------------|-----------|------------------------------|
| 400 Bad Request | Malformed request or missing required parameters | invalid |
| 401 Unauthorized | Signature verification failed, token invalid, or receiver not in trust list | security |
| 403 Forbidden | VHL expired, revoked, or doesn't authorize documents | forbidden |
| 404 Not Found | List resource with specified _id not found | not-found |
| 422 Unprocessable Entity | Invalid passcode or passcode required but not provided | invalid |
| 429 Too Many Requests | Rate limit exceeded | throttled |
| 500 Internal Server Error | Server-side error during processing | exception |
{: .grid}

**Example Error Response:**

```json
{
  "resourceType": "OperationOutcome",
  "issue": [
    {
      "severity": "error",
      "code": "security",
      "diagnostics": "HTTP signature verification failed: signature does not match"
    }
  ]
}
```

#### 2:3.YY5.4.2 Retrieve Manifest Response Message

##### 2:3.YY5.4.2.1 Trigger Events

This message is sent when the {{ linkvhls }} has successfully authenticated the {{ linkvhlr }}, authorized the VHL, and retrieved the requested document manifest.

##### 2:3.YY5.4.2.2 Message Semantics

The response is a FHIR Bundle of type "searchset" containing:
- List resource(s) matching the search criteria (search.mode="match")
- DocumentReference resources if `_include=List:item` was used and supported (search.mode="include")

**Bundle Structure:**

```json
{
  "resourceType": "Bundle",
  "type": "searchset",
  "total": 5,
  "link": [
    {
      "relation": "self",
      "url": "https://vhl-sharer.example.org/List/_search?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item"
    }
  ],
  "entry": [
    {
      "fullUrl": "https://vhl-sharer.example.org/List/abc123def456",
      "resource": {
        "resourceType": "List",
        "id": "abc123def456",
        "status": "current",
        "mode": "working",
        "code": {
          "coding": [
            {
              "system": "https://profiles.ihe.net/ITI/MHD/CodeSystem/MHDlistTypes",
              "code": "folder"
            }
          ]
        },
        "subject": {
          "identifier": {
            "system": "urn:oid:2.16.840.1.113883.2.4.6.3",
            "value": "PASSPORT123"
          }
        },
        "date": "2024-01-15T10:30:00Z",
        "entry": [
          {
            "item": {
              "reference": "DocumentReference/doc001"
            }
          },
          {
            "item": {
              "reference": "DocumentReference/doc002"
            }
          },
          {
            "item": {
              "reference": "DocumentReference/doc003"
            }
          },
          {
            "item": {
              "reference": "DocumentReference/doc004"
            }
          }
        ]
      },
      "search": {
        "mode": "match"
      }
    },
    {
      "fullUrl": "https://vhl-sharer.example.org/DocumentReference/doc001",
      "resource": {
        "resourceType": "DocumentReference",
        "id": "doc001",
        "status": "current",
        "type": {
          "coding": [
            {
              "system": "http://loinc.org",
              "code": "34133-9",
              "display": "Summarization of Episode Note"
            }
          ]
        },
        "subject": {
          "identifier": {
            "system": "urn:oid:2.16.840.1.113883.2.4.6.3",
            "value": "PASSPORT123"
          }
        },
        "date": "2024-01-15T09:00:00Z",
        "content": [
          {
            "attachment": {
              "contentType": "application/pdf",
              "url": "https://vhl-sharer.example.org/Binary/doc001-content"
            }
          }
        ]
      },
      "search": {
        "mode": "include"
      }
    },
    {
      "fullUrl": "https://vhl-sharer.example.org/DocumentReference/doc002",
      "resource": {
        "resourceType": "DocumentReference",
        "id": "doc002"
      },
      "search": {
        "mode": "include"
      }
    },
    {
      "fullUrl": "https://vhl-sharer.example.org/DocumentReference/doc003",
      "resource": {
        "resourceType": "DocumentReference",
        "id": "doc003"
      },
      "search": {
        "mode": "include"
      }
    },
    {
      "fullUrl": "https://vhl-sharer.example.org/DocumentReference/doc004",
      "resource": {
        "resourceType": "DocumentReference",
        "id": "doc004"
      },
      "search": {
        "mode": "include"
      }
    }
  ]
}
```

**Key Elements:**

- `Bundle.type`: Always "searchset"
- `Bundle.total`: Total number of matching resources (List + included DocumentReferences)
- `Bundle.entry[].search.mode`:
  - "match" for List resource(s) matching search criteria
  - "include" for DocumentReference resources included via `_include` parameter
- List.entry[].item: References to DocumentReference resources
- If Include DocumentReference Option not supported: Bundle contains only List resource

##### 2:3.YY5.4.2.3 Expected Actions

The {{ linkvhlr }} SHALL:
- Parse Bundle to identify List and DocumentReference resources
- Distinguish between resources based on search.mode
- Extract document metadata from DocumentReference resources
- Use DocumentReference.content.attachment.url to retrieve document content (separate transaction)

The {{ linkvhlr }} MAY:
- Display document list to user
- Filter or sort documents based on metadata
- Retrieve document content on demand

### 2:3.YY5.5 Security Considerations

#### 2:3.YY5.5.1 Transport Security
- All requests SHALL use HTTPS with TLS 1.2 or higher
- TLS 1.3 is RECOMMENDED for improved security and performance
- Perfect Forward Secrecy (PFS) cipher suites SHOULD be used
- Certificate validation SHALL be enforced

#### 2:3.YY5.5.2 HTTP Message Signatures (Required)
All implementations SHALL support HTTP Message Signatures per RFC 9421:
- Signature MUST include `@method`, `@path`, `@authority`, `content-type`, `content-digest`
- Content-Digest MUST be SHA-256 or stronger
- Signature algorithm: ECDSA P-256 SHA-256 (recommended) or RSA 2048+ with PSS or PKCS#1 v1.5
- Private keys MUST be stored securely (Hardware Security Module recommended)
- Public keys MUST be obtained from trust list (ITI-YY2)
- `keyid` MUST uniquely identify receiver's public key in trust list
- Timestamp validation MUST enforce freshness (±2 minutes recommended)
- Replay attacks prevented by timestamp validation

#### 2:3.YY5.5.3 OAuth with SSRAA Option (Optional)
Implementations that support OAuth with SSRAA Option SHALL:
- Use OAuth 2.0 Backend Services (client_credentials grant)
- Use JWT client assertions (private_key_jwt) for client authentication
- Include appropriate FHIR scopes in access token
- Validate token signature, expiration, and scope
- Limit token lifetime (recommended: 1 hour maximum)
- Check JWT `jti` claim to prevent replay attacks
- Obtain receiver's public key from trust list for JWT signature validation

#### 2:3.YY5.5.4 VHL Authorization
{{ linkvhls }} MUST validate VHL before returning documents:
- Verify folder ID (_id parameter) corresponds to valid VHL
- Validate VHL signature (HCERT/CWT COSE signature from ITI-YY3)
- Check VHL expiration (CWT exp claim)
- Verify VHL not revoked (if revocation list maintained)
- Validate passcode if VHL requires it (P flag present):
  - Compare against stored hash using constant-time comparison
  - Use strong hash function (bcrypt, Argon2, PBKDF2)
- Confirm VHL scope authorizes requested documents

#### 2:3.YY5.5.5 Trust Network Validation
Both {{ linkvhlr }} and {{ linkvhls }} SHALL:
- Authenticate each other's participation in trust network
- Obtain public keys from trust list (ITI-YY2 Retrieve Trust List with DID)
- Validate certificates are not expired or revoked
- Use `keyid` (HTTP signatures) or the client key (OAuth JWT) to identify the client's key
- Reject requests from participants not in trust list (401 Unauthorized)

#### 2:3.YY5.5.6 Audit Logging
Both {{ linkvhlr }} and {{ linkvhls }} SHOULD log:
- All document access requests (successful and failed)
- Authentication method used (HTTP signatures or OAuth)
- Receiver identity (from keyid or OAuth token)
- VHL folder ID
- Authorization decisions (approved/denied)
- Timestamps
- IP addresses
- User identifiers (from recipient parameter)

#### 2:3.YY5.5.7 Rate Limiting
{{ linkvhls }} SHOULD implement rate limiting:
- Per receiver (identified by keyid or OAuth client_id)
- Per folder ID (to prevent brute force on VHL tokens)
- Per IP address
- Return 429 Too Many Requests when limits exceeded

#### 2:3.YY5.5.8 Passcode Security
When VHL is passcode-protected (P flag):
- Passcode MUST be transmitted over HTTPS only
- Passcode MUST be validated using constant-time comparison
- Failed passcode attempts SHOULD be rate limited
- Passcode SHOULD NOT be logged in audit trails
- Consider lockout after repeated failed attempts

