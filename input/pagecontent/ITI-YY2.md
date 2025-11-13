{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}

## 2:3.YY2 Retrieve Trust List

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

The Retrieve Trust List transaction allows both {{ linkvhls }}s and {{ linkvhlr }}s to retrieve trusted cryptographic material from the {{ linkta }}. This material includes:

- Public key certificates (e.g., X.509),
- Certificate revocation data (e.g., CRLs or OCSP responses),
- JSON Web Keys (JWKs) or equivalent,
- and associated metadata required to validate the authenticity of a Verified Health Link (VHL).
    
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


### 2:3.YY2.4 Messages

#### 2:3.YY2.4.1 Retrieve Trust List Request Message
##### 2:3.YY2.4.1.1 Trigger Events
{{ reqRetrievePKIdescription.valueMarkdown}}

##### 2:3.YY2.4.1.2 Message Semantics
The message semantics for the Retrieve Trust List Request SHALL be defined by the jurisdiction. The request format SHALL align with the PKI material representation chosen by the trust network (e.g., DID Documents, JSON Web Keys, mCSD Endpoints, or other jurisdiction-specific mechanisms).

##### 2:3.YY2.4.1.3 Expected Actions
{{ reqRetrievePKIRespdescription.valueMarkdown}}

#### 2:3.YY2.4.2 Retrieve Trust List Response Message 

##### 2:3.YY2.4.2.1 Trigger Events

A [Trust Anchor](ActorDefinition-TrustAnchor.html) initiates an Retrieve Trust List Response Message once it has completed, to the extent possible, the expected actions upon receipt of a Retrieve Trust List Request message.

##### 2:3.YY2.4.2.2  Message Semantics
The Retrieve Trust List request MAY take one of several forms, depending on the transport and representation models adopted by the content profile. Potential representations include:

- A FHIR Parameters resource with serialized public key material (e.g., PEM, DER, or JWK)
- A DID Document conforming to [W3C DID Core](https://www.w3.org/TR/did-core/)
- A pointer to a .well-known URI under organizational control, with machine-readable key data
    
The payload SHOULD include sufficient metadata to identify the submitting entity and bind the key material to its intended usage context (e.g., use: "sig", keyOps, x5c chain).

Content profiles SHALL define exact payload constraints, validation rules, and error behaviors.

##### 2:3.YY2.4.2.3 Expected Actions
{{ reqReceivePKIdescription.valueMarkdown }}

{% include requirements-list-statements.liquid req=reqReceivePKI site=site  %}

Upon receiving the Trust List response, the {{ linkvhlr }} or {{ linkvhls }} SHALL process the received PKI material as specified in the [Receive Trust List](Requirements-ReceiveTrustList.html) requirement.


### 2:3.YY2.5 Security Considerations 
All Retrieve Trust List interactions SHOULD occur over secure channels. The Trust Anchor SHOULD validate the authenticity, scope, and expiration of all retrieved key material before publishing or caching.

Clients (e.g., {{ linkvhlr }}s and {{ linkvhls }}s) SHOULD verify the signature chain or integrity envelope of the material prior to using it for signature verification.

Implementers SHOULD ensure that any out-of-band trust anchors or directory sources (e.g., .well-known/ endpoints) are tamper-resistant and publicly resolvable.

Content profiles MAY define additional constraints, such as:
- Minimum key lengths
- Permitted algorithms (e.g., RSA-2048, ECDSA P-256)
- CRL/OCSP freshness requirements
- Retry and caching behavior
