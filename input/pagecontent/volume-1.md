{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}
{% assign linksubmitpki = '<a href="ITI-YY1.html">Submit PKI Material with DID</a>' %}
{% assign linkretrievepki = '<a href="ITI-YY2.html">Retrieve Trust List with DID</a>' %}
{% assign linkgeneratevhl = '<a href="ITI-YY3.html">Generate VHL</a>' %}
{% assign linkprovidevhl = '<a href="ITI-YY4.html">Provide VHL</a>' %}
{% assign linkretrievemanifest = '<a href="ITI-YY5.html">Retrieve Manifest</a>' %}

As individuals move within or across jurisdictional boundaries, they may wish to provide access to clinical or other health-related documents to a defined set of trusted parties who are authorized to access their records. This access may be granted for a single document or for a set of related documents.

The **Verifiable Health Links (VHL)** profile defines a set of protocols and patterns that enable health documents to be shared in a verifiable and auditable manner—both within and across jurisdictions. Central to this profile is the concept of the **VHL**, a signed artifact that an individual (the **VHL Holder**) can use to authorize access to their health records from an issuer (the {{ linkvhls }}) to a third party (the {{ linkvhlr }}). The mechanisms by which the VHL is held by the Holder or transmitted to the {{ linkvhlr }} are out of scope for this profile.

VHL leverages **Public Key Infrastructure (PKI)** to establish trust among actors and to verify the authenticity and integrity of exchanged artifacts.

