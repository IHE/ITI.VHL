{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}


> **Note on Transaction Optionality**: This transaction is **REQUIRED (R)** for Trust Anchor actors and **OPTIONAL (O)** for VHL Sharer and VHL Receiver actors. Implementations that do not support this transaction must use alternative mechanisms (out of scope for this profile) to retrieve PKI material from the Trust Anchor. Only implementations that claim support for this transaction can participate in IHE Connectathon testing for trust material retrieval. See Volume 1 Section [1:XX.5.1 Trust Network Security](volume-1.html#1xx51-trust-network-security) for details on trust establishment approaches.

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
<p id="figure-2.3.YY2.1-1" class="figureTitle">Figure 2:3.YY2.1-1: Retrieve Trust List with DID Interaction Diagram</p>
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
- **W3C DID Method: Web**: [did:web Method Specification](https://w3c-ccg.github.io/did-method-web/)
- **RFC 7517**: JSON Web Key (JWK)
- **RFC 5280**: Internet X.509 Public Key Infrastructure Certificate and CRL Profile — the format of certificates carried in `x5c`
- **IHE mCSD**: [Mobile Care Services Discovery](https://profiles.ihe.net/ITI/mCSD/)


### 2:3.YY2.4 Messages

#### 2:3.YY2.4.1 Retrieve Trust List Request Message

##### 2:3.YY2.4.1.1 Trigger Events
{{ reqRetrievePKIdescription.valueMarkdown}}


The {{ linkta }} SHALL have made available at least one endpoint (such as an mCSD-compliant endpoint) that is accessible to all participants in the trust network. The requesting participant ({{ linkvhlr }} or {{ linkvhls }}) knows in advance the endpoint from which to retrieve DID Documents and PKI material.

The requesting participant SHALL also hold the {{ linkta }}'s public key, shared with the participant at the time of onboarding. That key is what the participant uses to verify the cryptographic proof over a retrieved trust list. It cannot be obtained from the trust list itself without circularity, and it is not established by transport security, so it is shared through the verified, out-of-band process the trust framework defines for onboarding.

The {{ linkta }} MAY additionally provide individual endpoints per participant, in addition to the common endpoint.


##### 2:3.YY2.4.1.2 Message Semantics

The Retrieve Trust List Request retrieves DID Documents from the {{ linkta }}.

**Request Methods:**

The mechanism used to retrieve a DID Document is determined by the DID method of the DID being resolved. Implementations SHALL resolve DID Documents according to the resolution rules defined by the applicable DID method specification.

Implementations SHALL support the `did:web` method, resolved as defined in the [did:web Method Specification](https://w3c-ccg.github.io/did-method-web/), where retrieval of the DID Document is an HTTP GET against the resolved HTTPS URL. Other DID methods MAY be used where all parties to a trust network have agreed to them.

**Organization of the Trust List (Recommended)**

A trust network typically holds key material for many participants, across more than one use case context, and for more than one key usage. Retrieving the entire trust list when only a subset is needed is wasteful, and the {{ linkvhlr }} or {{ linkvhls }} generally knows in advance which subset applies.

Where the governing trust framework defines a structured arrangement of trust list DIDs, implementations SHOULD use it. A trust network may, for example, arrange trust list DIDs by trust domain, participant, and key usage, so that a DID identifies a filtered view of the trust list:

```
did:web:[trust-anchor-host]:[version]:trustlist:[domain]:[participant]:[usage]
```

which resolves to:

```
https://[trust-anchor-host]/[version]/trustlist/[domain]/[participant]/[usage]/did.json
```

In that arrangement a hyphen (`-`) at any level acts as a wildcard, so a request for all participants within a domain, or all domains for one participant, is expressed by substituting `-` at the corresponding level. This is presented as a worked example of a trust list arrangement, not as a requirement of this profile.


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

The following response returns a trust list DID Document holding Certificate Authority issued key material for two participants. Certificate values are truncated for readability.

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "@context": [
    "https://www.w3.org/ns/did/v1",
    "https://w3id.org/security/suites/jws-2020/v1",
    "https://trust-anchor.example.org/context/v1.jsonld"
  ],
  "id": "did:web:trust-anchor.example.org:v2:trustlist:DCC:-:DSC",
  "controller": "did:web:trust-anchor.example.org:v2:trustlist:DCC:-:DSC",
  "verificationMethod": [
    {
      "id": "did:web:trust-anchor.example.org:v2:trustlist:DCC:-:DSC#XPjhL9Znd1M=",
      "type": "JsonWebKey2020",
      "controller": "did:web:trust-anchor.example.org:v2:trustlist:DCC:-:DSC",
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
      },
      "domain": { "code": "#DCC" },
      "participant": { "code": "#XA" },
      "keyusage": { "code": "#DSC" }
    },
    {
      "id": "did:web:trust-anchor.example.org:v2:trustlist:DCC:-:DSC#9tKmQ2ZbW4E=",
      "type": "JsonWebKey2020",
      "controller": "did:web:trust-anchor.example.org:v2:trustlist:DCC:-:DSC",
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
      },
      "domain": { "code": "#DCC" },
      "participant": { "code": "#XB" },
      "keyusage": { "code": "#DSC" }
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

Reading the example:

- Every `verificationMethod.id` is a DID URL within the namespace of the document's own `id`, and `controller` identifies the {{ linkta }} as the party that publishes and maintains this trust list. A verification method identified under a different DID would be a claim by the {{ linkta }} to control key material in another party's namespace.
- The participant to which each key belongs is conveyed by the `participant` metadata and by the subject of the certificate in `x5c` — not by the verification method identifier.
- `x5c` carries each participant's Document Signer Certificate followed by its issuing Signing Certificate Authority. The {{ linkvhlr }} or {{ linkvhls }} validates this chain before using the key.
- The `proof` is created by the {{ linkta }}'s own signing key, which is identified by a DID distinct from the trust list itself.

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
| @context | [1..*] | JSON-LD context, SHALL include "https://www.w3.org/ns/did/v1". MAY additionally include a context defined by the governing trust framework where that framework defines additional members |
| id | [1..1] | The DID identifier |
| controller | [0..1] | The DID authorized to make changes to this DID Document |
| verificationMethod | [1..*] | Public key material for verification |
| authentication | [0..*] | Methods used for authentication |
| assertionMethod | [0..*] | Methods used for signing/assertions |
| service | [0..*] | Service endpoints |
| proof | [1..1] | Cryptographic proof over the trust list document, enabling the recipient to establish that the document was published by the {{ linkta }} and has not been altered |
{: .grid}

Each verification method carries key material as described in [ITI-YY1 Message Semantics](ITI-YY1.html#23yy1412-message-semantics). In particular:

| Element | Cardinality | Description |
|---------|-------------|-------------|
| publicKeyJwk.x5c | [1..1] | Certificate chain as an array of base64-encoded DER certificates (RFC 5280). The certificate containing the public key is the first entry, followed by each issuing certificate in order toward the certificate authority; where the key material is self-generated the array contains a single self-signed certificate. See [Expected Actions](#23yy2423-expected-actions) for the recipient's validation obligation |
| domain / participant / keyusage | [0..1] each | Where the governing trust framework defines members distinguishing the use case context, the participating jurisdiction, and the intended key usage, they SHOULD be populated. See [ITI-YY1 Key Metadata](ITI-YY1.html#key-metadata) |
{: .grid}

The `proof` element SHALL contain:

| Sub-element | Cardinality | Description |
|-------------|-------------|-------------|
| type | [1..1] | Proof type (e.g., `JsonWebSignature2020`) |
| created | [1..1] | ISO 8601 datetime the proof was created. Used by the recipient to establish the freshness of the trust list — see [Expected Actions](#23yy2423-expected-actions) |
| verificationMethod | [1..1] | Reference to the key used to create the proof |
| proofPurpose | [1..1] | Purpose of the proof (e.g., `assertionMethod`) |
| nonce | [1..1] | A unique value included by the {{ linkta }} |
| jws | [1..1] | The detached JSON Web Signature value |
{: .grid}

##### 2:3.YY2.4.2.3 Expected Actions

Upon receiving a Retrieve Trust List Request, the {{ linkta }} SHALL:

1. **Authenticate Request**: Validate the requesting entity is authorized to retrieve trust material
2. **Process Query**: Identify the requested DID Document(s) based on query parameters
3. **Filter Results**: Return only active, non-revoked DID Documents
4. **Construct Response**: Format the response according to the requested representation, ensure returned DID Documents conform to W3C DID Core specification and include sufficient verification methods for signature validation
5. **Sign Response** : Digitally sign the response to ensure integrity

**VHL Receiver / VHL Sharer:**

{{ reqReceivePKIdescription.valueMarkdown }}

{% include requirements-list-statements.liquid req=reqReceivePKI site=site  %}

Upon receiving the Trust List response, the {{ linkvhlr }} or {{ linkvhls }} SHALL:

1. **Validate Response**: Verify the `proof` over each returned DID Document, using the {{ linkta }}'s public key established at onboarding, before any of its content is relied upon. A DID Document whose proof cannot be verified against a key established at onboarding SHALL NOT be used.
2. **Check Freshness**: Verify `proof.created` against the recipient's freshness policy, and SHALL NOT accept a trust list older than one already held for the same DID. This prevents an older, validly signed trust list being substituted for the current one in order to reinstate withdrawn key material.
3. **Parse DID Documents**: Extract each DID Document from the response
4. **Validate Certificate Chains**: For each verification method, validate that the `x5c` chain resolves back to a certificate verifiable against one of the public keys pre-shared with the trust network at the time of onboarding, confirm that the public key expressed in the JWK is the key certified by the first certificate in the chain, and confirm that each certificate in the path is within its validity period and not revoked.

   **A public key SHALL NOT be treated as trusted merely because it appears in a retrieved trust list.** Where the trust framework operates a certificate authority, the authority for a key derives from its certificate chain terminating in onboarded material. How the path is constructed, which algorithms and key strengths are permitted, and how revocation status is obtained are defined by the governing trust framework.
5. **Extract Public Keys**: Retrieve public key material from verification methods that passed the preceding checks
6. **Map to Usage**: Associate each verification method with its intended use, using the key metadata defined by the trust framework where present, or the DID Core verification relationships (authentication, assertionMethod, keyAgreement) otherwise
7. **Cache**: Store the DID Documents according to caching policy
8. **Monitor Expiry**: Track any expiration times and refresh cached material as needed


### 2:3.YY2.5 Security Considerations 

#### 2:3.YY2.5.1 Secure Retrieval

Trust list retrieval is subject to the secure channel requirements in [Volume 1 Section XX.5.2 Secure Channel Requirements](volume-1.html#xx52-secure-channel-requirements). The {{ linkta }} SHOULD authenticate requesting entities before serving trust material.

#### 2:3.YY2.5.2 DID Document Validation

Clients ({{ linkvhlr }}s and {{ linkvhls }}s) SHOULD check that key types and algorithms are acceptable per their trust framework policy.

The validation obligations on a client receiving a trust list are stated in [2:3.YY2.4.2.3 Expected Actions](#23yy2423-expected-actions). Two properties of this transaction explain why they are necessary.

A DID Document retrieved over HTTPS carries no inherent binding between the identifier and the content returned under it: whoever controls the host controls what is served, and may change it without leaving evidence that it was changed. Transport security establishes which host served the document, not that its content is the trust list the {{ linkta }} published. The `proof` over the document is what establishes that — and it is conclusive only because the key that verifies it was established out-of-band at onboarding rather than retrieved alongside the document it authenticates.

Similarly, appearance in a trust list conveys distribution, not authority. Where the governing trust framework operates a certificate authority, the authority for a key derives from a certificate chain terminating in material established at onboarding; taking a public key from a retrieved document without validating that chain discards the assurance the certificate hierarchy exists to provide.

#### 2:3.YY2.5.3 Caching and Freshness

Implementations SHOULD:
- Cache retrieved DID Documents to reduce load on {{ linkta }}
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
