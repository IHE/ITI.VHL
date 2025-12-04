{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}

## 2:3.YY5 Retrieve Manifest

{% assign reqRequestVHLDocs = site.data.Requirements-RequestVHLDocuments %}

{% assign reqRequestVHLDocsTitle = reqRequestVHLDocs.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqRequestVHLDocsDescription = reqRequestVHLDocs.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

### 2:3.YY5.1 Scope

The Retrieve Manifest transaction enables a {{ linkvhlr }} to retrieve a manifest (search set) of available health documents from a {{ linkvhls }} using a previously obtained and validated Verified Health Link (VHL). 

This transaction occurs after the {{ linkvhlr }} has received a VHL from a VHL Holder (via ITI-YY4 Provide VHL) and validated the VHL signature.

This transaction follows the same pattern as MHD ITI-66 Find Document Lists, using a FHIR search on the List resource with the `_include` parameter to retrieve both the List and the referenced DocumentReference resources.

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

This transaction is a FHIR search on the List resource, similar to MHD ITI-66 Find Document Lists transaction. However, due to the need to transmit sensitive authorization parameters (passcode, receiver signature), this transaction uses HTTP POST with the `_search` interaction instead of HTTP GET.

**Request Structure**

The {{ linkvhlr }} performs an HTTP POST operation on the List resource `_search` endpoint with search parameters in the request body:

```
POST [base]/List/_search
Host: vhl-sharer.example.org
Content-Type: application/x-www-form-urlencoded
Accept: application/fhir+json
```

Where **[base]** is the base URL of the VHL Sharer's FHIR server.

**Search Parameters:**

The manifest URL obtained from the VHL contains the core search parameters. The {{ linkvhls }} SHALL support the following parameters:

**Core FHIR Search Parameters:**

| Parameter | Type | Cardinality | Description | Example |
|-----------|------|-------------|-------------|---------|
| _id | token | [1..1] | The folder ID (with 256-bit entropy) from the VHL | `_id=abc123def456` |
| identifier | token | [0..1] | Business identifier for the List | `identifier=folder-2024-001` |
| patient | reference | [0..1] | The patient whose documents are referenced, either patient or patient.identifier shall be included | `patient=9876` |
| patient.identifier| token| [0..1]| specifies an identifier associated with the patient to which the List Resource is assigned,, either patient or patient.identifier shall be included|`patient.identifier=pat-2024-9876`|
| code | token | [1..1] | The type of List (typically "folder") | `code=folder` |
| status | token | 1..1] | The status of the List | `status=current` |
| _include | special | [0..1] | Include referenced DocumentReference resources | `_include=List:item` |
{: .grid}

**VHL Authorization Parameters:**

| Parameter | Type | Cardinality | Description |
|-----------|------|-------------|-------------|
| passcode | string | [0..1] | User-provided passcode if the VHL is passcode-protected |
| recipient | string | [1..1] | Identifier of the requesting organization or person |
| receiverSignature | string | [0..1] | JWS signature from the VHL Receiver containing the manifest URL and passcode |
| embeddedLengthMax | integer | [0..1] | Integer upper bound on the length of embedded payloads (aligns with MHD ITI-66) |
{: .grid}

**_include Parameter:**

The {{ linkvhls }} SHALL support the `_include=List:item` parameter, which instructs the server to include the DocumentReference resources referenced by `List.entry.item` in the response Bundle.

**Example Request:**

```http
POST https://vhl-sharer.example.org/List/_search
Content-Type: application/x-www-form-urlencoded

_id=abc123def456&_include=List:item&passcode=user-pin&recipient=Dr.+Smith+Hospital&receiverSignature=eyJhbGciOiJFUzI1NiIsImtpZCI6InJlY2VpdmVyLWtleS0xMjMifQ.eyJ1cmwiOiJodHRwczovL3ZobC1zaGFyZXIuZXhhbXBsZS5vcmcvTGlzdD9faWQ9YWJjMTIzZGVmNDU2IiwicGFzc2NvZGUiOiJ1c2VyLXBpbiJ9.MEUCIQDxyz...
```

