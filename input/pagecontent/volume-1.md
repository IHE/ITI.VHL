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
| {{ linkvhlh }} | QR Code Rendering         |
| ^              | Deep Link Sharing         |
| {{ linkvhlr }} | QR Code Scanning          |
| ^              | Deep Link Processing      |
| ^              | Verify Document Signature |
| {{ linkvhls }} | QR Code Rendering         |
| ^              | Deep Link Sharing         |
| ^              | Record Consent            |
| ^              | Audit Event               |
{: .grid}

Note 1: VHL Holder and VHL Sharer SHALL support at least one VHL rendering option (QR Code Rendering or Deep Link Sharing).

Note 2: VHL Receiver SHALL support at least one VHL processing option (QR Code Scanning or Deep Link Processing) that corresponds to the rendering option(s) used by VHL Holders.

### XX.2.1 Trust Establishment for VHL Sharer and VHL Receiver

VHL Sharer and VHL Receiver actors have two approaches to establish trust with the {{ linkta }}:

**Approach 1: DID-based Trust Establishment (Recommended)**
- Implement ITI-YY1 Submit PKI Material with DID
- Implement ITI-YY2 Retrieve Trust List with DID
- Enables interoperability testing at IHE Connectathons
- Provides standardized, jurisdiction-independent trust establishment
- Follows W3C DID Core specification

**Approach 2: Alternative Trust Establishment**
- Do not implement ITI-YY1 or ITI-YY2
- Use jurisdiction-specific PKI exchange mechanisms (out of scope for this profile)
- Cannot participate in IHE Connectathon testing for trust establishment
- Must document mechanisms in IHE Integration Statement
- Implementation-specific interoperability requirements

**Interoperability Testing:**

The VHL Profile defines trust establishment through the DID-based transactions ITI-YY1 and ITI-YY2. While these transactions are optional for VHL Sharer and VHL Receiver actors, they represent the ONLY standardized mechanism for demonstrating interoperability at IHE Connectathons.

Implementations using alternative trust establishment mechanisms:
- Are conformant to this profile
- May be appropriate for specific jurisdictional deployments
- Cannot demonstrate cross-jurisdiction interoperability at Connectathons
- SHALL document their trust establishment approach in their IHE Integration Statement

**IHE RECOMMENDS** that implementations support ITI-YY1 and ITI-YY2 to maximize interoperability potential.

### XX.2.2 QR Code Rendering Option

The QR Code Rendering Option enables the {{ linkvhlh }} or {{ linkvhls }} to render a VHL as a QR code that can be displayed on a screen or printed on paper.

Actors claiming the QR Code Rendering Option SHALL:
- Generate QR codes conforming to ISO/IEC 18004:2015
- Encode the complete `shlink:/` URL string in the QR code
- Use Error Correction Level L (Low) - approximately 7% error correction
- Generate QR codes in PNG or SVG format
- Ensure QR codes are of sufficient size and quality for reliable scanning (minimum 2cm x 2cm when printed)
- Include adequate quiet zone (white border) around the QR code

This option is suitable for:
- In-person encounters where the VHL Holder can display their device to the VHL Receiver
- Printed materials such as health cards or discharge summaries
- Walk-in clinics, emergency departments, and point-of-care scenarios

See ITI-YY3 Section 2:3.YY3.4.2.3 for detailed QR code generation requirements.

### XX.2.3 Deep Link Sharing Option

The Deep Link Sharing Option enables the {{ linkvhlh }} or {{ linkvhls }} to share a VHL as an HTTPS URL that can be transmitted via secure messaging, email, or other electronic communication channels.

Actors claiming the Deep Link Sharing Option SHALL:
- Generate VHLs as complete HTTPS URLs with the `shlink:/` prefix
- Ensure URLs are transmitted over secure channels
- Support URL formats compatible with standard web browsers and mobile applications

This option is suitable for:
- Telehealth and remote consultation scenarios
- Asynchronous care coordination
- Sharing via secure messaging platforms or patient portals
- Email transmission (when appropriately secured)

VHL Holders and VHL Sharers using this option SHOULD:
- Include expiration timestamps in VHLs to limit the window of potential forwarding
- Consider single-use VHLs for high-security scenarios
- Inform users about the risks of unintended forwarding

