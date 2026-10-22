{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}


{% assign reqRequestVHLDocs = site.data.Requirements-RequestVHLDocuments %}

{% assign reqRequestVHLDocsTitle = reqRequestVHLDocs.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqRequestVHLDocsDescription = reqRequestVHLDocs.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

### 2:3.YY5.1 Scope

The Retrieve Manifest transaction enables a {{ linkvhlr }} to retrieve a manifest (searchset Bundle) of available health documents from a {{ linkvhls }} using a previously obtained and validated Verified Health Link (VHL). 

This transaction occurs after the {{ linkvhlr }} has received a VHL from a VHL Holder (via ITI-YY4 Provide VHL) and validated the VHL signature.

**FHIR Search Transaction:** This transaction uses a standard FHIR search on the List resource, following the same pattern as MHD ITI-66 Find Document Lists. The manifest URL from the VHL payload contains all necessary FHIR search parameters. No custom operation is required.

**Authentication:** Implementations SHALL support at least one of the following three authentication mechanisms. Participants MAY use **HTTP Message Signatures (RFC 9421)**, **OAuth with SSRAA**, or the **Verifiable Credential Option** depending on their deployment context. The VHL Sharer authenticates the requesting VHL Receiver before processing the request.

  1. **HTTP Message Signatures Option:** Implementations MAY support authentication via **HTTP Message Signatures (RFC 9421)**, in which the {{ linkvhlr }} signs selected components of the outgoing HTTP manifest request (e.g., `@method`, `@target-uri`, `content-digest`, `date`) using its trust-network key. The {{ linkvhls }} verifies the signature against the {{ linkvhlr }}'s public key from the trust network before processing the request. This option requires no additional token endpoint or credential exchange — authentication is carried entirely within the HTTP request itself.

  2. **OAuth with SSRAA Option:** Implementations MAY support the **OAuth with SSRAA Option**, which uses OAuth 2.0 tokens for authentication as defined in the [HL7 Security for Scalable Registration, Authentication, and Authorization IG](http://hl7.org/fhir/us/udap-security/) (SSRAA). When this option is supported, implementations use OAuth Backend Services with JWT client assertions for system-to-system authentication.

  3. **Verifiable Credential Option:** Implementations MAY support the **Verifiable Credential Option**, in which the {{ linkvhlr }} self-issues a JSON-LD Verifiable Credential (LDP-VC) whose subject is the manifest decoded from the VHL (received as a QR code or as a Verifiable Credential per [ITI-YY4](ITI-YY4.html)). The VC contains an embedded **DataIntegrityProof** signed with the {{ linkvhlr }}'s key from the trust network, and is sent directly as the HTTP POST body (`Content-Type: application/vc`). No additional HTTP-level signing is needed; the embedded proof is sufficient.


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
- **RFC 5280**: X.509 PKI Certificate and CRL Profile
- **RFC 9110**: HTTP Semantics
- **RFC 9421**: HTTP Message Signatures
- **RFC 6234**: SHA-256 Hash Function
- **W3C VC Data Model v2**: [Verifiable Credentials Data Model v2](https://www.w3.org/TR/vc-data-model-2.0/) - for Verifiable Credential Option
- **W3C Data Integrity**: [Verifiable Credential Data Integrity 1.0](https://www.w3.org/TR/vc-data-integrity/) - DataIntegrityProof for Verifiable Credential Option
- **W3C Data Integrity ECDSA Cryptosuites**: [ecdsa-rdfc-2019 / ecdsa-jcs-2019](https://www.w3.org/TR/vc-di-ecdsa/)

**FHIR Specifications:**
- **FHIR R4**: [HL7 FHIR Release 4](http://hl7.org/fhir/R4/)
- **FHIR List Resource**: [List Resource](http://hl7.org/fhir/R4/list.html)
- **FHIR DocumentReference**: [DocumentReference Resource](http://hl7.org/fhir/R4/documentreference.html)
- **FHIR Bundle**: [Bundle Resource](http://hl7.org/fhir/R4/bundle.html)
- **FHIR Search**: [Search Parameters](http://hl7.org/fhir/R4/search.html)
- **FHIR _include**: [_include Parameter](http://hl7.org/fhir/R4/search.html#include)

**IHE Profiles:**
- **ITI TF-2: Mobile Health Document Sharing (MHD)**: [ITI-66 Find Document Lists](https://profiles.ihe.net/ITI/MHD/ITI-66.html)
- **ITI TF-2: Mobile Health Document Sharing (MHD)**: [ITI-68 Retrieve Document](https://profiles.ihe.net/ITI/MHD/ITI-68.html) - used to retrieve the binary content referenced from `DocumentReference.content.attachment.url`
- **ITI TF-1: Section 9**: ATNA Profile
- **ITI TF-2: 3.19**: Authenticate Node transaction

**OAuth with SSRAA (Optional):**
- **RFC 7515**: JSON Web Signature (JWS) - for OAuth with SSRAA Option
- **RFC 7519**: JSON Web Token (JWT) - for OAuth with SSRAA Option
- **SMART App Launch Backend Services**: [Backend Services](http://hl7.org/fhir/smart-app-launch/backend-services.html)
- **HL7 Security for Scalable Registration, Authentication, and Authorization IG**: [SSRAA](http://hl7.org/fhir/us/udap-security/)
- **ITI Internet User Authorization (IUA)**: [IUA Profile](https://profiles.ihe.net/ITI/IUA/)

**SHL Specifications:**
- **SHL Manifest Request**: [SHL Manifest Request](http://hl7.org/fhir/uv/smart-health-cards-and-links/STU1/links-specification.html#smart-health-link-manifest-request)
- **SHL Encrypting and Decrypting Files**: [SHL Encryption](https://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html#encrypting-and-decrypting-files) - JWE `dir` + `A256GCM` convention used to encrypt document binaries

**Encryption Standards:**
- **RFC 7516**: JSON Web Encryption (JWE) - compact serialization used for document encryption
- **RFC 7518**: JSON Web Algorithms (JWA) - `dir` key management and `A256GCM` content encryption

### 2:3.YY5.4 Messages

<figure >
  <div style="width:35em; max-width:100%;">
     {%include ITI-YY5.svg%}
  </div>
  <p id="f2:3.YY5.4-1" class="figureTitle">Figure 2:3.YY5.4-1: Retrieve Manifest Interaction Diagram</p>
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
| patient.identifier | token (chained) | [1..1] | FHIR chained search on the patient reference parameter; resolves the patient by business identifier (`system\|value`) without requiring a direct Patient resource reference. | `patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123` |
| _include | special | [0..1] | Include referenced DocumentReference resources; SHALL be "List:item" if used. Only processed if VHL Sharer supports Include DocumentReference Option | `_include=List:item` |
{: .grid}

**SHL Manifest Request Parameters**

In addition to the FHIR search parameters in the URL, the following SHL-defined manifest parameters (per the [SMART Health Links specification](http://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html)) SHALL be included in the request body:

| Parameter | Type | Cardinality | Description |
|-----------|------|-------------|-------------|
| recipient | string | [1..1] | Identifier of the requesting organization or person (e.g., "Dr. Smith Hospital", "Emergency Department - General Hospital") |
| passcode | string | [0..1] | User-provided passcode if the VHL is passcode-protected (P flag present in VHL) |
| embeddedLengthMax | integer | [0..1] | Integer upper bound on the length of embedded payloads (optional optimization hint) |
{: .grid}

**Parameter Placement**

The manifest URL decoded from the VHL is a FHIR search URL in `GET` form — `[base]/List?…`. The {{ linkvhlr }} issues the request as an HTTP `POST` to `[base]/List/_search`, carrying the parameters from that URL. POST is used rather than GET so that the passcode and the other SHL manifest parameters travel in the request body rather than the request line.

Each parameter SHALL be conveyed exactly once. [FHIR](https://hl7.org/fhir/R4/http.html) permits search parameters to appear in the query string of a `_search` request as well as in the body, and treats a parameter appearing in both places as a repeat of that parameter — which for `_id` would change the meaning of the search. Implementations SHALL therefore place the parameters in one location only:

| Authentication option | Parameters conveyed in |
|-----------------------|------------------------|
| HTTP Message Signatures | the `application/x-www-form-urlencoded` request body |
| OAuth with SSRAA | the `application/x-www-form-urlencoded` request body |
| Verifiable Credential | `credentialSubject.id` within the credential (see [2:3.YY5.4.1.5](#23yy5415-authentication-option---verifiable-credential-option)) |
{: .grid}

Keeping the parameters out of the request line also keeps the patient business identifier out of server, proxy and content-distribution logs, where request lines are commonly recorded by default. See [Security Considerations](#23yy556-privacy-of-request-metadata).

##### 2:3.YY5.4.1.3 Authentication Option - HTTP Message Signatures

Implementations MAY authenticate using **HTTP Message Signatures** per RFC 9421. HTTP Message Signatures provide cryptographic proof of the receiver's identity, request integrity, and non-repudiation.

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
   - SHALL be included for POST requests with body

2. **Signature-Input Header:**
   - Metadata about the signature
   - Components signed: `@method`, `@path`, `@authority`, `content-type`, `content-digest`
   - `created`: Unix timestamp when signature was created
   - `keyid`: Identifier of receiver's public key (used to locate key in trust list)
   - `alg`: Signature algorithm — selected per [Cryptographic Algorithm Selection](volume-1.html#1xx53-cryptographic-algorithm-selection)

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

**Signature Algorithms:**

Signature algorithms are selected per [Cryptographic Algorithm Selection](volume-1.html#1xx53-cryptographic-algorithm-selection).

> The {{ linkvhlr }} signing steps are described in [Expected Actions - VHL Receiver](#23yy5416-expected-actions---vhl-receiver). The {{ linkvhls }} verification steps are described in [Expected Actions - VHL Sharer](#23yy5417-expected-actions---vhl-sharer). Security requirements are in [Security Considerations Section 2:3.YY5.5.2](#23yy552-http-message-signatures).

##### 2:3.YY5.4.1.4 Authentication option - OAuth with SSRAA Option

Implementations that support the **OAuth with SSRAA Option** MAY use OAuth 2.0 access tokens for authentication instead of HTTP Message Signatures. This option provides interoperability with systems implementing the [HL7 Security for Scalable Registration, Authentication, and Authorization IG](http://hl7.org/fhir/us/udap-security/) (SSRAA). The following workflow description is informative only, and does not take precedence over underlying requirements from the HL7 Security for Scalable Registration, Authentication, and Authorization IG.

**Preconditions: SSRAA Discovery and Registration**

Before an access token can be obtained, the {{ linkvhlr }} and {{ linkvhls }} SHALL have completed SSRAA Discovery and Dynamic Client Registration (per SSRAA Sections 2 and 3) at least once per {{ linkvhlr }} 
/ {{ linkvhls }} pair — the FHIR Base URL of the {{ linkvhls }} comes from the VHL payload. These steps MAY take place in advance or just in time; the {{ linkvhlr }} steps are described in [Expected Actions - VHL Receiver](#23yy5416-expected-actions---vhl-receiver).

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
&scope=system/List.s system/DocumentReference.r system/Binary.r
&client_assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer
&client_assertion=eyJhbGciOiJSUzI1NiIsIng1YyI6WyJNSUkuLi4iLCJNSUkuLi4iXX0.eyJpc3MiOiI2QjlFRkQ3NDg4MkM0RTZDQjVFNTYxOUU4MjFDNTBGQSIsInN1YiI6IjZCOUVGRDc0ODgyQzRFNkNCNUU1NjE5RTgyMUM1MEZBIiwiYXVkIjoiaHR0cHM6Ly9hdXRob3JpemF0aW9uLXNlcnZlci5leGFtcGxlLm9yZy90b2tlbiIsImlhdCI6MTczNTY4OTYwMCwiZXhwIjoxNzM1Njg5OTAwLCJqdGkiOiJyYW5kb20tdW5pcXVlLWlkIiwiZXh0ZW5zaW9ucyI6eyJobDctYjJiIjp7InZlcnNpb24iOiIxIiwib3JnYW5pemF0aW9uX2lkIjoiaHR0cHM6Ly9kaXJlY3RvcnkuZXhhbXBsZS5vcmcvT3JnYW5pemF0aW9uL3ZobC1yZWNlaXZlci1pZCIsInB1cnBvc2Vfb2ZfdXNlIjoidXJuOm9pZDoyLjE2Ljg0MC4xLjExMzg4My4zLjE4LjcuMSNTWVNERVYifX19.signature-here


```

**JWT Client Assertion:**
- Algorithm: determined by the HL7 Security for Scalable Registration, Authentication, and Authorization IG, which governs this option. The client assertion is signed with the X.509 credential registered through that IG rather than with trust network key material, so its algorithm is independent of the baseline in [Cryptographic Algorithm Selection](volume-1.html#1xx53-cryptographic-algorithm-selection)
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
  "access_token": "eyJhbGciOiJSUzI1NiIsIng1YyI6WyJNSUkuLi4iLCJNSUkuLi4iXX0.eyJpc3MiOiI2QjlFRkQ3NDg4MkM0RTZDQjVFNTYxOUU4MjFDNTBGQSIsInN1YiI6IjZCOUVGRDc0ODgyQzRFNkNCNUU1NjE5RTgyMUM1MEZBIiwiYXVkIjoiaHR0cHM6Ly9hdXRob3JpemF0aW9uLXNlcnZlci5leGFtcGxlLm9yZy90b2tlbiIsImlhdCI6MTczNTY4OTYwMCwiZXhwIjoxNzM1Njg5OTAwLCJqdGkiOiJyYW5kb20tdW5pcXVlLWlkIiwiZXh0ZW5zaW9ucyI6eyJobDctYjJiIjp7InZlcnNpb24iOiIxIiwib3JnYW5pemF0aW9uX2lkIjoiaHR0cHM6Ly9kaXJlY3RvcnkuZXhhbXBsZS5vcmcvT3JnYW5pemF0aW9uL3ZobC1yZWNlaXZlci1pZCIsInB1cnBvc2Vfb2ZfdXNlIjoidXJuOm9pZDoyLjE2Ljg0MC4xLjExMzg4My4zLjE4LjcuMSNTWVNERVYifX19.signature-here",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "system/List.s system/DocumentReference.r system/Binary.r"
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

**OAuth Token Requirements:**

- Grant Type: `client_credentials`
- Client Authentication: `private_key_jwt` (JWT client assertion)
- Required Scopes (SMART v2 vocabulary use is illustrative; specific scope requirements are determined by trust community policies per the HL7 Security for Scalable Registration, Authentication, and Authorization IG):
  - `system/List.s` - Search for List resources
  - `system/DocumentReference.r` - Read DocumentReference resources
  - `system/Binary.r` - Read Binary resources (document content)
- Token Lifetime: Typically 1 hour (3600 seconds)
- Token Reuse: Access token MAY be reused for multiple requests until expiration, consistent with underlying requirements from the HL7 Security for Scalable Registration, Authentication, and Authorization IG.

> The {{ linkvhlr }} side (SSRAA Discovery/Registration, JWT client assertion creation, access token acquisition, and Authorization-header inclusion) is described in [Expected Actions - VHL Receiver](#23yy5416-expected-actions---vhl-receiver). The {{ linkvhls }} side (Bearer token validation) is in [Expected Actions - VHL Sharer](#23yy5417-expected-actions---vhl-sharer).

##### 2:3.YY5.4.1.5 Authentication Option - Verifiable Credential Option

Implementations that support the **Verifiable Credential Option** MAY use a self-issued JSON-LD Verifiable Credential (LDP-VC) for authentication. In this option the {{ linkvhlr }} constructs a VC whose `credentialSubject` is the manifest decoded from the VHL (received as a QR code or as a Verifiable Credential per [ITI-YY4](ITI-YY4.html)), and whose embedded **DataIntegrityProof** is signed with the {{ linkvhlr }}'s key from the trust network. The VC is sent directly as the HTTP POST body with `Content-Type: application/vc`. No additional HTTP-level signing is required; the DataIntegrityProof inside the VC document is the cryptographic proof of the receiver's identity and QR possession.

**Preconditions:**

Before using the Verifiable Credential Option, the {{ linkvhlr }} SHALL:
- Hold a key pair registered in the trust network (obtained via ITI-YY2 Retrieve Trust List with DID)
- Have decoded the VHL (from QR code or from a Verifiable Credential per the VC Enveloped VHL) and extracted the VHL payload (manifest URL, flags, label, etc.) via ITI-YY4

**Self-Issued VC Construction:**

The {{ linkvhlr }} SHALL construct the VC as a JSON-LD document per the [W3C Verifiable Credentials Data Model v2](https://www.w3.org/TR/vc-data-model-2.0/) with an embedded `proof` of type `DataIntegrityProof` per the [W3C Verifiable Credential Data Integrity 1.0](https://www.w3.org/TR/vc-data-integrity/) specification:

The credential carries the three SHL-defined manifest parameters inside `credentialSubject`, which
places them within the signature. Because those parameters are defined by the SMART Health Links
specification rather than by the VC Data Model, the credential declares them in an inline
`@context` — this keeps the credential self-contained and avoids a dependency on any externally
hosted context document.

```json
{
  "@context": [
    "https://www.w3.org/ns/credentials/v2",
    {
      "@vocab": null,
      "recipient": "https://profiles.ihe.net/ITI/VHL/ns#recipient",
      "passcode": "https://profiles.ihe.net/ITI/VHL/ns#passcode",
      "embeddedLengthMax": "https://profiles.ihe.net/ITI/VHL/ns#embeddedLengthMax"
    }
  ],
  "type": ["VerifiableCredential"],
  "issuer": "did:web:vhl-receiver.example.org",
  "validFrom": "2024-01-15T10:00:00Z",
  "validUntil": "2024-01-15T10:05:00Z",
  "credentialSubject": {
    "id": "https://vhl-sharer.example.org/List?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item",
    "recipient": "Dr. Smith Hospital",
    "passcode": "user-pin",
    "embeddedLengthMax": 10000
  },
  "proof": {
    "type": "DataIntegrityProof",
    "cryptosuite": "ecdsa-rdfc-2019",
    "created": "2024-01-15T10:00:00Z",
    "verificationMethod": "did:web:vhl-receiver.example.org#receiver-key-123",
    "proofPurpose": "assertionMethod",
    "proofValue": "z3FD9sJ8kL2m9pQ7rT4vW5xY6zAb3cD4eF5gH6iJ7kL8mN9oP0qR1sT2uV3wX4yZ"
  }
}
```

**VC Fields:**

| Field | Description |
|-------|-------------|
| `@context` | SHALL begin with `https://www.w3.org/ns/credentials/v2`, followed by definitions for the SHL manifest parameters. Every term used in the credential SHALL be defined, so that no member is discarded during JSON-LD processing and left outside the signature |
| `issuer` | The {{ linkvhlr }}'s DID or identifier corresponding to its trust network key |
| `validFrom` | Timestamp from which the credential is valid |
| `validUntil` | Expiration (SHALL be short-lived; recommended: 5 minutes from `validFrom`) |
| `credentialSubject.id` | The manifest URL — binds the VC to the specific manifest decoded from the VHL. It contains the folder ID, so a valid signature over this credential is proof that the {{ linkvhlr }} holds that VHL |
| `credentialSubject.recipient` | Identifier of the requesting organization or person (replaces SHL `recipient` body parameter) |
| `credentialSubject.passcode` | User-provided passcode if the VHL is passcode-protected (replaces SHL `passcode` body parameter) |
| `credentialSubject.embeddedLengthMax` | Optional size hint for embedded content (replaces SHL `embeddedLengthMax` body parameter) |
| **`proof`** | **Embedded DataIntegrityProof — the cryptographic proof of the {{ linkvhlr }}'s identity** |
| `proof.type` | `DataIntegrityProof` — W3C Data Integrity proof |
| `proof.cryptosuite` | Cryptosuite used — selected per [Cryptographic Algorithm Selection](volume-1.html#1xx53-cryptographic-algorithm-selection) |
| `proof.created` | Timestamp when the proof was created (SHALL match `validFrom`) |
| `proof.verificationMethod` | DID URL resolving to the {{ linkvhlr }}'s public key in the trust network (e.g., `did:web:receiver.example.org#key-id`) |
| `proof.proofPurpose` | `assertionMethod` — the {{ linkvhlr }} is asserting this credential |
| `proof.proofValue` | Multibase-encoded cryptographic signature over the VC document (computed with the {{ linkvhlr }}'s private key from the trust network) |
{: .grid}

> **Note:** The `proof.proofValue` is the sole cryptographic proof of the {{ linkvhlr }}'s identity. No outer JWT or HTTP Message Signature is needed. The `verificationMethod` resolves to the receiver's public key in the trust network (obtainable via ITI-YY2). The {{ linkvhls }} MUST verify this proof. The VHL payload encryption key (`key` field from the VHL payload) SHALL NOT appear anywhere in the VC.

**Request Structure:**

The {{ linkvhlr }} sends the VC as the POST body. The FHIR search parameters and the SHL manifest parameters are both carried inside the credential — the search parameters within `credentialSubject.id`, which is the manifest URL, and the SHL parameters as members of `credentialSubject`. The request line therefore carries no parameters:

```http
POST /List/_search HTTP/1.1
Host: vhl-sharer.example.org
Content-Type: application/vc
Accept: application/fhir+json

{
  "@context": [
    "https://www.w3.org/ns/credentials/v2",
    {
      "@vocab": null,
      "recipient": "https://profiles.ihe.net/ITI/VHL/ns#recipient",
      "passcode": "https://profiles.ihe.net/ITI/VHL/ns#passcode",
      "embeddedLengthMax": "https://profiles.ihe.net/ITI/VHL/ns#embeddedLengthMax"
    }
  ],
  "type": ["VerifiableCredential"],
  "issuer": "did:web:vhl-receiver.example.org",
  "validFrom": "2024-01-15T10:00:00Z",
  "validUntil": "2024-01-15T10:05:00Z",
  "credentialSubject": {
    "id": "https://vhl-sharer.example.org/List?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item",
    "recipient": "Dr. Smith Hospital",
    "passcode": "user-pin",
    "embeddedLengthMax": 10000
  },
  "proof": {
    "type": "DataIntegrityProof",
    "cryptosuite": "ecdsa-rdfc-2019",
    "created": "2024-01-15T10:00:00Z",
    "verificationMethod": "did:web:vhl-receiver.example.org#receiver-key-123",
    "proofPurpose": "assertionMethod",
    "proofValue": "z3FD9sJ8kL2m9pQ7rT4vW5xY6zA..."
  }
}
```

The {{ linkvhls }} takes the FHIR search parameters from `credentialSubject.id` rather than from the request line. Two consequences are worth noting: the parameters are inside the signature, so they cannot be altered in transit; and the patient business identifier does not appear in the request line, where it would otherwise be recorded by default in server, proxy and content-distribution logs.

> The {{ linkvhlr }} VC issuance steps are described in [Expected Actions - VHL Receiver](#23yy5416-expected-actions---vhl-receiver). The {{ linkvhls }} VC verification steps are in [Expected Actions - VHL Sharer](#23yy5417-expected-actions---vhl-sharer).

##### 2:3.YY5.4.1.6 Expected Actions - VHL Receiver

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

3. **Authenticate Request** (use atleast one of the following options):
   - **Option A - HTTP Message Signatures** (if supported):
     - Compute Content-Digest (SHA-256 of request body)
     - Construct signature base from HTTP components
     - Sign using receiver's private key
     - Include Content-Digest, Signature-Input, and Signature headers
   - **Option B - OAuth with SSRAA** (if supported):
     - **One-time setup:** if not already registered with this {{ linkvhls }}, perform UDAP Discovery and Dynamic Client Registration (per SSRAA Sections 2 and 3) using the FHIR Base URL from the VHL payload to obtain a client ID.
     - Create a JWT client assertion (`private_key_jwt`) signed with the receiver's trust-network private key — the X.509 cert (or chain) goes in the `x5c` header; `iss` and `sub` are the registered client ID; `aud` is the authorization server token endpoint; include `jti` and the `hl7-b2b` extension per SSRAA Section 5.2.1
     - Request an access token from the authorization server (`grant_type=client_credentials`) with appropriate scopes
     - Include the returned Bearer access token in the `Authorization` header of the manifest request
     - Reuse the access token across requests until expiration
   - **Option C - Verifiable Credential Option** (if supported):
     - Extract VHL payload fields from the decoded QR code (manifest URL, flags, label, expiration)
     - Construct LDP-VC with `credentialSubject.id` = manifest URL and the SHL manifest parameters (`recipient`, `passcode`, `embeddedLengthMax`) as members of `credentialSubject`, declaring every term used in `@context`. The VHL payload encryption `key` SHALL NOT appear anywhere in the VC
     - Compute `proof.proofValue` (DataIntegrityProof) over the VC document using trust network private key
     - Set `proof.verificationMethod` to the DID URL of the receiver's trust network key
     - POST the complete VC as `Content-Type: application/vc` body to `/List/_search`; the FHIR search parameters travel inside `credentialSubject.id` and SHALL NOT be repeated in the request line

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
- Support multiple authentication options

##### 2:3.YY5.4.1.7 Expected Actions - VHL Sharer

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
   - **OAuth with SSRAA Option**:
     - Extract Bearer token from Authorization header
     - Validate that the token was issued by the authorization server
     - Verify token expiration
     - Verify token scope authorizes access to the VHL
     - Reject if token invalid or expired (401 Unauthorized)
   - **Verifiable Credential Option**:
     - Parse `application/vc` request body as JSON-LD VC document
     - Resolve `proof.verificationMethod` DID URL to retrieve {{ linkvhlr }}'s public key from the trust network
     - Verify the **`proof.proofValue`** (DataIntegrityProof) over the VC document using the retrieved trust network key
     - Verify `proof.proofPurpose` is `assertionMethod`
     - Verify VC `validUntil` has not passed and `validFrom` is not in the future; verify `proof.created` freshness (±2 minutes recommended)
     - Take the FHIR search parameters from `credentialSubject.id`, which is the manifest URL
     - Extract SHL params from `credentialSubject` (`recipient`, `passcode`, `embeddedLengthMax`)
     - Reject if any verification fails (401 Unauthorized)

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
- `patient.identifier` (chained search on the patient reference parameter, token — `system|value`) - required. This is the same business identifier the VHL Holder supplied as `sourceIdentifier` at ITI-YY3. The direct `patient` reference parameter is not used in VHL manifest URLs.

The {{ linkvhls }} that supports the **Include DocumentReference Option** SHALL additionally support:
- `_include=List:item` (special)

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

Because the VHL manifest URL constructed at [ITI-YY3](ITI-YY3.html) is a FHIR search on `List` using the search parameters required by the Document Responder in [IHE MHD ITI-66 Find Document Lists](https://profiles.ihe.net/ITI/MHD/ITI-66.html), the Retrieve Manifest response is — at the FHIR level — an [MHD ITI-66 response message](https://profiles.ihe.net/ITI/MHD/ITI-66.html#23662-message-semantics): a FHIR `searchset` Bundle. The shape of the Bundle depends on whether the {{ linkvhls }} supports the **Include DocumentReference Option** AND the {{ linkvhlr }} included `_include=List:item` in the request:

| Case | Bundle contents | Receiver follow-up |
|------|-----------------|--------------------|
| **A. Include DocumentReference Option NOT used** (option unsupported, or `_include` not requested) | Standard MHD ITI-66 response: only `List` resource(s) with `search.mode="match"`. `List.entry[].item.reference` points to a DocumentReference on the {{ linkvhls }}. | Receiver SHALL FHIR-read each referenced DocumentReference (`GET /DocumentReference/<id>`) before retrieving binaries. |
| **B. Include DocumentReference Option used** | `List` resource(s) with `search.mode="match"` PLUS the referenced `DocumentReference` resources with `search.mode="include"`. | Receiver proceeds directly to binary retrieval; no extra metadata round-trip. |
{: .grid}

In both cases the Receiver subsequently retrieves each binary via [Retrieve Document [ITI-68]](#23yy5424-document-content-retrieval) and decrypts it as described in [Document Encryption](#23yy5425-document-encryption).

**Case A — Bundle without Include DocumentReference Option**

The Bundle conforms to the standard MHD ITI-66 response. For Bundle structure, element semantics, and a worked example, see [ITI-66 Message Semantics](https://profiles.ihe.net/ITI/MHD/ITI-66.html#23662-message-semantics). The {{ linkvhlr }} SHALL resolve each `List.entry[].item.reference` via a separate FHIR read on the {{ linkvhls }} before retrieving binaries.

**Case B — Bundle with Include DocumentReference Option**

The Bundle extends the ITI-66 response by including each referenced DocumentReference resource (`search.mode="include"`) — this `_include=List:item` behaviour is not defined by ITI-66. The {{ linkvhlr }} can move directly to binary retrieval.

```json
{
  "resourceType": "Bundle",
  "type": "searchset",
  "total": 5,
  "link": [
    {
      "relation": "self",
      "url": "https://vhl-sharer.example.org/List?_id=abc123def456&code=folder&status=current&patient.identifier=urn:oid:2.16.840.1.113883.2.4.6.3|PASSPORT123&_include=List:item"
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
- `List.entry[].item`: References to DocumentReference resources on the {{ linkvhls }}
- `DocumentReference.content.attachment.url`: Absolute URL the {{ linkvhlr }} dereferences via [Retrieve Document [ITI-68]](#23yy5424-document-content-retrieval) to obtain the (encrypted) binary
- `DocumentReference.content.attachment.contentType`: The **decrypted** content type (e.g. `application/fhir+json`, `application/pdf`). The transport content type observed during ITI-68 retrieval is `application/jose` whenever the binary is encrypted (see [Document Encryption](#23yy5425-document-encryption))

##### 2:3.YY5.4.2.3 Expected Actions

The {{ linkvhlr }} SHALL:
- Parse the Bundle and distinguish List vs. DocumentReference resources by `search.mode`.
- **If the Bundle does NOT contain DocumentReference resources** (Example A): for each `List.entry[].item.reference`, perform a FHIR read against the {{ linkvhls }} to obtain the DocumentReference metadata.
- For each DocumentReference, retrieve the binary by dereferencing `content.attachment.url` per [Retrieve Document [ITI-68]](#23yy5424-document-content-retrieval), reusing the same authentication option chosen for this ITI-YY5 session.
- Decrypt the retrieved binary using the `key` from the VHL payload cached from ITI-YY4, per [Document Encryption](#23yy5425-document-encryption).
- Verify that the decrypted payload's media type matches `DocumentReference.content.attachment.contentType`.

The {{ linkvhlr }} MAY:
- Display the document list to the user.
- Filter or sort documents based on metadata.
- Retrieve and decrypt document content on demand rather than eagerly.

##### 2:3.YY5.4.2.4 Document Content Retrieval

The {{ linkvhls }} returns FHIR `DocumentReference` metadata as part of (or referenced from) the manifest Bundle. The actual document binary is retrieved separately by dereferencing `DocumentReference.content.attachment.url`.

The binary retrieval SHALL conform to the IHE MHD **[Retrieve Document [ITI-68]](https://profiles.ihe.net/ITI/MHD/ITI-68.html)** transaction:

- **Method:** HTTP `GET` against `DocumentReference.content.attachment.url`.
- **Transport:** Same ATNA secure channel used for ITI-YY5.
- **Authentication:** The {{ linkvhlr }} SHALL reuse the same authentication option chosen for the originating ITI-YY5 request (HTTP Message Signatures, OAuth with SSRAA, or Verifiable Credential). A {{ linkvhlr }} SHALL NOT mix options across the manifest and binary retrievals of a single VHL session.
- **Response Content-Type:**
  - `application/jose` when the binary is encrypted per [Document Encryption](#23yy5425-document-encryption) (the default for VHL flows where the VHL payload carries a `key`).
  - The `DocumentReference.content.attachment.contentType` value when the binary is not encrypted.

A {{ linkvhls }} that supports ITI-YY5 SHALL be grouped with an MHD **Document Responder** so that ITI-68 GETs against `attachment.url` succeed. A {{ linkvhlr }} SHALL be grouped with an MHD **Document Consumer**.

**Example — ITI-68 retrieval of an encrypted document (HTTP Message Signatures option):**

```http
GET /Binary/doc001-content HTTP/1.1
Host: vhl-sharer.example.org
Accept: application/jose
Signature-Input: sig1=("@method" "@path" "@authority");created=1705315800;keyid="receiver-key-123";alg="ecdsa-p256-sha256"
Signature: sig1=:MEUCIQD...:
```

```http
HTTP/1.1 200 OK
Content-Type: application/jose

eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..<base64url-iv>.<base64url-ciphertext>.<base64url-tag>
```

The five dot-separated segments are the JWE Compact Serialization (RFC 7516): protected header, empty encrypted key (because `alg=dir`), IV, ciphertext, and authentication tag.

##### 2:3.YY5.4.2.5 Document Encryption

VHL document binaries are encrypted following the [SMART Health Links — Encrypting and Decrypting Files](https://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html#encrypting-and-decrypting-files) convention.

**Algorithm:**
- **Serialization:** JWE Compact Serialization per RFC 7516.
- **Key management (`alg`) and content encryption (`enc`):** selected per [Cryptographic Algorithm Selection](volume-1.html#1xx53-cryptographic-algorithm-selection), following the SMART Health Links convention referenced above.
- **Symmetric key:** The 32-byte (256-bit) value carried as `key` in the VHL payload generated by [ITI-YY3](ITI-YY3.html) and decoded by the {{ linkvhlr }} in [ITI-YY4](ITI-YY4.html). The receiver caches this key for the duration of the VHL session.

**Scope:**
- Encryption SHALL be applied to the document binary at `DocumentReference.content.attachment.url`. It is independent of the **Include DocumentReference Option** — the option only controls whether DocumentReference *metadata* is bundled into the manifest response.
- `DocumentReference.content.attachment.contentType` SHALL describe the **decrypted** payload (e.g. `application/fhir+json`, `application/pdf`). The encrypted transport representation is signalled by the `application/jose` Content-Type on the ITI-68 response.
- An unencrypted variant is permitted only when the originating VHL payload was generated without a `key` (matching SHL payload format semantics). VHL flows generated per ITI-YY3 always include a `key` and therefore always encrypt.

**Example — JWE Compact Serialization (illustrative, truncated):**

```
eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0
.
.
48V1_ALb6US04U3b
.
5eym8TW_c8SuK0ltJ3rpYIzOeDQz7TALvtu6UG9oMo4vpzs9tX_EFShS8iB7j6jiSdiwkIr3ajwQzaBtQD_A
.
XFBoMYUZodetZdvTiFvSkQ
```

The protected header decodes to `{"alg":"dir","enc":"A256GCM"}`. The empty second segment reflects `alg=dir` (no encrypted key).

**Decryption (informative):** The {{ linkvhlr }} base64url-decodes the IV, ciphertext, and authentication tag, then applies AES-256-GCM with the cached VHL payload `key` and the protected header as Additional Authenticated Data (per RFC 7516 Section 5.1). The plaintext is the original document body whose media type is `DocumentReference.content.attachment.contentType`. See the [SHL spec](https://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html#encrypting-and-decrypting-files) for full algorithmic detail.

### 2:3.YY5.5 Security Considerations

#### 2:3.YY5.5.1 Transport Security

Secure transport is required for all communications in this transaction. See [Volume 1 Section XX.5.2 Secure Channel Requirements](volume-1.html#xx52-secure-channel-requirements) for the applicable ATNA baseline.

#### 2:3.YY5.5.2 HTTP Message Signatures

Implementations that support HTTP Message Signatures per RFC 9421:
- Signature algorithm and key strength — see [Cryptographic Algorithm Selection](volume-1.html#1xx53-cryptographic-algorithm-selection)
- Private keys SHOULD be stored securely (Hardware Security Module recommended)
- Replay attacks are prevented by timestamp validation

A signature that covers `content-digest` commits to the exact bytes of the request body. Any intermediary that alters those bytes — a gateway that re-encodes form parameters, a proxy that re-chunks or re-serializes content, a security appliance that normalizes the payload — will cause verification to fail, and the failure is indistinguishable at the {{ linkvhls }} from a forged request. Deployments that place such intermediaries between the {{ linkvhlr }} and the {{ linkvhls }} SHOULD confirm that the request body is conveyed unmodified, or select one of the other authentication options, whose credentials are not bound to the body encoding.

#### 2:3.YY5.5.3 Audit Logging
Both {{ linkvhlr }} and {{ linkvhls }} SHOULD log:
- All document access requests (successful and failed)
- Authentication method used (HTTP signatures, OAuth, or Verifiable Credential)
- Receiver identity (from keyid or OAuth token)
- VHL folder ID
- Authorization decisions (approved/denied)
- Timestamps
- IP addresses
- User identifiers (from recipient parameter)

#### 2:3.YY5.5.4 Rate Limiting
{{ linkvhls }} SHOULD implement rate limiting:
- Per receiver (identified by keyid or OAuth client_id)
- Per folder ID (to prevent brute force on VHL tokens)
- Per IP address
- Return 429 Too Many Requests when limits exceeded

#### 2:3.YY5.5.5 Passcode Security
When VHL is passcode-protected (P flag):
- Failed passcode attempts SHOULD be rate limited
- Passcode SHOULD NOT be logged in audit trails
- Consider lockout after repeated failed attempts

<a name="23yy556-privacy-of-request-metadata"> </a>

#### 2:3.YY5.5.6 Privacy of Request Metadata

The manifest URL contains the patient business identifier that the {{ linkvhlh }} supplied at [ITI-YY3](ITI-YY3.html) — for example a passport or national identifier. While this is not clinical data, it is personal data under data protection regimes such as the European Health Data Space, and it is durable and highly identifying.

- Search parameters SHALL be conveyed in the request body or within the credential, not in the request line — see [Parameter Placement](#23yy5412-message-semantics). Request lines are recorded by default in web server, proxy and content-distribution logs, and those logs are typically retained far longer, and read by more people, than the health data itself.
- The `label` field is free text carried in the clear inside the VHL, readable by anyone who scans the QR code or opens the credential. It SHOULD identify the share to the {{ linkvhlh }} without disclosing clinical information — "Patient Health Summary" rather than a diagnosis, service or department name.
- Both the {{ linkvhlr }} and the {{ linkvhls }} SHOULD ensure that audit records capture the folder ID rather than the full manifest URL where the audit trail has a different retention period or a wider readership than the transaction logs.

