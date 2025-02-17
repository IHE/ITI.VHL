
As an indivudal moves within or across jurisidicional boundaries, they may wish to provide access to clinical anor other health related documents to a set of trusted parties who are authorized to access that individual's health documents. The individual may wish to grant access to a single health document or a set of related health documents. 


The Verifiable Health Link (VHL) profile defines protocols and patterns that allow the sharing of health documents in a auditable and verfiable manner within and across jurisdictional boundaries.   The VHL profile describes mechanisms, the VHLs, that an individual, the VHL Holder, uses to provide authorize access to their health records from an issuer, the VHL Sharer, to a third party, the VHL Receiver.  The means by which the VHL is held by the VHL Holder or shared by the VHL Holder to the VHL Receiver are beyond the scope of this profile.

In the VHL profile, the VHL Receiver and VHL Sharer participate in a trust network which enables the verification of the origin of the health document, any access mechanisms to these health documents, and the origin of requests to utilze these access mechanisms. The authorization for the participation of a VHL Receiver or VHL Sharer with the trust network is maintained by their respective jurisidictions.  The verification of that authorization is acheived using the PKI. 

The respective jurisidictions of the VHL Receiver and VHL Sharer may have regulatory framework in regards to the privacy and security of access to patient data that may include the needs for verfication of consent and maintaining audit trails for access to an person's health data.

The VHL leverages Public Key Infrastructure (PKI) as a means to verify trust amongst the actors and the veracity of artefacts.  As participants within a trust network, the VHL Receiver and VHL Sharer both share and receive PKI material with the Trust Anchor of the trust network.  The means by which the VHL Receiver and VHL Sharer establish trust with the Trust Anchor is beyond the scope of this profile.



<a name="actors-and-transactions"> </a>

## 1:X.1 Actors, Transactions, and Content Modules

