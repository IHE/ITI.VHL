{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}

## 2:3.YY5 Retrieve Manifest

{% assign reqRequestVHLDocs = site.data.Requirements-RequestVHLDocuments %}

{% assign reqRequestVHLDocsTitle = reqRequestVHLDocs.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqRequestVHLDocsDescription = reqRequestVHLDocs.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

### 2:3.YY5.1 Scope

The Retrieve Manifest transaction enables a {{ linkvhlr }} to retrieve a manifest (search set) of available health documents from a {{ linkvhls }} using a previously obtained and validated Verified Health Link (VHL). 

This transaction occurs after the {{ linkvhlr }} has received a VHL from a VHL Holder (via ITI-YY4 Provide VHL) and validated the VHL signature.

This transaction follows the same pattern as MHD ITI-66 Find Document Lists, using a FHIR search on the List resource with an option to use the `_include` parameter to retrieve both the List and the referenced DocumentReference resources.

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

This transaction is a FHIR search on the List resource, similar to MHD ITI-66 Find Document Lists transaction. However, due to the need to transmit sensitive authorization parameters (passcode, recipient) and to support digital signatures over the request, this transaction uses HTTP POST with `multipart/form-data` encoding with three distinct parts.

**Request Structure**

The {{ linkvhlr }} performs an HTTP POST operation on the List resource `_search` endpoint with a multipart request body:

```
POST [base]/List/_search
Host: vhl-sharer.example.org
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW
Accept: application/fhir+json
```

Where **[base]** is the base URL of the VHL Sharer's FHIR server.

**Multipart Request Structure:**

The request body SHALL use `multipart/form-data` encoding with the following three parts:

1. **FHIR Search Parameters Part** - Contains the FHIR search parameters (_id, code, status, patient, _include)
2. **SHL Manifest Parameters Part** - Contains the SHL-specific parameters (recipient, passcode, embeddedLengthMax)
3. **Signature Part** (optional) - Contains the digital signature over both Part 1 and Part 2

**Part 1: FHIR Search Parameters**

```
Content-Disposition: form-data; name="fhir-parameters"
Content-Type: application/x-www-form-urlencoded
```

Contains FHIR search parameters:
- `_id`: The folder ID from the VHL (required)
- `code`: The type of List, typically "folder" (required)
- `status`: The status of the List, typically "current" (required)
- `patient` or `patient.identifier`: Patient reference or identifier (required)
- `_include`: if used, SHALL be "List:item" to include DocumentReference resources (optional)

**Part 2: SHL Manifest Parameters**

```
Content-Disposition: form-data; name="shl-parameters"
Content-Type: application/json
```

Contains SHL authorization parameters as a JSON object:
- `recipient`: Identifier of the requesting organization or person (required)
- `passcode`: User-provided passcode if VHL requires it (optional)
- `embeddedLengthMax`: Integer upper bound on embedded payload length (optional)

**Part 3: Signature (Optional)**

```
Content-Disposition: form-data; name="signature"
Content-Type: application/jose
```

Contains a detached JWS signature computed over the concatenation of:
- Part 1 content (fhir-parameters bytes)
- Part 2 content (shl-parameters bytes)

The manifest URL obtained from the VHL contains the core search parameters. The {{ linkvhls }} SHALL support the following parameters:

**Core FHIR Search Parameters (Part 1):**

| Parameter | Type | Cardinality | Description | Example |
|-----------|------|-------------|-------------|---------|
| _id | token | [1..1] | The folder ID (with 256-bit entropy) from the VHL | `_id=abc123def456` |
| code | token | [1..1] | The type of List (typically "folder") | `code=folder` |
| status | token | [1..1] | The status of the List (typically "current") | `status=current` |
| patient | reference | [0..1] | The patient whose documents are referenced; either patient or patient.identifier SHALL be included | `patient=Patient/9876` |
| patient.identifier | token | [0..1] | Specifies an identifier associated with the patient; either patient or patient.identifier SHALL be included | `patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123` |
| identifier | token | [0..1] | Business identifier for the List | `identifier=folder-2024-001` |
| _include | special | [0..1] | Include referenced DocumentReference resources; SHALL be "List:item" | `_include=List:item` |
{: .grid}

**SHL Manifest Parameters (Part 2):**

| Parameter | Type | Cardinality | Description |
|-----------|------|-------------|-------------|
| recipient | string | [1..1] | Identifier of the requesting organization or person |
| passcode | string | [0..1] | User-provided passcode if the VHL is passcode-protected |
| embeddedLengthMax | integer | [0..1] | Integer upper bound on the length of embedded payloads |
{: .grid}

**Example Request (3-Part Multipart):**

```
POST https://vhl-sharer.example.org/List/_search HTTP/1.1
Host: vhl-sharer.example.org
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Length: 1678

------WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="fhir-parameters"
Content-Type: application/x-www-form-urlencoded

_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item
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

1. **Part 1 (fhir-parameters):** Contains URL-encoded FHIR search parameters
   - `_id`: The folder ID from the VHL (required)
   - `code`: The type of List, typically "folder" (required)
   - `status`: The status of the List, typically "current" (required)
   - `patient.identifier`: Patient identifier in system|value format (required)
   - `_include`: Request to include DocumentReference resources (required)

2. **Part 2 (shl-parameters):** Contains JSON object with SHL authorization parameters
   - `recipient`: Identifier of requesting party (required)
   - `passcode`: User-provided passcode (if required by VHL)
   - `embeddedLengthMax`: Optional size limit for embedded content

3. **Part 3 (signature):** Contains detached JWS signature
   - Signs the concatenation of Part 1 and Part 2 content
   - Uses VHL Receiver's private key
   - Enables VHL Sharer to verify request authenticity and integrity

**Digital Signature Content:**

When using the signature part, the detached JWS signature SHALL be computed over the concatenation of:
1. The exact bytes of Part 1 (fhir-parameters content)
2. The exact bytes of Part 2 (shl-parameters content)

**JWS Protected Header:**
```
{
  "alg": "ES256",
  "kid": "receiver-key-123",
  "typ": "JOSE"
}
```

**Signed Content (Concatenation):**
```
_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item{"recipient":"Dr. Smith Hospital","passcode":"user-pin","embeddedLengthMax":10000}
```

**Note:** The concatenation is performed by appending Part 2 directly to Part 1 without any delimiter, separator, or newline between them.


##### 2:3.YY5.4.1.3 Expected Actions - VHL Sharer

Upon receiving Retrieve Manifest Request, the {{ linkvhls }} SHALL:

1. **Authenticate Request**:
   - Validate request originates from trusted {{ linkvhlr }}
   - Verify secure channel credentials if ATNA is used
   - Parse multipart request to extract all three parts
   - If signature provided:
     - Concatenate Part 1 and Part 2 bytes (no delimiter)
     - Extract `kid` from JWS protected header to identify receiver's public key
     - Verify detached JWS signature over the concatenated content
     - Use receiver's public key from trust list for verification

2. **Authorize Request**:
   - Validate the folder ID (_id parameter) corresponds to a valid VHL
   - Verify VHL signature matches the original issuance
   - Confirm VHL not expired (check against issuance time + validity period)
   - Verify VHL not revoked
   - Validate passcode if VHL requires it (compare against stored hash)
   - Confirm VHL authorizes requested documents

3. **Execute Search**:
   - Query for List resource matching FHIR search parameters from Part 1
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

### 2:3.YY5.5 Security Considerations

#### 2:3.YY5.5.1 Secure Channel Requirements
All requests MAY occur over ATNA-defined secure channel with mutual authentication.

#### 2:3.YY5.5.2 Request Authentication via Digital Signature
- Digital signature over both FHIR parameters and SHL parameters ensures integrity
- Separation of parameters into distinct parts enables clear authorization boundaries
- Signature proves the request originates from a trusted {{ linkvhlr }}
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
- Digital signatures with timestamps prevent replay attacks
