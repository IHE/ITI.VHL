{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}

## 2:3.YY1 Submit PKI Material

> **ALTERNATIVE APPROACH - OPTION-BASED**: This file represents an alternative structure where "Submit PKI Material" is a REQUIRED transaction, with "DID-based PKI Exchange" as an optional format. See ITI-YY1.md for the current (DID-only optional transaction) approach.

{% assign reqSubmitPKI = site.data.Requirements-InitiateSubmitPKIMaterialRequest %}
{% assign reqDistributePKI = site.data. Requirements-RespondtoSubmitPKIMaterialRequest %}


{% assign reqSubmitPKItitle = reqSubmitPKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqDistributePKItitle = reqDistributePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign reqSubmitPKIdescription = reqSubmitPKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign reqDistributePKIdescription = reqDistributePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}



### 2:3.YY1.1 Scope

The Submit PKI Material transaction enables entities within a trust network—specifically, {{ linkvhls }}s and {{ linkvhlr }}s—to submit their public key material to a designated {{ linkta }}. The {{ linkta }} validates, catalogs, and makes this material available for retrieval, enabling participants to verify digital signatures and establish secure communications within the VHL ecosystem.

This transaction is REQUIRED for all actors that need to establish trust. The specific format and mechanism for PKI material submission is determined by the options claimed by the actor.

### 2:3.YY1.2 Actor Roles



| Actor | Role |
|-------|------|
| {{ linkvhlr}}, {{ linkvhls}} | {{ reqSubmitPKItitle.valueString }}     |
| {{ linkta }}            | {{ reqDistributePKItitle.valueString }} |
{: .grid}


### 2:3.YY1.3 Referenced Standards

- **W3C DID Core 1.0**: [Decentralized Identifiers (DIDs) v1.0](https://www.w3.org/TR/did-core/) (for DID-based PKI Exchange Option)
- **RFC 7517**: JSON Web Key (JWK)
- **RFC 8446**: TLS Protocol Version 1.3
- **RFC 5280**: X.509 PKI Certificate and CRL Profile


### 2:3.YY1.4 Messages

<figure >
  <div style="width:35em; max-width:100%;">
     {%include ITI-YY1.svg%}
  </div>
  <p id="fX.X.X.X-2" class="figureTitle">Figure X.X.X.X-2: Submit PKI Material Interaction Diagram</p>
</figure>

#### 2:3.YY1.4.1 Submit PKI Material Request Message
##### 2:3.YY1.4.1.1 Trigger Events
{{ reqSubmitPKIdescription.valueMarkdown}}

{% include requirements-list-statements.liquid site=site req=reqSubmitPKI  %}

##### 2:3.YY1.4.1.2 Message Semantics

The {{ linkvhls }} or {{ linkvhlr }} SHALL submit PKI material to the {{ linkta }} in a format that enables verification of digital signatures and establishment of trust relationships.

The specific format and submission mechanism depends on which option the actor claims:

**DID-based PKI Exchange Option**

Actors claiming the DID-based PKI Exchange Option SHALL format submissions as DID Documents according to W3C DID Core specification. See Section 2:3.YY1.4.1.2.1 for details.

**Alternative Implementations**

Implementations that do not claim the DID-based PKI Exchange Option SHALL use alternative formats defined by the implementing jurisdiction, such as:
- X.509 Certificates with associated metadata
- JSON Web Keys (JWK) with metadata  
- Jurisdiction-specific formats

The specific format and submission mechanism SHALL be defined by the implementing jurisdiction or deployment environment. Such implementations cannot be tested for interoperability at IHE Connectathons unless they claim a standardized option.

##### 2:3.YY1.4.1.2.1 DID-based PKI Exchange Option Message Semantics

Actors claiming the DID-based PKI Exchange Option SHALL submit PKI material formatted as DID Documents per W3C DID Core specification.

**DID Document Structure**

[Include full DID Document specification from current ITI-YY1.md...]

##### 2:3.YY1.4.1.3 Expected Actions

[Include expected actions from current ITI-YY1.md...]

#### 2:3.YY1.4.2 Submit PKI Material Response Message 

The response message format is determined by the implementing jurisdiction of the {{ linkta }}.

[Include response details from current ITI-YY1.md...]


### 2:3.YY1.5 Security Considerations 

[Include security considerations from current ITI-YY1.md...]