This section defines the actors, transactions, and/or content modules in this profile. Further information about actor and transaction definitions can be found in the IHE Technical Frameworks General Introduction [Appendix A: Actors](https://profiles.ihe.net/GeneralIntro/ch-A.html) and [Appendix B: Transactions](https://profiles.ihe.net/GeneralIntro/ch-B.html).

* Actors
  * [Trust Anchor](#trust-anchor)
  * [VHL Holder](#vhl-holder)
  * [VHL Receiver](#vhl-receiver)
  * [VHL Sharer](#vhl-sharer)
* Transactions
  * [Publish PKI Material](ITI-YY1.html)
  * [Retrieve PKI Material](ITI-YY2.html)
  * [Generate VHL](ITI-YY3.html)
  * [Request VHL Documents](ITI-YY4.html)
  * [Request VHL Document](ITI-YY5.html)


As a pre-condition to transactions ITI-YY3, ITI-YY4 and ITI-YY5, the VHL Receiver and VHL Sharer must exchange the appropriate PKI in order to verify their trust relationship at the time of the utlization of the VHL.  As the identities of the VHL Receiver and VHL Sharer are not directly know to each other in advance of a request to utilize a VHL, the VHL Receiver and VHL Sharer publish and retrieve key material from a third party, the Trust Anchor.    This is illustrated in Figure X.X.X.X-1


<figure>
  {%include usecase-exchange-key-material-processflow.svg%}
  <p id="fX.X.X.X-1" class="figureTitle">Figure X.X.X.X-1: Use Case Issue and Utilize VHL Process Flow</p>
</figure>

The process of a VHL Holder requesting a VHL to a set of health documents from a VHL Sharer and subsequently sharing them to a VHL Receiver is illusrated in Figure X.X.X.X-2.


<figure>
  {%include usecase-generate-use-vhl-processflow.svg%}
  <p id="fX.X.X.X-2" class="figureTitle">Figure X.X.X.X-2: Use Case Issue and Utilize VHL for a Set of Health Documents Process Flow</p>
</figure>



The process of a VHL Holder requesting a VHL to a single health document from a VHL Sharer and subsequently sharing them to a VHL Receiver is illusrated in Figure X.X.X.X-3.


<figure>
  {%include usecase-generate-use-vhl-single-doc-processflow.svg%}
  <p id="fX.X.X.X-3" class="figureTitle">Figure X.X.X.X-3: Use Case Issue and Utilize VHL for a Single Health Document Process Flow</p>
</figure>

<br clear="all">

<p id ="tXX.1-1" class="tableTitle">Table XX.1-1: Profile Acronym Profile - Actors and Transactions</p>

|              |                              |                        |            |                           |
|--------------|------------------------------|------------------------|------------|---------------------------|
| Actors       | Transactions                 | Initiator or Responder | Optionality| Reference                 |
| Trust Anchor | Publish PKI Material         | Responder              | R          | ITI TF-2: YY1 |
|              | Retrieve PKI Material        | Responder              | R          | ITI TF-2: YY2 |
| VHL Holder   | Generate VHL                 | Initiator              | R          | ITI TF-2: YY3 |
| VHL Receiver | Publish PKI Material         | Initiator              | R          | ITI TF-2: YY1 |
|              | Retrieve PKI Material        | Initiator              | R          | ITI TF-2: YY2 |
|              | Request VHL Documents        | Initiator              | R          | ITI TF-2: YY4 |
|              | Request VHL Document         | Initiator              | R          | ITI TF-2: YY5 |
| VHL Sharer   | Publish PKI Material         | Initiator              | R          | ITI TF-2: YY1 |
|              | Retrieve PKI Material        | Initiator              | R          | ITI TF-2: YY2 |
|              | Generate VHL                 | Responder              | R          | ITI TF-2: YY3 |
|              | Request VHL Documents        | Responder              | R          | ITI TF-2: YY4 |
|              | Request VHL Document         | Responder              | R          | ITI TF-2: YY5 |
{: .grid}


### XX.1.1 Actors
The actors in this profile are described in more detail in the sections below.

<a name="trust-anchor"> </a>

#### XX.1.1.1 Trust Anchor

The Trust Anchor receives, aggregates and distributes PKI material to the participants within a trust network, specifically the VHL Reciver and VHL Sharer.

FHIR Capability Statement for [Trust Anchor](CapabilityStatement-IHE.ToDo.trust-anchor.html)

<a name="vhl-holder"> </a>

#### XX.1.1.2 VHL Holder


The VHL Holder is an individual that is holding an authorization mechanism, a VHL, which allows a VHL Receiver to access a (set of) health document(s) held by a VHL Sharer.

FHIR Capability Statement for [VHL Holder](CapabilityStatement-IHE.ToDo.vhl-holder.html)


<a name="vhl-receiver"> </a>
#### XX.1.1.2 VHL Receiver


The VHL Receiver receives a VHL from a VHL Holder which it utilizes to request access to health documents from a VHL Sharer.

FHIR Capability Statement for [VHL Receiver](CapabilityStatement-IHE.ToDo.vhl-receiver.html)


<a name="vhl-sharer"> </a>
#### XX.1.1.2 VHL Sharer


The VHL Sharer generates a VHL, provides the VHL to a VHL Holder, and responds to requests from a VHL Sharer to utilize the VHL.

FHIR Capability Statement for [VHL Sharer](CapabilityStatement-IHE.ToDo.vhl-sharer.html)

### XX.1.2 Transaction Descriptions

The transactions in this profile are summarized in the sections below.

#### XX.1.2.1 Publish PKI Material

This transactions is used by a VHL Receiver or VHL Sharer to publish PKI material to a Trust Anchor.  

For more details see the detailed [transaction description](ITI-YY1.html)


#### XX.1.2.2 Retrieve PKI Material

This transactions is used by a VHL Receiver or VHL Sharer to retrieve PKI material previously published to a Trust Anchor. Retrieved key material should be able to be distinguised by the participating jurisdiction, use case context, and key usage. 

For more details see the detailed [transaction description](ITI-YY2.html)


#### XX.1.2.4 Generate VHL

This transactions is used by a VHL Holder to request that a VHL Sharer generate a VHL.  A VHL Sharer may optionally record the consent of the individual to share their information under the Record Consent option. A VHL Sharer may optionally create an audit trail of the creation of the VHL under the Audit Event option. The individual shall trust that VHL Sharer has been authorized by its jurisidiction to authorize and provide access to health documents.   

For more details see the detailed [transaction description](ITI-YY3.html)


#### XX.1.2.4 Request VHL Documents

This transactions is used by a VHL Receiver to request a set of health documents from a VHL Sharer.  This transaction should be conducted in such a manner that the VHL Receiver and VHL Sharer can validate one another's participation in the same trust network. The VHL Sharer shall optionally be able to record an audit event for the access of the folder by the VHL Receiver upon the transaction request under the Audit Event option.


For more details see the detailed [transaction description](ITI-YY4.html)


#### XX.1.2.5 Request VHL Document

This transactions is used by a VHL Receiver to request a single health document from a VHL Sharer.  This transaction should be conducted in such a manner that the VHL Receiver and VHL Sharer can validate one another's participation in the same trust network.  The VHL Receiver shall optionally be able to validate that the veracity of the health document received through this transaction under the Verify Document Signature option.  The VHL Sharer shall optionally be able to record an audit event for the access of the folder by the VHL Receiver upon the transaction request under the Audit Event option.



<a name="actor-options"> </a>

## XX.2  Actor Options

Options that may be selected for each actor in this implementation guide, are listed in Table 3.2-1 below. Dependencies between options when applicable are specified in notes.

<p id ="tXX.1-1" class="tableTitle">Table XX.2-1: Actor Options</p>

|              |                 |
|--------------|-----------------|
| Actor        | Option Name     |
| VHL Receiver | Verify Document |
| VHL Sharer   | Record Consent  |
|              | Audit Event     |
{: .grid}


### XX.2.1 Verify Document Option

In this option the VHL Receiver, after receipt of a digitally signed document from a VHL Sharer, shall verify that digtial singature using previosuly retrieved PKI material.  

See cross-profile considerations for a discussion of the relationship of this option to the IHE Document Signature profile.

### XX.2.2 Record Consent Option

In this option the VHL Sharer acts a Consent Recorder from the Privacy Consent on FHIR (PCF) profile.  In this option, the VHL Sharer SHALL initiate a [Access Consent : ITI-108)(https://profiles.ihe.net/ITI/PCF/ITI-108.html)
transaction as part of the Expected Actions after receipt of a Generate VHL request.   The Access Consent transaction is used to record the consent declarations by the VHL Holder for the sharing of the (set of) health document(s) by the VHL Sharer to any authorized VHL Receiver within the trust network for a specified use case.



### XX.2.3 Audit Event Option

In this option the VHL Sharer records an audit event for critical events in the access of health documents including:
* Request for the generation of a VHL by a VHL Holder; and
* Reuqest for access to a (set of) health document(s) by a VHL Receiver.


<a name="required-groupings"> </a>

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


A Verifiable Health Link is a mechanism which enables the sharing of health documents with additional sharing options that may include: limited-time access, long-term sharing of data that can evolve over time,  and protecting access with a PIN. These shareable links can often be downloaded onto devices and converted into a QR code format, facilitating patient-mediated data sharing and interoperability within the healthcare ecosystem.


### XX.4.2 Use Cases

#### XX.4.2.1 Use Case \#1: Holder requests generation of link

A patient, via a patient-facing application, requests access to a shareable copy of their health summary. 

##### XX.4.2.1.1 Genreate VHL Use Case Description
Ms. SJ, a 37-year-old non-smoker and non-drinker, recently experienced a high-risk pregnancy involving early hospitalization and pre-term delivery due to pre-eclampsia and gestational diabetes. She is currently taking metformin and an anti-hypertensive. Ms. SJ, recently moved within her province, and she found a new primary care clinic that is taking on new patients.  

Ms. SJ signs up for a patient-facing provincial application to access her personal health information and creates a shareable patient summary, which will be useful for her upcoming appointment. On the application, she is presented with privacy and security measures, such as a consent notice, passcode, and QR code timeout. After providing her consent and completing the security instructions for her shareable patient summary, the application assembles her patient summary using available data and creates a VHL and QR code, which is displayed on Ms. SJ’s mobile phone, and she is happy to see that she has the option to print a copy. Ms. SJ is ready for her appointment. 

##### XX.4.2.1.2  Generate VHL Process Flow

**Pre-conditions**:

- Patient has access to a patient-facing application which supports access to their patient summary and creation of a QR code with a VHL for sharing with an HCP. 


**Main Flow**:

- Patient or their designated caregiver accesses Personal Health Information via a patient facing application (e.g., Jurisdictional Patient Portal).
- Patient or their designated caregiver requests access to a shareable patient summary, on option available within their patient facing application.
- Patient or their designated caregiver is presented with applicable privacy and/or security forms such as a consent statement, requirements for a PIN, passcode, validity time frame etc., according to jurisdictional policies.
- Patient or their designated caregiver reviews the information presented and selects information they'd like to share.
- Patient determines if they would like to proceed. 
  - If yes,proceed to complete the privacy and security forms.
  - If no, Patient or their designated caregiver decide not to complete the privacy and security forms. The request for their verifiable patient summary is terminated.
- If process was completed, the VHL requester makes the request with defined parameters of PIN, passcode, validity time etc to the VHL creator
- VHL creator issues VHL

**Post-conditions:**

A QR code, with a VHL, is created and displayed to the patient for accessing and sharing their patient summary.  


<a name="security-considerations"> </a>


#### XX.4.2.2 Use Case \#2: Holder shares generated VHLink to HCP for access

The patient provides access to their encrypted patient summary via the QR code on their mobile device or by sharing a secure VHL, (e.g., via email) at the point of care (e.g., walk-in clinic, emergency department).  The healthcare provider scans the QR code or accesses the VHL shared by the patient, addressing any security prompts, such as entering a passcode if required, and then may proceed to view/utilize and consume the patient summary.

##### XX.4.2.2.1 simple name Use Case Description

##### XX.4.2.2.2 simple name Process Flow

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


#### XX.4.2.3 Use Case \#3: Holder requests to destroy a VHLink

##### XX.4.2.3.1 simple name Use Case Description

##### XX.4.2.3.2 simple name Process Flow

**Pre-conditions**:

**Main Flow**:

**Post-conditions:**


#### XX.4.2.4 Use Case \#4: Holder requests to destroy a VHLink

##### XX.4.2.4.1 simple name Use Case Description

##### XX.4.2.4.2 simple name Process Flow

**Pre-conditions**:

**Main Flow**:

**Post-conditions:**

#### XX.4.2.5 Use Case \#5: Receiver accesses the data and updates the link and provides a new link back

##### XX.4.2.5.1 simple name Use Case Description

##### XX.4.2.5.2 simple name Process Flow

**Pre-conditions**:

**Main Flow**:

**Post-conditions:**

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


## XX.6 ToDo Cross-Profile Considerations

This section is informative, not normative. It is intended to put
this profile in context with other profiles. Any required groupings
should have already been described above. Brief descriptions can go
directly into this section; lengthy descriptions should go into an
appendix. Examples of this material include ITI Cross Community Access
(XCA) Grouping Rules (Section 18.2.3), the Radiology associated profiles
listed at wiki.ihe.net, or ITI Volume 1 Appendix E "Cross Profile
Considerations", and the "See Also" sections Radiology Profile
descriptions on the wiki such as
<http://wiki.ihe.net/index.php/Scheduled_Workflow#See_Also>. If this
section is left blank, add "Not applicable."

Consider using a format such as the following:

other profile acronym - other profile name

A other profile actor name in other profile name might
be grouped with a this profile actor name to describe
benefit/what is accomplished by grouping.

### mCSD
The mCSD Profile supports querying for Endpoint(s) for Organizations. The Trust Anchor may store DID (Decentralized IDentifier) as endpoints for Jurisdictions.
### DSG
IPS or other health documents being shared could be digitally signed using DSG under the Verify Document Signature Option.
	
