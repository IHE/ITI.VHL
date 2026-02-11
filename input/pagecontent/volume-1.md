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

The **Verifiable Health Link (VHL)** profile defines a set of protocols and patterns that enable health documents to be shared in a verifiable and auditable manner—both within and across jurisdictions. Central to this profile is the concept of the **VHL**, a signed artifact that an individual (the **VHL Holder**) can use to authorize access to their health records from an issuer (the {{ linkvhls }}) to a third party (the {{ linkvhlr }}). The mechanisms by which the VHL is held by the Holder or transmitted to the {{ linkvhlr }} are out of scope for this profile.

VHL leverages **Public Key Infrastructure (PKI)** to establish trust among actors and to verify the authenticity and integrity of exchanged artifacts.

Within the VHL trust model, both the {{ linkvhlr }} and the {{ linkvhls }} are participants in a shared **trust network**. This network enables:
- Verification of the origin of a health document,
- Validation of any access mechanism (i.e., the VHL itself),
- Authentication of requests that seek to utilize these mechanisms.
    
The authority to participate in the trust network is governed by each actor's **jurisdiction**, which determines eligibility and onboarding criteria. Verification of this authorization is achieved through PKI, specifically through the validation of credentials issued or endorsed by a **Trust Anchor** ({{ linkta }}).

Jurisdictions may also impose specific regulatory requirements on the privacy and security of health data exchange. These may include mandatory **consent verification**, **audit logging**, or other compliance controls that impact how VHL-based exchanges are implemented.

As members of a trust network, both the {{ linkvhlr }} and the {{ linkvhls }} are expected to submit and retrieve PKI material—typically as signed **Trust Lists**—from the {{ linkta }}. The precise onboarding and credential issuance processes used to establish trust with the {{ linkta }} are implementation-specific and beyond the scope of this profile.

> **Note on SMART Health Links (SHL):**

> VHLs and SMART® Health Links (SHLs) are conceptually related but rely on fundamentally different trust assumptions. In the VHL model, a **pre-established trust relationship** exists between the {{ linkvhls }} and the {{ linkvhlr }}, verified via PKI material exchanged through Trust Lists. In contrast, SHL assumes **no prior trust** between the SHL Receiver and SHL Sharer. Instead, trust is conveyed at the time the SHL is presented, often using embedded JWS signatures and keys controlled by the SHL Sharer. See [Appendix A](vhl_vs_shl.html) for a more detailed comparison.


<a name="actors-and-transactions"> </a>

## 1:X.1 Actors, Transactions, and Content Modules

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

As a pre-condition to transactions ITI-YY4 and ITI-YY5, the {{ linkvhlr }} and {{ linkvhls }} must have established trust relationships enabling mutual authentication and VHL signature verification.

This trust MAY be established through:
- Implementation of the optional Submit PKI Material with DID [ITI-YY1] and Retrieve Trust List with DID [ITI-YY2] transactions, OR
- Alternative jurisdiction-specific PKI exchange mechanisms (out of scope for this profile)

This is illustrated in Figure X.X.X.X-1.


<figure >
  <div style="width:35em; max-width:100%;">
  {%include trust_interaction.svg%}
  </div>
  <p id="fX.X.X.X-1" class="figureTitle">Figure X.X.X.X-1: Trust Network PKI Exchange</p>
</figure>

The process of a VHL Holder requesting a VHL for a set of health documents from a {{ linkvhls }} and subsequently sharing them to a {{ linkvhlr }} is illustrated in Figure X.X.X.X-2.

<figure >
  <div style="width:18em; max-width:100%;">
  {%include vhl_interaction.svg%}
  </div>
  <p id="fX.X.X.X-2" class="figureTitle" >Figure X.X.X.X-2: VHL Generation, Provision, and Document Retrieval Flow</p>
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


### XX.1.1 Actors
The actors in this profile are described in more detail in the sections below.


{% assign canonicals = site.data.canonicals | where: 'type' , 'ActorDefinition' %}
{% for canonical in canonicals %}
   {% assign stub = canonical.type | append: "-" | append: canonical.id %}
   {% assign actordefinition = site.data[stub] %}
   {% include actordefinition-short-summary.liquid actordefinition=actordefinition site=site %}
{% endfor %}


