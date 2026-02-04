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

The Retrieve Trust List with DID transaction allows both {{ linkvhls }}s and {{ linkvhlr }}s to retrieve trusted cryptographic material from the {{ linkta }} using Decentralized Identifiers (DIDs). This material includes:

- DID Documents containing public key material
- Verification methods with cryptographic keys (JWK or multibase format)
- Service endpoints for trust network participants
- Associated metadata required to validate the authenticity of a Verified Health Link (VHL)
    
Retrieved material SHALL be used to determine the trustworthiness of VHL artifacts and service endpoints in accordance with the governing trust framework.

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
- **RFC 8446**: TLS Protocol Version 1.3
- **IHE mCSD**: [Mobile Care Services Discovery](https://profiles.ihe.net/ITI/mCSD/)


### 2:3.YY2.4 Messages

#### 2:3.YY2.4.1 Retrieve Trust List Request Message

##### 2:3.YY2.4.1.1 Trigger Events
{{ reqRetrievePKIdescription.valueMarkdown}}

**Preconditions:**

When the DID option is used for PKI material retrieval, the {{ linkta }} SHALL have made available at least one endpoint (such as an mCSD-compliant endpoint) that is accessible to all participants in the trust network. The requesting participant ({{ linkvhlr }} or {{ linkvhls }}) knows in advance the endpoint from which to retrieve DID Documents and PKI material.

The {{ linkta }} MAY provide:
- A single common endpoint for all participants to retrieve PKI material, OR
- Individual endpoints per participant, in addition to the common endpoint

At minimum, one endpoint accessible to all participants SHALL be available.

##### 2:3.YY2.4.1.2 Message Semantics

The Retrieve Trust List Request retrieves DID Documents from the {{ linkta }}.

**Request Methods:**

Implementations SHALL support one of the following request patterns:

**Option 1: HTTP GET for specific DID**

```http
GET [trust-anchor-base]/did/{did-identifier}
Accept: application/did+json
```

Where `{did-identifier}` is the URL-encoded DID (e.g., `did:example:vhl-sharer-123456`)

**Option 2: Query for all DIDs**

```http
GET [trust-anchor-base]/did
Accept: application/did+json
```

Returns a collection of DID Documents for all registered trust network participants.

**Option 3: mCSD-based Query**

Using IHE mCSD patterns to query for Organization resources containing DID Documents:

```http
GET [trust-anchor-base]/Organization?_has:OrganizationAffiliation:organization:role=VHLSharer
Accept: application/fhir+json
```

**Request Parameters:**

| Parameter | Cardinality | Description |
|-----------|-------------|-------------|
| did-identifier | [0..1] | Specific DID to retrieve (for Option 1) |
| type | [0..1] | Filter by entity type (e.g., VHLSharer, VHLReceiver) |
| status | [0..1] | Filter by status (active, revoked, expired) |
{: .grid}

##### 2:3.YY2.4.1.3 Expected Actions

**VHL Sharer / VHL Receiver (Requester):**

The requesting actor SHALL:

1. **Determine Retrieval Endpoint**: Identify the {{ linkta }} endpoint for DID Document retrieval
2. **Construct Request**: Build an HTTP GET request for:
   - A specific DID Document (if the DID is known), OR
   - All active DID Documents in the trust network
3. **Submit Request**: Send the request over a secure connection
4. **Handle Response**: Process the returned DID Document(s) and extract public key material
5. **Cache**: Cache the retrieved material according to caching policies
6. **Validate**: Verify the integrity and authenticity of retrieved DID Documents

**Trust Anchor (Responder):**

{{ reqRetrievePKIRespdescription.valueMarkdown}}

Upon receiving a Retrieve Trust List Request, the {{ linkta }} SHALL:

1. **Authenticate Request**: Validate the requesting entity is authorized to retrieve trust material
2. **Process Query**: Identify the requested DID Document(s) based on query parameters
3. **Filter Results**: Return only active, non-revoked DID Documents
4. **Construct Response**: Format the response according to the requested representation
5. **Sign Response** (optional): Digitally sign the response to ensure integrity

#### 2:3.YY2.4.2 Retrieve Trust List Response Message 

##### 2:3.YY2.4.2.1 Trigger Events

A {{ linkta }} initiates a Retrieve Trust List Response Message once it has processed the request and assembled the appropriate DID Documents.

##### 2:3.YY2.4.2.2  Message Semantics

**Success Response (Single DID):**

```http
HTTP/1.1 200 OK
Content-Type: application/did+json

{
  "@context": [
    "https://www.w3.org/ns/did/v1",
    "https://w3id.org/security/suites/jws-2020/v1"
  ],
  "id": "did:example:vhl-sharer-123456",
  "verificationMethod": [{
    "id": "did:example:vhl-sharer-123456#signing-key-1",
    "type": "JsonWebKey2020",
    "controller": "did:example:vhl-sharer-123456",
    "publicKeyJwk": {
      "kty": "EC",
      "crv": "P-256",
      "x": "38M1FDts7Oea7urmseiugGW7tWc3mLpJh6rKe7xINZ8",
      "y": "nDQW6XZ7b_u2Sy9slofYLlG03sOEoug3I0aAPQ0exs4"
    }
  }],
  "authentication": [
    "did:example:vhl-sharer-123456#signing-key-1"
  ],
  "assertionMethod": [
    "did:example:vhl-sharer-123456#signing-key-1"
  ],
  "service": [{
    "id": "did:example:vhl-sharer-123456#vhl-endpoint",
    "type": "VHLSharerService",
    "serviceEndpoint": "https://vhl-sharer.example.org"
  }]
}
```

**Success Response (Multiple DIDs):**

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "didDocuments": [
    {
      "@context": ["https://www.w3.org/ns/did/v1"],
      "id": "did:example:vhl-sharer-123456",
      "verificationMethod": [...]
    },
    {
      "@context": ["https://www.w3.org/ns/did/v1"],
      "id": "did:example:vhl-receiver-789012",
      "verificationMethod": [...]
    }
  ]
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
{: .grid}

##### 2:3.YY2.4.2.3 Expected Actions

**Trust Anchor:**

The {{ linkta }} SHALL:
- Return only active, non-revoked DID Documents
- Ensure returned DID Documents conform to W3C DID Core specification
- Include sufficient verification methods for signature validation
- MAY sign the response payload for integrity protection

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

The receiving actor SHALL process the received PKI material as specified in the [Receive Trust List](Requirements-ReceiveTrustList.html) requirement.


### 2:3.YY2.5 Security Considerations 

#### 2:3.YY2.5.1 Secure Retrieval

All Retrieve Trust List interactions MUST occur over secure channels (TLS 1.3 or equivalent). The {{ linkta }} SHOULD authenticate requesting entities before serving trust material.

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
