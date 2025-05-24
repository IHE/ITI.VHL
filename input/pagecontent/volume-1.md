
{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}
{% assign linkgeneratevhl = '<a href="volume-2.html#GenerateVHL">Generate VHL</a>' %}
{% assign linkpublishpki = '<a href="volume-2.html#SubmitPKIMaterial">Submit PKI Material</a>' %}
{% assign linkretrievepki = '<a href="volume-2.html#RetrievePKIMaterial">Retreive PKI Material</a>' %}
{% assign linkprovidevhl = '<a href="volume-2.html#ProvideVHL">Provide VHL</a>' %}
{% assign linkrequestdocument = '<a href="volume-2.html#RequestDocument">Request Document</a>' %}
{% assign linkrequestdocuments = '<a href="volume-2.html#RequestDocuments">Request Documents</a>' %}


As individuals move within or across jurisdictional boundaries, they may wish to provide access to clinical or other health-related documents to a defined set of trusted parties who are authorized to access their records. This access may be granted for a single document or for a set of related documents.

The **Verifiable Health Link (VHL)** profile defines a set of protocols and patterns that enable health documents to be shared in a verifiable and auditable manner—both within and across jurisdictions. Central to this profile is the concept of the **VHL**, a signed artifact that an individual (the **VHL Holder**) can use to authorize access to their health records from an issuer (the {{ linkvhls }}) to a third party (the {{ linkvhlr }}). The mechanisms by which the VHL is held by the Holder or transmitted to the {{ linkvhlr }} are out of scope for this profile.

VHL leverages **Public Key Infrastructure (PKI)** to establish trust among actors and to verify the authenticity and integrity of exchanged artifacts.

Within the VHL trust model, both the {{ linkvhlr }} and the {{ linkvhls }} are participants in a shared **trust network**. This network enables:
- Verification of the origin of a health document,
- Validation of any access mechanism (i.e., the VHL itself),
- Authentication of requests that seek to utilize these mechanisms.
    
The authority to participate in the trust network is governed by each actor’s **jurisdiction**, which determines eligibility and onboarding criteria. Verification of this authorization is achieved through PKI, specifically through the validation of credentials issued or endorsed by a **Trust Anchor** ({{ linkta }}).

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
		<li> {{ linkpublishpki }}</li>
		<li> {{ linkretrievepki }}</li>
		<li> {{ linkgeneratevhl }} </li>
		<li> {{ linkrequestdocuments }}</li>
		<li> {{ linkrequestdocument }}</li>
		<li> {{ linkprovidevhl }}</li>
	</ul>
  </li>
</ul>

As a pre-condition to transactions ITI-YY3, ITI-YY4 and ITI-YY5, the {{ linkvhlr }} and {{ linkvhls }} must exchange the appropriate PKI in order to verify their trust relationship at the time of the utlization of the VHL.  As the identities of the {{ linkvhlr }}  and {{ linkvhls }} are not directly know to each other in advance of a request to utilize a VHL, the {{ linkvhlr }} and {{ linkvhls }} publish and retrieve key material from a third party, the {{ linkta }}.    This is illustrated in Figure X.X.X.X-1


<figure >
  <div style="width:35em; max-width:100%;">
  {%include trust_interaction.svg%}
  </div>
  <p id="fX.X.X.X-2" class="figureTitle">Figure X.X.X.X-2: Use Case Issue and Utilize VHL for a (set of) Health Document(s) Process Flow</p>
</figure>

The process of a VHL Holder requesting a VHL to a set of health documents from a {{ linkvhls }} and subsequently sharing them to a {{ linkvhlr }} is illusrated in Figure X.X.X.X-2.



The interaction between a VHL Holder requesting a VHL to a single health document from a {{ linkvhls }} and subsequently sharing them to a {{ linkvhlr }} is illusrated in Figure X.X.X.X-2.


<figure >
  <div style="width:18em; max-width:100%;">
  {%include vhl_interaction.svg%}
  </div>
  <p id="fX.X.X.X-2" class="figureTitle" >Figure X.X.X.X-2: Use Case Issue and Utilize VHL for a (set of) Health Document(s) Process Flow</p>
</figure>



<br clear="all">

<p id ="tXX.1-1" class="tableTitle">Table XX.1-1: Profile Acronym Profile - Actors and Transactions</p>