### XX.2.4 QR Code Scanning Option

The QR Code Scanning Option enables the {{ linkvhlr }} to scan and decode QR codes containing VHLs.

Actors claiming the QR Code Scanning Option SHALL:
- Support scanning of QR codes conforming to ISO/IEC 18004:2015
- Decode QR codes containing `shlink:/` URLs
- Extract and validate the VHL payload according to the decoding process specified in ITI-YY4 Section 2:3.YY4.4.1.3
- Handle QR codes displayed on screens or printed on paper
- Provide appropriate user feedback during the scanning process

The QR Code Scanning process is detailed in ITI-YY4 Expected Actions for VHL Receiver.

### XX.2.5 Deep Link Processing Option

The Deep Link Processing Option enables the {{ linkvhlr }} to receive and process VHLs transmitted as HTTPS URLs.

Actors claiming the Deep Link Processing Option SHALL:
- Accept VHL URLs with `shlink:/` prefix via secure channels
- Parse and validate the URL structure
- Extract and decode the VHL payload according to the process specified in ITI-YY4
- Handle URLs received via secure messaging, email, or other electronic means

This option is suitable for receiving VHLs in telehealth and asynchronous care scenarios.

### XX.2.6 Verify Document Signature Option

In this option the {{ linkvhlr }}, after receipt of a digitally signed document from a {{ linkvhls }}, shall verify the digital signature using previously retrieved PKI material. This key material may or may not be distributed under the same trust network under which the VHL was distributed. This key material may or may not be the same key material that was used to verify the VHL.

See cross-profile considerations for a discussion of the relationship of this option to the IHE Document Signature profile.

This option is captured in the following business requirement:
* [Verify Document Signature](Requirements-VerifyDocumentSignature.html)

### XX.2.7 Record Consent Option