### XX.1.2 Transaction Descriptions

The transactions in this profile are summarized in the sections below.

#### XX.1.2.1 Submit PKI Material with DID [ITI-YY1]

This transaction is used by a {{ linkvhlr }} or {{ linkvhls }} to submit PKI material to a {{ linkta }} using Decentralized Identifiers (DIDs). The submitted material is formatted as DID Documents containing public keys and associated metadata for validation and inclusion in the Trust List.

**Transaction Optionality:**

This transaction is:
- **REQUIRED (R)** for Trust Anchor actors
- **OPTIONAL (O)** for VHL Sharer and VHL Receiver actors

**When to Implement:**

VHL Sharer and VHL Receiver actors SHALL implement this transaction when:
- They do not have pre-established PKI material exchange mechanisms with the {{ linkta }}, OR
- They wish to demonstrate interoperability at IHE Connectathons

**Alternative Implementations:**

Actors that do not implement this transaction MUST establish trust relationships through jurisdiction-specific mechanisms that are out of scope for this profile. Such implementations:
- Cannot participate in IHE Connectathon testing for trust establishment
- Must document their trust establishment mechanisms in their IHE Integration Statement
- Are responsible for ensuring PKI material is available for VHL signature verification

For more details see the detailed [transaction description](ITI-YY1.html)

This transaction is captured as the following requirements:
* [Initiate Submit PKI Material Request](Requirements-InitiateSubmitPKIMaterialRequest.html)
* [Respond to Submit PKI Material Request](Requirements-RespondtoSubmitPKIMaterialRequest.html)

#### XX.1.2.2 Retrieve Trust List with DID [ITI-YY2]

This transaction is used by a {{ linkvhlr }} or {{ linkvhls }} to retrieve a Trust List from a {{ linkta }} containing DID Documents with PKI material. The retrieved DID Documents include public keys and metadata necessary for verifying digital signatures and establishing trust relationships. Received key material should be distinguished by the participating jurisdiction, use case context, and key usage.

**Transaction Optionality:**

This transaction is:
- **REQUIRED (R)** for Trust Anchor actors
- **OPTIONAL (O)** for VHL Sharer and VHL Receiver actors

**When to Implement:**

VHL Sharer and VHL Receiver actors SHALL implement this transaction when:
- They do not have pre-established mechanisms to retrieve PKI material from the {{ linkta }}, OR
- They wish to demonstrate interoperability at IHE Connectathons

**Alternative Implementations:**

Actors that do not implement this transaction MUST retrieve trust material through jurisdiction-specific mechanisms that are out of scope for this profile. Such implementations:
- Cannot participate in IHE Connectathon testing for trust material retrieval
- Must document their trust material retrieval mechanisms in their IHE Integration Statement
- Are responsible for obtaining current PKI material for VHL signature verification

For more details see the detailed [transaction description](ITI-YY2.html)

This transaction is captured as the following requirements:
* [Initiate Retrieve Trust List Request](Requirements-InitiateRetrieveTrustListRequest.html)
* [Respond to Retrieve Trust List Request](Requirements-RespondtoRetrieveTrustListRequest.html)

#### XX.1.2.3 Generate VHL [ITI-YY3]

This transaction is used by a {{ linkvhlh }} to request that a {{ linkvhls }} generate a QR code containing a VHL. The QR code is encoded as an HCERT/CWT structure.

A {{ linkvhls }} MAY:
- Record consent of the individual
- Create audit trail of VHL creation
- Set passcode protection (P flag) with secure hash storage
- Set expiration time for time-limited access
- Set long-term flag (L) for ongoing access

For more details see the detailed [transaction description](ITI-YY3.html)

This transaction is captured as the following requirements:
* [Initiate VHL Generation Request](Requirements-InitiateVHLGenerationRequest.html)
* [Respond to VHL Generation Request](Requirements-RespondtoGenerateVHLRequest.html)

#### XX.1.2.4 Provide VHL [ITI-YY4]

This transaction is initiated by a {{ linkvhlh }} to transmit a VHL to a {{ linkvhlr }} by displaying or providing a QR code for scanning. 