| Actors         | Transactions                 | Initiator or Responder | Optionality| Reference                 |
|----------------|------------------------------|------------------------|------------|---------------------------|
| {{ linkta }}   | {{ linkpublishpki }}         | Responder              | R          | ITI TF-2: YY1 |
|                | {{ linkretrievepki }}        | Responder              | R          | ITI TF-2: YY2 |
| {{ linkvhlh }} | {{ linkgeneratevhl }}        | Initiator              | R          | ITI TF-2: YY3 |
|                | {{ linkprovidevhl }}         | Initiator              | R          | ITI TF-2: YY6 |
| {{ linkvhlr }} | {{ linkpublishpki }}         | Initiator              | R          | ITI TF-2: YY1 |
|                | {{ linkretrievepki }}        | Initiator              | R          | ITI TF-2: YY2 |
|                | {{ linkprovidevhl }}         | Responder              | R          | ITI TF-2: YY6 |
|                | {{ linkrequestdocuments }}   | Initiator              | R          | ITI TF-2: YY4 |
|                | {{ linkrequestdocument }}    | Initiator              | R          | ITI TF-2: YY5 |
| {{ linkvhls }} | {{ linkpublishpki }}         | Initiator              | R          | ITI TF-2: YY1 |
|                | {{ linkretrievepki }}         | Initiator              | R          | ITI TF-2: YY2 |
|                | {{ linkgeneratevhl }}        | Responder              | R          | ITI TF-2: YY3 |
|                | {{ linkrequestdocuments }}   | Responder              | R          | ITI TF-2: YY4 |
|                | {{ linkrequestdocuments }}   | Responder              | R          | ITI TF-2: YY5 |
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

#### XX.1.2.1 Submit PKI Material

This transactions is used by a {{ linkvhlr }} or {{ linkvhls }} to submit PKI material to a {{ linkta }}.

For more details see the detailed [transaction description](ITI-YY1.html)

This transaction is captured as the following requirement:
* [Submit PKI Material](Requirements-SubmitPKIMaterial.html)

{% assign requirement = site.data.Requirements-SubmitPKIMaterial  %}
{% include requirements-list-statements.liquid %}


#### XX.1.2.2 Receive PKI Material

This transactions is used by a {{ linkvhlr }} or {{ linkvhls }} to receive PKI material previously published to a {{ linkta }}. Received key material should be able to be distinguised by the participating jurisdiction, use case context, and key usage. 

For more details see the detailed [transaction description](ITI-YY2.html)

This transaction is captured as the following requirement:
* [Receive PKI Material](Requirements-ReceivePKIMaterial.html)

{% assign requirement = site.data.Requirements-ReceivePKIMaterial  %}
{% include requirements-list-statements.liquid %}


#### XX.1.2.3 Generate VHL

This transactions is used by a VHL Holder to request that a {{ linkvhls }} generate a VHL.  A {{ linkvhls }} may optionally record the consent of the individual to share their information under the Record Consent option. A {{ linkvhls }} may optionally create an audit trail of the creation of the VHL under the Audit Event option. The individual shall trust that {{ linkvhls }} has been authorized by its jurisidiction to authorize and provide access to health documents.   

For more details see the detailed [transaction description](generate_vhl.html)

This transaction is captured as the following requirement:
* [Generate VHL](Requirements-GenerateVHL.html)

{% assign requirement = site.data.Requirements-GenerateVHL  %}
{% include requirements-list-statements.liquid %}


#### XX.1.2.4 Request VHL Documents

This transactions is initiated by a {{ linkvhlr }} to request a set of health documents from a {{ linkvhls }}.  This transaction should be conducted in such a manner that the {{ linkvhlr }} and {{ linkvhls }} can validate one another's participation in the same trust network. The {{ linkvhls }} shall optionally be able to record an audit event for the access of the folder by the {{ linkvhlr }} upon the transaction request under the Audit Event option.


For more details see the detailed [transaction description](ITI-YY4.html)


This transaction is captured as the following requirement:
* [Request VHL Documents](Requirements-RequestVHLDocuments.html)

{% assign requirement = site.data.Requirements-RequestVHLDocuments  %}
{% include requirements-list-statements.liquid %}


#### XX.1.2.5 Request VHL Document