Alternative format using JSON (if server supports):
```http
POST https://vhl-sharer.example.org/List/_search
Content-Type: application/json

{
  "_id": "abc123def456",
  "_include": "List:item",
  "passcode": "user-pin",
  "recipient": "Dr. Smith Hospital",
  "receiverSignature": "eyJhbGciOiJFUzI1NiIsImtpZCI6InJlY2VpdmVyLWtleS0xMjMifQ..."
}
```

**Receiver Signature Content:**

When using the `receiverSignature` parameter, the JWS payload SHALL contain:

```json
{
  "url": "https://vhl-sharer.example.org/List?_id=abc123def456",
  "passcode": "user-pin",
  "recipient": "Dr. Smith Hospital",
  "iat": 1704067200
}
```

**Authentication and Authorization:**

The {{ linkvhlr }} SHALL authenticate the request using one or more of the following mechanisms:
- **VHL-based Authorization**: The request parameters match those in the validated VHL
- **Receiver Signature**: JWS signature in `receiverSignature` parameter proves the request originates from a trusted {{ linkvhlr }}
- **Secure Channel**: Mutual TLS authentication per ATNA
- **OAuth 2.0 Bearer Token**: If supported by the {{ linkvhls }}

##### 2:3.YY5.4.1.3 Expected Actions - VHL Receiver

The {{ linkvhlr }} SHALL:

1. **Extract Manifest URL from VHL**:
   - Parse the validated VHL payload
   - Extract the `url` field containing the manifest URL
   - Parse the URL to identify the base endpoint and core search parameters

2. **Prepare Request Parameters**:
   - Extract core FHIR search parameters (_id, patient, code, status, etc.) from manifest URL
   - Prepare `_include=List:item` parameter
   - Include `passcode` if VHL requires it (user-provided)
   - Include `recipient` identifier (required)
   - Include `embeddedLengthMax` if limiting embedded content size

3. **Prepare Signed Request** (if using receiver signature):
   - Construct JWS payload containing:
     - `url`: the manifest URL
     - `passcode`: the user-provided passcode (if applicable)
     - `recipient`: the recipient identifier
     - `iat`: issued-at timestamp
   - Sign payload using {{ linkvhlr }} private key
   - Include signature in `receiverSignature` parameter

4. **Submit Request**:
   - Perform HTTP POST on the List `_search` endpoint
   - Send parameters in request body (application/x-www-form-urlencoded or JSON)
   - Include all required and optional parameters
   - Handle HTTP responses (200, 401, 403, 404, 422, 429, 500)

5. **Process Response**:
   - Parse FHIR Bundle of type `searchset`
   - Extract List resource (search.mode = "match")
   - Extract DocumentReference resources (search.mode = "include")
   - Cache manifest for subsequent document retrievals

The {{ linkvhlr }} MAY:
- Record audit event per **[Audit Event – Received Health Data](Requirements-AuditEventReceived.html)**

##### 2:3.YY5.4.1.3 Expected Actions - VHL Sharer

Upon receiving Retrieve Manifest Request, the {{ linkvhls }} SHALL:

1. **Authenticate Request**:
   - Validate request originates from trusted {{ linkvhlr }}
   - Verify secure channel credentials if ATNA is used
   - Verify receiver signature if provided

2. **Authorize Request**:
   - Validate the folder ID (_id parameter) corresponds to a valid VHL
   - Verify VHL signature matches the original issuance
   - Confirm VHL not expired (check against issuance time + validity period)
   - Verify VHL not revoked
   - Validate passcode if VHL requires it (compare against stored hash)
   - Confirm VHL authorizes requested documents

3. **Execute Search**:
   - Query for List resource matching search parameters
   - Validate List exists and is accessible
   - Retrieve DocumentReference resources referenced by List.entry.item
   - Apply VHL scope and consent filters

4. **Prepare Response**:
   - Construct FHIR Bundle of type `searchset`
   - Include List resource with search.mode = "match"
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
- `_include=List:item`