**QR Code Transmission:**

The {{ linkvhlh }} presents the VHL by:
- Displaying the QR code on their device screen for the {{ linkvhlr }} to scan, OR
- Providing a printed QR code generated during ITI-YY3

The {{ linkvhlr }} scans the QR code using a camera-equipped device and processes the HCERT-encoded VHL through a 9-step decoding process:

For more details see the detailed [transaction description](ITI-YY4.html)

This transaction is captured as the following requirements:
* [Provide VHL](Requirements-ProvideVHL.html)
* [Respond to Provide VHL](Requirements-RespondtoProvideVHL.html)

#### XX.1.2.5 Retrieve Manifest [ITI-YY5]

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
* [Request VHL Documents](Requirements-RequestVHLDocuments.html)

<a name="actor-options"> </a>

<a name="actor-options"> </a>

## XX.2  Actor Options

Options that may be selected for each actor in this implementation guide are listed in Table XX.2-1 below. Dependencies between options when applicable are specified in notes.

<p id ="tXX.2-1" class="tableTitle">Table XX.2-1: Actor Options</p>

| Actor          | Option Name                          |
|----------------|--------------------------------------|
| {{ linkvhlr }} | Sign Manifest Request                |
| ^              | Include DocumentReference            |
| ^              | Verify Document Signature            |
| ^              | OAuth with FAST                      |
| {{ linkvhls }} | Include DocumentReference            |
| ^              | Sign Manifest Request                |
| ^              | OAuth with FAST                      |
{: .grid}


### XX.2.1 Sign Manifest Request Option (VHL Receiver)

The Sign Manifest Request Option enables the {{ linkvhlr }} to digitally sign manifest requests sent to the {{ linkvhls }}.

Actors claiming the Sign Manifest Request Option SHALL:
- Compute detached JWS signature over SHL parameters (Part 1 of multipart request)
- Include signature in Part 2 of the multipart request to ITI-YY5
- Use receiver's private key for signing
- Include `kid` (key identifier) in JWS protected header
- Format signature as `application/jose`

This option provides:
- Mutual authentication between VHL Receiver and VHL Sharer
- Non-repudiation of manifest requests
- Protection against request forgery
- Enhanced audit trail

**Complementary Option:** This option is designed to work with the Sign Manifest Request Option (VHL Sharer). If a {{ linkvhlr }} signs requests, the {{ linkvhls }} should support signature verification.

See ITI-YY5 Section 2:3.YY5.4.1.2 for detailed signature format and ITI-YY5 Section 2:3.YY5.6 for conformance requirements.

### XX.2.1 Sign Manifest Request Option (VHL Sharer)

The Sign Manifest Request Option enables the {{ linkvhls }} to verify digital signatures on manifest requests from the {{ linkvhlr }}.

Actors claiming the Sign Manifest Request Option SHALL:
- Parse Part 2 (signature) from multipart requests in ITI-YY5
- Extract `kid` from JWS protected header
- Retrieve receiver's public key from trust list using `kid`
- Verify detached JWS signature over Part 1 (shl-parameters) content
- Reject requests with invalid signatures
- Reject requests from untrusted receivers (not in trust list)
- Return HTTP 401 Unauthorized for signature verification failures

This option provides:
- Verification that requests originate from trusted VHL Receivers
- Protection against unauthorized manifest access
- Enhanced security for high-value health data
- Detailed audit trail of authenticated requests

**Complementary Option:** This option is designed to work with the Sign Manifest Request Option (VHL Receiver). If a {{ linkvhls }} verifies signatures, the {{ linkvhlr }} should support signing requests.

See ITI-YY5 Section 2:3.YY5.4.1.3 for verification process and ITI-YY5 Section 2:3.YY5.6 for conformance requirements.

### XX.2.2 Include DocumentReference Option (VHL Sharer)

The Include DocumentReference Option enables the {{ linkvhls }} to process the `_include=List:item` parameter in manifest requests and return DocumentReference resources along with the List resource in a single response.

Actors claiming the Include DocumentReference Option SHALL:
- Support `_include=List:item` parameter in manifest URL
- When `_include=List:item` is present:
  - Retrieve DocumentReference resources referenced by List.entry.item
  - Include them in searchset Bundle with search.mode = "include"
  - Apply VHL scope and consent filters to DocumentReferences