This transactions is initiated by a {{ linkvhlr }} to request a single health document from a {{ linkvhls }}.  This transaction should be conducted in such a manner that the {{ linkvhlr }} and {{ linkvhls }} can validate one another's participation in the same trust network.  The {{ linkvhlr }} shall optionally be able to validate that the veracity of the health document received through this transaction under the Verify Document Signature option.  The {{ linkvhls }} shall optionally be able to record an audit event for the access of the folder by the {{ linkvhlr }} upon the transaction request under the Audit Event option.

For more details see the detailed [transaction description](ITI-YY4.html)

This transaction is captured as the following requirement:
* [Request VHL Document](Requirements-RequestVHLDocuments.html)

{% assign requirement = site.data.Requirements-RequestVHLDocuments  %}
{% include requirements-list-statements.liquid %}


#### XX.1.2.6 Provide VHL

This transacation is initiated by a VHL Holder to transmit a VHL to the {{ linkvhlr }}.   Depending on the use case and context, the payload comprising the VHL may be rendered/serialized and transmitted through various mechanisms, for example as a QR-code, Verifiable Credentials, bluetooth or near-field communication protocols.  These mechanisms are described in [Volume 3](volume-3.html)


For more details see the detailed [transaction description](ITI-YY4.html)


This transaction is captured as the following requirement:
* [Provide VHL](Requirements-ProvideVHL.html)

<a name="actor-options"> </a>

{% assign requirement = site.data.Requirements-ProvideVHL  %}
{% include requirements-list-statements.liquid %}

## XX.2  Actor Options

Options that may be selected for each actor in this implementation guide, are listed in Table 3.2-1 below. Dependencies between options when applicable are specified in notes.

<p id ="tXX.1-1" class="tableTitle">Table XX.2-1: Actor Options</p>

| Actor        | Option Name               |
|--------------|---------------------------|
| {{ linkvhlr }} | Verify Document Signature |
| {{ linkvhls }}   | Record Consent            |
|              | Audit Event               |
{: .grid}


### XX.2.1 Verify Document Signature Option

In this option the {{ linkvhlr }}, after receipt of a digitally signed document from a {{ linkvhls }}, shall verify the digtial signature using previosuly retrieved PKI material.  This key material may or may not be distributed under the same trust network under which the VHL was distributed.  This key material may or may not be the same key material that was used to verify the VHL.

See cross-profile considerations for a discussion of the relationship of this option to the IHE Document Signature profile.


This option is captured in the following business requirement:
* [Verify Document Signature](Requirements-VerifyDocumentSignature.html)



### XX.2.2 Record Consent Option

