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

**Sign Manifest Request Option:** A {{ linkvhlr }} that supports the **Sign Manifest Request Option** MAY digitally sign the manifest request. A {{ linkvhls }} that supports the **Verify Manifest Request Signature Option** SHALL verify the signature before processing the request. These options provide mutual authentication and non-repudiation.

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

**SHL Specification:**
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

This transaction is a FHIR search on the List resource, similar to MHD ITI-66 Find Document Lists transaction. The request is sent to the manifest URL decoded from the VHL (from ITI-YY4). The request uses HTTP POST with `multipart/form-data` encoding to transmit SHL authorization parameters and optional digital signature.

**Request Structure**

The {{ linkvhlr }} performs an HTTP POST operation directly to the manifest URL extracted from the VHL payload:

```
POST [manifest-url]
Host: vhl-sharer.example.org
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW
Accept: application/fhir+json
```

Where **[manifest-url]** is the complete URL from the VHL payload, including all FHIR search parameters.

**Example Manifest URL from VHL:**
```
https://vhl-sharer.example.org/List?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item
```

**Multipart Request Structure:**

The request body SHALL use `multipart/form-data` encoding with the following two parts:

1. **SHL Manifest Parameters Part** - Contains the SHL-specific parameters (recipient, passcode, embeddedLengthMax)
2. **Signature Part** (optional) - Contains the digital signature over Part 1

**Part 1: SHL Manifest Parameters**

```
Content-Disposition: form-data; name="shl-parameters"
Content-Type: application/json
```

Contains SHL authorization parameters as a JSON object:
- `recipient`: Identifier of the requesting organization or person (required)
- `passcode`: User-provided passcode if VHL requires it (optional)
- `embeddedLengthMax`: Integer upper bound on embedded payload length (optional)

**Part 2: Signature (Optional - Sign Manifest Request Option)**

```
Content-Disposition: form-data; name="signature"
Content-Type: application/jose
```

Contains a detached JWS signature computed over Part 1 content (shl-parameters bytes).

**SHL Manifest Parameters (Part 1):**

| Parameter | Type | Cardinality | Description |
|-----------|------|-------------|-------------|
| recipient | string | [1..1] | Identifier of the requesting organization or person |
| passcode | string | [0..1] | User-provided passcode if the VHL is passcode-protected |
| embeddedLengthMax | integer | [0..1] | Integer upper bound on the length of embedded payloads |
{: .grid}

**Example Request (2-Part Multipart):**

```
POST https://vhl-sharer.example.org/List/_search?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item HTTP/1.1
Host: vhl-sharer.example.org
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Length: 945

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

**Multipart Structure Explanation:**

1. **Part 1 (shl-parameters):** Contains JSON object with SHL authorization parameters
   - `recipient`: Identifier of requesting party (required)
   - `passcode`: User-provided passcode (if P flag in VHL)
   - `embeddedLengthMax`: Optional size limit for embedded content

2. **Part 2 (signature):** Contains detached JWS signature (optional - only if Sign Manifest Request Option supported)
   - Signs the exact bytes of Part 1 (shl-parameters content)
   - Uses VHL Receiver's private key
   - Enables VHL Sharer to verify request authenticity and integrity

**Digital Signature Content (Sign Manifest Request Option):**

When the {{ linkvhlr }} supports the Sign Manifest Request Option, the detached JWS signature SHALL be computed over the exact bytes of Part 1 (shl-parameters content).

**JWS Protected Header:**
```json
{
  "alg": "ES256",
  "kid": "receiver-key-123",
  "typ": "JOSE"
}
```

**Signed Content:**
```json
{"recipient":"Dr. Smith Hospital","passcode":"user-pin","embeddedLengthMax":10000}
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

##### 2:3.YY5.4.1.3 Expected Actions - VHL Receiver

The {{ linkvhlr }} SHALL:

1. **Extract Manifest URL from VHL**:
   - Obtain manifest URL from VHL payload (ITI-YY4)
   - URL contains all FHIR search parameters (_id, code, status, patient.identifier, optional _include)

2. **Create Multipart Request**:
   - Create 2-part multipart/form-data request
   - Part 1: JSON object with recipient (required), passcode (if P flag), embeddedLengthMax (optional)
   - Part 2: Optional JWS signature over Part 1 (only if Sign Manifest Request Option supported)

3. **Send POST Request**:
   - POST directly to the manifest URL from VHL
   - Include Content-Type: multipart/form-data header
   - Include Accept: application/fhir+json header

4. **Process Response**:
   - Receive searchset Bundle with List and optional DocumentReferences
   - Parse Bundle entries to identify available documents

##### 2:3.YY5.4.1.3 Expected Actions - VHL Sharer

Upon receiving Retrieve Manifest Request, the {{ linkvhls }} SHALL:

1. **Parse Request**:
   - Extract FHIR search parameters from URL query string
   - Parse multipart request to extract shl-parameters (Part 1)
   - If signature present and Verify Manifest Request Signature Option supported:
     - Extract signature (Part 2)
     - Extract `kid` from JWS protected header to identify receiver's public key
     - Verify detached JWS signature over Part 1 content
     - Use receiver's public key from trust list for verification
     - Reject if signature invalid or receiver not trusted

