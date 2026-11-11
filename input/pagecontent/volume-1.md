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
- Verification of the origin and integrity of a VHL;
- Authentication and authorization of requests made by means of a VHL.
    
The authority to participate in the trust network is governed by each actor's **jurisdiction**, which determines eligibility and onboarding criteria. A participant's authorization is established through PKI, by validating its certificate chain against material established at onboarding and published by the **Trust Anchor** ({{ linkta }}).

Jurisdictions may also impose specific regulatory requirements on the privacy and security of health data exchange. These may include mandatory **consent verification**, **audit logging**, or other compliance controls that impact how VHL-based exchanges are implemented.

As members of a trust network, both the {{ linkvhlr }} and the {{ linkvhls }} publish their own PKI material to the {{ linkta }} and retrieve that of other participants from it, typically as a signed **Trust List**. The precise onboarding and credential issuance processes used to establish trust with the {{ linkta }} are implementation-specific and beyond the scope of this profile.

> **Relationship to SMART® Health Links (SHL):**
>
> A VHL **adopts the payload format and manifest-request parameters** defined in the [SMART Health Links specification](https://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html). The **fundamental difference is the trust model**: VHL assumes a **pre-established trust relationship** between the {{ linkvhls }} and the {{ linkvhlr }}, verified via PKI material exchanged through Trust Lists, whereas SHL assumes **no prior trust**, access following from possession of the link and the key it carries. See [Appendix A](vhl_vs_shl.html) for a side-by-side comparison.
>
> **Terminology used in this IG:**
> - **VHL payload** — a concrete instance populated by the {{ linkvhls }} and carried by a VHL (inside an HCERT/CWT QR code, or inside a signed Verifiable Credential under the VC Enveloped VHL Option). Instance-level references in this IG say "VHL payload".
> - **SHL payload format** / **SHL payload structure** — the schema (field names and shapes) that the VHL payload conforms to. Where this IG refers to the inherited schema itself, it uses "SHL payload format".
> - **SHL-defined manifest parameters** — `recipient`, `passcode`, `embeddedLengthMax`, etc., as defined by the SHL specification and reused here.
> - Actors in this IG are always the {{ linkvhlh }}, {{ linkvhls }}, and {{ linkvhlr }} — never "SHL Receiver" or "SHL Sharer" (those terms only appear in the comparison at Appendix A).

## Background Knowledge and Reading

This profile assumes the reader is familiar with the [IHE Technical Frameworks General Introduction](https://profiles.ihe.net/GeneralIntro/) and with [HL7 FHIR R4](http://hl7.org/fhir/R4/). VHL builds on the specifications below, and readers new to any of them should consult it before reading the transaction definitions.

- **SMART Health Links Specification**: [SMART Health Links](https://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html) — the payload format and manifest-request parameters VHL adopts; see also [Appendix A: Comparison of VHL and SHL](vhl_vs_shl.html) and the [SHL encryption convention](https://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html#encrypting-and-decrypting-files)
- **IHE MHD**: [Mobile Health Document Sharing](https://profiles.ihe.net/ITI/MHD/) — [ITI-66 Find Document Lists](https://profiles.ihe.net/ITI/MHD/ITI-66.html) and [ITI-68 Retrieve Document](https://profiles.ihe.net/ITI/MHD/ITI-68.html)
- **IHE DSG**: [Document Digital Signature](https://profiles.ihe.net/ITI/DSGj/Volume1/ch-37.html)
- **IHE Technical Frameworks General Introduction Appendix D**: [Glossary](other.html#ihe-technical-frameworks-general-introduction-appendix-d-glossary) — Trust Anchor, Trust Network, and related terms
- **RFC 5280**: [Internet X.509 Public Key Infrastructure Certificate and CRL Profile](https://datatracker.ietf.org/doc/html/rfc5280)
- **RFC 7515**: [JSON Web Signature (JWS)](https://datatracker.ietf.org/doc/html/rfc7515)
- **RFC 7516**: [JSON Web Encryption (JWE)](https://datatracker.ietf.org/doc/html/rfc7516)
- **RFC 7517**: [JSON Web Key (JWK)](https://datatracker.ietf.org/doc/html/rfc7517)
- **RFC 8392**: [CBOR Web Token (CWT)](https://datatracker.ietf.org/doc/html/rfc8392)
- **RFC 8152**: [CBOR Object Signing and Encryption (COSE)](https://datatracker.ietf.org/doc/html/rfc8152)
- **W3C DID Core 1.0**: [Decentralized Identifiers (DIDs) v1.0](https://www.w3.org/TR/did-core/)
- **W3C DID Method: Web**: [did:web Method Specification](https://w3c-ccg.github.io/did-method-web/) — the method this profile requires support for
- **W3C VC Data Model v2**: [Verifiable Credentials Data Model v2](https://www.w3.org/TR/vc-data-model-2.0/)
- **W3C Data Integrity**: [Verifiable Credential Data Integrity 1.0](https://www.w3.org/TR/vc-data-integrity/)
- **WHO SMART Trust HCERT Specification**: [HCERT Structure](https://smart.who.int/trust/hcert_spec.html)

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

The figure below shows the actors directly involved in this profile and the relevant transactions between them.

Trust between the {{ linkvhlr }} and the {{ linkvhls }} MAY be established through:
- Implementation of the optional Submit PKI Material with DID [ITI-YY1] and Retrieve Trust List with DID [ITI-YY2] transactions, OR
- Alternative jurisdiction-specific PKI exchange mechanisms (out of scope for this profile)

This is illustrated in Figure 1:XX.1-1.

<figure >
  <div style="width:18em; max-width:100%;">
  {%include trust_interaction.svg%}
  </div>
  <p id="f1:XX.1-1" class="figureTitle">Figure 1:XX.1-1
  : Trust Network PKI Exchange</p>
</figure>

The process of a VHL Holder requesting a VHL for a set of health documents from a {{ linkvhls }} and subsequently sharing them to a {{ linkvhlr }} is illustrated in Figure 1:XX.1-2.

<figure >
  <div style="width:23em; max-width:100%;">
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

This transaction is used by a {{ linkvhlr }} or {{ linkvhls }} to submit PKI material to a {{ linkta }} using Decentralized Identifiers (DIDs).

For more details see the detailed [transaction description](ITI-YY1.html)

This transaction is captured as the following requirements:
- [Initiate Submit PKI Material Request](Requirements-InitiateSubmitPKIMaterialRequest.html)
- [Respond to Submit PKI Material Request](Requirements-RespondtoSubmitPKIMaterialRequest.html)

#### 1:XX.1.2.2 Retrieve Trust List with DID [ITI-YY2]

This transaction is used by a {{ linkvhlr }} or {{ linkvhls }} to retrieve a Trust List from a {{ linkta }} containing DID Documents with PKI material.

For more details see the detailed [transaction description](ITI-YY2.html)

This transaction is captured as the following requirements:
- [Initiate Retrieve Trust List Request](Requirements-InitiateRetrieveTrustListRequest.html)
- [Respond to Retrieve Trust List Request](Requirements-RespondtoRetrieveTrustListRequest.html)

#### 1:XX.1.2.3 Generate VHL [ITI-YY3]

This transaction is used by a {{ linkvhlh }} to request that a {{ linkvhls }} generate a VHL. By default the VHL is carried as a QR code encoded as an HCERT/CWT structure; where the {{ linkvhls }} supports the VC Enveloped VHL Option it MAY instead be carried as a signed Verifiable Credential.

For more details see the detailed [transaction description](ITI-YY3.html)

This transaction is captured as the following requirements:
- [Initiate VHL Generation Request](Requirements-InitiateVHLGenerationRequest.html)
- [Respond to VHL Generation Request](Requirements-RespondtoGenerateVHLRequest.html)

#### 1:XX.1.2.4 Provide VHL [ITI-YY4]

This transaction is initiated by a {{ linkvhlh }} to transmit a VHL to a {{ linkvhlr }}, either by displaying a QR code for scanning or, where the {{ linkvhls }} supports the VC Enveloped VHL Option, as a signed Verifiable Credential.

For more details see the detailed [transaction description](ITI-YY4.html)

This transaction is captured as the following requirements:
- [Provide VHL](Requirements-ProvideVHL.html)
- [Respond to Provide VHL](Requirements-RespondtoProvideVHL.html)

#### 1:XX.1.2.5 Retrieve Manifest [ITI-YY5]

This transaction is initiated by a {{ linkvhlr }} to retrieve a document manifest from a {{ linkvhls }} using a previously validated VHL as authorization. The transaction uses standard FHIR search on the List resource, following the same pattern as MHD ITI-66 Find Document Lists.

For more details see the detailed [transaction description](ITI-YY5.html)

This transaction is captured as the following requirements:
- [Request VHL Documents](Requirements-RequestVHLDocuments.html)
- [Respond to Request VHL Documents](Requirements-RespondtoRequestVHLDocuments.html)

The documents referenced by the returned manifest are retrieved separately, using MHD [ITI-68 Retrieve Document](https://profiles.ihe.net/ITI/MHD/ITI-68.html); see [Request VHL Document](Requirements-RequestVHLDocument.html).

<a name="actor-options"> </a>

## 1:XX.2  Actor Options

Options that may be selected for each actor in this implementation guide are listed in Table XX.2-1 below. Dependencies between options when applicable are specified in notes.

<p id ="tXX.2-1" class="tableTitle">Table XX.2-1: Actor Options</p>

| Actor          | Option Name                                     |
|----------------|-------------------------------------------------|
| {{ linkvhls }} | Include DocumentReference                       |
| ^              | Sign Manifest Request (HTTP Message Signatures) |
| ^              | Sign Manifest Request (OAuth with SSRAA)        |
| ^              | Sign Manifest Request (Verifiable Credential)   |
| ^              | VC Enveloped VHL                                |
| {{ linkvhlr }} | Include DocumentReference                       |
| ^              | Sign Manifest Request (HTTP Message Signatures) |
| ^              | Sign Manifest Request (OAuth with SSRAA)        |
| ^              | Sign Manifest Request (Verifiable Credential)   |
| ^              | Verify Document Signature                       |
{: .grid}

The three Sign Manifest Request Options differ only in the mechanism by which the {{ linkvhlr }} presents its credential. Each is optional for both actors, and each is complementary between them: the {{ linkvhlr }} side presents the credential, and the {{ linkvhls }} side verifies it and confirms the {{ linkvhlr }}'s authorization within the trust network before responding. An option is therefore only effective where both actors claim it. An actor MAY claim more than one, in which case the two agree on which to use for a given exchange.

Any of the three provides:
- Authentication of the {{ linkvhlr }} by the {{ linkvhls }}
- Non-repudiation of manifest requests
- Protection against request forgery
- Enhanced audit trail

A {{ linkvhls }} claiming one of these options rejects a request that carries no credential under that option, or whose credential does not verify against the {{ linkvhlr }}'s key material obtained from the trust list, returning `401 Unauthorized`. Where neither actor claims any of the three, the {{ linkvhls }} does not establish the identity of the requester, and access to the manifest follows from possession of the VHL and, where the `P` flag is set, the passcode. A deployment that requires the identity of the requester to be established — by jurisdictional policy, by regulation, or under a data sharing agreement — therefore requires one of these options of both actors. What the options do and do not establish is set out in [2:3.YY5.1 Scope](ITI-YY5.html#23yy51-scope).

### 1:XX.2.1 Sign Manifest Request Option (HTTP Message Signatures)

Under this option the {{ linkvhlr }} signs selected components of the outgoing HTTP manifest request with its trust-network key per RFC 9421, and the {{ linkvhls }} verifies that signature against the {{ linkvhlr }}'s public key from the trust list. Authentication is carried entirely within the HTTP request, so neither a token endpoint nor a prior credential exchange is needed.

The option is defined in [2:3.YY5.4.1.4](ITI-YY5.html#23yy5414-sign-manifest-request-option-http-message-signatures).

### 1:XX.2.2 Sign Manifest Request Option (OAuth with SSRAA)

Under this option the {{ linkvhlr }} presents an OAuth 2.0 access token obtained as defined in the [HL7 Security for Scalable Registration, Authentication, and Authorization IG](http://hl7.org/fhir/us/udap-security/) (SSRAA), using OAuth Backend Services with JWT client assertions, and the {{ linkvhls }} validates that token. The two actors complete SSRAA Discovery and Dynamic Client Registration beforehand, and a {{ linkvhls }} claiming this option publishes its FHIR base URL in the VHL payload at [Generate VHL [ITI-YY3]](ITI-YY3.html) so that the {{ linkvhlr }} can reach the authorization server.

The option is defined in [2:3.YY5.4.1.5](ITI-YY5.html#23yy5415-sign-manifest-request-option-oauth-with-ssraa).

### 1:XX.2.3 Sign Manifest Request Option (Verifiable Credential)

Under this option the {{ linkvhlr }} self-issues a JSON-LD Verifiable Credential whose subject is the manifest it decoded from the VHL, signs it with its trust-network key as an embedded `DataIntegrityProof`, and sends that credential as the manifest request body; the {{ linkvhls }} verifies the proof against the trust network. No HTTP-level signing is required, because the credential is the request. This option additionally binds the request to the particular VHL the {{ linkvhlr }} decoded, and is the one option in which the {{ linkvhlr }} can state, inside the signature, the agreement it acts under and the purpose it asserts.

The option is defined in [2:3.YY5.4.1.6](ITI-YY5.html#23yy5416-sign-manifest-request-option-verifiable-credential).

### 1:XX.2.4 Include DocumentReference Option

The Include DocumentReference Option enables the {{ linkvhls }} to process the `_include=List:item` parameter in manifest requests and return DocumentReference resources along with the List resource in a single response. A {{ linkvhlr }} supporting this option includes `_include=List:item` in the manifest request; otherwise it retrieves each referenced DocumentReference separately.

**Benefits:**
- Reduces network round trips for VHL Receiver
- Improves performance for document discovery
- Simplifies workflow for retrieving document metadata

**Implementation Note:** When generating VHLs in ITI-YY3, VHL Sharers supporting this option SHOULD include `_include=List:item` in the manifest URL. VHL Sharers not supporting this option SHOULD NOT include the `_include` parameter in the manifest URL.

See ITI-YY5 Section [2:3.YY5.4.2.2 Message Semantics](ITI-YY5.html#23yy5422-message-semantics) and [2:3.YY5.4.1.3 Expected Actions](ITI-YY5.html#23yy5413-expected-actions) for detailed behavior.

### 1:XX.2.5 Verify Document Signature Option (VHL Receiver)

In this option the {{ linkvhlr }}, after receipt of a digitally signed document from a {{ linkvhls }}, shall verify the digital signature using previously retrieved PKI material. This key material may or may not be distributed under the same trust network under which the VHL was distributed. This key material may or may not be the same key material that was used to verify the VHL.

See [DSG - Document Digital Signature](#1xx65-dsg---document-digital-signature) for a discussion of the relationship of this option to the IHE Document Signature profile.

This option is captured in the following business requirement:
- [Verify Document Signature](Requirements-VerifyDocumentSignature.html)

### 1:XX.2.6 VC Enveloped VHL Option (VHL Sharer)

The VC Enveloped VHL Option enables the {{ linkvhls }} to return the VHL as a signed W3C Verifiable Credential (`application/vc`) instead of a QR code in the ITI-YY3 Generate VHL transaction. The VC is subsequently transmitted to the {{ linkvhlr }} via ITI-YY4 Provide VHL as an alternative carrier to the HCERT/CWT QR code.

This option provides:
- An alternative carrier for the VHL payload, suitable for machine-to-machine transfer and asynchronous delivery where QR presentation is impractical
- A JSON-LD representation compatible with VC-aware ecosystems
- Reuse of the existing trust network — the VC's `DataIntegrityProof` chains to the same trust anchors used for HCERT/CWT verification (no new trust framework introduced)

**How It Works:**

When the caller of `$generate-vhl` sets `format=vc` and the {{ linkvhls }} supports this option, the {{ linkvhls }} returns the VHL as the `credentialSubject.id` of a VC issued per the [W3C Verifiable Credentials Data Model v2](https://www.w3.org/TR/vc-data-model-2.0/), with an embedded `DataIntegrityProof` signed by the {{ linkvhls }} using its trust-network key. The value carried is the `vhlink:` URI that the QR carrier embeds at HCERT claim key 5, so both carriers convey byte-identical payloads. If the option is not supported and `format=vc` is requested, the {{ linkvhls }} SHALL return an OperationOutcome error.

**Naming Note:** This option (a Sharer option carrying the VHL) is distinct from the [Sign Manifest Request Option (Verifiable Credential)](ITI-YY5.html#23yy5416-sign-manifest-request-option-verifiable-credential), in which the {{ linkvhlr }} self-issues a VC as the manifest request body at ITI-YY5.

See ITI-YY3 Section [2:3.YY3.4.1.2.1 Output Carrier Options](ITI-YY3.html#output-carrier-options) for VC construction, ITI-YY4 Section [2:3.YY4.4.1.2 Message Semantics](ITI-YY4.html#23yy4412-message-semantics) for transmission, and ITI-YY4 Section [2:3.YY4.4.1.3 Expected Actions](ITI-YY4.html#23yy4413-expected-actions) for decoding.

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

### 1:XX.4.2 Use Cases

<style>
.usecase-purpose img {
  float: none;      /* project.css sets `p > img { float: left }`, which wraps prose around the image */
  display: block;
  font-size: 14px;  /* so 35em resolves to the same width as the figures on this page */
  width: 35em;
  max-width: 100%;
  height: auto;
  margin: 1.5em 0;
}
</style>

The use cases below are **illustrative**. Each describes a programme or deployment that exists independently of this profile, and is presented to show where the VHL transactions apply — not as a statement that the deployment implements this profile as specified here.

Across these use cases the transactions combine in the common pattern shown in Figure 1:XX.4.2-1. The {{ linkvhls }} and the {{ linkvhlr }} first onboard to a {{ linkta }}, submitting their own PKI material with {{ linksubmitpki }} and obtaining the trust list with {{ linkretrievepki }}, or through the jurisdiction-specific mechanisms that may be used in their place. A {{ linkvhlh }} then obtains a VHL from the {{ linkvhls }} with {{ linkgeneratevhl }}, and presents it to the {{ linkvhlr }} with {{ linkprovidevhl }}. The {{ linkvhlr }} verifies the VHL against the trust list before redeeming it with {{ linkretrievemanifest }}, then retrieves the documents the manifest references using [ITI-68 Retrieve Document](https://profiles.ihe.net/ITI/MHD/ITI-68.html). Individual use cases exercise different subsets of this pattern.

<figure >
  <div style="width:35em; max-width:100%;">
  {%include usecase-processflow.svg%}
  </div>
  <p id="f1:XX.4.2-1" class="figureTitle">Figure 1:XX.4.2-1: VHL Transactions Applicable Across the Use Cases</p>
</figure>

#### 1:XX.4.2.1 Use Case #1: WHO Global Digital Health Certification Network

{% assign UseCaseGDHCN = site.data.ExampleScenario-UseCaseGDHCN %}

<div class="usecase-purpose">{{ UseCaseGDHCN.purpose | markdownify }}</div>

This use case has the following business requirements:
- [Establish Trust](Requirements-EstablishTrust.html)
- [Initiate Submit PKI Material Request](Requirements-InitiateSubmitPKIMaterialRequest.html)
- [Initiate Retrieve Trust List Request](Requirements-InitiateRetrieveTrustListRequest.html)

##### 1:XX.4.2.1.1 Hajj Pilgrimage
{% assign useCaseHajjPilgrimage = site.data.ExampleScenario-UseCaseHajjPilgrimage %}

<div class="usecase-purpose">{{ useCaseHajjPilgrimage.purpose | markdownify }}</div>

This use case has the following business requirements:
- [Establish Trust](Requirements-EstablishTrust.html)
- [Create Secure Channel](Requirements-CreateSecureChannel.html)

##### 1:XX.4.2.1.2 Pan-American Highway for Health

{% assign UseCasePH4H = site.data.ExampleScenario-UseCasePH4H %}

<div class="usecase-purpose">{{ UseCasePH4H.purpose | markdownify }}</div>

This use case has the following business requirement:
- [Establish Trust](Requirements-EstablishTrust.html)

#### 1:XX.4.2.2 Use Case #2: EU Vaccination Card

{% assign UseCaseEVAC = site.data.ExampleScenario-UseCaseEVAC %}

<div class="usecase-purpose">{{ UseCaseEVAC.purpose | markdownify }}</div>

This use case has the following business requirement:
- [Record Access To Health Data](Requirements-RecordAccessToHealthData.html)

#### 1:XX.4.2.3 Use Case #3: US Trusted Exchange Framework and Common Agreement (TEFCA)

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

- Every participant ({{ linkvhlr }}, {{ linkvhls }}) depends on a trust relationship with a {{ linkta }}: without one there is no material against which a VHL signature can be verified. ITI-YY1 (Submit PKI Material with DID) and ITI-YY2 (Retrieve Trust List with DID) are this profile's transactions for establishing and retrieving that material. [Section XX.1](#actors-and-transactions) gives their optionality and states that a deployment may instead use jurisdiction-specific PKI exchange mechanisms, which are out of scope for this profile.
- Certificates and keys should be regularly updated and revocation status checked.
- Onboarding establishes key material in both directions: the participant's own certificate authority material is pre-shared with the trust network, and the {{ linkta }}'s public key is shared with the participant. Neither can be obtained over the channel it secures, so both are established through the verified, out-of-band process the trust framework defines.
- Appearing in a retrieved trust list does not by itself make a public key trustworthy. Where the governing trust framework operates a certificate authority, authority for a key derives from its certificate chain, and [ITI-YY2 Expected Actions](ITI-YY2.html) is where this profile requires that chain to resolve back to material pre-shared at onboarding. How the path is constructed, which algorithms and key strengths are permitted, and how revocation status is obtained are left to the trust framework.
- Trust lists are commonly published as static, cacheable documents. Recipients should verify the cryptographic proof over a retrieved trust list against the {{ linkta }} key established at onboarding, check its freshness, and not accept a trust list older than one already held, so that withdrawn key material cannot be reinstated by serving an earlier validly signed version.

### 1:XX.5.2 Secure Channel Requirements

- ITI-YY5 (Retrieve Manifest) carries health data and the patient business identifier, so it runs over a secure channel. The obligation is the ATNA Secure Node or Secure Application grouping in [Required Actor Groupings](#required-groupings), which brings with it Authenticate Node [ITI-19].

### 1:XX.5.3 Cryptographic Algorithm Selection

The transactions in this profile (ITI-YY1 through ITI-YY5) rely on cryptographic primitives for digital signatures, message authentication, and content encryption. This IG does not mandate a single algorithm suite for deployment. Implementers select algorithms consistent with the underlying specifications — for example, RFC 9421 (HTTP Message Signatures), RFC 7515/7516/7518 (JWS/JWE/JWA), RFC 8152 (COSE), W3C Data Integrity (Verifiable Credentials), the HL7 SSRAA IG (OAuth with SSRAA), and the WHO SMART Trust specification (HCERT). The preceding list is illustrative, not exhaustive.

**Interoperability baseline:** For the purpose of interoperability testing, implementations SHALL support **ECDSA using curve P-256 and SHA-256** as a common baseline across signature operations. This is `ES256` in the JOSE and COSE registries and `ecdsa-p256-sha256` in the HTTP Message Signatures registry. A single baseline is possible because this algorithm is expressible in every signature container this profile uses — JWS/JWT, COSE, HTTP Message Signatures, and the W3C Data Integrity ECDSA cryptosuites — and because it is the algorithm the trust networks this profile targets already distribute.

This baseline ensures that two independent conformant implementations can always interoperate during testing. It does not preclude support for — or preferred deployment use of — other algorithms (other ECDSA curves, EdDSA, RSA-PSS, or future post-quantum algorithms).

Where an underlying specification sets its own algorithm requirements, those requirements govern:

| Signature operation | Governed by |
|---------------------|-------------|
| HCERT/CWT signature on the VHL ([ITI-YY3](ITI-YY3.html), [ITI-YY4](ITI-YY4.html)) | [WHO SMART Trust HCERT specification](https://smart.who.int/trust/hcert_spec.html), which defines a primary and a secondary algorithm and requires both to be implemented |
| JWT client assertions and access tokens under the Sign Manifest Request Option (OAuth with SSRAA) at [ITI-YY5](ITI-YY5.html) | the [HL7 Security for Scalable Registration, Authentication, and Authorization IG](http://hl7.org/fhir/us/udap-security/), which operates on its own X.509 credentials rather than on trust network key material |
| `DataIntegrityProof` on Verifiable Credentials | the declared `cryptosuite`, which determines both the canonicalization and the signature algorithm |
| JWE encryption of document binaries ([ITI-YY5](ITI-YY5.html)) | the [SMART Health Links encryption convention](https://hl7.org/fhir/uv/smart-health-cards-and-links/links-specification.html#encrypting-and-decrypting-files), which fixes `alg=dir` and `enc=A256GCM` so that the symmetric key carried in the VHL payload can be used directly |
{: .grid}

Note that a signature algorithm is constrained by the key it is made with: a participant whose trust network key material is an elliptic-curve key cannot produce an RSA signature with it. Implementers selecting algorithms for operations that use trust network keys should begin from the key types their trust framework issues.

**Deployment considerations:** Implementers SHOULD take into account additional considerations beyond the interoperability baseline when selecting algorithms for production deployments, including but not limited to:
- **Jurisdictional policies and regulatory requirements** (e.g., national cryptographic agency guidance, healthcare-sector rules, data-protection law);
- **Post-quantum / quantum-safe cryptography** as standards mature (e.g., NIST PQC) and migration guidance evolves;
- **Evolving industry guidance** on algorithm deprecation, minimum key strengths, and cryptosuite lifecycle (e.g., updates from IETF, W3C, NIST, ENISA).

Algorithms named in examples, tables, and code blocks throughout this IG are illustrative. Except for the interoperability baseline stated above, and for the requirements of the underlying specifications listed above, they do not constrain deployment choices. Jurisdictions and trust networks MAY define additional profiles (permitted algorithm lists, minimum key lengths, deprecation schedules) consistent with this guidance.

### 1:XX.5.4 VHL Integrity and Authorization

- A VHL conveys no authority until its signature has been checked against the trust list. Verification is required of the {{ linkvhlr }} as an expected action of [ITI-YY4 Provide VHL](ITI-YY4.html), before any manifest request is made.
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
- Consent may be recorded during VHL generation; see [PCF - Privacy Consent on FHIR](#1xx62-pcf---privacy-consent-on-fhir).
- VHL Holders retain the right to revoke access where supported.

<a name="other-grouping"> </a>
## 1:XX.6 Cross-Profile Considerations

This section is informative, not normative. It is intended to put this profile in context with other profiles. Any required groupings should have already been described above.

<a name="atna-cross-profile"> </a>
### 1:XX.6.1 ATNA - Audit Trail and Node Authentication

The grouping of the {{ linkvhlr }} and the {{ linkvhls }} with an ATNA Secure Node or Secure Application is required for ITI-YY5 and is stated in [Section XX.3 Required Actor Groupings](#required-groupings). What that grouping brings is Authenticate Node [ITI-19] and the creation of audit records for security-relevant events.

The protection ITI-19 affords depends on which ATNA Secure Transport (STX) option the deployment claims. A Secure Node or Secure Application is required to support at least one STX option, and the available options include [STX: No Secure Transport](https://profiles.ihe.net/ITI/TF/Volume1/ch-9.html), for which ITI-19 requires no actions because confidentiality is provided by an already-secure network such as an isolated segment or a VPN. Where a TLS option is claimed, ITI-19 specifies mutual authentication using X.509 certificates. The ATNA grouping therefore establishes that the channel is protected by a means the deployment has chosen and declared; it does not by itself establish that TLS, or mutual certificate authentication, is in use.

That protection is distinct from the authentication ITI-YY5 requires. Authenticate Node authenticates the communicating node and secures the channel between nodes; ITI-YY5 authenticates the requesting entity and establishes its authorization within the trust network, and under the Sign Manifest Request Option (Verifiable Credential) additionally binds the request to the particular VHL the {{ linkvhlr }} decoded. The authentication options in [ITI-YY5](ITI-YY5.html) are consequently not made redundant by the ATNA grouping, and an ATNA grouping does not satisfy them.

<a name="pcf-cross-profile"> </a>
### 1:XX.6.2 PCF - Privacy Consent on FHIR

The [IHE Privacy Consent on FHIR (PCF)](https://profiles.ihe.net/ITI/PCF/) profile is the recommended companion for capturing, storing, and enforcing patient consent alongside VHL. A {{ linkvhls }} that records consent acts as a PCF Consent Recorder and initiates Access Consent [ITI-108] transactions to record consent declarations by the {{ linkvhlh }}; this is captured in the [Record Consent](Requirements-RecordConsent.html) requirement.

Recommended groupings:

- **{{ linkvhlh }} (or the Holder's client app)** MAY be grouped with a PCF **Consent Recorder** so that the Holder authors a `Consent` resource when generating a VHL.
- **{{ linkvhls }}** MAY be grouped with a PCF **Consent Registry** so that consents governing a generated folder are persisted and discoverable, and with a PCF **Consent Enforcement Point** so that the set of documents returned at [ITI-YY5](ITI-YY5.html) is filtered by the active `Consent.provision` (actor, purpose, period, class, code).

The `$generate-vhl` operation (ITI-YY3) accepts an optional `purposeOfUse` input parameter bound (extensible) to the HL7 v3 [PurposeOfUse](http://terminology.hl7.org/ValueSet/v3-PurposeOfUse) value set. The {{ linkvhls }} persists this value against the generated folder. When the {{ linkvhls }} is grouped with a PCF Consent Recorder or Consent Registry, the value populates `Consent.provision.purpose` on any `Consent` created for or bound to the folder. At ITI-YY5, the {{ linkvhls }} MAY reject manifest requests whose purpose claim is inconsistent with the purpose recorded at generation time. Where that claim can travel depends on the Sign Manifest Request Option in use: in the access token or the SSRAA `hl7-b2b` extension under OAuth with SSRAA, and in `credentialSubject.purposeOfUse` under the Verifiable Credential option, which also lets the {{ linkvhlr }} name the policy it acts under in `termsOfUse` — a `Consent.policyRule` among the possibilities. HTTP Message Signatures carry neither.

### 1:XX.6.3 MHD - Mobile Health Document Sharing

ITI-YY5 (Retrieve Manifest) reuses the FHIR search machinery of [MHD ITI-66 Find Document Lists](https://profiles.ihe.net/ITI/MHD/ITI-66.html): the VHL manifest URL constructed at ITI-YY3 is a FHIR `List` search using the parameters the Document Responder is required to support per ITI-66, and the ITI-YY5 response is an ITI-66 `searchset` Bundle. Binary retrieval is delegated to [MHD ITI-68 Retrieve Document](https://profiles.ihe.net/ITI/MHD/ITI-68.html) per the required grouping in [Section XX.3 Required Actor Groupings](#required-groupings).

### 1:XX.6.4 mCSD - Mobile Care Services Discovery

A trust network needs a way for participants to discover one another's identifiers, and [mCSD](https://profiles.ihe.net/ITI/mCSD/) provides one. A {{ linkta }} MAY be grouped with an mCSD **Directory** so that each participating organization is published as an `Organization` with an associated `Endpoint` carrying that participant's DID, and a {{ linkvhlr }} or {{ linkvhls }} MAY be grouped with an mCSD **Query Client** to resolve a participant to its DID by means of Find Matching Care Services [ITI-90]. mCSD states that an endpoint is not limited to a RESTful FHIR server and types it through `Endpoint.connectionType`, but it defines no connection type for DIDs; a deployment taking this approach therefore establishes that type itself.

This is a discovery mechanism only. The DID so obtained is dereferenced and its contents validated as ITI-YY2 requires, and nothing in an mCSD directory entry confers authority on the key material it leads to.

### 1:XX.6.5 DSG - Document Digital Signature

The Verify Document Signature Option ([Section XX.2.5](#1xx25-verify-document-signature-option-vhl-receiver)) concerns signatures over the documents themselves, which this profile does not define; the IHE profile that does is [Document Digital Signature (DSG)](https://profiles.ihe.net/ITI/DSGj/Volume1/ch-37.html). A {{ linkvhlr }} supporting the option is correspondingly grouped with a DSG **Content Consumer**, and a {{ linkvhls }} that signs the documents it shares with a DSG **Content Creator**.

DSG carries the XML and JSON cases as content modules on those same two actors rather than as separate profiles:

- **Document Digital Signature** (required; [ITI TF-3: 5.5](https://profiles.ihe.net/ITI/TF/Volume3/ch-5.5.html)) — XAdES signatures over XML documents;
- **Document Digital Signature in JSON** (optional; [ITI TF-3: 5.10](https://profiles.ihe.net/ITI/DSGj/Volume3/ch-5.10.html)) — JSON Web Signature per RFC 7515, which is the relevant module for the FHIR documents a VHL typically references.

A Content Creator MAY use both. Each actor selects at least one signature form — detached, SubmissionSet, or enveloping — in the XML or JSON variant as applicable.

The key material used for document signature verification may or may not be the same as the key material used to verify the VHL itself, and may or may not be distributed under the same trust network. A {{ linkvhlr }} that verifies a document signature is therefore making a second, independent trust decision, and the trust framework that governs the VHL does not necessarily govern the signer of the document.