The {{ linkvhls }} SHOULD support:
- `identifier` (token)
- `patient` (reference)
- `code` (token)
- `status` (token)

**Error Conditions:**

| HTTP Status | Condition |
|-------------|-----------|
| 401 Unauthorized | Secure channel authentication failed or signature invalid |
| 403 Forbidden | VHL expired, revoked, or doesn't authorize documents |
| 404 Not Found | List resource with specified _id not found or VHL invalid |
| 422 Unprocessable Entity | Invalid passcode |
| 429 Too Many Requests | Rate limit exceeded |
| 500 Internal Server Error | Server-side error |
{: .grid}

#### 2:3.YY5.4.2 Retrieve Manifest Response Message

##### 2:3.YY5.4.2.1 Trigger Events

{{ linkvhls }} returns manifest after successfully authenticating and authorizing request.

##### 2:3.YY5.4.2.2 Message Semantics

The response is a FHIR Bundle of type `searchset` containing the List resource and included DocumentReference resources.

**Success Response (HTTP 200):**

```http
HTTP/1.1 200 OK
Content-Type: application/fhir+json
ETag: "W/\"version-123\""
```

**Response Body - FHIR Bundle with List and DocumentReference Resources:**

```json
{
  "resourceType": "Bundle",
  "type": "searchset",
  "total": 3,
  "link": [{
    "relation": "self",
    "url": "https://vhl-sharer.example.org/List?_id=abc123def456&_include=List:item"
  }],
  "entry": [
    {
      "fullUrl": "https://vhl-sharer.example.org/List/abc123def456",
      "resource": {
        "resourceType": "List",
        "id": "abc123def456",
        "identifier": [{
          "system": "urn:ietf:rfc:3986",
          "value": "urn:uuid:abc123def456"
        }],
        "status": "current",
        "mode": "working",
        "code": {
          "coding": [{
            "system": "http://profiles.ihe.net/ITI/MHD/CodeSystem/MHDlistTypes",
            "code": "folder",
            "display": "Folder as a FHIR List"
          }]
        },
        "subject": {"reference": "Patient/9876"},
        "date": "2024-01-15T10:30:00Z",
        "entry": [
          {
            "item": {
              "reference": "DocumentReference/doc1"
            }
          },
          {
            "item": {
              "reference": "DocumentReference/doc2"
            }
          }
        ]
      },
      "search": {
        "mode": "match"
      }
    },
    {
      "fullUrl": "https://vhl-sharer.example.org/DocumentReference/doc1",
      "resource": {
        "resourceType": "DocumentReference",
        "id": "doc1",
        "masterIdentifier": {
          "system": "urn:ietf:rfc:3986",
          "value": "urn:oid:1.2.3.4.5.6.7.8.9.1"
        },
        "status": "current",
        "type": {
          "coding": [{
            "system": "http://loinc.org",
            "code": "60591-5",
            "display": "Patient Summary Document"
          }]
        },
        "category": [{
          "coding": [{
            "system": "http://ihe.net/connectathon/classCodes",
            "code": "History and Physical"
          }]
        }],
        "subject": {"reference": "Patient/9876"},
        "date": "2024-01-15T10:30:00Z",
        "author": [{
          "reference": "Practitioner/pract1"
        }],
        "content": [{
          "attachment": {
            "contentType": "application/fhir+json",
            "url": "https://vhl-sharer.example.org/Binary/doc1-content",
            "size": 15234,
            "hash": "07a2f6e5f8b3c9d4e1a2b3c4d5e6f7a8b9c0d1e2",
            "title": "Patient Summary - John Doe"
          },
          "format": {
            "system": "http://ihe.net/fhir/ihe.formatcode.fhir/CodeSystem/formatcode",
            "code": "urn:ihe:iti:xds:2017:mimeTypeSufficient",
            "display": "mimeType Sufficient"
          }
        }]
      },
      "search": {
        "mode": "include"
      }
    },
    {
      "fullUrl": "https://vhl-sharer.example.org/DocumentReference/doc2",
      "resource": {
        "resourceType": "DocumentReference",
        "id": "doc2",
        "masterIdentifier": {
          "system": "urn:ietf:rfc:3986",
          "value": "urn:oid:1.2.3.4.5.6.7.8.9.2"
        },
        "status": "current",
        "type": {
          "coding": [{
            "system": "http://loinc.org",
            "code": "11503-0",
            "display": "Laboratory Report"
          }]
        },
        "category": [{
          "coding": [{
            "system": "http://ihe.net/connectathon/classCodes",
            "code": "Laboratory"
          }]
        }],
        "subject": {"reference": "Patient/9876"},
        "date": "2024-01-10T14:20:00Z",
        "author": [{
          "reference": "Practitioner/pract2"
        }],
        "content": [{
          "attachment": {
            "contentType": "application/pdf",
            "url": "https://vhl-sharer.example.org/Binary/doc2-content",
            "size": 45678,
            "hash": "a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0",
            "title": "Lab Results - Complete Blood Count"
          },
          "format": {
            "system": "http://ihe.net/fhir/ihe.formatcode.fhir/CodeSystem/formatcode",
            "code": "urn:ihe:iti:xds:2017:mimeTypeSufficient",
            "display": "mimeType Sufficient"
          }
        }]
      },
      "search": {
        "mode": "include"
      }
    }
  ]
}
```

