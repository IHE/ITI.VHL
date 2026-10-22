{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}

> **Note on Transaction Optionality**: This transaction is **REQUIRED (R)** for Trust Anchor actors and **OPTIONAL (O)** for VHL Sharer and VHL Receiver actors. Implementations that do not support this transaction must use alternative mechanisms (out of scope for this profile) to establish trust relationships with the Trust Anchor. Only implementations that claim support for this transaction can participate in IHE Connectathon testing for trust establishment. See Volume 1 Section [1:XX.5.1 Trust Network Security](volume-1.html#1xx51-trust-network-security) for details on trust establishment approaches.

{% assign reqSubmitPKI = site.data.Requirements-InitiateSubmitPKIMaterialRequest %}
{% assign reqDistributePKI = site.data.Requirements-RespondtoSubmitPKIMaterialRequest %}

{% assign reqSubmitPKItitle = reqSubmitPKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqDistributePKItitle = reqDistributePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign reqSubmitPKIdescription = reqSubmitPKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign reqDistributePKIdescription = reqDistributePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

### 2:3.YY1.1 Scope

The Submit PKI Material with DID transaction enables entities within a trust network—specifically, {{ linkvhls }}s and {{ linkvhlr }}s—to submit their PKI material to a designated {{ linkta }} using Decentralized Identifiers (DIDs). PKI material is carried as a certificate chain: where the participant is enrolled under a Certificate Authority, the issued certificate together with the chain of certificates linking it to the issuing authority; where the participant generates its own key material, a single self-signed certificate. This transaction uses DID Documents conforming to the W3C DID Core specification to package and transmit that material. The {{ linkta }} validates, catalogs, and makes this material available for retrieval, enabling participants to verify digital signatures and establish secure communications within the VHL ecosystem.

This transaction is specified as a content interaction rather than as an API: what this transaction constrains is **the content of the DID Document**. The mechanism by which that content reaches the {{ linkta }} — the endpoint, protocol, and message envelope — is determined by the implementing jurisdiction and is out of scope for this profile.

### 2:3.YY1.2 Actor Roles

| Actor | Role |
|-------|------|
| {{ linkvhlr}}, {{ linkvhls}} | {{ reqSubmitPKItitle.valueString }}     |
| {{ linkta }}            | {{ reqDistributePKItitle.valueString }} |
{: .grid}


### 2:3.YY1.3 Referenced Standards

- **W3C DID Core 1.0**: [Decentralized Identifiers (DIDs) v1.0](https://www.w3.org/TR/did-core/)
- **W3C DID Method: Web**: [did:web Method Specification](https://w3c-ccg.github.io/did-method-web/)
- **RFC 7517**: JSON Web Key (JWK)
- **RFC 7515**: JSON Web Signature (JWS) — Section 4.1.6 defines the `x5c` header parameter used to carry certificate chains
- **RFC 5280**: Internet X.509 Public Key Infrastructure Certificate and CRL Profile — the format of certificates carried in `x5c`


### 2:3.YY1.4 Messages

<figure >
  <div style="width:35em; max-width:100%;">
     {%include ITI-YY1.svg%}
  </div>
  <p id="f3:YY1.4-1" class="figureTitle">Figure 3:YY1.4-1: Submit PKI Material with DID Interaction Diagram</p>
</figure>

#### 2:3.YY1.4.1 Submit PKI Material Request Message

##### 2:3.YY1.4.1.1 Trigger Events
{{ reqSubmitPKIdescription.valueMarkdown }}

{% include requirements-list-statements.liquid site=site req=reqSubmitPKI  %}

**VHL Sharer / VHL Receiver (Submitter):**

The submitting actor:

1. **Obtains Key Material**: Obtain one or more sets of key material suitable for the intended use (signing, encryption, authentication) by one of two paths, as determined by the governing trust framework:
   - **Self-generated** — the submitter generates its own cryptographic key pair [RR to check key pair vs a self signed certificate] and a self-signed certificate over it; or
   - **Certificate Authority (CA) issued** — the submitter is enrolled under a Signing Certificate Authority (SCA) and the SCA issues a certificate — for example a Document Signer Certificate (DSC) — to the submitter. In this case the submitter holds, in addition to the public key, the issued certificate and the chain of certificates linking it to the issuing authority.
2. **Constructs DID Document**: Create a DID Document containing:
   - A unique DID identifier for the entity
   - Verification methods with public key material in JWK format
   - The certificate chain carried in the `x5c` member of the JWK (see [Message Semantics](#23yy1412-message-semantics))
3. **Submits to Trust Anchor**: Makes the DID Document available to the {{ linkta }} via the submission pathway determined by the implementing jurisdiction

##### 2:3.YY1.4.1.2 Message Semantics

PKI material SHALL be submitted to the {{ linkta }} using DID Documents formatted according to the [W3C DID Core specification](https://www.w3.org/TR/did-core/).

**DID Method**

Participants SHALL support the `did:web` method for the DIDs used in this transaction, resolved as defined in the [did:web Method Specification](https://w3c-ccg.github.io/did-method-web/). Other DID methods MAY be used where all parties to a trust network have agreed to them.

**DID Document Structure**

The DID Document SHALL be formatted as a JSON document containing:

- A unique DID identifier for the submitting entity
- One or more verification methods containing public key material
- Service endpoints where the entity can be reached
- Authentication and assertion methods as appropriate

**Required DID Document Elements:**

| Element | Cardinality | Description |
|---------|-------------|-------------|
| @context | [1..*] | JSON-LD context, SHALL include "https://www.w3.org/ns/did/v1". MAY additionally include a context defined by the governing trust framework, where that framework defines additional members (see [Key Metadata](#key-metadata)) |
| id | [1..1] | The DID for the submitting entity (e.g., "did:web:example.org:participant") |
| controller | [0..1] | The DID authorized to make changes to this DID Document. Where present it is typically the same value as `id` |
| verificationMethod | [1..*] | Array of verification methods containing public key material |
{: .grid}

**Verification Method Structure:**

Each verification method SHALL include:

| Element | Cardinality | Description |
|---------|-------------|-------------|
| id | [1..1] | Unique identifier for this verification method, expressed as a DID URL with a fragment (e.g., "did:web:example.org:participant#signing-key-1"). Trust frameworks commonly use the key identifier as the fragment |
| type | [1..1] | Cryptographic suite type (e.g., "JsonWebKey2020") |
| controller | [1..1] | DID that controls this verification method |
| publicKeyJwk | [1..1] | Public key in JWK format (RFC 7517), carrying the certificate chain in `x5c` (see [Carrying the Certificate Chain](#certificate-chains)) |
{: .grid}

<a name="certificate-chains"> </a>

**Carrying the Certificate Chain**

Key material SHALL be carried as a certificate chain in the `x5c` member of the `publicKeyJwk`, as defined by [RFC 7517 Section 4.7](https://datatracker.ietf.org/doc/html/rfc7517#section-4.7) and [RFC 7515 Section 4.1.6](https://datatracker.ietf.org/doc/html/rfc7515#section-4.1.6).

This applies to both paths by which key material is obtained. Where the material is issued by a Certificate Authority, `x5c` carries the issued certificate followed by each issuing certificate. Where the material is self-generated, `x5c` carries a **chain of one**: the submitter's self-signed certificate, which is simultaneously the leaf and the terminus of its own chain.

| Element | Cardinality | Description |
|---------|-------------|-------------|
| publicKeyJwk.kid | [1..1] | Key identifier. Where the trust framework derives the identifier from the certificate (for example, a truncated hash of the DER encoding), that derived value is used |
| publicKeyJwk.x5c | [1..1] | Certificate chain as an array of base64-encoded DER certificates (RFC 5280). The certificate containing the public key SHALL be the first entry, followed by each issuing certificate in order toward the certificate authority. Where the key material is self-generated the array contains a single self-signed certificate |
{: .grid}

The public key expressed in the JWK members (for example `crv`, `x`, `y`) SHALL be the same key as that certified by the first certificate in `x5c`.

The `x5c` chain is what conveys the *authority* for a key, as distinct from the key material itself. **The chain SHALL resolve back to a certificate that is verifiable against one of the public keys pre-shared with the trust network at the time of onboarding.** That pre-shared material is what makes the chain meaningful: without it, a chain establishes only that some certificate authority issued the certificate, not that it is an authority this trust network recognizes.

This profile constrains where the chain terminates. It does not constrain how the chain is validated: path construction, acceptable certificate authorities beyond the onboarded set, permitted algorithms and key strengths, validity periods, and how revocation status is obtained are defined by the governing trust framework.

<a name="key-metadata"> </a>

**Key Metadata (Recommended)**

Trust networks typically need to distinguish key material by the participating jurisdiction, the use case context in which it applies, and the intended key usage. Where the governing trust framework defines members for this purpose, submitters SHOULD populate them on each verification method and declare the defining context in `@context`.

Some trust networks define members such as the following. They are shown here as a worked example of how such metadata is expressed, not as a requirement of this profile:

| Member | Description |
|--------|-------------|
| domain | The trust domain the key applies within (e.g., a code identifying the use case and its governing specifications) |
| participant | The participating jurisdiction or organization the key belongs to |
| keyusage | The intended usage of the key (e.g., a document signer certificate as distinct from a signing certificate authority) |
{: .grid}

Trust frameworks that do not define such members MAY instead express intended usage through the DID Core verification relationships (`authentication`, `assertionMethod`, `keyAgreement`, `capabilityInvocation`, `capabilityDelegation`).

**Example DID Document:**

The following example carries Certificate Authority issued material. It illustrates a `did:web` identifier, a certificate chain in `x5c` (the Document Signer Certificate followed by its issuing Signing Certificate Authority), the recommended key metadata declared through a trust framework context, and a `proof` over the document. Certificate values are truncated for readability.

```json
{
   "@context":[
      "https://www.w3.org/ns/did/v1",
      "https://w3id.org/security/suites/jws-2020/v1",
      "https://trust-anchor.example.org/context/v1.jsonld"
   ],
   "id":"did:web:some.exampledomain.of.participant.int:customId",
   "controller":"did:web:some.exampledomain.of.participant.int:customId",
   "verificationMethod":[
      {
         "id":"did:web:some.exampledomain.of.participant.int:customId#XPjhL9Znd1M=",
         "type":"JsonWebKey2020",
         "controller":"did:web:some.exampledomain.of.participant.int:customId",
         "publicKeyJwk":{
            "kty":"EC",
            "kid":"XPjhL9Znd1M=",
            "x5c":[
               "MIICuTCCAmCgAwIBAgIUD9k1Q64Eav5r07DQ4Gff/7h7r6QwCgYIKoZIzj0EAwIwdDELMAkGA1UEBhMCWEExFDASBgNVBAgMC1hYQSBDb3VudHJ5...",
               "MIICMDCCAdWgAwIBAgIUFqWc0xbrcpAettDF8gEymTzDtSkwCgYIKoZIzj0EAwIwdDELMAkGA1UEBhMCWEExFDASBgNVBAgMC1hYQSBDb3VudHJ5..."
            ],
            "crv":"P-256",
            "x":"APdNVtZixJhhqsJS_yx--a_bLQaMMQj48CSb_3adr_MA",
            "y":"AOoV8O2w7rov_Txk3wwz_jMoKvx-IgSfYoyygtGetYEd"
         },
         "domain":{
            "code":"#DCC"
         },
         "participant":{
            "code":"#XA"
         },
         "keyusage":{
            "code":"#DSC"
         }
      }
   ],
   "proof":{
      "type":"JsonWebSignature2020",
      "created":"2026-07-06T06:00:12Z",
      "nonce":"m9t8CCfNotLiE9OCqhxQfYrWq0xwYQhf",
      "proofPurpose":"assertionMethod",
      "verificationMethod":"did:web:trust-anchor.example.org:v2:signing#trust-anchor-key-1",
      "jws":"eyJiNjQiOmZhbHNlLCJjcml0IjpbImI2NCJdLCJhbGciOiJFUzI1NiJ9..MEUCIQDVJHCENivQvdeQJcNFZoucpkrSK_ZlEvwcikhQRR7r8wIgfkaKfg8cYA6CUPbu2lJZEhEVGWpeMcYwDrdPBhPVinM"
   }
}
```

Reading the example:

- `id` and `controller` are the same `did:web` DID, so the document declares itself as the authority over its own content.
- The verification method fragment (`#XPjhL9Znd1M=`) matches the JWK `kid`, so a verifier that has extracted a key identifier from a signed artifact can dereference directly to the corresponding key.
- `x5c` carries two certificates: the Document Signer Certificate holding the public key, followed by the Signing Certificate Authority that issued it. A verifier validates this chain to a trust anchor before using the key.
- `domain`, `participant` and `keyusage` are defined by the trust framework context declared in `@context` — they are not DID Core members.
- The `proof` is a detached JWS (`"b64":false`) over the document, created by the key identified in `proof.verificationMethod` — a key the recipient obtained at onboarding.

**Where the key material is self-generated**, the structure is unchanged: `x5c` carries a chain of one — the submitter's self-signed certificate — and that certificate is the material pre-shared with the trust network at onboarding.

**Submission Pathways**

This profile does not define an API for submission. The pathway by which the DID Document reaches the {{ linkta }} is determined by the implementing jurisdiction, and the submission SHALL be conducted over a secure connection or an equivalently protected pathway.

The following pathways are informative examples of mechanisms in use:

- **Direct submission over a network connection**: The DID Document is transferred to an endpoint designated by the {{ linkta }} — for example, an HTTP POST to a jurisdiction-defined endpoint, or an upload over a mutually authenticated connection with the submission itself signed by the submitting organization.

- **Indirect Publication**: The DID Document is published at a well-known URL under the control of the submitting organization and the {{ linkta }} is notified of the location. Where the DID is a `did:web` DID, that URL is already determined by the DID itself.

- **Offline Submission**: The DID Document is submitted on secure physical media during a verified in-person encounter with formal identity attestation. Trust frameworks commonly use an out-of-band pathway of this kind for initial onboarding, before any network pathway is available to the participant.

Note that initial onboarding — establishing that an organization is entitled to participate at all — and subsequent operational publication of key material are distinct activities. Onboarding is governed by the trust framework and is out of scope for this profile; this transaction addresses the content published in the course of the latter.

Onboarding is nonetheless what anchors both directions of the trust relationship, and it establishes key material each way:

- the participant's own key material — typically the certificate of its Signing Certificate Authority — is pre-shared with the trust network, and is what certificate chains submitted through this transaction SHALL resolve back to (see [Carrying Certificate Authority Issued Material](#certificate-chains)); and
- the {{ linkta }}'s public key is shared with the participant, and is what the participant uses to verify the cryptographic proof on any trust list it later retrieves through [ITI-YY2 Retrieve Trust List with DID](ITI-YY2.html).

Neither key can be obtained over the channel it secures, so both are established through the verified, out-of-band process the trust framework defines for onboarding.

**Required Metadata**

Submissions SHOULD include sufficient **provenance metadata** to support validation by the {{ linkta }}:

- The asserted identity of the submitting entity
- The intended usage scope of the key(s) — see [Key Metadata](#key-metadata)
- The certificate chain — see [Carrying the Certificate Chain](#certificate-chains)
- An expiry date or revocation mechanism (if applicable)
- Digital signature or proof establishing the authenticity of the submission

##### 2:3.YY1.4.1.3 Expected Actions

**Trust Anchor (Receiver):**

{{ reqDistributePKIdescription.valueMarkdown }}

{% include requirements-list-statements.liquid req=reqDistributePKI site=site  %}

Upon receiving a DID Document submission, the {{ linkta }} SHALL:

1. **Validate DID Document Structure**: Verify the DID Document conforms to W3C DID Core specification
2. **Verify Cryptographic Material**: Validate that:
   - Public keys are properly formatted (JWK)
   - Key types and curves are acceptable per trust framework policy
   - Key sizes meet minimum security requirements
3. **Validate the Certificate Chain**: Validate the `x5c` chain:
   - Verify that the chain resolves back to a certificate that is verifiable against one of the public keys pre-shared with the trust network at the time of onboarding
   - Verify that the public key expressed in the JWK is the key certified by the first certificate in the chain
   - Verify that each certificate in the path is within its validity period and has not been revoked

   The onboarded key material is what makes this check conclusive: a chain that validates only to an arbitrary certificate authority establishes nothing about membership of this trust network. How the path is constructed, which algorithms and key strengths are permitted, and how revocation status is obtained are defined by the governing trust framework. Trust frameworks commonly distribute revocation status as certificate revocation lists (CRLs); some frameworks discourage the use of the Online Certificate Status Protocol (OCSP) because a status request reveals which certificate is being verified, and by whom, at the time of use.
4. **Verify Identity**: Authenticate the submitting entity's identity through:
   - secure connection
   - Verification of proof/signature on the DID Document
   - Validation against pre-registered organizational identifiers
   - Confirmation that the subject of the first certificate in `x5c` corresponds to the authenticated identity of the submitting participant, so that a participant cannot publish key material on behalf of another
5. **Catalog DID Document**: Store the validated DID Document in the Trust Anchor's registry
6. **Make Available for Retrieval**: Ensure the DID Document is accessible via the retrieval endpoint(s)

**Rejection Criteria**

The {{ linkta }} SHALL reject submissions that:
- Do not conform to W3C DID Core specification
- Contain invalid or malformed cryptographic material
- Cannot be authenticated to a known trust network participant
- Carry a certificate chain that cannot be validated to a certificate authority recognized by the governing trust framework
- Carry a certificate whose subject does not correspond to the authenticated submitting participant
- Omit `x5c`, or present a chain whose first certificate does not certify the public key expressed in the JWK
- Present self-generated key material where the governing trust framework requires Certificate Authority issued material
- Use prohibited cryptographic algorithms or insufficient key sizes
- Lack required metadata or provenance information

**Lifecycle**

The {{ linkta }} SHALL support mechanisms for updating or revoking DID Documents once cataloged, so that participants can retrieve current status via [ITI-YY2 Retrieve Trust List with DID](ITI-YY2.html).

#### 2:3.YY1.4.2 Submit PKI Material Response Message

##### 2:3.YY1.4.2.1 Trigger Events

The {{ linkta }} sends a Submit PKI Material Response Message upon completing the processing of a Submit PKI Material Request Message. A response SHALL be returned regardless of whether the submission succeeded or failed.

##### 2:3.YY1.4.2.2 Message Semantics

The response message format is determined by the implementing jurisdiction of the {{ linkta }}. The {{ linkta }} SHALL indicate, by whatever means its submission pathway provides, whether the submission was accepted and — where it was not — the reason for rejection in sufficient detail for the submitter to take corrective action.

The following are informative examples of how that indication is conveyed where the submission pathway is an HTTP request:

**Success Response:**

- HTTP 201 Created — submission accepted and validated

**Error Response:**

- HTTP 400 Bad Request: Malformed DID Document
- HTTP 401 Unauthorized: Authentication failed
- HTTP 403 Forbidden: Entity not authorized to submit
- HTTP 422 Unprocessable Entity: Valid format but validation failed — for example, a certificate chain that does not validate to a recognized certificate authority, or a certificate subject that does not correspond to the authenticated submitter

##### 2:3.YY1.4.2.3 Expected Actions

Upon receiving the response, the submitting actor ({{ linkvhls }} or {{ linkvhlr }}) SHALL:

1. **Handle Success**: On receipt of a success response, the submitting actor SHALL record that PKI material has been accepted by the {{ linkta }} and is available for distribution to trust network participants.
2. **Handle Errors**: On receipt of an error response, the submitting actor SHALL inspect the reason for rejection and take corrective action as appropriate:
   - For a malformed submission, correct the DID Document structure and resubmit
   - For an authentication or authorization failure, resolve that issue before retrying
   - For a validation failure, review the details and resubmit with corrected key material, certificate chain, or metadata
3. **Retain Private Keys**: Regardless of the response, the submitting actor SHALL continue to securely maintain the private key(s) corresponding to any submitted public key material.


### 2:3.YY1.5 Security Considerations 

The secure and verifiable exchange of PKI material via DID Documents is foundational to the operation of a Verified Health Link (VHL) trust network. Any compromise in the integrity, authenticity, or provenance of this material undermines the ability of network participants to verify digital signatures, authenticate service endpoints, or enforce trust relationships.

#### 2:3.YY1.5.1 DID Document Integrity

- DID Documents SHOULD be signed by the submitting entity using a verification method

#### 2:3.YY1.5.2 Key Material Security

- Submitting entities SHOULD securely store private keys with appropriate access controls
- Key material SHOULD meet minimum cryptographic strength requirements (e.g., EC P-256 or stronger)
- Where key material is Certificate Authority issued, the submitting entity does not generate the trust network signing key itself; the private key corresponding to the issued certificate is nonetheless held by the submitting entity and is subject to the same protection obligations
- Self-generated key material is carried as a self-signed certificate, and therefore has an explicit validity period and subject name. Submitting entities SHOULD plan for its expiry and replacement as they would for any other certificate
- Publishing a public key is not the same as conferring authority on it. Where the trust framework operates a certificate authority, authority derives from the certificate chain carried in `x5c` and not from the presence of the key in a DID Document

#### 2:3.YY1.5.3 Identity Verification

- Authentication mechanisms MAY include:
  - Secure connection with pre-registered certificates
  - Signed proof-of-control over the DID
  - Out-of-band identity verification for initial registration

#### 2:3.YY1.5.4 Revocation and Updates

- The {{ linkta }} MAY maintain a history of DID Document versions for audit purposes

Jurisdictions MAY define additional security controls, such as specific cryptographic algorithm requirements, certificate chaining policies, offline verification workflows, or restrictions on submission endpoints.