In this option the {{ linkvhls }} acts a Consent Recorder from the Privacy Consent on FHIR (PCF) profile.  In this option, the {{ linkvhls }} SHALL initiate a [Access Consent : ITI-108)(https://profiles.ihe.net/ITI/PCF/ITI-108.html)
transaction as part of the Expected Actions after receipt of a Generate VHL request.   The Access Consent transaction is used to record the consent declarations by the VHL Holder for the sharing of the (set of) health document(s) by the {{ linkvhls }} to any authorized {{ linkvhlr }} within the trust network for a specified use case.

This option is captured in the following business requirement:
* [Record Consent](Requirements-RecordConsent.html)


### XX.2.3 Audit Event Option

In this option the {{ linkvhls }} records an audit event for critical events in the access of health documents including:
* Request for the generation of a VHL by a VHL Holder; and
* Request for access to a (set of) health document(s) by a {{ linkvhlr }}.


<a name="required-groupings"> </a>

This option is captured in the following business requirement:
* [Record Access To Health Data](Requirements-RecordAccessToHealthData.html)



## XX.3 Required Actor Groupings

*Describe any requirements for actors in this profile to be grouped
with other actors.*

*This section specifies all REQUIRED Actor Groupings (although
"required" sometimes allows for a selection of one of several). To
SUGGEST other profile groupings or helpful references for other profiles
to consider, use Section XX.6 Cross Profile Considerations. Use Section
X.5 for security profile recommendations.*

An actor from this profile (Column 1) shall implement all of the
required transactions and/or content modules in this profile ***in
addition to*** ***<u>all</u>*** of the requirements for the grouped
actor (Column 2) (Column 3 in alternative 2).

If this is a content profile, and actors from this profile are grouped
with actors from a workflow or transport profile, the Reference column
references any specifications for mapping data from the content module
into data elements from the workflow or transport transactions.

In some cases, required groupings are defined as at least one of an
enumerated set of possible actors; this is designated by merging column
one into a single cell spanning multiple potential grouped actors. Notes
are used to highlight this situation.

Section XX.5 describes some optional groupings that may be of interest
for security considerations and Section XX.6 describes some optional
groupings in other related profiles.

Two alternatives for Table XX.3-1 are presented below.

* If there are no required groupings for any actor in this profile,
    use alternative 1 as a template.
* If an actor in this profile (with no option), has a required
    grouping, use alternative 1.
* If any required grouping is associated with an actor/option
    combination in this profile, use alternative 2.

alternative 1 Table XX.3-1: Profile Name - Required Actor
Groupings

All actors from this profile should be listed in Column 1, even if
none of the actors has a required groupings. If no required grouping
exists, "None" should be indicated in Column 2. If an actor in a content
profile is required to be grouped with an actor in a transport or
workflow profile, it will be listed **with at least one** required
grouping. Do not use "XD\*" as an actor name.

In some cases, required groupings are defined as at least one of an
enumerated set of possible actors; to designate this, create a row for
each potential actor grouping and merge column one to form a single cell
containing the profile actor which should be grouped with at least one
of the actors in the spanned rows. In addition, a note should be
included to explain the enumerated set. See example below showing
Document Consumer needing to be grouped with at least one of XDS.b
Document Consumer, XDR Document Recipient or XDM Portable Media
Importer

The author should pay special consideration to security profiles in
this grouping section. Consideration should be given to Consistent Time
(CT) Client, ATNA Secure Node or Secure Application, as well as other
profiles. For the sake of clarity and completeness, even if this table
begins to become long, a line should be added for each actor for each of
the required grouping for security. Also see the ITI document titled
'Cookbook: Preparing the IHE Profile Security Section' at
<http://ihe.net/Technical_Frameworks/#IT> for a list of suggested IT and
security groupings.

<p id ="tXX.3-1" class="tableTitle">Table XX.3-1: Actor Groupings</p>

<table border="1" borderspacing="0" style='border: 1px solid black; border-collapse: collapse'>
<thead>
<tr class="header">
<th>this Profile Acronym Actor</th>
<th>Actor(s) to be grouped with</th>
<th>Reference</th>
<th>Content Bindings Reference</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Actor A</td>
<td><p><em>external Domain Acronym or blank</em></p>
<p><em>profile acronym/Actor</em></p>
<p><em>e.g., ITI CT / Time Client</em></p></td>
<td><p><em>TF Reference; typically from Vol 1</em></p>
<p><em>e.g., ITI-TF-1: 7.1</em></p></td>
<td>--</td>
</tr>
<tr class="even">
<td>Actor B</td>
<td>None</td>
<td>--</td>
<td>--</td>
</tr>
<tr class="odd">
<td><p>Actor C</p>
<p><em>In this example, Actor C shall be grouped with all three actors listed in column 2</em></p></td>
<td><p><em>external Domain Acronym or blank</em></p>
<p><em>profile acronym/Actor</em></p></td>
<td>--</td>
<td>See Note 1</td>
</tr>
<tr class="even">
<td></td>
<td><em>external Domain Acronym or blank profile acronym/Actor</em></td>
<td>--</td>
<td>See Note 1</td>
</tr>
<tr class="odd">
<td></td>
<td><p><em>external Domain Acronym or blank</em></p>
<p><em>profile acronym/Actor</em></p></td>
<td>--</td>
<td>See Note 1</td>
</tr>
<tr class="even">
<td><p>Actor D <em>(See note 1)</em></p>
<p><em>In this example, the note is used to indicate that the Actor D shall be grouped with one or more of the two actors of the two actors in column 2.</em></p></td>
<td><p><em>external Domain Acronym or blank</em></p>
<p><em>profile acronym/Actor</em></p></td>
<td>--</td>
<td>See Note 1</td>
</tr>
<tr class="odd">
<td></td>
<td><p><em>external Domain Acronym or blank</em></p>
<p><em>profile acronym/Actor</em></p></td>
<td>--</td>
<td>See Note 1</td>
</tr>
<tr class="even">
<td><p>Actor E</p>
<p><em>In rare cases, the actor to be grouped with must implement an option. An example is in column 2.)</em></p></td>
<td><p><em>external Domain Acronym or blank</em></p>
<p><em>profile acronym Actor</em></p>
<p><em>e.g., ITI RFD Form Filler with the Archive Form Option</em></p></td>
<td><p><em>TF Reference to the Option definition; typically from Vol 1</em></p>
<p><em>(e.g., ITI TF-1: 17.3.11)</em></p></td>
<td></td>
</tr>
<tr class="odd">
<td><em>e.g., Content Consumer (See Note 1)</em></td>
<td><em>ITI XDS.b / Document Consumer</em></td>
<td><em>ITI TF-1: 10.1</em></td>
<td><em>PCC TF-2:4.1 (See Note 2)</em></td>
</tr>
<tr class="even">
<td></td>
<td><em>ITI XDR / Document Recipient</em></td>
<td><em>ITI TF-1: 15.1</em></td>
<td><em>PCC TF-2:4.1 (See Note 2)</em></td>
</tr>
<tr class="odd">
<td></td>
<td><em>ITI XDM / Portable Media Importer</em></td>
<td><em>ITI TF-1: 16.1</em></td>
<td><em>PCC TF-2:4.1 (See Note 2)</em></td>
</tr>
<tr class="even">
<td><em>e.g., Content Consumer</em></td>
<td><em>ITI CT / Time Client</em></td>
<td><em>ITI TF-1: 7.1</em></td>
<td>--</td>
</tr>
</tbody>
</table>

