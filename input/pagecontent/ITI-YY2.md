{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}


> **Note on Transaction Optionality**: This transaction is **REQUIRED (R)** for Trust Anchor actors and **OPTIONAL (O)** for VHL Sharer and VHL Receiver actors. Implementations that do not support this transaction must use alternative mechanisms (out of scope for this profile) to retrieve PKI material from the Trust Anchor. Only implementations that claim support for this transaction can participate in IHE Connectathon testing for trust material retrieval. See Volume 1 Section XX.2.1 for details on trust establishment approaches.

{% assign reqRetrievePKI = site.data.Requirements-InitiateRetrieveTrustListRequest %}
{% assign reqRetrievePKIResp = site.data.Requirements-RespondtoRetrieveTrustListRequest %}
{% assign reqReceivePKI = site.data.Requirements-ReceiveTrustList %}


{% assign reqRetrievePKItitle = reqRetrievePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqRetrievePKIResptitle = reqRetrievePKIResp.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqReceivePKItitle = reqReceivePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign reqRetrievePKIdescription = reqRetrievePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign reqRetrievePKIRespdescription = reqRetrievePKIResp.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign reqReceivePKIdescription = reqReceivePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}


### 2:3.YY2.1 Scope

The Retrieve Trust List with DID transaction allows both {{ linkvhls }}s and {{ linkvhlr }}s to retrieve trusted public key material from the {{ linkta }} using Decentralized Identifiers (DIDs). 
    
Retrieved material SHALL be used to determine the trustworthiness of VHL artifacts in accordance with the governing trust framework.

<figure>
{%include ITI-YY2.svg%}
<p id="figure-2.3.YY2-1" class="figureTitle">Figure 2:3.YY2-1: Retrieve Trust List with DID Interaction Diagram</p>
</figure>
<br clear="all">

### 2:3.YY2.2 Actor Roles


| Actor | Role |
|-------|--------|
| VHL Receiver, VHL Sharer | {{ reqRetrievePKItitle.valueString }} |
| Trust Anchor             | {{ reqRetrievePKIResptitle.valueString }} |
{: .grid}

### 2:3.YY2.3 Referenced Standards