- Return Bundle with both List (search.mode = "match") and DocumentReference resources

Actors NOT claiming the Include DocumentReference Option SHALL:
- Ignore the `_include` parameter if provided
- Return only the List resource in searchset Bundle
- VHL Receiver will use ITI-67 (Retrieve Document) transactions to retrieve individual DocumentReferences

**Benefits:**
- Reduces network round trips for VHL Receiver
- Improves performance for document discovery
- Simplifies workflow for retrieving document metadata

**Implementation Note:** When generating VHLs in ITI-YY3, VHL Sharers supporting this option SHOULD include `_include=List:item` in the manifest URL. VHL Sharers not supporting this option SHOULD NOT include the `_include` parameter in the manifest URL.

See ITI-YY5 Section 2:3.YY5.4.1.3 for detailed behavior and ITI-YY5 Section 2:3.YY5.6 for conformance requirements.

### XX.2.3 Verify Document Signature Option (VHL Receiver)

In this option the {{ linkvhlr }}, after receipt of a digitally signed document from a {{ linkvhls }}, shall verify the digital signature using previously retrieved PKI material. This key material may or may not be distributed under the same trust network under which the VHL was distributed. This key material may or may not be the same key material that was used to verify the VHL.

See cross-profile considerations for a discussion of the relationship of this option to the IHE Document Signature profile.

This option is captured in the following business requirement:
* [Verify Document Signature](Requirements-VerifyDocumentSignature.html)


<a name="required-groupings"> </a>

## XX.3 Required Actor Groupings

The following actor groupings are required for secure operations within the VHL trust network:

<p id ="tXX.3-1" class="tableTitle">Table XX.3-1: VHL Profile - Required Actor Groupings</p>

| VHL Actor | Grouping Condition | Actor(s) to be grouped with | Reference |
|-----------|--------------------|-----------------------------|-----------|
| {{ linkvhlr }} | Required for ITI-YY5 | ITI ATNA / Secure Node or Secure Application | ITI TF-1: 9.1 |
| {{ linkvhls }} | Required for ITI-YY5 | ITI ATNA / Secure Node or Secure Application | ITI TF-1: 9.1 |
| {{ linkta }} | -- | None | -- |
| {{ linkvhlh }} | -- | None | -- |
{: .grid}

Note: The {{ linkvhlr }} and {{ linkvhls }} SHALL be grouped with ATNA Secure Node or Secure Application to support the secure channel requirements of the ITI-YY5 Retrieve Manifest transaction.

<a name="overview"> </a>

## XX.4 Overview

This section shows how the transactions/content modules of the profile are combined to address the use cases.

### XX.4.1 Concepts

A **Verifiable Health Link (VHL)** is a mechanism that enables individuals to share access to health documents in a secure, auditable, and configurable manner. Sharing options may include **limited-time access**, **PIN-protected retrieval**, or **ongoing access** to a longitudinal dataset that may evolve over time. VHLs can be rendered as QR codes or downloaded to a user’s device, supporting patient-mediated data sharing and enhancing interoperability across healthcare systems.

#### XX.4.2 Use Cases

#### XX.4.2.1 Use Case \#1: WHO Global Digital Health Certification Network

{% assign ucGDHCN = site.data.ExampleScenario-UseCaseGroupGDHCN %}
{% include usecase.liquid site=site scenario=ucGDHCN %}


##### XX.4.2.1.1 Hajj Pilgrimage Use Case Description


{% assign ucHajj = site.data.ExampleScenario-UseCaseHajjPilgrimage %}
{{% include ucHajj._purpose}}



This use case has the following business requirement:
* [Establish Trust](Requirements-EstablishTrust.html)
* [Create Trusted Channel](Requirements-CreateTrustedChannel.html)

##### XX.4.2.1.2 Pan-American Highway for Health Use Case Description

{% assign ucPH4H = site.data.ExampleScenario-UseCasePH4H %}
{% include usecase.liquid site=site scenario=ucPH4H %}

This use case has the following business requirement:
* [Establish Trust](Requirements-EstablishTrust.html)