**Bundle Structure:**

| Element | Description |
|---------|-------------|
| type | SHALL be "searchset" |
| total | Total number of entries (List + included DocumentReferences) |
| link | Self link to the search URL |
| entry[0] | List resource with search.mode = "match" |
| entry[1..n] | DocumentReference resources with search.mode = "include" |
{: .grid}

##### 2:3.YY5.4.2.3 Expected Actions

**VHL Sharer:**
- Return FHIR Bundle with search results
- Include matching List resource with search.mode = "match"
- Include referenced DocumentReference resources with search.mode = "include"
- List.entry.item SHALL contain references to DocumentReference resources
- DocumentReference resources SHALL be included as separate Bundle entries per the `_include=List:item` parameter
- Provide document content URLs in DocumentReference.content.attachment for subsequent retrieval

**VHL Receiver:**
- Parse FHIR Bundle
- Extract List resource (search.mode = "match")
- Extract DocumentReference resources (search.mode = "include") that are referenced by the List
- Map List.entry.item references to the corresponding DocumentReference resources in the Bundle
- Cache manifest for subsequent document retrievals
- Prepare to retrieve specific document content using URLs from DocumentReference.content.attachment

### 2:3.YY5.5 Security Considerations

#### 2:3.YY5.5.1 Secure Channel Requirements
All requests SHALL occur over ATNA-defined secure channel with mutual authentication.

#### 2:3.YY5.5.2 Request Authentication via VHL
- VHL proves authorization from VHL Holder to access documents
- Manifest URL and parameters must match those in the validated VHL
- Ensures integrity of request parameters (manifest URL and passcode)
- Enables verification of the requesting party
- Creates non-repudiable audit trail

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
- VHL expiration limits replay window

### 2:3.YY5.6 Conformance

**VHL Receiver SHALL:**
- Support HTTP POST on List `_search` endpoint with parameters in request body
- Support `_include=List:item` parameter
- Include `recipient` parameter in all requests
- Include `passcode` parameter when VHL requires passcode
- Optionally include `receiverSignature` for additional authentication
- Parse searchset Bundle with included resources
- Distinguish between List (match) and DocumentReference (include) entries

**VHL Sharer SHALL:**
- Support HTTP POST on List `_search` endpoint
- Accept parameters via application/x-www-form-urlencoded request body
- Support search on List resource with parameters: _id, identifier, patient, code, status
- Support `_include=List:item` parameter
- Support VHL authorization parameters: passcode, recipient, receiverSignature, embeddedLengthMax
- Return Bundle of type searchset
- Include List resource with search.mode = "match"
- Include DocumentReference resources with search.mode = "include"
- Validate VHL authorization before returning documents
- Verify passcode securely (if provided)
- Optionally verify receiverSignature (if provided)