Note 1: *This is a short note. It may be used to describe situations
where an actor from this profile may be grouped with one of several
other profiles/actors.*

Note 2: *A note could also be used to explain why the grouping is
required, if that is still not clear from the text above.*

alternative 2 Table XX.3-1: this Profile Acronym Profile

* Required Actor Groupings

All actors from this profile should be listed in Column 1. If no
required grouping exists, "None" should be indicated in Column 3.

Guidance on using the "Grouping Condition" column:

* If an actor has no required grouping, Column 2 should contain "--".
    See Actor A below.
* If an actor has a required grouping that is not associated with a
    profile option (i.e., it has no condition), column 2 should contain
    "Required". See Actor B below.
* Sometimes an option requires that an actor in this profile be
    grouped with an actor in another profile. That condition is
    specified in Column 2. See Actor C below.

<p id ="tXX.3-1" class="tableTitle">Table XX.3-1: Actor Groupings</p>

<table border="1" borderspacing="0" style='border: 1px solid black; border-collapse: collapse'>
<tbody>
<tr class="odd">
<td>this Profile Acronym Actor</td>
<td>Grouping Condition</td>
<td>Actor(s) to be grouped with</td>
<td>Reference</td>
</tr>
<tr class="even">
<td>Actor A</td>
<td>--</td>
<td>None</td>
<td>--</td>
</tr>
<tr class="odd">
<td>Actor B</td>
<td>Required</td>
<td><p><em>external Domain Acronym or blank profile acronym/Actor</em></p>
<p><em>e.g., ITI CT / Time Client</em></p></td>
<td><p><em>TF Reference; typically from Vol 1</em></p>
<p><em>(e.g., ITI TF-1: 7.1)</em></p></td>
</tr>
<tr class="even">
<td>Actor C</td>
<td>With the <em>Option name in this profile</em> Option</td>
<td><em>external Domain Acronym or blank profile acronym/Actor</em></td>
<td><em>Where the Option is defined in this profile Section XX.3 z</em></td>
</tr>
<tr class="odd">
<td><p>Actor D</p>
<p><em>if an actor has both required and conditional groupings, list the Required grouping first</em></p></td>
<td>Required</td>
<td><em>external Domain Acronym or blank profile acronym/Actor</em></td>
<td><em>TF Reference; typically from Vol 1</em></td>
</tr>
<tr class="even">
<td></td>
<td>If the <em>Option name in this profile</em> Option is supported.</td>
<td><em>external Domain Acronym or blank profile acronym/Actor</em></td>
<td><em>TF Reference; typically from Vol 1</em></td>
</tr>
<tr class="odd">
<td></td>
<td>If the <em>other Option name in this profile</em> Option is supported.</td>
<td><em>external Domain Acronym or blank profile acronym/Actor</em></td>
<td><em>TF Reference; typically from Vol 1</em></td>
</tr>
<tr class="even">
<td><p>Actor E</p>
<p><em>(In rare cases, the actor to be grouped with must implement an option, an example is in column 3)</em></p></td>
<td>Required</td>
<td><p><em>external Domain Acronym or blank profile acronym/Actor</em> with the <em>option name</em></p>
<p><em>e.g. ITI RFD Form Filler with the Archive Form Option</em></p></td>
<td><p><em>TF Reference to the Option definition; typically from Vol 1</em></p>
<p><em>(eg ITI TF-1:17.3.11)</em></p></td>
</tr>
</tbody>
</table>