#### XX.4.2.2 Use Case #2: EU Vaccination Card

{% assign ucEVAC = site.data.ExampleScenario-UseCaseEVAC %}
{% include usecase.liquid site=site scenario=ucEVAC %}

ueries do NOT reveal which specific credentials are being presented
   - No party can correlate presentations across different {{ linkvhlr }}s



<a name = "security-considerations"></a>
## XX.5 Security Considerations

VHL is a building block that is meant to be used together with added security measures, otherwise it is not suitable for exchange in environments where security and provenance cannot be reliably established by other means.

Key security considerations include:

### XX.5.1 Trust Network Security

- All participants ({{ linkvhlr }}, {{ linkvhls }}) must establish trust via the {{ linkta }} using ITI-YY1 (Submit PKI Material) and ITI-YY2 (Retrieve Trust List) transactions.
- PKI material must be validated before use in signature verification or secure channel establishment.
- Certificates and keys should be regularly updated and revocation status checked.

### XX.5.2 Secure Channel Requirements

- ITI-YY5 (Retrieve Manifest) SHALL be conducted over a secure channel as defined by ATNA Authenticate Node [ITI-19].
- Both {{ linkvhlr }} and {{ linkvhls }} SHALL present credentials validated against the {{ linkta }}.
- Mutual authentication is required for all document retrieval operations.

### XX.5.3 VHL Integrity and Authorization

- VHL signatures must be verified before trusting VHL content.
- VHL expiration timestamps should be enforced.
- Passcodes (if used) should be communicated out-of-band and validated server-side.
- VHL Sharers should implement rate limiting and account lockout for failed passcode attempts.

### XX.5.4 Audit Requirements

- The European Health Data Space (EHDS) requires detailed audit information on data access.
- Provisions 8f) and 12a) outline requirements for auditability of data access.
- VHL Sharers and VHL Receivers should record audit events documenting:
  - VHL generation requests
  - VHL provision events
  - Document retrieval attempts
  - Authentication/authorization failures

### XX.5.5 Privacy Considerations

- VHL payloads do not contain PHI - only references to documents.
- Actual health data is transmitted over secure channels (ITI-YY5).
- Consent may be recorded during VHL generation (Record Consent option).
- VHL Holders retain the right to revoke access where supported.

<a name="other-grouping"> </a>
## XX.6 Cross-Profile Considerations

This section is informative, not normative. It is intended to put this profile in context with other profiles. Any required groupings should have already been described above.

### XX.6.1 ATNA - Audit Trail and Node Authentication

The {{ linkvhlr }} and {{ linkvhls }} SHALL be grouped with ATNA Secure Node or Secure Application actors to support the secure channel requirements of ITI-YY5. This grouping ensures:
- Mutual authentication via X.509 certificates or other ATNA-supported mechanisms
- Secure channel establishment per ATNA Authenticate Node [ITI-19]
- Audit logging capabilities for security events

### XX.6.2 PCF - Privacy Consent on FHIR

When the {{ linkvhls }} implements the Record Consent option, it acts as a Consent Recorder and initiates Access Consent [ITI-108] transactions to record consent declarations by the {{ linkvhlh }}.

### XX.6.3 MHD - Mobile Health Document Sharing

ITI-YY5 (Retrieve Manifest) follows patterns similar to MHD transactions:
- Returns FHIR Bundle (searchset) with DocumentReference resources, similar to MHD ITI-67
- Document retrieval patterns could be extended to align with MHD ITI-68

### XX.6.4 mCSD - Mobile Care Services Discovery

The {{ linkta }} may store DID (Decentralized Identifier) as endpoints for Jurisdictions. The mCSD Profile supports querying for Endpoint(s) for Organizations.

### XX.6.5 DSG/DSGj - Document Digital Signature

The Verify Document Signature option enables {{ linkvhlr }} to verify digital signatures on retrieved documents. This may use:
- DSG (Document Digital Signature) profile for XML-based documents
- DSGj (JSON Document Signature) profile for JSON-based documents

The key material used for document signature verification may or may not be the same as the key material used to verify the VHL itself, and may or may not be distributed under the same trust network.