2. **Authorize Request**:
   - Validate the folder ID (_id parameter) corresponds to a valid VHL
   - Verify VHL signature matches the original issuance
   - Confirm VHL not expired (check against issuance time + validity period)
   - Verify VHL not revoked
   - Validate passcode if VHL requires it (compare against stored hash)
   - Confirm VHL authorizes requested documents

3. **Execute Search**:
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

4. **Prepare Response**:
   - Construct FHIR Bundle of type `searchset`
   - Include List resource with search.mode = "match"
   - If Include DocumentReference Option is supported AND `_include` parameter was provided:
     - Include DocumentReference resources with search.mode = "include"
   - Include only documents authorized by the VHL

5. **Return Response**:
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
| 401 Unauthorized | Secure channel authentication failed or signature invalid (if Verify Manifest Request Signature Option supported) |
| 403 Forbidden | VHL expired, revoked, or doesn't authorize documents |
| 404 Not Found | List resource with specified _id not found or VHL invalid |
| 422 Unprocessable Entity | Invalid passcode or malformed parameters |
| 429 Too Many Requests | Rate limit exceeded |
| 500 Internal Server Error | Server-side error |
{: .grid}

### 2:3.YY5.5 Security Considerations

#### 2:3.YY5.5.1 Secure Channel Requirements
All requests MAY occur over ATNA-defined secure channel with mutual authentication.

#### 2:3.YY5.5.2 Request Authentication via Digital Signature (Sign Manifest Request Option)
When the {{ linkvhlr }} supports the Sign Manifest Request Option and the {{ linkvhls }} supports the Verify Manifest Request Signature Option:
- Digital signature over SHL parameters ensures integrity and authenticity
- Signature proves the request originates from a trusted {{ linkvhlr }}
- Creates non-repudiable audit trail
- VHL Sharer uses receiver's public key from trust list (identified by kid) to verify signature

#### 2:3.YY5.5.3 VHL Token Validation
{{ linkvhls }} MUST:
- Validate folder ID corresponds to valid VHL issuance
- Verify VHL signature before trusting authorization
- Check VHL expiration timestamp
- Validate passcode if VHL requires it
- Confirm VHL scope authorizes requested documents

#### 2:3.YY5.5.4 Audit Logging
Both {{ linkvhlr }} and {{ linkvhls }} SHOULD log:
- Document access requests
- Authorization decisions
- Authorization denials
- Timestamps and identifiers

#### 2:3.YY5.5.5 Replay Attack Prevention
- VHL tokens include expiration timestamps
- {{ linkvhls }} SHALL enforce VHL expiration
- Short validity windows minimize replay risk
- Digital signatures with timestamps prevent replay attacks (if Sign Manifest Request Option used)

### 2:3.YY5.6 Conformance

**VHL Receiver SHALL:**
- Support HTTP POST on manifest URL with multipart/form-data encoding
- Create 2-part multipart request: shl-parameters (required) and signature (optional)
- POST to the complete manifest URL extracted from VHL payload
- Include SHL authorization parameters in Part 1 (shl-parameters) as JSON
- Include mandatory parameters: recipient
- Include optional parameters: passcode (if P flag in VHL), embeddedLengthMax
- Parse searchset Bundle response
- Distinguish between List (search.mode = "match") and DocumentReference (search.mode = "include") entries
- If `_include` parameter was in manifest URL but no DocumentReferences are returned in Bundle:
  - Use ITI-67 (Retrieve Document) transactions to retrieve individual DocumentReferences from List.entry.item references

**VHL Receiver with Sign Manifest Request Option SHALL additionally:**
- Compute detached JWS signature over Part 1 (shl-parameters) content
- Include signature in Part 2 with kid identifying receiver's key
- Sign using receiver's private key

**VHL Sharer SHALL:**
- Support HTTP POST on List resource with multipart/form-data encoding
- Parse 2-part multipart request to extract shl-parameters and optional signature
- Accept SHL parameters via JSON format in Part 1
- Extract FHIR search parameters from the URL query string
- Support mandatory search parameters: _id, code, status, patient or patient.identifier
- Support SHL authorization parameters: recipient (required), passcode (optional), embeddedLengthMax (optional)
- Return Bundle of type searchset
- Include List resource with search.mode = "match"
- Validate VHL authorization before returning documents
- Verify passcode securely (if provided)

**VHL Sharer with Verify Manifest Request Signature Option SHALL additionally:**
- Verify detached JWS signature in Part 2 over Part 1 content
- Use receiver's public key from trust list (identified by kid from JWS header)
- Reject requests with invalid signatures
- Reject requests from untrusted receivers

**VHL Sharer with Include DocumentReference Option SHALL additionally:**
- Support `_include=List:item` parameter
- When `_include=List:item` is provided:
  - Retrieve DocumentReference resources referenced by List.entry.item
  - Include them in searchset Bundle with search.mode = "include"
  - Apply VHL scope and consent filters to DocumentReferences

**VHL Sharer without Include DocumentReference Option SHALL:**
- Ignore `_include` parameter if provided
- Return only List resource in searchset Bundle
- {{ linkvhlr }} will use ITI-67 transactions to retrieve individual DocumentReferences
