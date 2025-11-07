{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}
{% assign linksubmitpki = '<a href="ITI-YY1.html">Submit PKI Material</a>' %}
{% assign linkretrievepki = '<a href="ITI-YY2.html">Retrieve Trust List</a>' %}
{% assign linkgeneratevhl = '<a href="ITI-YY3.html">Generate VHL</a>' %}
{% assign linkprovidevhl = '<a href="ITI-YY4.html">Provide VHL</a>' %}
{% assign linkretrievemanifest = '<a href="ITI-YY5.html">Retrieve Manifest</a>' %}



As individuals move within or across jurisdictional boundaries, they may wish to provide access to clinical or other health-related documents to a defined set of trusted parties who are authorized to access their records. This access may be granted for a single document or for a set of related documents.

The **Verifiable Health Link (VHL)** profile defines a set of protocols and patterns that enable health documents to be shared in a verifiable and auditable manner—both within and across jurisdictions. Central to this profile is the concept of the **VHL**, a signed artifact that an individual (the **VHL Holder**) can use to authorize access to their health records from an issuer (the {{ linkvhls }}) to a third party (the {{ linkvhlr }}).

VHL leverages **Public Key Infrastructure (PKI)** to establish trust among actors and to verify the authenticity and integrity of exchanged artifacts.

Within the VHL trust model, both the {{ linkvhlr }} and the {{ linkvhls }} are participants in a shared **trust network**. This network enables:
- Verification of the origin of a health document,
- Validation of any access mechanism (i.e., the VHL itself),
- Authentication of requests that seek to utilize these mechanisms.
    
The authority to participate in the trust network is governed by each actor's **jurisdiction**, which determines eligibility and onboarding criteria. Verification of this authorization is achieved through PKI, specifically through the validation of credentials issued or endorsed by a **Trust Anchor** ({{ linkta }}).

Jurisdictions may also impose specific regulatory requirements on the privacy and security of health data exchange. These may include mandatory **consent verification**, **audit logging**, or other compliance controls that impact how VHL-based exchanges are implemented.

As members of a trust network, both the {{ linkvhlr }} and the {{ linkvhls }} are expected to publish and retrieve PKI material—typically as signed **Trust Lists**—from the {{ linkta }}. The precise onboarding and credential issuance processes used to establish trust with the {{ linkta }} are implementation-specific and beyond the scope of this profile.

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

As a pre-condition to transactions ITI-YY4 and ITI-YY5, the {{ linkvhlr }} and {{ linkvhls }} must exchange the appropriate PKI material in order to verify their trust relationship. As the identities of the {{ linkvhlr }} and {{ linkvhls }} are not directly known to each other in advance, they publish and retrieve key material from a third party, the {{ linkta }}, via ITI-YY1 and ITI-YY2 transactions. This is illustrated in Figure X.X.X.X-1.


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
| {{ linkvhlr }} | {{ linksubmitpki }}          | Initiator              | R          | ITI TF-2: 3.YY1 |
|                | {{ linkretrievepki }}        | Initiator              | R          | ITI TF-2: 3.YY2 |
|                | {{ linkprovidevhl }}         | Responder              | R          | ITI TF-2: 3.YY4 |
|                | {{ linkretrievemanifest }}   | Initiator              | R          | ITI TF-2: 3.YY5 |
| {{ linkvhls }} | {{ linksubmitpki }}          | Initiator              | R          | ITI TF-2: 3.YY1 |
|                | {{ linkretrievepki }}        | Initiator              | R          | ITI TF-2: 3.YY2 |
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

#### XX.1.2.1 Submit PKI Material [ITI-YY1]

This transaction is used by a {{ linkvhlr }} or {{ linkvhls }} to submit PKI material to a {{ linkta }}. The submitted material includes public keys and associated metadata for validation and inclusion in the Trust List.

For more details see the detailed [transaction description](ITI-YY1.html)

