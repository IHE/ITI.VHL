{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}

## 2:3.YY2 Retrieve Trust List

> **ALTERNATIVE APPROACH - OPTION-BASED**: This file represents an alternative structure where "Retrieve Trust List" is a REQUIRED transaction, with "DID-based PKI Exchange" as an optional format. See ITI-YY2.md for the current (DID-only optional transaction) approach.

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

The Retrieve Trust List transaction allows both {{ linkvhls }}s and {{ linkvhlr }}s to retrieve trusted cryptographic material from the {{ linkta }}. This material includes public key certificates, verification methods, and associated metadata required to validate the authenticity of a Verified Health Link (VHL).

This transaction is REQUIRED for all actors that need to verify trust relationships. The specific format of the retrieved material is determined by the options claimed by the actor.

Retrieved material SHALL be used to determine the trustworthiness of VHL artifacts and service endpoints in accordance with the governing trust framework.

<figure>
{%include ITI-YY2.svg%}
<p id="figure-2.3.YY2-1" class="figureTitle">Figure 2:3.YY2-1: Retrieve Trust List Interaction Diagram</p>
</figure>
<br clear="all">

### 2:3.YY2.2 Actor Roles


| Actor | Role |
|-------|--------|
| VHL Receiver, VHL Sharer | {{ reqRetrievePKItitle.valueString }} |
| Trust Anchor             | {{ reqRetrievePKIResptitle.valueString }} |
{: .grid}

### 2:3.YY2.3 Referenced Standards

- **W3C DID Core 1.0**: [Decentralized Identifiers (DIDs) v1.0](https://www.w3.org/TR/did-core/) (for DID-based PKI Exchange Option)
- **RFC 7517**: JSON Web Key (JWK)
- **RFC 8446**: TLS Protocol Version 1.3
- **IHE mCSD**: [Mobile Care Services Discovery](https://profiles.ihe.net/ITI/mCSD/)


### 2:3.YY2.4 Messages

#### 2:3.YY2.4.1 Retrieve Trust List Request Message

##### 2:3.YY2.4.1.1 Trigger Events
{{ reqRetrievePKIdescription.valueMarkdown}}

**Preconditions:**

The {{ linkta }} SHALL have made available endpoint(s) for retrieving PKI material. The requesting participant ({{ linkvhlr }} or {{ linkvhls }}) knows in advance the endpoint from which to retrieve PKI material.

When the DID-based PKI Exchange Option is used, the {{ linkta }} SHALL provide at least one endpoint (such as an mCSD-compliant endpoint) accessible to all participants.

##### 2:3.YY2.4.1.2 Message Semantics

The {{ linkvhls }} or {{ linkvhlr }} SHALL retrieve PKI material from the {{ linkta }} in a format that enables verification of digital signatures and establishment of trust relationships.

The specific format and retrieval mechanism depends on which option the actor claims:

**DID-based PKI Exchange Option**

Actors claiming the DID-based PKI Exchange Option SHALL retrieve PKI material as DID Documents according to W3C DID Core specification. See Section 2:3.YY2.4.1.2.1 for details.

**Alternative Implementations**

Implementations that do not claim the DID-based PKI Exchange Option SHALL use alternative retrieval mechanisms defined by the implementing jurisdiction. Such implementations cannot be tested for interoperability at IHE Connectathons unless they claim a standardized option.

##### 2:3.YY2.4.1.2.1 DID-based PKI Exchange Option Message Semantics

Actors claiming the DID-based PKI Exchange Option SHALL retrieve DID Documents from the {{ linkta }}.

[Include full request semantics from current ITI-YY2.md...]

##### 2:3.YY2.4.1.3 Expected Actions

[Include expected actions from current ITI-YY2.md...]

#### 2:3.YY2.4.2 Retrieve Trust List Response Message 

[Include response details from current ITI-YY2.md...]

### 2:3.YY2.5 Security Considerations 

[Include security considerations from current ITI-YY2.md...]