<a name="overview"> </a>

## XX.4 ToDo Overview

This section shows how the transactions/content modules of the profile
are combined to address the use cases.

Use cases are informative, not normative, and "SHALL" language is
not allowed in use cases.

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


<a name="security-considerations"> </a>


#### XX.4.2.2 Use Case \#2: Holder Generates and Uses a VHL 

The patient provides access to their encrypted patient summary via the QR code on their mobile device or by sharing a secure VHL, (e.g., via email) at the point of care (e.g., walk-in clinic, emergency department).  The healthcare provider scans the QR code or accesses the VHL shared by the patient, addressing any security prompts, such as entering a passcode if required, and then may proceed to view/utilize and consume the patient summary.

##### XX.4.2.2.1 Generate and Use VHL Case Description

##### XX.4.2.2.2 Generate and Use VHL Process Flow

**Pre-conditions**:
- Patient has a QR code or VHL with access to a patient summary.
- HCP has the necessary tools to scan the QR code or access the VHL (e.g., a QR code scanner, Health Information System).
- VHL Responder and VHL Consumer have shared their public keys to a trust network
- VHL Consumer is in the same trust network as as the VHL Responder.

**Main Flow**:
- Patient has a medical encounter with a health care provider (HCP) virtually or in-person to obtain health care services. 
- Patient displays their patient summary QR code on their mobile device or shares a verifiable health link (e.g., via email) with the HCP and provides them with the passcode/PIN that they created (in Part A of this use case) to access the patient summary.
- HCP scans the QR code or accesses the VHL in a browser to retrieve the patient summary. 
- HCP is presented with applicable privacy and/or security form and they enter required security prompts (e.g., passcode, expiration time frame etc.,) according to jurisdictional policies.
- VHL consumer verifies the provenance of the shared link and confirms that the link originated from a trusted source before making a request to retrieve health document
- VHL responder verifies the manifest request was made by a trusted organization/entity
- VHL responder verifies the information submitted by the HCP in response to the security prompts (e.g., passcode/PIN). 
  - If the security prompts are correct, proceed to retrieve patient summary.
  - If the security prompts are incorrect, VHL responder denies access and prompts the user to re-submit the security prompts. If multiple failed attempts occur or the HCP abandons the process, the request for the patient summary is terminated. Process complete.
- VHL consumer retrieves the patient summary. Note: This process typically involves two steps: initially, a manifest file is provided containing the link to the patient summary. The patient summary is then retrieved in a subsequent step.
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

The World Health Organization (WHO) operates a trust network, the Global Digital Health Certification Network (GDHCN), for use by public sector health jurisidictions.  The WHO GDHCN uses the notion of a Trust Domain which is defined by a set of:
* use cases and business processes related to the utilization of Verifiable Digital Health Certificates;
* open, interoperable technical specifications that define the applicable Trusted Services and verifiable digital health certificates for the use case; and
* policy and regulatory standards describing expected behavior of participants for to the use case.

The PKI operated by the WHO supports a variety of trust domains, two of which are described below. 


##### XX.4.2.5.1 Hajj Pilgrimage Use Case Description

During the Hajj pilgrimage the Kingdom of Saudi Arabia (KSA) hosts approximately two milliion pilgrims from across the globe as part of a mass gathering event.  Temporary hospitals and clinics, comprising over a thousand beds, are established to provide care to the pilgrims over the ?four? week period of Hajj.

Starting with Hajj XXXX, in 2024, pilgrims from Oman, Malaysia and Indonesia were able to share their health records utilizing the International Patient Summary (IPS) with verification of health documents provided through the GDHCN infrastructure.

Pilgrims begin their journey in their home country where they receive a health check and are educated on the use of QR codes (a version of Verifiable Health Links) and provide the consent to share their health records.  This consent may be provided verbally or recorded digitally.  When recorded, there are two notions of consent recorded: 
- for their home country in which they agree that health records from their home country can be shared with appropriate authorities during Hajj
- for KSA is to permit utilization of these health records within the Saudi System. These consent records are recorded into the IPS Advanced Directives section and are included with the IPS when it is shared.  