This transaction is captured as the following requirements:
* [Initiate Submit PKI Material Request](Requirements-InitiateSubmitPKIMaterialRequest.html)
* [Respond to Submit PKI Material Request](Requirements-RespondtoSubmitPKIMaterialRequest.html)

#### XX.1.2.2 Retrieve Trust List [ITI-YY2]

This transaction is used by a {{ linkvhlr }} or {{ linkvhls }} to retrieve a Trust List from a {{ linkta }}. Received key material should be distinguished by the participating jurisdiction, use case context, and key usage. 

For more details see the detailed [transaction description](ITI-YY2.html)

This transaction is captured as the following requirements:
* [Initiate Retrieve Trust List Request](Requirements-InitiateRetrieveTrustListRequest.html)
* [Respond to Retrieve Trust List Request](Requirements-RespondtoRetrieveTrustListRequest.html)

#### XX.1.2.3 Generate VHL [ITI-YY3]

This transaction is used by a {{ linkvhlh }} to request that a {{ linkvhls }} generate a VHL. A {{ linkvhls }} may optionally record the consent of the individual to share their information under the Record Consent option. A {{ linkvhls }} may optionally create an audit trail of the VHL creation under the Audit Event option. The individual shall trust that the {{ linkvhls }} has been authorized by its jurisdiction to authorize and provide access to health documents.   

For more details see the detailed [transaction description](ITI-YY3.html)

This transaction is captured as the following requirements:
* [Initiate VHL Generation Request](Requirements-InitiateVHLGenerationRequest.html)
* [Respond to VHL Generation Request](Requirements-RespondtoGenerateVHLRequest.html)

#### XX.1.2.4 Provide VHL [ITI-YY4]

This transaction is initiated by a {{ linkvhlh }} to transmit a VHL to a {{ linkvhlr }}. Depending on the use case and context, the VHL may be rendered and transmitted through various mechanisms, such as QR code, Verifiable Credentials, Bluetooth, or near-field communication protocols. These mechanisms are described in [Volume 3](volume-3.html).

For more details see the detailed [transaction description](ITI-YY4.html)

This transaction is captured as the following requirements:
* [Provide VHL](Requirements-ProvideVHL.html)
* [Respond to Provide VHL](Requirements-RespondtoProvideVHL.html)

#### XX.1.2.5 Retrieve Manifest [ITI-YY5]

This transaction is initiated by a {{ linkvhlr }} to retrieve a document manifest from a {{ linkvhls }} using a previously validated VHL as authorization. The transaction is conducted over a secure channel as defined by ATNA, with mutual authentication of both parties.

For more details see the detailed [transaction description](ITI-YY5.html)

This transaction is captured as the following requirements:
* [Request VHL Documents](Requirements-RequestVHLDocuments.html)

<a name="actor-options"> </a>

## XX.2  Actor Options

Options that may be selected for each actor in this implementation guide are listed in Table XX.2-1 below. Dependencies between options when applicable are specified in notes.

<p id ="tXX.2-1" class="tableTitle">Table XX.2-1: Actor Options</p>

| Actor          | Option Name               |
|----------------|---------------------------|
| {{ linkvhlr }} | Submit PKI Material       |
| ^              | Verify Document Signature |
| {{ linkvhls }} | Submit PKI Material       |
| ^              | Record Consent            |
| ^              | Audit Event               |
{: .grid}


### XX.2.1 Submit PKI Material Option

In this option the {{ linkvhlr }} or {{ linkvhls }}, as part of establishing trust within the trust network, shall submit PKI material to the {{ linkta }}. This material includes public keys and associated metadata that will be included in the Trust List for verification by other participants in the trust network.

This option is captured in the following business requirement:
* [Establish Trust](Requirements-EstablishTrust.html)

### XX.2.2 Verify Document Signature Option