In this option the {{ linkvhls }} acts as a Consent Recorder from the Privacy Consent on FHIR (PCF) profile. In this option, the {{ linkvhls }} SHALL initiate an [Access Consent: ITI-108](https://profiles.ihe.net/ITI/PCF/ITI-108.html) transaction as part of the Expected Actions after receipt of a Generate VHL request. The Access Consent transaction is used to record the consent declarations by the VHL Holder for the sharing of the (set of) health document(s) by the {{ linkvhls }} to any authorized {{ linkvhlr }} within the trust network for a specified use case.

This option is captured in the following business requirement:
* [Record Consent](Requirements-RecordConsent.html)

### XX.2.8 Audit Event Option

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

A **Verifiable Health Link (VHL)** is a mechanism that enables individuals to share access to health documents in a secure, auditable, and configurable manner. Sharing options may include **limited-time access**, **PIN-protected retrieval**, or **ongoing access** to a longitudinal dataset that may evolve over time. VHLs can be rendered as QR codes or downloaded to a user’s device, supporting patient-mediated data sharing and enhancing interoperability across healthcare systems.

#### XX.4.2 Use Cases

##### XX.4.2.1 Use Case #1: Holder Requests Generation of a Verifiable Health Link

A patient uses a digital health application to request a shareable summary of their health information, intended for use by a new healthcare provider or other interested.

###### XX.4.2.1.1 Scenario Narrative

**Ms. SJ**, age 37, recently relocated within her province after a complex pregnancy. She is currently managing hypertension and Type 2 diabetes and is seeking continuity of care at a new primary care clinic. Through a provincial patient portal, she accesses her personal health information and elects to generate a Verifiable Health Link (VHL) for her new provider.

The application guides Ms. SJ through privacy and security options: she is presented with a consent form, the ability to set a PIN, and an expiration time for the VHL. Once she completes the required steps, the system assembles a health summary (e.g., medications, encounters, diagnoses) and generates a VHL encoded in a QR code, which is displayed on her device. She is also given the option to print the QR code. Ms. SJ is now ready for her upcoming appointment.

###### XX.4.2.1.2 Process Flow – Generate VHL**

**Preconditions:**
- The patient has access to a jurisdictionally supported patient portal or mobile application that allows the generation of a VHL referencing a patient summary.
    
**Main Flow:**

1. The patient or authorized caregiver logs into the patient-facing application.
2. The user navigates to a section offering the ability to generate a shareable health summary.
3. The system presents privacy and security options, which may include:
    - Acceptance of a consent statement
    - Setting a PIN or passcode
    - Selecting a validity period
    - Scoping the data to be included
4. The user reviews and confirms the selected sharing options.
5. If the user consents:
    - The application submits a request to the VHL issuer (e.g., the jurisdictional system or EHR backend) with the defined parameters.
    - The VHL issuer generates a signed VHL referencing the selected documents.
6. The system returns the VHL, rendering it as a QR code or downloadable artifact.
7. If the user declines, the process is terminated and no VHL is created.
    
**Postconditions:**
- A signed Verifiable Health Link (VHL) is created and rendered as a QR code or URL.  
- The patient is able to display, print, or transmit the VHL for use by authorized third parties (e.g., the receiving healthcare provider). 




#### XX.4.2.2 Use Case \#2: Holder Generates and Uses a VHL 

The patient provides access to their encrypted patient summary via the QR code on their mobile device or by sharing a secure VHL, (e.g., via email) at the point of care (e.g., walk-in clinic, emergency department).  The healthcare provider scans the QR code or accesses the VHL shared by the patient, addressing any security prompts, such as entering a passcode if required, and then may proceed to view/utilize and consume the patient summary.

##### XX.4.2.2.1 Generate and Use VHL Case Description

##### XX.4.2.2.2 Generate and Use VHL Process Flow

**Pre-conditions**:
- Patient has a QR code or VHL with access to a patient summary.
- HCP has the necessary tools to scan the QR code or access the VHL (e.g., a QR code scanner, Health Information System).
- VHL Sharer and VHL Receiver have shared their public keys to a trust network
- VHL Receiver is in the same trust network as as the VHL Sharer.

**Main Flow**:
- Patient has a medical encounter with a health care provider (HCP) virtually or in-person to obtain health care services. 
- Patient displays their patient summary QR code on their mobile device or shares a verifiable health link (e.g., via email) with the HCP and provides them with the passcode/PIN that they created (in Part A of this use case) to access the patient summary.
- HCP scans the QR code or accesses the VHL in a browser to retrieve the patient summary. 
- HCP is presented with applicable privacy and/or security form and they enter required security prompts (e.g., passcode, expiration time frame etc.,) according to jurisdictional policies.
- VHL Receiver verifies the provenance of the shared link and confirms that the link originated from a trusted source before making a request to retrieve health document
- VHL Sharer verifies the manifest request was made by a trusted organization/entity
- VHL Sharer verifies the information submitted by the HCP in response to the security prompts (e.g., passcode/PIN). 
  - If the security prompts are correct, proceed to retrieve patient summary.
  - If the security prompts are incorrect, VHL Sharer denies access and prompts the user to re-submit the security prompts. If multiple failed attempts occur or the HCP abandons the process, the request for the patient summary is terminated. Process complete.
- VHL Receiver retrieves the patient summary. Note: This process typically involves two steps: initially, a manifest file is provided containing the link to the patient summary. The patient summary is then retrieved in a subsequent step.
- HCP views and optionally saves/imports the patient summary in their clinical system.

**Post-conditions:**

HCP has access to Patient Summary.


<figure >
  <div style="width:38em; max-width:100%;">
    {%include usecase-generate-use-vhl-single-doc-processflow.svg%}
  </div>
  <p id="fX.X.X.X-3" class="figureTitle">Figure X.X.X.X-3: Use Case Issue and Utilize VHL for a Single Health Document Process Flow</p>
</figure>

<figure >
  <div style="width:35em; max-width:100%;">
     {%include usecase-generate-use-vhl-processflow.svg%}
  </div>
  <p id="fX.X.X.X-2" class="figureTitle">Figure X.X.X.X-2: Use Case Issue and Utilize VHL for a (set of) Health Document(s) Process Flow</p>
</figure>

This use case has the following business requirement:
* [Establish Trust](Requirements-EstablishTrust.html)
* [Record Access To Health Data](Requirements-RecordAccessToHealthData.html)


#### XX.4.2.3 Use Case \#3: Exchange Key Material 

##### XX.4.2.3.1 Exchange Key Material  Use Case Description

##### XX.4.2.3.2 Exchange Key Material  Process Flow

**Pre-conditions**:

**Main Flow**:

**Post-conditions:**

<figure >
  <div style="width:35em; max-width:100%;">
  {%include usecase-exchange-key-material-processflow.svg%}
  </div>
  <p id="fX.X.X.X-1" class="figureTitle">Figure X.X.X.X-1: Use Case Issue and Utilize VHL Process Flow</p>
</figure>

#### XX.4.2.4 Use Case \#4: Holder requests to destroy a VHLink

##### XX.4.2.4.1 simple name Use Case Description

##### XX.4.2.4.2 simple name Process Flow

**Pre-conditions**:

**Main Flow**:

**Post-conditions:**




#### XX.4.2.5 Use Case \#5: WHO Global Digital Health Certification Network

The World Health Organization (WHO) operates a trust network, the Global Digital Health Certification Network (GDHCN), for use by public sector health jurisdictions.  The WHO GDHCN uses the notion of a Trust Domain which is defined by a set of:
* use cases and business processes related to the utilization of Verifiable Digital Health Certificates;
* open, interoperable technical specifications that define the applicable Trusted Services and verifiable digital health certificates for the use case; and
* policy and regulatory standards describing expected behavior of participants for to the use case.

The PKI operated by the WHO supports a variety of trust domains, two of which are described below. 


##### XX.4.2.5.1 Hajj Pilgrimage Use Case Description

During the Hajj pilgrimage the Kingdom of Saudi Arabia (KSA) hosts approximately two million pilgrims from across the globe as part of a mass gathering event.  Temporary hospitals and clinics, comprising over a thousand beds, are established to provide care to the pilgrims over the ?four? week period of Hajj.

Starting with Hajj XXXX, in 2024, pilgrims from Oman, Malaysia and Indonesia were able to share their health records utilizing the International Patient Summary (IPS) with verification of health documents provided through the GDHCN infrastructure.

Pilgrims begin their journey in their home country where they receive a health check and are educated on the use of QR codes (a version of Verifiable Health Links) and provide the consent to share their health records.  This consent may be provided verbally or recorded digitally.  When recorded, there are two notions of consent recorded: 
- for their home country in which they agree that health records from their home country can be shared with appropriate authorities during Hajj
- for KSA is to permit utilization of these health records within the Saudi System. These consent records are recorded into the IPS Advanced Directives section and are included with the IPS when it is shared.  

The verifiable health link is provided by their home jurisdiction during their health check as a QR code.   
Depending on the digital infrastructure pilgrim's origin country, jurisdictional policies and digital capabilities (e.g. access to smart phones) of the pilgrim's origin country, the verifiable health link may be:
* generated and printed on the pilgrim's health card and distributed to the pilgrim at the time of the health check; or
* provisioned to the pilgrim through an existing digital health platform or wallet.
For similar reasons, the verifiable health link may refer to:
* an instance of the IPS rendered as a PDF;
* an instance of the IPS rendered as JSON; or
* a folder containing at least the PDF of JSON rendering of the IPS as well associated digital signatures.


During a care encounter in KSA, the pilgrim provides their verifiable health link as a QR code to their care provider.  Once a VHL is shared by a pilgrim during a care encounter in KSA:
* the VHL is verified through the GDHCN infrastructure
* an mTLS connection is established between the KSA EMRs and the origin country national infrastructure using key material exchanged via GDHCN
* a manifest of IPS related files including a PDF and JSON renderings and associated digital signatures
* The EMR retrieves the requisite files,

Some of the challenges faced during the pilot implementation, though not necessarily to be taken up in this profile, include:
- while not the main point of security, leveraging the PIN is a weakness, need to enable better options for future consideration (e.g. biometrics, other authorization methods)
- in planning for expansion to umrah and general tourism, there will not in general be a health check which presents some process challenges such as not having a encounter point to record consent prior to a visit.  
- how to scale and automate some of the health checks  (e.g. are vaccinations sufficient) using verifiable health documents (e.g. the IPS). 

<figure >
  <div>
  <img src="hajj-diagram.png" caption="Figure X.X.X.X-2: Hajj Pilgrimage" style="width:42em; max-width:100%;"/>
  </div>
    <p id="fX.X.X.X-1" class="figureTitle">Figure X.X.X.X-1: Pilgrim's Journey Hajj Health Card </p>
</figure>

This use case has the following business requirement:
* [Establish Trust](Requirements-EstablishTrust.html)
* [Create Trusted Channel](Requirements-CreateTrustedChannel.html)

##### XX.4.2.5.2 Pan-American Highway for Health Use Case Description

In the region of the Americas,  "countries identified several priorities for cross-border digital
health, including optimizing available human resources through international
telehealth, validating digital certificates, ensuring continuity of care, and regional
resilience to face health emergencies by sharing data for public health. During the
IDB-PAHO co-led event, RELACSIS 4.0,1 a plan was launched to strengthen regional
digital health services and resilience, through regional data exchange and policy
harmonization. Sixteen countries successfully exchanged digital vaccine certificates
(COVID-19, Polio, Measles, and Yellow Fever) and critical clinical information
(diagnosis, allergy, and prescription information) using international standards during
the 2nd Regional LACPASS Connectathon.2 Regional bodies and network such as the
Council of Ministers of Health of Central America and the Dominican Republic
(COMISCA), The Caribbean Public Health Agency (CARPHA), and the LAC Digital
Health Network (RACSEL) have all identified cross-border data sharing as a priority."  
[footnote](https://ewsdata.rightsindevelopment.org/files/documents/46/IADB-RG-T4546_BBZnmFh.pdf)

The Pan American Health Organization (PAHO) and the InterAmerican Development Bank (IADB) are supporting the development of policues and digital infrastructrue to support this need. One particular priority is to improve the continuity of care for internal migrants within the region, by ensuring individuals have access to and can share their vaccination records and the International Patient Summary.

The Pan-American Highway for Health (PH4H)  "aims to provide patients with better healthcare services, regardless of their location. It will also enhance healthcare for those who move temporarily for work
or study, as well as for migrants, by enabling them to share their health history, thus
improving their employability and access to education. "  
[footnote](https://ewsdata.rightsindevelopment.org/files/documents/46/IADB-RG-T4546_BBZnmFh.pdf)

While there currently there is no single legal framework that broadly enables data sharing across the region, there are sub-regional networks (e.g. COMISCA, CARPHA) that have policies that can be leveraged in the short term while neccesary data sharing agreements are developed.   Thus, individuals in this region will need to be able to move through overlapping trust networks.



<figure >
  <img src="PH4H.png" caption="Figure X.X.X.X-2: Pan-American Highway for Digital Health Goals" style="width:38em; max-width: 100%;"/>
  <p id="fX.X.X.X-1" class="figureTitle">Figure X.X.X.X-1: Pan-American Highway for Digital Health Goals </p>
</figure>


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

#### XX.4.2.7 Use Case #7: Smart Health Links
Note: Not sure if we want to include "Verifiable" health link as an option and Smart Health Link as another option. If so, we should recap SHL use case here. (No pre-coordination of trust)

#### XX.4.2.8 Use Case #8: EU Digital Identity Wallet - Unlinkability

The European Union's digital identity regulation establishes requirements for the European Digital Identity Wallet (EUDIW) that ensure user privacy through unlinkability. These requirements are particularly relevant when health attestations are shared through digital wallets.

##### XX.4.2.8.1 Unlinkability Use Case Description

Article 5a(16) of [Regulation (EU) No 910/2014 as amended](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A02014R0910-20241018) establishes critical privacy requirements for the European Digital Identity Wallet:

> **Article 5a(16):** The technical framework of the European Digital Identity Wallet shall:
> 
> (a) not allow providers of electronic attestations of attributes or any other party, after the issuance of the attestation of attributes, to obtain data that allows transactions or user behaviour to be tracked, linked or correlated, or knowledge of transactions or user behaviour to be otherwise obtained, unless explicitly authorised by the user;
> 
> (b) enable privacy preserving techniques which ensure unlinkability, where the attestation of attributes does not require the identification of the user.

When health information is shared through a digital wallet infrastructure, these requirements mandate that:

1. **No post-issuance tracking**: After a health attestation (such as vaccination records or health certificates) is issued to a wallet, the issuing {{ linkvhls }} SHALL NOT be able to track when, where, or with whom the holder shares that attestation, unless explicitly authorized by the user.

2. **Unlinkability of presentations**: When a {{ linkvhlh }} presents health attestations to different {{ linkvhlr }}s (e.g., different healthcare providers or venues), those presentations SHALL NOT be linkable to each other by the {{ linkvhls }} or any third party, preventing behavioral profiling.

3. **Privacy-preserving verification**: The {{ linkvhlr }} can verify the authenticity and validity of the health attestation through the trust network without revealing to the {{ linkvhls }} that a verification occurred or identifying which specific presentation is being verified.

##### XX.4.2.8.2 Unlinkability Process Flow

**Pre-conditions:**
- The {{ linkvhlh }} has obtained health attestations (e.g., vaccination records) in their digital wallet
- The {{ linkvhls }} has issued verifiable credentials that support privacy-preserving presentation
- The {{ linkvhlr }} participates in the trust network and can verify credentials
- Privacy-preserving cryptographic techniques are implemented (e.g., selective disclosure, zero-knowledge proofs, or unlinkable signatures)

**Main Flow:**

1. **Issuance Phase:**
   - {{ linkvhlh }} requests health attestation from {{ linkvhls }}
   - {{ linkvhls }} issues credential using privacy-preserving techniques that enable unlinkable presentations
   - Credential is stored in {{ linkvhlh }}'s digital wallet
   - {{ linkvhls }} does NOT maintain presentation-tracking capabilities

2. **First Presentation:**
   - {{ linkvhlh }} presents health attestation to {{ linkvhlr }} A (e.g., Hospital A)
   - {{ linkvhlr }} A verifies attestation against trust network
   - Verification occurs without notifying {{ linkvhls }} of the specific presentation
   - {{ linkvhlr }} A cannot link this presentation to other presentations by the same holder

3. **Second Presentation:**
   - {{ linkvhlh }} presents health attestation to {{ linkvhlr }} B (e.g., Pharmacy B)
   - {{ linkvhlr }} B verifies attestation against trust network
   - This presentation is cryptographically unlinkable from the presentation to {{ linkvhlr }} A
   - {{ linkvhls }} cannot determine that both presentations came from the same credential

4. **Trust Network Operation:**
   - {{ linkta }} maintains trust list for verification
   - Verification queries do NOT reveal which specific credentials are being presented
   - No party can correlate presentations across different {{ linkvhlr }}s

**Post-conditions:**
- {{ linkvhlh }} has successfully shared health information with multiple parties
- {{ linkvhls }} cannot track usage patterns or build behavioral profiles
- {{ linkvhlr }}s can verify authenticity but cannot collude to track the {{ linkvhlh }}
- User privacy is preserved through technical unlinkability measures

##### XX.4.2.8.3 Implementation Considerations

To achieve unlinkability while maintaining verifiability, implementations MAY use:

- **Selective Disclosure**: Allow holders to present only necessary attributes without revealing the entire credential
- **Zero-Knowledge Proofs**: Enable verification of claims without revealing underlying data
- **Unlinkable Signatures**: Use cryptographic techniques (e.g., BBS+ signatures, anonymous credentials) that prevent correlation of signatures across presentations
- **Batch Issuance**: Issue credentials in batches to prevent timing correlation
- **Minimized Identifiers**: Avoid including persistent identifiers that could enable tracking

The VHL profile supports these requirements by:
- Enabling the {{ linkvhls }} to issue credentials that can be presented without callback to the issuer
- Supporting verification through the trust network without requiring issuer notification
- Allowing jurisdictions to implement privacy-preserving cryptographic schemes appropriate to their regulatory requirements

<figure>
  <img src="unlinkability-diagram.png" caption="Figure X.X.X.X-9: Unlinkable Health Credential Presentations" style="width:45em; max-width:100%"/>
  <p id="fX.X.X.X-9" class="figureTitle">Figure X.X.X.X-9: Unlinkable Health Credential Presentations</p>
</figure>

This use case has the following business requirements:
* [Establish Trust](Requirements-EstablishTrust.html)
* Privacy-preserving credential presentation (implementation-specific)


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
