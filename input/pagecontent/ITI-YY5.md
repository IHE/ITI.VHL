{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}

## 2:3.YY5 Retrieve Manifest

{% assign reqRequestVHLDocs = site.data.Requirements-RequestVHLDocuments %}

{% assign reqRequestVHLDocsTitle = reqRequestVHLDocs.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqRequestVHLDocsDescription = reqRequestVHLDocs.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

### 2:3.YY5.1 Scope

The Retrieve Manifest transaction enables a {{ linkvhlr }} to retrieve a manifest (search set) of available health documents from a {{ linkvhls }} using a previously obtained and validated Verified Health Link (VHL). 

This transaction occurs after the {{ linkvhlr }} has received a VHL from a VHL Holder (via ITI-YY4 Provide VHL) and validated the VHL signature.

This transaction follows the same pattern as MHD ITI-66 Find Document Lists, using a FHIR search on the List resource. 

**Include DocumentReference Option:** A {{ linkvhls }} that supports the **Include DocumentReference Option** MAY process the `_include=List:item` parameter to retrieve both the List and the referenced DocumentReference resources in a single response. This optimization reduces the number of round trips required by the {{ linkvhlr }}. If a {{ linkvhls }} does not support this option, the {{ linkvhlr }} SHALL retrieve the List first, then retrieve each DocumentReference individually using ITI-67 (Retrieve Document) transactions.

Both the {{ linkvhlr }} and {{ linkvhls }} SHALL authenticate each other's participation in the trust network. The {{ linkvhls }} validates that the requesting {{ linkvhlr }} is authorized to access the documents before responding. This transaction MAY be optionally conducted over a secure channel as defined by the IHE Audit Trail and Node Authentication (ATNA) Profile. 

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
- **RFC 9421**: HTTP Message Signatures

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
- **ITI Internet User Authorization (IUA)**: [IUA Profile](https://profiles.ihe.net/ITI/IUA/)

**SHL and OAuth Specifications:**
- **SHL Manifest Request**: [SHL Manifest Request](https://build.fhir.org/ig/HL7/smart-health-cards-and-links/links-specification.html#smart-health-link-manifest-request)
- **SMART App Launch Backend Services**: [Backend Services](http://hl7.org/fhir/smart-app-launch/backend-services.html)

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

This transaction is a FHIR search on the List resource, similar to MHD ITI-66 Find Document Lists transaction. The request is sent to the manifest URL decoded from the VHL (from ITI-YY4).

**Manifest URL Structure**

The {{ linkvhlr }} performs an HTTP operation directly to the manifest URL extracted from the VHL payload:

**Example Manifest URL from VHL:**
```
https://vhl-sharer.example.org/List/_search?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item
```

**FHIR Search Parameters from Manifest URL:**

The FHIR search parameters are included in the URL itself (from the VHL payload):

| Parameter | Type | Cardinality | Description | Example |
|-----------|------|-------------|-------------|---------|
| _id | token | [1..1] | The folder ID (with 256-bit entropy) from the VHL | `_id=abc123def456` |
| code | token | [1..1] | The type of List (typically "folder") | `code=folder` |
| status | token | [1..1] | The status of the List (typically "current") | `status=current` |
| patient | reference | [0..1] | The patient whose documents are referenced; either patient or patient.identifier SHALL be included | `patient=Patient/9876` |
| patient.identifier | token | [0..1] | Specifies an identifier associated with the patient; either patient or patient.identifier SHALL be included | `patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123` |
| identifier | token | [0..1] | Business identifier for the List | `identifier=folder-2024-001` |
| _include | special | [0..1] | Include referenced DocumentReference resources; SHALL be "List:item" if used. Only applicable if VHL Sharer supports Include DocumentReference Option | `_include=List:item` |
{: .grid}

**SHL Manifest Request Parameters:**

All authentication methods SHALL include the following SHL-specific parameters in the request body:

| Parameter | Type | Cardinality | Description |
|-----------|------|-------------|-------------|
| recipient | string | [1..1] | Identifier of the requesting organization or person |
| passcode | string | [0..1] | User-provided passcode if the VHL is passcode-protected |
| embeddedLengthMax | integer | [0..1] | Integer upper bound on the length of embedded payloads |
{: .grid}

##### 2:3.YY5.4.1.3 Authentication Methods

The {{ linkvhlr }} and {{ linkvhls }} SHALL use one of the following authentication methods. The choice of method is determined by implementing jurisdiction and trading partner agreement.

###### 2:3.YY5.4.1.3.1 Method 1: Multipart POST with Detached Signature

The {{ linkvhlr }} sends a multipart POST request with SHL parameters in Part 1 and a detached JWS signature in Part 2.

**Request Structure:**

```
POST [manifest-url]
Host: vhl-sharer.example.org
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW
Accept: application/fhir+json
```

**Multipart Body:**

```
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="shl-parameters"
Content-Type: application/json

{"recipient":"Dr. Smith Hospital","passcode":"user-pin","embeddedLengthMax":10000}
------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="signature"
Content-Type: application/jose

eyJhbGciOiJFUzI1NiIsImtpZCI6InJlY2VpdmVyLWtleS0xMjMiLCJ0eXAiOiJKT1NFIn0..MEUCIQDxyz_signature_content_here
------WebKitFormBoundary7MA4YWxkTrZu0gW--
```

**Authentication Process:**
1. VHL Receiver creates JSON object with SHL parameters (Part 1)
2. VHL Receiver creates detached JWS signature over Part 1 content using their private key
3. VHL Receiver sends multipart POST with both parts
4. VHL Sharer extracts signature, verifies using receiver's public key from trust list
5. If valid, VHL Sharer processes request and returns Bundle

**JWS Signature Details:**
- Type: Detached JWS (RFC 7515)
- Signed Content: Exact bytes of Part 1 (shl-parameters JSON)
- Header MUST include `kid` (key identifier) and `alg` (RS256 or ES256)
- Signature verified using receiver's public key from trust list

---

###### 2:3.YY5.4.1.3.2 Method 2: POST with Embedded JSON Signature

The {{ linkvhlr }} sends a POST request with a single JSON body containing both SHL parameters and an embedded JWS signature.

**Request Structure:**

```
POST [manifest-url]
Host: vhl-sharer.example.org
Content-Type: application/json
Accept: application/fhir+json
```

**Request Body:**

```json
{
  "shlParameters": {
    "recipient": "Dr. Smith Hospital",
    "passcode": "user-pin",
    "embeddedLengthMax": 10000
  },
  "signature": {
    "type": "JWS",
    "algorithm": "RS256",
    "keyId": "receiver-key-123",
    "value": "eyJhbGciOiJSUzI1NiIsImtpZCI6InJlY2VpdmVyLWtleS0xMjMifQ.eyJyZWNpcGllbnQiOiJEci4gU21pdGggSG9zcGl0YWwiLCJwYXNzY29kZSI6InVzZXItcGluIiwiZW1iZWRkZWRMZW5ndGhNYXgiOjEwMDAwfQ.signature-here"
  }
}
```

**Authentication Process:**
1. VHL Receiver creates JSON object with SHL parameters
2. VHL Receiver creates JWS signature over shlParameters object
3. VHL Receiver embeds signature in same JSON body
4. VHL Receiver sends POST with complete JSON
5. VHL Sharer extracts signature.value, verifies using receiver's public key from trust list
6. If valid, VHL Sharer processes request and returns Bundle

**JWS Signature Details:**
- Type: JWS (RFC 7515)
- Signed Content: shlParameters object (canonicalized JSON)
- signature.algorithm: "RS256" or "ES256"
- signature.keyId: Receiver's public key identifier from trust list
- signature.value: Base64url-encoded JWS

---

###### 2:3.YY5.4.1.3.3 Method 3: OAuth Backend Services with POST

The {{ linkvhlr }} obtains an OAuth access token, then sends POST request with SHL parameters and token.

**Step 1: Obtain Access Token (one time or per expiration)**

```
POST [authorization-server]/oauth/token
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials
&scope=system/List.read system/DocumentReference.read system/Binary.read
&client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer
&client_assertion=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InJlY2VpdmVyLWtleS0xMjMifQ...
```

**Token Response:**
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "system/List.read system/DocumentReference.read system/Binary.read"
}
```

**Step 2: Retrieve Manifest with Token**

```
POST [manifest-url]
Host: vhl-sharer.example.org
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
Accept: application/fhir+json
```

**Request Body:**

```json
{
  "recipient": "Dr. Smith Hospital",
  "passcode": "user-pin",
  "embeddedLengthMax": 10000
}
```

**Authentication Process:**
1. VHL Receiver creates JWT client assertion signed with their private key (one time)
2. VHL Receiver requests access token from authorization server
3. Authorization server validates JWT, issues access token
4. VHL Receiver sends POST with SHL parameters in JSON body
5. VHL Receiver includes access token in Authorization header
6. VHL Sharer validates token signature and expiration
7. If valid, VHL Sharer processes request and returns Bundle

**OAuth Details:**
- Grant Type: client_credentials
- Client Authentication: private_key_jwt (JWT client assertion)
- Required Scopes: system/List.read, system/DocumentReference.read, system/Binary.read
- Token can be reused for multiple requests until expiration (typically 1 hour)

---

###### 2:3.YY5.4.1.3.4 Method 4: HTTP Message Signatures with POST

The {{ linkvhlr }} sends a POST request with SHL parameters and HTTP signature headers.

**Request Structure:**

```
POST [manifest-url]
Host: vhl-sharer.example.org
Content-Type: application/json
Content-Digest: sha-256=X48E9qOokqqrvdts8nOJRJN3OWDUoyWxBf7kbu9DBPE=
Signature-Input: sig1=("@request-target" "@method" "content-digest" "content-type");created=1735689600;keyid="receiver-key-123";alg="rsa-v1_5-sha256"
Signature: sig1=:K2qGT5srn2OGbOIDzQ6kYT+ruaycnDAAUpKv+ePFfD6...:
Accept: application/fhir+json
```

**Request Body:**

```json
{
  "recipient": "Dr. Smith Hospital",
  "passcode": "user-pin",
  "embeddedLengthMax": 10000
}
```

**Authentication Process:**
1. VHL Receiver creates JSON body with SHL parameters
2. VHL Receiver computes Content-Digest (SHA-256 of body)
3. VHL Receiver constructs signature base from HTTP components
4. VHL Receiver signs signature base using their private key
5. VHL Receiver includes signature headers in POST request
6. VHL Sharer reconstructs signature base, verifies using receiver's public key from trust list
7. If valid, VHL Sharer processes request and returns Bundle

**HTTP Signature Details:**
- Standard: RFC 9421 (HTTP Message Signatures)
- Signed Components: @request-target, @method, content-digest, content-type
- Signature-Input: Contains signature metadata (created timestamp, keyid, algorithm)
- Content-Digest: SHA-256 hash of request body
- Signature verified using receiver's public key from trust list

---

##### 2:3.YY5.4.1.4 Expected Actions - VHL Receiver

The {{ linkvhlr }} SHALL:

1. **Extract Manifest URL from VHL**:
   - Obtain manifest URL from VHL payload (ITI-YY4)
   - URL contains all FHIR search parameters (_id, code, status, patient.identifier, optional _include)

2. **Prepare SHL Parameters**:
   - Create JSON object or equivalent structure with:
     - recipient (required)
     - passcode (if P flag in VHL)
     - embeddedLengthMax (optional)

3. **Choose and Apply Authentication Method**:
   - **Method 1**: Create multipart POST with shl-parameters (Part 1) and detached signature (Part 2)
   - **Method 2**: Create JSON POST with embedded signature
   - **Method 3**: Obtain OAuth token, send JSON POST with Authorization header
   - **Method 4**: Create JSON POST with HTTP signature headers

4. **Send Request**:
   - POST to the complete manifest URL from VHL
   - Include appropriate authentication credentials per chosen method

5. **Process Response**:
   - Receive searchset Bundle with List and optional DocumentReferences
   - Parse Bundle entries to identify available documents

##### 2:3.YY5.4.1.5 Expected Actions - VHL Sharer

Upon receiving Retrieve Manifest Request, the {{ linkvhls }} SHALL:

1. **Parse Request**:
   - Extract FHIR search parameters from URL query string
   - Extract SHL parameters from request body (format depends on authentication method)
   - Extract authentication credentials (signature, token, or headers)

2. **Authenticate Receiver**:
   - **Method 1**: Verify detached JWS signature over Part 1 using receiver's public key
   - **Method 2**: Verify embedded JWS signature over shlParameters using receiver's public key
   - **Method 3**: Validate OAuth access token (signature, expiration, scope)
   - **Method 4**: Verify HTTP message signature using receiver's public key
   - Use receiver's public key from trust list (identified by kid/keyid)
   - Reject if signature/token invalid or receiver not in trust list

3. **Authorize Request**:
   - Validate the folder ID (_id parameter) corresponds to a valid VHL
   - Verify VHL signature matches the original issuance
   - Confirm VHL not expired (check against issuance time + validity period)
   - Verify VHL not revoked
   - Validate passcode if VHL requires it (compare against stored hash)
   - Confirm VHL authorizes requested documents

4. **Execute Search**:
   - Query for List resource matching FHIR search parameters from URL
   - Validate List exists and is accessible
   - If `_include=List:item` parameter is present:
     - If {{ linkvhls }} supports the Include DocumentReference Option:
       - Retrieve DocumentReference resources referenced by List.entry.item
       - Include them in the response Bundle with search.mode = "include"
     - If {{ linkvhls }} does NOT support the Include DocumentReference Option:
       - Ignore the `_include` parameter
       - Return only the List resource in the response Bundle
       - {{ linkvhlr }} will subsequently use ITI-67 transactions to retrieve individual DocumentReferences
   - Apply VHL scope and consent filters

5. **Prepare Response**:
   - Construct FHIR Bundle of type `searchset`
   - Include List resource with search.mode = "match"
   - If Include DocumentReference Option is supported AND `_include` parameter was provided:
     - Include DocumentReference resources with search.mode = "include"
   - Include only documents authorized by the VHL

6. **Return Response**:
   - Send HTTP 200 with FHIR Bundle
   - Handle errors appropriately

The {{ linkvhls }} MAY:
- Record audit event per **[Audit Event – Accessed Health Data](Requirements-AuditEventAccess.html)**
- Implement rate limiting
- Log failed attempts

**Supported Search Parameters:**

The {{ linkvhls }} SHALL support at minimum:
- `_id` (token)
- `code` (token)
- `status` (token)
- Either `patient` (reference) OR `patient.identifier` (token)

The {{ linkvhls }} that supports the **Include DocumentReference Option** SHALL additionally support:
- `_include=List:item` (special)

The {{ linkvhls }} SHOULD support:
- `identifier` (token)

**_include Parameter Behavior:**

If a {{ linkvhls }} supports the Include DocumentReference Option:
- It SHALL process `_include=List:item` and return DocumentReference resources with search.mode = "include"
- This reduces network round trips for the {{ linkvhlr }}

If a {{ linkvhls }} does NOT support the Include DocumentReference Option:
- It SHALL ignore the `_include` parameter if provided
- It SHALL return only the List resource in the searchset Bundle
- The {{ linkvhlr }} SHALL then use ITI-67 (Retrieve Document) transactions to retrieve individual DocumentReferences

**Error Conditions:**

| HTTP Status | Condition |
|-------------|-----------|
| 401 Unauthorized | Signature/token verification failed or receiver not in trust list |
| 403 Forbidden | VHL expired, revoked, or doesn't authorize documents |
| 404 Not Found | List resource with specified _id not found or VHL invalid |
| 422 Unprocessable Entity | Invalid passcode or malformed parameters |
| 429 Too Many Requests | Rate limit exceeded |
| 500 Internal Server Error | Server-side error |
{: .grid}

### 2:3.YY5.5 Security Considerations

#### 2:3.YY5.5.1 Secure Channel Requirements
All requests MAY occur over ATNA-defined secure channel with mutual authentication. HTTPS (TLS 1.2 or higher) is REQUIRED for all authentication methods.

#### 2:3.YY5.5.2 Authentication Method Selection
- The choice of authentication method SHALL be determined by organizational security policies, regulatory requirements, and trading partner agreements
- Implementations SHOULD support OAuth Backend Services (Method 3) for interoperability with healthcare FHIR APIs
- Implementations MAY support multiple authentication methods

#### 2:3.YY5.5.3 Cryptographic Requirements
All authentication methods SHALL use:
- TLS 1.2 or higher for transport security
- RSA with minimum 2048-bit keys (RS256, PS256) OR ECDSA with P-256 curve (ES256) or stronger
- Private keys stored securely (Hardware Security Module recommended)
- Public keys obtained from trust list (ITI-YY2)

#### 2:3.YY5.5.4 Request Authentication
Regardless of authentication method:
- Receiver identity MUST be verified using cryptographic signature or OAuth token
- Receiver's public key MUST be obtained from trusted source (trust list)
- Requests MUST include timestamp or expiration to prevent replay attacks
- Invalid signatures/tokens MUST result in 401 Unauthorized response

#### 2:3.YY5.5.5 VHL Token Validation
{{ linkvhls }} MUST:
- Validate folder ID corresponds to valid VHL issuance
- Verify VHL signature before trusting authorization
- Check VHL expiration timestamp
- Validate passcode if VHL requires it
- Confirm VHL scope authorizes requested documents

#### 2:3.YY5.5.6 Audit Logging
Both {{ linkvhlr }} and {{ linkvhls }} SHOULD log:
- Document access requests
- Authentication method used
- Authorization decisions
- Authorization denials
- Timestamps and identifiers
- Receiver identity (from kid/keyid or OAuth token)

#### 2:3.YY5.5.7 Replay Attack Prevention
- Timestamps MUST be validated with acceptable clock skew (recommended: ±2 minutes)
- Nonces/JTIs SHOULD be checked for reuse where applicable
- VHL tokens include expiration timestamps which MUST be enforced
- OAuth tokens have built-in expiration (typically 1 hour)

### 2:3.YY5.6 Conformance

**VHL Receiver SHALL:**
- Support at least one authentication method (Methods 1-4)
- POST to the complete manifest URL extracted from VHL payload
- Include SHL authorization parameters in request body:
  - recipient (required)
  - passcode (if P flag in VHL)
  - embeddedLengthMax (optional)
- Generate valid signatures/tokens per chosen authentication method
- Parse searchset Bundle response
- Distinguish between List (search.mode = "match") and DocumentReference (search.mode = "include") entries
- If `_include` parameter was in manifest URL but no DocumentReferences are returned:
  - Use ITI-67 (Retrieve Document) transactions to retrieve individual DocumentReferences

**VHL Receiver SHOULD:**
- Support OAuth Backend Services (Method 3) for interoperability

**VHL Receiver MAY:**
- Support multiple authentication methods
- Cache OAuth access tokens for reuse (Method 3)
- Implement retry logic for transient failures

**VHL Sharer SHALL:**
- Support at least one authentication method (Methods 1-4)
- Accept POST requests to List/_search endpoint
- Extract FHIR search parameters from URL query string
- Extract SHL parameters from request body (format varies by authentication method)
- Verify authentication credentials using receiver's public key from trust list
- Support mandatory search parameters: _id, code, status, patient or patient.identifier
- Support SHL authorization parameters: recipient (required), passcode (optional), embeddedLengthMax (optional)
- Return Bundle of type searchset
- Include List resource with search.mode = "match"
- Validate VHL authorization before returning documents
- Verify passcode securely (if provided)
- Reject requests with invalid authentication (401 Unauthorized)

**VHL Sharer SHOULD:**
- Support OAuth Backend Services (Method 3) for interoperability
- Provide discovery mechanism to indicate supported authentication methods
- Implement rate limiting

**VHL Sharer MAY:**
- Support multiple authentication methods
- Implement additional authorization rules beyond receiver authentication

**VHL Sharer with Include DocumentReference Option SHALL additionally:**
- Support `_include=List:item` parameter
- When `_include=List:item` is provided:
  - Retrieve DocumentReference resources referenced by List.entry.item
  - Include them in searchset Bundle with search.mode = "include"
  - Apply VHL scope and consent filters to DocumentReferences

**VHL Sharer without Include DocumentReference Option SHALL:**
- Ignore `_include` parameter if provided
- Return only List resource in searchset Bundle