In this option the {{ linkvhlr }}, after receipt of a digitally signed document from a {{ linkvhls }}, shall verify the digital signature using previously retrieved PKI material. This key material may or may not be distributed under the same trust network under which the VHL was distributed. This key material may or may not be the same key material that was used to verify the VHL.

See cross-profile considerations for a discussion of the relationship of this option to the IHE Document Signature profile.

This option is captured in the following business requirement:
* [Verify Document Signature](Requirements-VerifyDocumentSignature.html)

### XX.2.3 Record Consent Option

In this option the {{ linkvhls }} acts as a Consent Recorder from the Privacy Consent on FHIR (PCF) profile. In this option, the {{ linkvhls }} SHALL initiate an [Access Consent: ITI-108](https://profiles.ihe.net/ITI/PCF/ITI-108.html) transaction as part of the Expected Actions after receipt of a Generate VHL request. The Access Consent transaction is used to record the consent declarations by the VHL Holder for the sharing of the (set of) health document(s) by the {{ linkvhls }} to any authorized {{ linkvhlr }} within the trust network for a specified use case.

This option is captured in the following business requirement:
* [Record Consent](Requirements-RecordConsent.html)

### XX.2.4 Audit Event Option

In this option the {{ linkvhls }} records an audit event for critical events in the access of health documents including:
* Request for the generation of a VHL by a VHL Holder; and
* Request for access to a (set of) health document(s) by a {{ linkvhlr }}.

This option is captured in the following business requirement:
* [Record Access To Health Data](Requirements-RecordAccessToHealthData.html)


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

A **Verifiable Health Link (VHL)** is a mechanism that enables individuals to share access to health documents in a secure, auditable, and configurable manner. Sharing options may include **limited-time access**, **PIN-protected retrieval**, or **ongoing access** to a longitudinal dataset that may evolve over time. VHLs can be rendered as QR codes or downloaded to a user's device, supporting patient-mediated data sharing and enhancing interoperability across healthcare systems.

### XX.4.2 Use Cases

(Continue with all use cases as before, ending with...)

This use case has the following business requirement:
* [Establish Trust](Requirements-EstablishTrust.html)

#### XX.4.2.6 Use Case #6: EU Vaccination Card

The [European Vaccination Card (EVC)](https://euvabeco.eu/news/european-vaccination-card-evc-a-citizen-held-card-to-foster-informed-decision-making-on-vaccination-and-improve-continuity-of-care-across-the-eu/) is a citizen-held card to foster informed decision-making on vaccination, and improve continuity of care across the EU.

The EVC will allow "Member States to bilaterally verify the authenticity of digital records through an interoperable trust architecture. While similar to the EU Digital COVID Certificate in being a portable vaccination record, the EVC serves a different purpose. Unlike the certificate, which often fulfilled legal or health mandates, the EVC is specifically designed to empower individuals by granting them control over their vaccination information. This empowerment is crucial for ensuring continuity of care for those crossing borders or transitioning between healthcare systems."

The EVC will operate in the context of the European Health Data Spaces that requires detailed information on access the health data to be recorded.

<figure >
  <img src="ehds_legal.png" caption="Figure X.X.X.X-8: European Health Data Spaces" style="width:45em; max-width:100%"/>
  <p id="fX.X.X.X-8" class="figureTitle">Figure X.X.X.X-8: European Health Data Spaces </p>
</figure>

For more information see Regulation (EU) 2025/327 of the European Parliament and of the Council of 11 February 2025 on the European Health Data Space and amending Directive 2011/24/EU and Regulation (EU) 2024/2847. Specifically:
* [ANNEX II - Essential requirements for the harmonised software components of EHR systems and for products for which interoperability with EHR systems has been claimed](https://eur-lex.europa.eu/eli/reg/2025/327/oj#anx_II)
* [Article 9 - Right to obtain information on accessing data](https://eur-lex.europa.eu/eli/reg/2025/327/oj#art_9)

This use case has the following business requirement:
* [Record Access To Health Data](Requirements-RecordAccessToHealthData.html)

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