- **W3C DID Core 1.0**: [Decentralized Identifiers (DIDs) v1.0](https://www.w3.org/TR/did-core/)
- **RFC 7517**: JSON Web Key (JWK)
- **IHE mCSD**: [Mobile Care Services Discovery](https://profiles.ihe.net/ITI/mCSD/)


### 2:3.YY2.4 Messages

#### 2:3.YY2.4.1 Retrieve Trust List Request Message

##### 2:3.YY2.4.1.1 Trigger Events
{{ reqRetrievePKIdescription.valueMarkdown}}


The {{ linkta }} SHALL have made available at least one endpoint (such as an mCSD-compliant endpoint) that is accessible to all participants in the trust network. The requesting participant ({{ linkvhlr }} or {{ linkvhls }}) knows in advance the endpoint from which to retrieve DID Documents and PKI material.

The {{ linkta }} MAY additionally provide individual endpoints per participant, in addition to the common endpoint.


##### 2:3.YY2.4.1.2 Message Semantics

The Retrieve Trust List Request retrieves DID Documents from the {{ linkta }}.

**Request Methods:**

The mechanism used to retrieve a DID Document is determined by the DID method of the DID being resolved. Implementations SHALL resolve DID Documents according to the resolution rules defined by the applicable DID method specification.


##### 2:3.YY2.4.1.3 Expected Actions

**VHL Sharer / VHL Receiver (Requester):**

The requesting actor SHALL:

1. **Determine Retrieval Endpoint**: Identify the {{ linkta }} endpoint for DID Document retrieval
2. **Construct Request**: Build an HTTP GET request for retrieval of DID Document
3. **Submit Request**: Send the request over a secure connection



#### 2:3.YY2.4.2 Retrieve Trust List Response Message 

##### 2:3.YY2.4.2.1 Trigger Events

{{ reqRetrievePKIRespdescription.valueMarkdown}}



##### 2:3.YY2.4.2.2  Message Semantics

**Success Response:**

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "@context": [
    "https://www.w3.org/ns/did/v1",
    "https://w3id.org/security/suites/jws-2020/v1"
  ],
  "id": "did:web:trust-anchor.example.org:v1:trustlist",
  "controller": "did:web:trust-anchor.example.org:v1:trustlist",
  "verificationMethod": [
    {
      "id": "did:web:trust-anchor.example.org:v1:trustlist#signing-key-1",
      "type": "JsonWebKey2020",
      "controller": "did:web:trust-anchor.example.org:v1:trustlist",
      "publicKeyJwk": {
        "kty": "EC",
        "kid": "signing-key-1",
        "crv": "P-256",
        "x": "38M1FDts7Oea7urmseiugGW7tWc3mLpJh6rKe7xINZ8",
        "y": "nDQW6XZ7b_u2Sy9slofYLlG03sOEoug3I0aAPQ0exs4"
      }
    },
    {
      "id": "did:example:vhl-sharer-123456#signing-key-2",
      "type": "JsonWebKey2020",
      "controller": "did:web:trust-anchor.example.org:v1:trustlist",
      "publicKeyJwk": {
        "kty": "EC",
        "kid": "signing-key-2",
        "crv": "P-256",
        "x": "38M1FDts7Oea7urmseiugGW7tWc3mLpJh6rKe7xINZ8-Q",
        "y": "nDQW6XZ7b_u2Sy9slofYLlG03sOEoug3I0aAPQ0exs4-"
      }
    }
  ],
  "proof": {
    "type": "JsonWebSignature2020",
    "created": "2025-01-15T12:00:00Z",
    "verificationMethod": "did:web:trust-anchor.example.org:v1:trustlist#signing-DID",
    "proofPurpose": "assertionMethod",
    "nonce": "a3f8c2d1-9b4e-4f7a-b6e2-1c5d8f3a9e2b",
    "jws": "eyJhbGciOiJFUzI1NiIsImI2NCI6ZmFsc2UsImNyaXQiOlsiYjY0Il19..example_signature_value"
  }
}
```

**Error Responses:**

| HTTP Status | Condition |
|-------------|-----------|
| 404 Not Found | Requested DID not found in Trust Anchor registry |
| 401 Unauthorized | Request not authenticated |
| 403 Forbidden | Requester not authorized to retrieve trust material |
{: .grid}

**Response Elements:**

The response SHALL include one or more DID Documents, each containing:

| Element | Cardinality | Description |
|---------|-------------|-------------|
| @context | [1..*] | JSON-LD context |
| id | [1..1] | The DID identifier |
| verificationMethod | [1..*] | Public key material for verification |
| authentication | [0..*] | Methods used for authentication |
| assertionMethod | [0..*] | Methods used for signing/assertions |
| service | [0..*] | Service endpoints |
| proof | [1..1] | Cryptographic proof over the trust list document as defined in [W3C VC Data Model 2.0](https://www.w3.org/TR/vc-data-model-2.0/). The proof SHALL include a `nonce` to prevent replay attacks. |
{: .grid}

The `proof` element SHALL contain:

| Sub-element | Cardinality | Description |
|-------------|-------------|-------------|
| type | [1..1] | Proof type (e.g., `JsonWebSignature2020`) |
| created | [1..1] | ISO 8601 datetime the proof was created |
| verificationMethod | [1..1] | Reference to the key used to create the proof |
| proofPurpose | [1..1] | Purpose of the proof (e.g., `assertionMethod`) |
| nonce | [1..1] | Unique value to prevent replay attacks; SHALL be included by the Trust Anchor |
| jws | [1..1] | The detached JSON Web Signature value |
{: .grid}

##### 2:3.YY2.4.2.3 Expected Actions

Upon receiving a Retrieve Trust List Request, the {{ linkta }} SHALL:

1. **Authenticate Request**: Validate the requesting entity is authorized to retrieve trust material
2. **Process Query**: Identify the requested DID Document(s) based on query parameters
3. **Filter Results**: Return only active, non-revoked DID Documents
4. **Construct Response**: Format the response according to the requested representation, ensure returned DID Documents conform to W3C DID Core specification and include sufficient verification methods for signature validation
5. **Sign Response** (optional): Digitally sign the response to ensure integrity

**VHL Receiver / VHL Sharer:**

{{ reqReceivePKIdescription.valueMarkdown }}

{% include requirements-list-statements.liquid req=reqReceivePKI site=site  %}

Upon receiving the Trust List response, the {{ linkvhlr }} or {{ linkvhls }} SHALL:

1. **Validate Response**: Verify the integrity of the response (signature if present)
2. **Parse DID Documents**: Extract each DID Document from the response
3. **Extract Public Keys**: Retrieve public key material from verification methods
4. **Map to Usage**: Associate each verification method with its intended use (authentication, assertion, etc.)
5. **Cache**: Store the DID Documents according to caching policy
6. **Monitor Expiry**: Track any expiration times and refresh cached material as needed
4. **Handle Response**: Process the returned DID Document(s) and extract public key material


### 2:3.YY2.5 Security Considerations 

#### 2:3.YY2.5.1 Secure Retrieval

All Retrieve Trust List interactions SHALL occur over a secure connection. The {{ linkta }} SHOULD authenticate requesting entities before serving trust material.

#### 2:3.YY2.5.2 DID Document Validation

Clients ({{ linkvhlr }}s and {{ linkvhls }}s) SHALL:
- Verify DID Documents conform to W3C DID Core specification
- Validate that verification methods contain well-formed public keys
- Check that key types and algorithms are acceptable per trust framework policy
- Verify any signatures or integrity proofs on the response payload

#### 2:3.YY2.5.3 Caching and Freshness

Implementations SHOULD:
- Cache retrieved DID Documents to reduce load on {{ linkta }}
- Respect any cache-control headers or expiration times
- Implement periodic refresh of cached material
- Immediately invalidate cached DID Documents upon revocation notification

#### 2:3.YY2.5.4 Revocation Checking

The {{ linkta }} SHALL:
- Only serve active, non-revoked DID Documents
- Provide mechanisms for distributing revocation information
- Support timely updates when DID Documents are revoked

Clients SHOULD:
- Check revocation status before trusting retrieved material
- Implement appropriate revocation checking mechanisms (e.g., periodic polling, push notifications)

#### 2:3.YY2.5.5 Endpoint Security

The {{ linkta }}'s DID retrieval endpoint SHOULD:
- Implement rate limiting to prevent abuse
- Log all retrieval attempts for audit purposes
- Use authentication to restrict access to authorized participants
- Be publicly resolvable and tamper-resistant

Content profiles MAY define additional constraints, such as:
- Minimum key lengths (e.g., EC P-256 or stronger)
- Permitted cryptographic algorithms
- Retry and timeout behavior
- Maximum cache lifetimes