The verifiable health link is provided by their home jurisidiction during their health check as a QR code.   
Depending on the digital infrastructure pilgrim's origin country, jurisidictional policies and digital capabilities (e.g. access to smart phones) of the pilgrim's origin country, the verifable health link may be:
* generated and printed on the pilgrim's health card and distrubted to the pilgrim at the time of the health check; or
* provisioned to the pilgrim through an existing digital health platform or wallet.
For similar reasons, the verifiable health link may refer to:
* an instance of the IPS rendered as a PDF;
* an instance of the IPS rendered as JSON; or
* a folder containing at least the PDF of JSON rendering of the IPS as well associated digital signatures.


During a care encounter in KSA, the pilgrim provides their verifiable health link as a QR code to their care provider.  Once a VHL is shared by a pilgrim during a care enounter in KSA:
* the VHL is verified through the GDHCN infrastructure
* an mTLS connection is established between the KSA EMRs and the origin country national infrastructure using key material exchanged via GDHCN
* a manifest of IPS relataed files including a PDF and JSON renderings and associated digital signatures
* The EMR retrieves the requisite files,

Some of the challenges faced during the pilot implementation, though not necessarily to be taken up in this profile, include:
- while not the main point of security, levergaing the PIN is a weakness, need to enable better options for future consideration (e.g. biometrics, other authorizaiton methods)
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



#### XX.4.2.6 Use Case \#6: EU Vaccination Card

