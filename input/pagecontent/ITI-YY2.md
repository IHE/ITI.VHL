{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}


> **Note on Transaction Optionality**: This transaction is **REQUIRED (R)** for Trust Anchor actors and **OPTIONAL (O)** for VHL Sharer and VHL Receiver actors. Implementations that do not support this transaction must use alternative mechanisms (out of scope for this profile) to retrieve PKI material from the Trust Anchor.


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

### 2:3.YY2.2 Actor Roles

<p id="t2:3.YY2.2-1" class="tableTitle"><strong>Table 2:3.YY2.2-1: Actor Roles</strong></p>

| Actor | Role |
|-------|------|
| {{ linkvhlr }}, {{ linkvhls }} | {{ reqRetrievePKItitle.valueString }} |
| {{ linkta }}             | {{ reqRetrievePKIResptitle.valueString }} |
{: .grid}

### 2:3.YY2.3 Referenced Standards

- **W3C DID Core 1.0**: [Decentralized Identifiers (DIDs) v1.0](https://www.w3.org/TR/did-core/)
- **W3C DID Method: Web**: [did:web Method Specification](https://w3c-ccg.github.io/did-method-web/)
- **RFC 7517**: JSON Web Key (JWK)
- **RFC 7515**: JSON Web Signature (JWS) — Section 4.1.6 defines the `x5c` header parameter used to carry certificate chains
- **RFC 5280**: Internet X.509 Public Key Infrastructure Certificate and CRL Profile — the format of certificates carried in `x5c`


### 2:3.YY2.4 Messages

<figure>
  <div style="width:35em; max-width:100%;">
     {%include ITI-YY2.svg%}
  </div>
  <p id="f2:3.YY2.4-1" class="figureTitle"><strong>Figure 2:3.YY2.4-1: Retrieve Trust List with DID Interaction Diagram</strong></p>
</figure>


#### 2:3.YY2.4.1 Retrieve Trust List Request Message

##### 2:3.YY2.4.1.1 Trigger Events
{{ reqRetrievePKIdescription.valueMarkdown}}

**VHL Sharer / VHL Receiver (Requester):**

The requesting actor SHALL:

1. **Determine Retrieval Endpoint**: Identify the {{ linkta }} endpoint for DID Document retrieval
2. **Construct Request**: Build an HTTP GET request for retrieval of the DID Document
3. **Submit Request**: Send the request over a secure connection


##### 2:3.YY2.4.1.2 Message Semantics


**Request Methods:**


Implementations SHALL support the `did:web` method, resolved as defined in the [did:web Method Specification](https://w3c-ccg.github.io/did-method-web/), where retrieval of the DID Document is an HTTP GET against the resolved HTTPS URL. Other DID methods MAY be used where all parties to a trust network have agreed to them.


##### 2:3.YY2.4.1.3 Expected Actions

**Trust Anchor (Responder):**

Upon receiving a Retrieve Trust List Request, the {{ linkta }} SHALL:

1. **Authenticate Request**: Validate the requesting entity is authorized to retrieve trust material
2. **Process Query**: Identify the requested DID Document(s) based on query parameters
3. **Filter Results**: Return only active, non-revoked DID Documents
4. **Construct Response**: Format the response according to the requested representation, ensure returned DID Documents conform to the W3C DID Core specification and include sufficient verification methods for signature validation
5. **Sign Response**: Digitally sign the response to ensure integrity


#### 2:3.YY2.4.2 Retrieve Trust List Response Message

##### 2:3.YY2.4.2.1 Trigger Events

{{ reqRetrievePKIRespdescription.valueMarkdown}}


##### 2:3.YY2.4.2.2 Message Semantics

**Success Response:**

The following response returns a trust list DID Document holding Certificate Authority-issued key material for two participants. Certificate values are truncated for readability.

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "@context": [
    "https://www.w3.org/ns/did/v1",
    "https://w3id.org/security/suites/jws-2020/v1"
  ],
  "id": "did:web:trust-anchor.example.org:v2:trustlist",
  "controller": "did:web:trust-anchor.example.org:v2:trustlist",
  "verificationMethod": [
    {
      "id": "did:web:trust-anchor.example.org:v2:trustlist:DCC:XXA:DSC#XPjhL9Znd1M=",
      "type": "JsonWebKey2020",
      "controller": "did:web:trust-anchor.example.org:v2:trustlist",
      "publicKeyJwk": {
        "kty": "EC",
        "kid": "XPjhL9Znd1M=",
        "x5c": [
          "MIICuTCCAmCgAwIBAgIUD9k1Q64Eav5r07DQ4Gff/7h7r6QwCgYIKoZIzj0EAwIwdDELMAkGA1UEBhMCWEEx...",
          "MIICMDCCAdWgAwIBAgIUFqWc0xbrcpAettDF8gEymTzDtSkwCgYIKoZIzj0EAwIwdDELMAkGA1UEBhMCWEEx..."
        ],
        "crv": "P-256",
        "x": "APdNVtZixJhhqsJS_yx--a_bLQaMMQj48CSb_3adr_MA",
        "y": "AOoV8O2w7rov_Txk3wwz_jMoKvx-IgSfYoyygtGetYEd"
      }
    },
    {
      "id": "did:web:trust-anchor.example.org:v2:trustlist:DCC:XXB:DSC#9tKmQ2ZbW4E=",
      "type": "JsonWebKey2020",
      "controller": "did:web:trust-anchor.example.org:v2:trustlist",
      "publicKeyJwk": {
        "kty": "EC",
        "kid": "9tKmQ2ZbW4E=",
        "x5c": [
          "MIICtzCCAl6gAwIBAgIUYm5rM0hQeVJ2TkZmR2xoT2NrRXdDZ1lJS29aSXpqMEVBd0l3...",
          "MIICLjCCAdSgAwIBAgIUS2xwZDNRbEVoTWpZd1JXNXBibVZ5TUI0WERUSTBNRGd3TWpB..."
        ],
        "crv": "P-256",
        "x": "AL1rXqTnDwUyVvKcHs3ZmJ4tRfQoNbGxWpYeAiKdM2Uc",
        "y": "AJ7hTgVwPzXsRbNmKcYdQfLoEuHiVaWtZpXrBnMjSk9F"
      }
    }
  ],
  "proof": {
    "type": "JsonWebSignature2020",
    "created": "2025-01-15T12:00:00Z",
    "verificationMethod": "did:web:trust-anchor.example.org:v2:signing#trust-anchor-key-1",
    "proofPurpose": "assertionMethod",
    "nonce": "a3f8c2d1-9b4e-4f7a-b6e2-1c5d8f3a9e2b",
    "jws": "eyJhbGciOiJFUzI1NiIsImI2NCI6ZmFsc2UsImNyaXQiOlsiYjY0Il19..example_signature_value"
  }
}
```

**Error Responses:**

<p id="t2:3.YY2.4.2.2-1" class="tableTitle"><strong>Table 2:3.YY2.4.2.2-1: Retrieve Trust List Error Responses</strong></p>

| HTTP Status | Condition |
|-------------|-----------|
| 404 Not Found | Requested DID not found in Trust Anchor registry |
| 401 Unauthorized | Request not authenticated |
| 403 Forbidden | Requester not authorized to retrieve trust material |
{: .grid}

**Response Elements:**

The response SHALL include one or more DID Documents. Their structure, and the key material carried in each verification method, are as defined in [ITI-YY1 Message Semantics](ITI-YY1.html#23yy1412-message-semantics) and are not restated here; the recipient's obligation to validate the certificate chain of each verification method is in [Expected Actions](#23yy2423-expected-actions).

In addition, each returned DID Document SHALL carry a `proof` over the document, enabling the recipient to establish that the document was published by the {{ linkta }} and has not been altered.

The `proof` element SHALL contain the sub-elements listed in Table 2:3.YY2.4.2.2-2.

<p id="t2:3.YY2.4.2.2-2" class="tableTitle"><strong>Table 2:3.YY2.4.2.2-2: Trust List proof Sub-elements</strong></p>

| Sub-element | Cardinality | Description |
|-------------|-------------|-------------|
| type | [1..1] | Proof type (e.g., `JsonWebSignature2020`) |
| created | [1..1] | ISO 8601 datetime the proof was created. Used by the recipient to establish the freshness of the trust list — see [Expected Actions](#23yy2423-expected-actions) |
| verificationMethod | [1..1] | Reference to the key used to create the proof. This is the {{ linkta }}'s own signing key, identified by a DID distinct from the trust list it signs |
| proofPurpose | [1..1] | Purpose of the proof (e.g., `assertionMethod`) |
| nonce | [1..1] | A unique value included by the {{ linkta }} |
| jws | [1..1] | The detached JSON Web Signature value |
{: .grid}

##### 2:3.YY2.4.2.3 Expected Actions


**VHL Receiver / VHL Sharer:**

{{ reqReceivePKIdescription.valueMarkdown }}

{% include requirements-list-statements.liquid req=reqReceivePKI site=site  %}

Upon receiving the Trust List response, the {{ linkvhlr }} or {{ linkvhls }} SHALL:

1. **Validate Response**: Verify the `proof` over each returned DID Document before any of its content is relied upon. A DID Document whose proof cannot be verified SHALL NOT be used.
2. **Check Freshness**: Verify `proof.created` against the recipient's freshness policy, and SHALL NOT accept a trust list older than one already held for the same DID. This prevents an older, validly signed trust list being substituted for the current one in order to reinstate withdrawn key material.
3. **Parse DID Documents**: Extract each DID Document from the response
4. **Validate Certificate Chains**: Where a verification method carries `x5c`, validate the chain to a certificate authority recognized by the governing trust framework, confirm that the public key expressed in the JWK is the key certified by the first certificate in the chain, and confirm that each certificate in the path is within its validity period and not revoked.

   **A public key SHALL NOT be treated as trusted merely because it appears in a retrieved trust list.** Where the trust framework operates a certificate authority, the authority for a key derives from its certificate chain. The rules governing that validation — recognized certificate authorities, path construction, permitted algorithms and key strengths, and how revocation status is obtained — are defined by the governing trust framework and are out of scope for this profile.
5. **Extract Public Keys**: Retrieve public key material from verification methods that passed the preceding checks
6. **Map to Usage**: Associate each verification method with its intended use through the DID Core verification relationships (`authentication`, `assertionMethod`, `keyAgreement`), or as the governing trust framework otherwise defines
7. **Cache**: Store the DID Documents according to caching policy
8. **Monitor Expiry**: Track any expiration times and refresh cached material as needed


### 2:3.YY2.5 Security Considerations

#### 2:3.YY2.5.1 Secure Retrieval

Trust list retrieval is subject to the secure channel requirements in [Volume 1 Section 1:XX.5.2 Secure Channel Requirements](volume-1.html#1xx52-secure-channel-requirements). The {{ linkta }} SHOULD authenticate requesting entities before serving trust material.

#### 2:3.YY2.5.2 DID Document Validation

Clients ({{ linkvhlr }}s and {{ linkvhls }}s) SHOULD check that key types and algorithms are acceptable per their trust framework policy.

Because a `did:web` DID Document is retrieved over HTTPS, and the identifier carries no inherent binding to the content returned, transport security alone does not establish that a trust list is authentic — whoever controls the host controls the content served. The `proof` over the document is what establishes authenticity, which is why verifying it before any of the document's content is relied upon is required at [2:3.YY2.4.2.3 Expected Actions](#23yy2423-expected-actions).

Where key material is Certificate Authority-issued, clients SHALL validate the `x5c` chain to a recognized certificate authority before using a key. Extracting a public key from a retrieved DID Document without validating its chain reduces a certificate hierarchy to the assertion that a key was present in a document, discarding the authority the hierarchy exists to convey.

#### 2:3.YY2.5.3 Caching and Freshness

Implementations SHOULD:
- Cache retrieved DID Documents to reduce load on the {{ linkta }}
- Respect any cache-control headers or expiration times
- Implement periodic refresh of cached material
- Immediately invalidate cached DID Documents upon revocation notification

#### 2:3.YY2.5.4 Revocation Checking

The {{ linkta }} SHOULD:
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