Within the VHL trust model, both the {{ linkvhlr }} and the {{ linkvhls }} are participants in a shared **[trust network](other.html#ihe-technical-frameworks-general-introduction-appendix-d-glossary)**. This network enables:
- Verification of the origin of a health document,
- Validation of any access mechanism (i.e., the VHL itself),
- Authentication of requests that seek to utilize these mechanisms.
    
The authority to participate in the trust network is governed by each actor's **jurisdiction**, which determines eligibility and onboarding criteria. Verification of this authorization is achieved through PKI, specifically through the validation of credentials issued or endorsed by a **Trust Anchor** ({{ linkta }}).

Jurisdictions may also impose specific regulatory requirements on the privacy and security of health data exchange. These may include mandatory **consent verification**, **audit logging**, or other compliance controls that impact how VHL-based exchanges are implemented.

As members of a trust network, both the {{ linkvhlr }} and the {{ linkvhls }} are expected to submit and retrieve PKI material—typically as signed **Trust Lists**—from the {{ linkta }}. The precise onboarding and credential issuance processes used to establish trust with the {{ linkta }} are implementation-specific and beyond the scope of this profile.

> **Relationship to SMART® Health Links (SHL):**
>
> A VHL **adopts the SMART Health Links payload format** — the `url`, `key`, `flag`, `label`, `exp`, `v`, and `extension` fields defined in the [SMART Health Links specification](https://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html) — and reuses the SHL-defined manifest-request parameters (`recipient`, `passcode`, `embeddedLengthMax`). The **fundamental difference is the trust model**: VHL assumes a **pre-established trust relationship** between the {{ linkvhls }} and the {{ linkvhlr }}, verified via PKI material exchanged through Trust Lists, whereas SHL assumes **no prior trust** and conveys trust at presentation time via keys controlled by the SHL Sharer. See [Appendix A](vhl_vs_shl.html) for a side-by-side comparison.
>
> **Terminology used in this IG:**
> - **VHL payload** — a concrete instance populated by the {{ linkvhls }} and carried by a VHL (inside an HCERT/CWT QR code, or inside a signed Verifiable Credential under the VC Enveloped VHL Option). Instance-level references in this IG say "VHL payload".
> - **SHL payload format** / **SHL payload structure** — the schema (field names and shapes) that the VHL payload conforms to. Where this IG refers to the inherited schema itself, it uses "SHL payload format".
> - **SHL-defined manifest parameters** — `recipient`, `passcode`, `embeddedLengthMax`, etc., as defined by the SHL specification and reused here.
> - Actors in this IG are always the {{ linkvhlh }}, {{ linkvhls }}, and {{ linkvhlr }} — never "SHL Receiver" or "SHL Sharer" (those terms only appear in the comparison at Appendix A).

## Background Knowledge and Reading

This profile assumes the reader is familiar with the [IHE Technical Frameworks General Introduction](https://profiles.ihe.net/GeneralIntro/) and with [HL7 FHIR R4](http://hl7.org/fhir/R4/). Beyond that, VHL builds on the concepts below. Readers new to any of them should consult the referenced specification before reading Volume 2.

| Topic | Why it matters in VHL | Reference |
| ----- | --------------------- | --------- |
| **SMART Health Links (SHL)** | A patient-mediated sharing pattern in which a link — typically carried in a QR code — points to a manifest of health documents. VHL adopts the SHL payload format and manifest-request parameters, but replaces the SHL trust model with one anchored in PKI. | [SMART Health Links specification](https://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html); [Appendix A: Comparison of VHL and SHL](vhl_vs_shl.html) |
| **Public Key Infrastructure (PKI)** | The system of key pairs, X.509 certificates, certification authorities, and revocation lists used to bind a public key to an organization. VHL uses PKI to decide whether a {{ linkvhls }} or {{ linkvhlr }} is an authorized participant in the trust network. | [RFC 5280](https://datatracker.ietf.org/doc/html/rfc5280) — X.509 Certificate and CRL Profile |
| **Digital Signatures** | A signature computed with a private key that lets a relying party verify the origin and integrity of an artifact. VHL requires signature verification on the VHL itself, and offers signature verification on retrieved documents through the Verify Document Signature Option. | [RFC 7515](https://datatracker.ietf.org/doc/html/rfc7515) — JSON Web Signature (JWS); [IHE Document Digital Signature (DSG)](https://profiles.ihe.net/ITI/DSG/) |
| **Trust Anchors and Trust Lists** | A trust anchor is a root key or certificate that a relying party accepts as authoritative; a trust list is the signed, published set of PKI material for a community. The {{ linkta }} publishes trust lists that VHL participants retrieve and use to validate one another. | [Trust Network glossary entry](other.html#ihe-technical-frameworks-general-introduction-appendix-d-glossary); [Retrieve Trust List with DID [ITI-YY2]](ITI-YY2.html) |
| **Decentralized Identifiers (DID)** | A globally resolvable identifier that resolves to a DID Document containing verification methods (public keys) and service endpoints, without depending on a central registry. VHL uses DIDs to locate and publish trust list material, and requires support for the `did:web` method, in which a DID resolves deterministically to an HTTPS URL. | [W3C Decentralized Identifiers (DIDs) v1.0](https://www.w3.org/TR/did-core/); [did:web Method Specification](https://w3c-ccg.github.io/did-method-web/); [Submit PKI Material with DID [ITI-YY1]](ITI-YY1.html) |
| **Verifiable Credentials (VC)** | A tamper-evident credential with a `credentialSubject` and an embedded cryptographic proof. VHL uses VCs in two distinct places: a self-issued VC that authenticates a manifest request (Verifiable Credential Option), and a VC that envelopes the VHL payload itself (VC Enveloped VHL Option). | [W3C Verifiable Credentials Data Model v2](https://www.w3.org/TR/vc-data-model-2.0/); [W3C Verifiable Credential Data Integrity 1.0](https://www.w3.org/TR/vc-data-integrity/) |
| **CBOR Web Token (CWT) and COSE** | The binary, CBOR-based counterparts to JWT and JWS. Their compactness is what allows a signed VHL payload to fit inside a QR code. | [RFC 8392](https://datatracker.ietf.org/doc/html/rfc8392) — CBOR Web Token; [RFC 8152](https://datatracker.ietf.org/doc/html/rfc8152) — CBOR Object Signing and Encryption |
| **Health Certificate (HCERT)** | The WHO SMART Trust CWT claim structure for carrying health content in a signed, QR-encodable certificate. VHL uses HCERT as one of the carriers for the VHL payload. | [WHO SMART Trust HCERT specification](https://smart.who.int/trust/hcert_spec.html) |
{:.grid}

<a name="actors-and-transactions"> </a>

## 1:XX.1 Actors, Transactions, and Content Modules

This section defines the actors, transactions, and/or content modules in this profile. Further information about actor and transaction definitions can be found in the IHE Technical Frameworks General Introduction [Appendix A: Actors](https://profiles.ihe.net/GeneralIntro/ch-A.html) and [Appendix B: Transactions](https://profiles.ihe.net/GeneralIntro/ch-B.html).

<ul>
  <li>
    Actors
	{% include actordefinition-list.liquid site=site %}
  </li>
  <li>
    Transactions
    <ul>
		<li> {{ linksubmitpki }}</li>
		<li> {{ linkretrievepki }}</li>
		<li> {{ linkgeneratevhl }} </li>
		<li> {{ linkprovidevhl }}</li>
		<li> {{ linkretrievemanifest }}</li>
	</ul>
  </li>
</ul>

As a pre-condition to transactions ITI-YY4 and ITI-YY5, the {{ linkvhlr }} and {{ linkvhls }} SHALL have established trust relationships enabling mutual authentication and VHL signature verification.

This trust MAY be established through:
- Implementation of the optional Submit PKI Material with DID [ITI-YY1] and Retrieve Trust List with DID [ITI-YY2] transactions, OR
- Alternative jurisdiction-specific PKI exchange mechanisms (out of scope for this profile)

This is illustrated in Figure 1:XX.1-1.

<figure >
  <div style="width:35em; max-width:100%;">
  {%include trust_interaction.svg%}
  </div>
  <p id="f1:XX.1-1" class="figureTitle">Figure 1:XX.1-1
  : Trust Network PKI Exchange</p>
</figure>

The process of a VHL Holder requesting a VHL for a set of health documents from a {{ linkvhls }} and subsequently sharing them to a {{ linkvhlr }} is illustrated in Figure X.X.X.X-2.

<figure >
  <div style="width:18em; max-width:100%;">
  {%include vhl_interaction.svg%}
  </div>
  <p id="f1:XX.1-2" class="figureTitle" >Figure 1:XX.1-2: VHL Generation, Provision, and Document Retrieval Flow</p>
</figure>

<br clear="all">

<p id ="tXX.1-1" class="tableTitle">Table XX.1-1: VHL Profile - Actors and Transactions</p>

| Actors         | Transactions                 | Initiator or Responder | Optionality| Reference                 |
|----------------|------------------------------|------------------------|------------|---------------------------|
| {{ linkta }}   | {{ linksubmitpki }}          | Responder              | R          | ITI TF-2: 3.YY1 |
|                | {{ linkretrievepki }}        | Responder              | R          | ITI TF-2: 3.YY2 |
| {{ linkvhlh }} | {{ linkgeneratevhl }}        | Initiator              | R          | ITI TF-2: 3.YY3 |
|                | {{ linkprovidevhl }}         | Initiator              | R          | ITI TF-2: 3.YY4 |
| {{ linkvhlr }} | {{ linksubmitpki }}          | Initiator              | O          | ITI TF-2: 3.YY1 |
|                | {{ linkretrievepki }}        | Initiator              | O          | ITI TF-2: 3.YY2 |
|                | {{ linkprovidevhl }}         | Responder              | R          | ITI TF-2: 3.YY4 |
|                | {{ linkretrievemanifest }}   | Initiator              | R          | ITI TF-2: 3.YY5 |
| {{ linkvhls }} | {{ linksubmitpki }}          | Initiator              | O          | ITI TF-2: 3.YY1 |
|                | {{ linkretrievepki }}        | Initiator              | O          | ITI TF-2: 3.YY2 |
|                | {{ linkgeneratevhl }}        | Responder              | R          | ITI TF-2: 3.YY3 |
|                | {{ linkretrievemanifest }}   | Responder              | R          | ITI TF-2: 3.YY5 |
{: .grid}


### 1:XX.1.1 Actors
The actors in this profile are described in more detail in the sections below.

{% assign canonicals = site.data.canonicals | where: 'type' , 'ActorDefinition' %}
{% for canonical in canonicals %}
   {% assign stub = canonical.type | append: "-" | append: canonical.id %}
   {% assign actordefinition = site.data[stub] %}
   {% include actordefinition-short-summary.liquid actordefinition=actordefinition site=site %}
{% endfor %}


### 1:XX.1.2 Transaction Descriptions

The transactions in this profile are summarized in the sections below.

#### 1:XX.1.2.1 Submit PKI Material with DID [ITI-YY1]

This transaction is used by a {{ linkvhlr }} or {{ linkvhls }} to submit PKI material to a {{ linkta }} using Decentralized Identifiers (DIDs). The submitted material is formatted as DID Documents containing public keys and associated metadata for validation and inclusion in the Trust List.

Key material may be self-generated or issued by a Certificate Authority. Where the participant is enrolled under a Signing Certificate Authority it does not generate its own trust network signing key. In either case the key material is carried within the DID Document as a certificate chain — the issued certificate and its issuers, or, where self-generated, a single self-signed certificate. The transaction constrains the content of the DID Document; the mechanism by which that content reaches the {{ linkta }} is determined by the implementing jurisdiction.

**Transaction Optionality:**

This transaction is:
- **REQUIRED (R)** for Trust Anchor actors
- **OPTIONAL (O)** for VHL Sharer and VHL Receiver actors


**Alternative Implementations:**

Actors that do not implement this transaction SHALL establish trust relationships through jurisdiction-specific mechanisms that are out of scope for this profile.

For more details see the detailed [transaction description](ITI-YY1.html)

This transaction is captured as the following requirements:
- [Initiate Submit PKI Material Request](Requirements-InitiateSubmitPKIMaterialRequest.html)
- [Respond to Submit PKI Material Request](Requirements-RespondtoSubmitPKIMaterialRequest.html)

#### 1:XX.1.2.2 Retrieve Trust List with DID [ITI-YY2]

This transaction is used by a {{ linkvhlr }} or {{ linkvhls }} to retrieve a Trust List from a {{ linkta }} containing DID Documents with PKI material. The retrieved DID Documents include public keys and metadata necessary for verifying digital signatures and establishing trust relationships. Received key material should be distinguished by the participating jurisdiction, use case context, and key usage.

Retrieved key material is not trusted by virtue of appearing in the Trust List. The recipient verifies the cryptographic proof over the retrieved document and, where the key material is Certificate Authority issued, validates the accompanying certificate chain to a certificate authority recognized by the governing trust framework before the key is used.

**Transaction Optionality:**

This transaction is:
- **REQUIRED (R)** for Trust Anchor actors
- **OPTIONAL (O)** for VHL Sharer and VHL Receiver actors

**When to Implement:**

VHL Sharer and VHL Receiver actors SHALL implement this transaction when:
- They do not have jurisdiction-specific mechanisms to retrieve PKI material from the {{ linkta }}, OR
- They wish to demonstrate interoperability at IHE Connectathons

**Alternative Implementations:**

Actors that do not implement this transaction SHALL retrieve trust material through jurisdiction-specific mechanisms that are out of scope for this profile. Such implementations:
- Cannot participate in IHE Connectathon testing for trust material retrieval
- SHALL document their trust material retrieval mechanisms in their IHE Integration Statement
- Are responsible for obtaining current PKI material for VHL signature verification

For more details see the detailed [transaction description](ITI-YY2.html)

This transaction is captured as the following requirements:
- [Initiate Retrieve Trust List Request](Requirements-InitiateRetrieveTrustListRequest.html)
- [Respond to Retrieve Trust List Request](Requirements-RespondtoRetrieveTrustListRequest.html)

#### 1:XX.1.2.3 Generate VHL [ITI-YY3]

This transaction is used by a {{ linkvhlh }} to request that a {{ linkvhls }} generate a VHL. By default the VHL is carried as a QR code encoded as an HCERT/CWT structure; where the {{ linkvhls }} supports the VC Enveloped VHL Option it MAY instead be carried as a signed Verifiable Credential.

A {{ linkvhls }} MAY:
- Record consent of the individual
- Create audit trail of VHL creation
- Set passcode protection (P flag) with secure hash storage
- Set expiration time for time-limited access
- Set long-term flag (L) for ongoing access

For more details see the detailed [transaction description](ITI-YY3.html)

This transaction is captured as the following requirements:
- [Initiate VHL Generation Request](Requirements-InitiateVHLGenerationRequest.html)
- [Respond to VHL Generation Request](Requirements-RespondtoGenerateVHLRequest.html)

#### 1:XX.1.2.4 Provide VHL [ITI-YY4]

This transaction is initiated by a {{ linkvhlh }} to transmit a VHL to a {{ linkvhlr }} by displaying or providing a QR code for scanning. 

**QR Code Transmission:**

The {{ linkvhlh }} presents the VHL by:
- Displaying the QR code on their device screen for the {{ linkvhlr }} to scan, OR
- Providing a printed QR code generated during ITI-YY3

The {{ linkvhlr }} scans the QR code using a camera-equipped device and processes the HCERT-encoded VHL through a 9-step decoding process:

For more details see the detailed [transaction description](ITI-YY4.html)

This transaction is captured as the following requirements:
- [Provide VHL](Requirements-ProvideVHL.html)
- [Respond to Provide VHL](Requirements-RespondtoProvideVHL.html)

#### 1:XX.1.2.5 Retrieve Manifest [ITI-YY5]

This transaction is initiated by a {{ linkvhlr }} to retrieve a document manifest from a {{ linkvhls }} using a previously validated VHL as authorization. The transaction uses standard FHIR search on the List resource, following the same pattern as MHD ITI-66 Find Document Lists.

**Response:**

The {{ linkvhls }} returns a FHIR Bundle of type "searchset" containing:
- **List resource** with search.mode="match" - references available documents
- **DocumentReference resources** with search.mode="include" (if Include DocumentReference Option supported and `_include` parameter used)

If the {{ linkvhls }} supports the **Include DocumentReference Option**, it processes the `_include=List:item` parameter and returns both List and DocumentReference resources in a single response, reducing network round trips.

If the {{ linkvhls }} does NOT support this option, it ignores the `_include` parameter and returns only the List resource. The {{ linkvhlr }} then retrieves individual DocumentReference resources using separate read requests.

**Capability Statements:**

Client and server requirements are defined in:
- [VHL Receiver Client Capability Statement](CapabilityStatement-VHLReceiverCapabilityStatement.html)
- [VHL Sharer Server Capability Statement](CapabilityStatement-VHLSharerCapabilityStatement.html)

For more details see the detailed [transaction description](ITI-YY5.html)

This transaction is captured as the following requirements:
- [Request VHL Documents](Requirements-RequestVHLDocuments.html)

<a name="actor-options"> </a>

## 1:XX.2  Actor Options

Options that may be selected for each actor in this implementation guide are listed in Table XX.2-1 below. Dependencies between options when applicable are specified in notes.

<p id ="tXX.2-1" class="tableTitle">Table XX.2-1: Actor Options</p>

| Actor          | Option Name                          |
|----------------|--------------------------------------|
| {{ linkvhlr }} | Sign Manifest Request                |
| ^              | Include DocumentReference            |
| ^              | Verify Document Signature            |
| ^              | OAuth with SSRAA                     |
| ^              | Verifiable Credential                |
| {{ linkvhls }} | Include DocumentReference            |
| ^              | Sign Manifest Request                |
| ^              | OAuth with SSRAA                     |
| ^              | Verifiable Credential                |
| ^              | VC Enveloped VHL                     |
{: .grid}


### 1:XX.2.1 Sign Manifest Request Option (VHL Receiver)

The Sign Manifest Request Option enables the {{ linkvhlr }} to digitally sign manifest requests sent to the {{ linkvhls }} and enables the {{ linkvhls }} to verify digital signatures on manifest requests from the {{ linkvhlr }}.

This option provides:
- Authentication of the VHL Receiver by the VHL Sharer
- Non-repudiation of manifest requests
- Protection against request forgery
- Enhanced audit trail

**Complementary Option:** This option is designed to work with the Sign Manifest Request Option (VHL Sharer). If a {{ linkvhlr }} signs requests, the {{ linkvhls }} should support signature verification.

See ITI-YY5 Section [2:3.YY5.4.1.3 Authentication Option - HTTP Message Signatures](ITI-YY5.html#23yy5413-authentication-option---http-message-signatures) for detailed signature format.

### 1:XX.2.2 Include DocumentReference Option (VHL Sharer)

The Include DocumentReference Option enables the {{ linkvhls }} to process the `_include=List:item` parameter in manifest requests and return DocumentReference resources along with the List resource in a single response.

**Benefits:**
- Reduces network round trips for VHL Receiver
- Improves performance for document discovery
- Simplifies workflow for retrieving document metadata

**Implementation Note:** When generating VHLs in ITI-YY3, VHL Sharers supporting this option SHOULD include `_include=List:item` in the manifest URL. VHL Sharers not supporting this option SHOULD NOT include the `_include` parameter in the manifest URL.

See ITI-YY5 Section [2:3.YY5.4.2.2 Message Semantics](ITI-YY5.html#23yy5422-message-semantics) and [2:3.YY5.4.1.7 Expected Actions - VHL Sharer](ITI-YY5.html#23yy5417-expected-actions---vhl-sharer) for detailed behavior.

### 1:XX.2.3 Verify Document Signature Option (VHL Receiver)

In this option the {{ linkvhlr }}, after receipt of a digitally signed document from a {{ linkvhls }}, shall verify the digital signature using previously retrieved PKI material. This key material may or may not be distributed under the same trust network under which the VHL was distributed. This key material may or may not be the same key material that was used to verify the VHL.

See cross-profile considerations for a discussion of the relationship of this option to the IHE Document Signature profile.

This option is captured in the following business requirement:
- [Verify Document Signature](Requirements-VerifyDocumentSignature.html)

### 1:XX.2.4 OAuth with SSRAA Option

The OAuth with SSRAA Option enables the {{ linkvhlr }} and {{ linkvhls }} to use OAuth 2.0 access tokens for authentication during the ITI-YY5 Retrieve Manifest transaction, as an alternative to HTTP Message Signatures. This option provides interoperability with systems implementing the [HL7 Security for Scalable Registration, Authentication, and Authorization IG](http://hl7.org/fhir/us/udap-security/) (SSRAA).


**Complementary Option:** Both the {{ linkvhlr }} and {{ linkvhls }} SHALL support this option for OAuth-based authentication to be used. If only one actor supports this option, HTTP Message Signatures or other authentication mechanisms defined in ITI-YY5 SHALL be used instead.

See ITI-YY5 Section 2:3.YY5.4.1.4 for detailed OAuth flow and examples.

### 1:XX.2.5 Verifiable Credential Option

The Verifiable Credential Option enables the {{ linkvhlr }} to self-issue a JSON-LD Verifiable Credential (LDP-VC) per the [W3C Verifiable Credentials Data Model v2](https://www.w3.org/TR/vc-data-model-2.0/) when sending a manifest request in the ITI-YY5 Retrieve Manifest transaction. The VC's `credentialSubject` is the manifest decoded from the QR code, and the VC contains an embedded **DataIntegrityProof** signed with the {{ linkvhlr }}'s key from the trust network.

This option provides:
- Authentication of the {{ linkvhlr }} to the {{ linkvhls }} using a trust network key, without requiring a prior OAuth registration flow
- Cryptographic proof of QR code possession — the manifest content is embedded in the VC `credentialSubject`, binding the request to the specific VHL decoded by the receiver
- Non-repudiation of manifest requests
- An alternative authentication path suitable for deployments that prefer credential-based identity over token-based flows (e.g., those with unlinkability requirements or no central authorization server)

**How It Works:**

When the {{ linkvhlr }} decodes the QR code (ITI-YY4), it extracts the VHL payload containing the manifest URL and metadata. The {{ linkvhlr }} constructs a self-issued LDP-VC in which:
- The `credentialSubject` contains the manifest metadata from the VHL payload (excluding the encryption key), with `id` set to the manifest URL; the SHL-defined manifest parameters (`recipient`, `passcode`, `embeddedLengthMax`) are also included in `credentialSubject`
- An embedded **`proof`** element of type `DataIntegrityProof` is included with a `verificationMethod` resolving to the {{ linkvhlr }}'s key in the trust network, `proofPurpose` = `assertionMethod`, and a `proofValue` signature over the VC document — this is the cryptographic proof of the receiver's identity

The VC (with embedded proof) is sent directly as the HTTP POST body (`Content-Type: application/vc`), with the FHIR search parameters carried inside the credential at `credentialSubject.id`. No additional HTTP-level signing is required. The {{ linkvhls }} verifies the `proof.proofValue` using the {{ linkvhlr }}'s public key from the trust network before processing the request.

**Complementary Option:** Both the {{ linkvhlr }} and {{ linkvhls }} SHALL support this option for VC-based authentication to be used.

See ITI-YY5 Section 2:3.YY5.4.1.5 for detailed VC construction, request format, and verification process.

### 1:XX.2.6 VC Enveloped VHL Option (VHL Sharer)

The VC Enveloped VHL Option enables the {{ linkvhls }} to return the VHL as a signed W3C Verifiable Credential (`application/vc`) instead of a QR code in the ITI-YY3 Generate VHL transaction. The VC is subsequently transmitted to the {{ linkvhlr }} via ITI-YY4 Provide VHL as an alternative carrier to the HCERT/CWT QR code.

This option provides:
- An alternative carrier for the VHL payload, suitable for machine-to-machine transfer and asynchronous delivery where QR presentation is impractical
- A JSON-LD representation compatible with VC-aware ecosystems
- Reuse of the existing trust network — the VC's `DataIntegrityProof` chains to the same trust anchors used for HCERT/CWT verification (no new trust framework introduced)

**How It Works:**

When the caller of `$generate-vhl` sets `format=vc` and the {{ linkvhls }} supports this option, the {{ linkvhls }} returns the VHL as the `credentialSubject.id` of a VC issued per the [W3C Verifiable Credentials Data Model v2](https://www.w3.org/TR/vc-data-model-2.0/), with an embedded `DataIntegrityProof` signed by the {{ linkvhls }} using its trust-network key. The value carried is the `vhlink:` URI that the QR carrier embeds at HCERT claim key 5, so both carriers convey byte-identical payloads. If the option is not supported and `format=vc` is requested, the {{ linkvhls }} SHALL return an OperationOutcome error.

**Naming Note:** This option (a Sharer option carrying the VHL) is distinct from the **Verifiable Credential Option** (a Receiver authentication option at ITI-YY5 where the Receiver self-issues a VC as the manifest request body).

See ITI-YY3 Section [2:3.YY3.4.1.2.1 Output Carrier Options](ITI-YY3.html#output-carrier-options) for VC construction, ITI-YY4 Section [2:3.YY4.4.1.2 Message Semantics](ITI-YY4.html#23yy4412-message-semantics) for transmission, and ITI-YY4 Section [2:3.YY4.4.1.4 Expected Actions - VHL Receiver](ITI-YY4.html#23yy4414-expected-actions---vhl-receiver) for decoding.

<a name="required-groupings"> </a>

## 1:XX.3 Required Actor Groupings

The following actor groupings are required for secure operations within the VHL trust network:

<p id ="tXX.3-1" class="tableTitle">Table XX.3-1: VHL Profile - Required Actor Groupings</p>

| VHL Actor | Grouping Condition | Actor(s) to be grouped with | Reference |
|-----------|--------------------|-----------------------------|-----------|
| {{ linkvhlr }} | Required for ITI-YY5 | ITI ATNA / Secure Node or Secure Application | ITI TF-1: 9.1 |
| {{ linkvhls }} | Required for ITI-YY5 | ITI ATNA / Secure Node or Secure Application | ITI TF-1: 9.1 |
| {{ linkvhls }} | Required for serving document binaries referenced from `DocumentReference.content.attachment.url` | ITI MHD / Document Responder ([ITI-68](https://profiles.ihe.net/ITI/MHD/ITI-68.html)) | ITI TF-2: 3.68 |
| {{ linkvhlr }} | Required for retrieving document binaries referenced from `DocumentReference.content.attachment.url` | ITI MHD / Document Consumer ([ITI-68](https://profiles.ihe.net/ITI/MHD/ITI-68.html)) | ITI TF-2: 3.68 |
| {{ linkta }} | -- | None | -- |
| {{ linkvhlh }} | -- | None | -- |
{: .grid}

Note: The {{ linkvhlr }} and {{ linkvhls }} SHALL be grouped with ATNA Secure Node or Secure Application to support the secure channel requirements of the ITI-YY5 Retrieve Manifest transaction.

Note: The {{ linkvhls }} SHALL be grouped with an MHD Document Responder so that the binary referenced from `DocumentReference.content.attachment.url` can be retrieved via [ITI-68 Retrieve Document](https://profiles.ihe.net/ITI/MHD/ITI-68.html). The {{ linkvhlr }} SHALL be grouped with an MHD Document Consumer to perform that retrieval. Document binaries are encrypted as JWE per RFC 7516/7518 using the `key` from the VHL payload decoded by the {{ linkvhlr }} in ITI-YY4; specific JWE algorithms are selected per [Cryptographic Algorithm Selection](#1xx53-cryptographic-algorithm-selection).

<a name="overview"> </a>

## 1:XX.4 Overview

This section shows how the transactions/content modules of the profile are combined to address the use cases.

### 1:XX.4.1 Concepts

A **Verifiable Health Link (VHL)** is a mechanism that enables individuals to share access to health documents in a secure, auditable, and configurable manner. Sharing options may include **limited-time access**, **PIN-protected retrieval**, or **ongoing access** to a longitudinal dataset that may evolve over time. VHLs can be rendered as QR codes or downloaded to a user’s device, supporting patient-mediated data sharing and enhancing interoperability across healthcare systems.

#### 1:XX.4.2 Use Cases

<style>.usecase-purpose img { max-width: 100%; height: auto; }</style>

#### 1:XX.4.2.1 Use Case \#1: WHO Global Digital Health Certification Network

{% assign UseCaseGDHCN = site.data.ExampleScenario-UseCaseGDHCN %}

<div class="usecase-purpose">{{ UseCaseGDHCN.purpose | markdownify }}</div>

This use case has the following business requirements:
- [Establish Trust](Requirements-EstablishTrust.html)
- [Initiate Submit PKI Material Request](Requirements-InitiateSubmitPKIMaterialRequest.html)
- [Initiate Retrieve Trust List Request](Requirements-InitiateRetrieveTrustListRequest.html)

##### 1:XX.4.2.1.1 Hajj Pilgrimage Use Case Description
{% assign useCaseHajjPilgrimage = site.data.ExampleScenario-UseCaseHajjPilgrimage %}

<div class="usecase-purpose">{{ useCaseHajjPilgrimage.purpose | markdownify }}</div>

This use case has the following business requirement:
- [Establish Trust](Requirements-EstablishTrust.html)
- [Create Secure Channel](Requirements-CreateSecureChannel.html)

##### 1:XX.4.2.1.2 Pan-American Highway for Health Use Case Description

{% assign UseCasePH4H = site.data.ExampleScenario-UseCasePH4H %}

<div class="usecase-purpose">{{ UseCasePH4H.purpose | markdownify }}</div>

This use case has the following business requirement:
- [Establish Trust](Requirements-EstablishTrust.html)

#### 1:XX.4.2.2 Use Case #2: EU Vaccination Card

{% assign UseCaseEVAC = site.data.ExampleScenario-UseCaseEVAC %}

<div class="usecase-purpose">{{ UseCaseEVAC.purpose | markdownify }}</div>

This use case has the following business requirement:
- [Record Access To Health Data](Requirements-RecordAccessToHealthData.html)

#### 1:XX.4.2.3 Use Case \#3: US Trusted Exchange Framework and Common Agreement (TEFCA)

{% assign UseCaseTEFCA = site.data.ExampleScenario-UseCaseTEFCA %}

<div class="usecase-purpose">{{ UseCaseTEFCA.purpose | markdownify }}</div>

This use case has the following business requirements:
- [Establish Trust](Requirements-EstablishTrust.html)
- [Create Secure Channel](Requirements-CreateSecureChannel.html)
- [Request VHL Documents](Requirements-RequestVHLDocuments.html)

<a name = "security-considerations"></a>
## 1:XX.5 Security Considerations

VHL is a building block that is meant to be used together with added security measures, otherwise it is not suitable for exchange in environments where security and provenance cannot be reliably established by other means.

Key security considerations include:

### 1:XX.5.1 Trust Network Security

- All participants ({{ linkvhlr }}, {{ linkvhls }}) SHALL establish trust via the {{ linkta }}. ITI-YY1 (Submit PKI Material) and ITI-YY2 (Retrieve Trust List) transactions MAY be used to support this trust establishment.
- Certificates and keys should be regularly updated and revocation status checked.
- Onboarding establishes key material in both directions: the participant's own certificate authority material is pre-shared with the trust network, and the {{ linkta }}'s public key is shared with the participant. Neither can be obtained over the channel it secures, so both are established through the verified, out-of-band process the trust framework defines.
- A public key SHALL NOT be treated as trusted merely because it appears in a retrieved trust list. Where the governing trust framework operates a certificate authority, authority for a key derives from its certificate chain, and that chain SHALL resolve back to a certificate verifiable against one of the public keys pre-shared with the trust network at onboarding. How the path is constructed, which algorithms and key strengths are permitted, and how revocation status is obtained are defined by the trust framework.
- Trust lists are commonly published as static, cacheable documents. Recipients should verify the cryptographic proof over a retrieved trust list against the {{ linkta }} key established at onboarding, check its freshness, and not accept a trust list older than one already held, so that withdrawn key material cannot be reinstated by serving an earlier validly signed version.

### 1:XX.5.2 Secure Channel Requirements

- ITI-YY5 (Retrieve Manifest) SHALL be conducted over a secure channel as defined by ATNA Authenticate Node [ITI-19].

### 1:XX.5.3 Cryptographic Algorithm Selection

The transactions in this profile (ITI-YY1 through ITI-YY5) rely on cryptographic primitives for digital signatures, message authentication, and content encryption. This IG does not mandate a single algorithm suite for deployment. Implementers select algorithms consistent with the underlying specifications — for example, RFC 9421 (HTTP Message Signatures), RFC 7515/7516/7518 (JWS/JWE/JWA), RFC 8152 (COSE), W3C Data Integrity (Verifiable Credentials), the HL7 SSRAA IG (OAuth with SSRAA Option), and the WHO SMART Trust specification (HCERT). The preceding list is illustrative, not exhaustive.

**Interoperability baseline:** For the purpose of interoperability testing, implementations SHALL support **ECDSA using curve P-256 and SHA-256** as a common baseline across signature operations. This is `ES256` in the JOSE and COSE registries and `ecdsa-p256-sha256` in the HTTP Message Signatures registry. A single baseline is possible because this algorithm is expressible in every signature container this profile uses — JWS/JWT, COSE, HTTP Message Signatures, and the W3C Data Integrity ECDSA cryptosuites — and because it is the algorithm the trust networks this profile targets already distribute.

This baseline ensures that two independent conformant implementations can always interoperate during testing. It does not preclude support for — or preferred deployment use of — other algorithms (other ECDSA curves, EdDSA, RSA-PSS, or future post-quantum algorithms).

Where an underlying specification sets its own algorithm requirements, those requirements govern:

| Signature operation | Governed by |
|---------------------|-------------|
| HCERT/CWT signature on the VHL ([ITI-YY3](ITI-YY3.html), [ITI-YY4](ITI-YY4.html)) | [WHO SMART Trust HCERT specification](https://smart.who.int/trust/hcert_spec.html), which defines a primary and a secondary algorithm and requires both to be implemented |
| JWT client assertions and access tokens under the OAuth with SSRAA Option ([ITI-YY5](ITI-YY5.html)) | the [HL7 Security for Scalable Registration, Authentication, and Authorization IG](http://hl7.org/fhir/us/udap-security/), which operates on its own X.509 credentials rather than on trust network key material |
| `DataIntegrityProof` on Verifiable Credentials | the declared `cryptosuite`, which determines both the canonicalization and the signature algorithm |
{: .grid}

Note that a signature algorithm is constrained by the key it is made with: a participant whose trust network key material is an elliptic-curve key cannot produce an RSA signature with it. Implementers selecting algorithms for operations that use trust network keys should begin from the key types their trust framework issues.

**Deployment considerations:** Implementers SHOULD take into account additional considerations beyond the interoperability baseline when selecting algorithms for production deployments, including but not limited to:
- **Jurisdictional policies and regulatory requirements** (e.g., national cryptographic agency guidance, healthcare-sector rules, data-protection law);
- **Post-quantum / quantum-safe cryptography** as standards mature (e.g., NIST PQC) and migration guidance evolves;
- **Evolving industry guidance** on algorithm deprecation, minimum key strengths, and cryptosuite lifecycle (e.g., updates from IETF, W3C, NIST, ENISA).

Algorithms named in examples, tables, and code blocks throughout this IG are illustrative. Except for the interoperability baseline stated above, and for the requirements of the underlying specifications listed above, they do not constrain deployment choices. Jurisdictions and trust networks MAY define additional profiles (permitted algorithm lists, minimum key lengths, deprecation schedules) consistent with this guidance.

### 1:XX.5.4 VHL Integrity and Authorization

- VHL signatures SHALL be verified before trusting VHL content.
- VHL expiration timestamps should be enforced.
- Passcodes (if used) should be communicated out-of-band and validated server-side.
- VHL Sharers should implement rate limiting and account lockout for failed passcode attempts.

### 1:XX.5.5 Audit Requirements

- The European Health Data Space (EHDS) requires detailed audit information on data access.
- Provisions 8f) and 12a) outline requirements for auditability of data access.
- VHL Sharers and VHL Receivers should record audit events documenting:
  - VHL generation requests
  - VHL provision events
  - Document retrieval attempts
  - Authentication/authorization failures

### 1:XX.5.6 Privacy Considerations

- VHL payloads do not contain clinical content - only a reference to a document folder. They do carry the patient business identifier supplied at generation time and a free-text label, both of which are readable by anyone holding the VHL; see [ITI-YY5 Privacy of Request Metadata](ITI-YY5.html#23yy556-privacy-of-request-metadata).
- Actual health data is transmitted over secure channels (ITI-YY5).
- Consent may be recorded during VHL generation (Record Consent option).
- VHL Holders retain the right to revoke access where supported.

<a name="other-grouping"> </a>
## 1:XX.6 Cross-Profile Considerations

This section is informative, not normative. It is intended to put this profile in context with other profiles. Any required groupings should have already been described above.

<a name="atna-cross-profile"> </a>
### 1:XX.6.1 ATNA - Audit Trail and Node Authentication

The {{ linkvhlr }} and {{ linkvhls }} SHALL be grouped with ATNA Secure Node or Secure Application actors to support the secure channel requirements of ITI-YY5. This grouping ensures:
- Mutual authentication via X.509 certificates or other ATNA-supported mechanisms
- Secure channel establishment per ATNA Authenticate Node [ITI-19]
- Audit logging capabilities for security events

<a name="pcf-cross-profile"> </a>
### 1:XX.6.2 PCF - Privacy Consent on FHIR

The [IHE Privacy Consent on FHIR (PCF)](https://profiles.ihe.net/ITI/PCF/) profile is the recommended companion for capturing, storing, and enforcing patient consent alongside VHL. When the {{ linkvhls }} implements the Record Consent option, it acts as a Consent Recorder and initiates Access Consent [ITI-108] transactions to record consent declarations by the {{ linkvhlh }}.

Recommended groupings:

- **{{ linkvhlh }} (or the Holder's client app)** MAY be grouped with a PCF **Consent Creator** so that the Holder authors a `Consent` resource when generating a VHL.
- **{{ linkvhls }}** MAY be grouped with a PCF **Consent Recipient** so that consents governing a generated folder are persisted and discoverable, and with a PCF **Policy Enforcement Point (PEP)** so that the set of documents returned at [ITI-YY5](ITI-YY5.html) is filtered by the active `Consent.provision` (actor, purpose, period, class, code).

The `$generate-vhl` operation (ITI-YY3) accepts an optional `purposeOfUse` input parameter bound (extensible) to the HL7 v3 [PurposeOfUse](http://terminology.hl7.org/ValueSet/v3-PurposeOfUse) value set. The {{ linkvhls }} persists this value against the generated folder. When the {{ linkvhls }} is grouped with a PCF Consent Creator or Consent Recipient, the value populates `Consent.provision.purpose` on any `Consent` created for or bound to the folder. At ITI-YY5, the {{ linkvhls }} MAY reject manifest requests whose purpose claim (carried by the chosen authentication option — OAuth token, UDAP assertion, or Verifiable Credential) is inconsistent with the purpose recorded at generation time.

### 1:XX.6.3 MHD - Mobile Health Document Sharing

ITI-YY5 (Retrieve Manifest) reuses the FHIR search machinery of [MHD ITI-66 Find Document Lists](https://profiles.ihe.net/ITI/MHD/ITI-66.html): the VHL manifest URL constructed at ITI-YY3 is a FHIR `List` search using the parameters the Document Responder is required to support per ITI-66, and the ITI-YY5 response is an ITI-66 `searchset` Bundle. Binary retrieval is delegated to [MHD ITI-68 Retrieve Document](https://profiles.ihe.net/ITI/MHD/ITI-68.html) per the required grouping in [Section XX.3 Required Actor Groupings](#required-groupings).

### 1:XX.6.4 mCSD - Mobile Care Services Discovery

The {{ linkta }} may store DID (Decentralized Identifier) as endpoints for Jurisdictions. The mCSD Profile supports querying for Endpoint(s) for Organizations.

### 1:XX.6.5 DSG/DSGj - Document Digital Signature

The Verify Document Signature option enables {{ linkvhlr }} to verify digital signatures on retrieved documents. This may use:
- DSG (Document Digital Signature) profile for XML-based documents
- DSGj (JSON Document Signature) profile for JSON-based documents

The key material used for document signature verification may or may not be the same as the key material used to verify the VHL itself, and may or may not be distributed under the same trust network.