The [European Vaccination Card (EVC)](https://euvabeco.eu/news/european-vaccination-card-evc-a-citizen-held-card-to-foster-informed-decision-making-on-vaccination-and-improve-continuity-of-care-across-the-eu/) is a citizen-held card to foster informed decision-making on vaccination, and improve continuity of care across the EU.

The EVC will allow "Member States to bilaterally verify the authenticity of digital records through an interoperable trust architecture. While similar to the EU Digital COVID Certificate in being a portable vaccination record, the EVC serves a different purpose. Unlike the certificate, which often fulfilled legal or health mandates, the EVC is specifically designed to empower individuals by granting them control over their vaccination information. This empowerment is crucial for ensuring continuity of care for those crossing borders or transitioning between healthcare systems."

The EVC will operate in the context of the European Health Data Spaces that requires detailed information on access the health data to be recorded.

<figure >
  <img src="ehds_legal.png" caption="Figure X.X.X.X-2: European Health Data Spaces" style="width:45em; max-width:100%"/>
  <p id="fX.X.X.X-1" class="figureTitle">Figure X.X.X.X-1:European Health Data Spaces </p>
</figure>

For more infomration see Regulation (EU) 2025/327 of the European Parliament and of the Council of 11 February 2025 on the European Health Data Space and amending Directive 2011/24/EU and Regulation (EU) 2024/2847.  Specifically:
* [ANNEX II - Essential requirements for the harmonised software components of EHR systems and for products for which interoperability with EHR systems has been claimed](https://eur-lex.europa.eu/eli/reg/2025/327/oj#anx_II)
* [Article 9 - Right to obtain information on accessing data](https://eur-lex.europa.eu/eli/reg/2025/327/oj#art_9)

This use case has the following business requirement:
* [Record Access To Health Data](Requirements-RecordAccessToHealthData.html)





#### XX.4.2.7 Use Case \#6: Smart Health Links
<bold>Note:</bold>  Not sure if we want to include "Verifiable" health link as an option and Smart Health Link as another option.  If so, we should recap SHL use case here. (No pre-coordination of trust)

## XX.5 ToDo Security Considerations

<i>
    See ITI TF-2x: [Appendix Z.8 "Mobile Security Considerations"](https://profiles.ihe.net/ITI/TF/Volume2/ch-Z.html#z.8-mobile-security-considerations)
    
    The following is instructions to the editor and this text is not to be included in a publication.
    The material initially from [RFC 3552 "Security Considerations Guidelines" July 2003](https://tools.ietf.org/html/rfc3552).
    
    This section should address downstream design considerations, specifically for: Privacy, Security, and Safety. These might need to be individual header sections if they are significant or need to be referenced.
    
    The editor needs to understand Security and Privacy fundamentals.
    General [Security and Privacy guidance]({{site.data.fhir.path}}secpriv-module.html) is provided in the FHIR Specification. 
    The FHIR core specification should be leveraged where possible to inform the reader of your specification.
    
    IHE FHIR based profiles should reference the [ITI Appendix Z](https://profiles.ihe.net/ITI/TF/Volume2/ch-Z.html) section 8 Mobile Security and Privacy Considerations base when appropriate.
    
    IHE Document Content profiles can reference the security and privacy provided by the Document Sharing infrastructure as directly grouped or possibly to be grouped.
    
       While it is not a requirement that any given specification or system be
       immune to all forms of attack, it is still necessary for authors of specifications to
       consider as many forms as possible.  Part of the purpose of the
       Security and Privacy Considerations section is to explain what attacks have been
       considered and what countermeasures can be applied to defend against them.
    
       There should be a clear description of the kinds of threats on the
       described specification.  This should be approached as an
       effort to perform "due diligence" in describing all known or
       foreseeable risks and threats to potential implementers and users.
    
    Authors MUST describe:
    
    * which attacks have been considered and addressed in the specification
    * which attacks have been considered but not addressed in the specification
    * what could be done in system design, system deployment, or user training
    
       At least the following forms of attack MUST be considered:
       eavesdropping, replay, message insertion, deletion, modification, and
       man-in-the-middle.  Potential denial of service attacks MUST be
       identified as well.  If the specification incorporates cryptographic
       protection mechanisms, it should be clearly indicated which portions
       of the data are protected and what the protections are (i.e.,
       integrity only, confidentiality, and/or endpoint authentication,
       etc.).  Some indication should also be given to what sorts of attacks
       the cryptographic protection is susceptible.  Data which should be
       held secret (keying material, random seeds, etc.) should be clearly
       labeled.
    
       If the specification involves authentication, particularly user-host
       authentication, the security of the authentication method MUST be
       clearly specified.  That is, authors MUST document the assumptions
       that the security of this authentication method is predicated upon.
    
       The threat environment addressed by the Security and Privacy Considerations
       section MUST at a minimum include deployment across the global
       Internet across multiple administrative boundaries without assuming
       that firewalls are in place, even if only to provide justification
       for why such consideration is out of scope for the protocol.  It is
       not acceptable to only discuss threats applicable to LANs and ignore
       the broader threat environment.  In
       some cases, there might be an Applicability Statement discouraging
       use of a technology or protocol in a particular environment.
       Nonetheless, the security issues of broader deployment should be
       discussed in the document.
    
       There should be a clear description of the residual risk to the user
       or operator of that specification after threat mitigation has been
       deployed.  Such risks might arise from compromise in a related
       specification (e.g., IPsec is useless if key management has been
       compromised), from incorrect implementation, compromise of the
       security technology used for risk reduction (e.g., a cipher with a
       40-bit key), or there might be risks that are not addressed by the
       specification (e.g., denial of service attacks on an
       underlying link protocol).  Particular care should be taken in
       situations where the compromise of a single system would compromise
       an entire protocol.  For instance, in general specification designers
       assume that end-systems are inviolate and don't worry about physical
       attack.  However, in cases (such as a certificate authority) where
       compromise of a single system could lead to widespread compromises,
       it is appropriate to consider systems and physical security as well.
    
       There should also be some discussion of potential security risks
       arising from potential misapplications of the specification or technology
       described in the specification.  
      
    This section also include specific considerations regarding Digital Signatures, Provenance, Audit Logging, and De-Identification.
    
    Where audit logging is specified, a StructureDefinition profile(s) should be included, and Examples of those logs might be included.
    
    <a name="other-grouping"> </a>
</i>

VHL is a building block that is meant to be used together with added security measures, otherwise it is not suitable for exchange in environments where security and provenance cannot be reliably established by other means.

- The European Health Data Space can be found here https://www.europarl.europa.eu/doceo/document/TA-9-2024-0331_EN.pdf .  In particular, provisions 8f) and 12a) outline the requirements for the auditability of data access.  This means that there needs to be a means to identify the entity/organization that is acting as a VHL Receiving Application.  
- Before a Receiver Application initiates a VHL request, it should be able to determine the provenance of the VHL that it was presented. 


## XX.6 Cross-Profile Considerations

This section is informative, not normative. It is intended to put
this profile in context with other profiles. Any required groupings
should have already been described above.


### mCSD - Mobile Care Services Discovery 
The mCSD Profile supports querying for Endpoint(s) for Organizations. The {{ linkta }} may store DID (Decentralized IDentifier) as endpoints for Jurisdictions.
### DSGj - JSON Document Signature
<TO DO: insert content> 
### DSG - Document Signature
<TO DO: insert>
	
