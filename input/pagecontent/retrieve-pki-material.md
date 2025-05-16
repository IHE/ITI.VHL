
{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}

## 2:XX Retrieve PKI Material

{% assign reqRequestPKI = site.data.Requirements-RequestPKIMaterial %}
{% assign reqProvidePKI = site.data.Requirements-ProvidePKIMaterial %}
{% assign reqReceivePKI = site.data.Requirements-ReceivePKIMaterial %}


{% assign reqRequestPKItitle = reqRequestPKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqProvidePKItitle = reqProvidePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqReceivePKItitle = reqReceivePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign reqRequestPKIdescription = reqRequestPKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign reqProvidePKIdescription = reqProvidePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign reqReceivePKIdescription = reqReceivePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}


### 2:XX.1 Scope

The Retrieve PKI Material transaction allows both {{ linkvhls }}s and {{ linkvhlr }}s to retrieve trusted cryptographic material from the {{ linkta }}. This material includes:

- Public key certificates (e.g., X.509),
- Certificate revocation data (e.g., CRLs or OCSP responses),
- JSON Web Keys (JWKs) or equivalent,
- and associated metadata required to validate the authenticity of a Verified Health Link (VHL) and to establish mutually authenticated TLS (mTLS) sessions.
    
Retrieved material SHALL be used to determine the trustworthiness of VHL artifacts and service endpoints in accordance with the governing trust framework.

### 2:XX.2 Actor Roles


| Actor | Role |
|-------|--------|
| VHL Receiver, VHL Sharer | {{ reqRequestPKItitle.valueString }} |
|                          | {{ reqReceivePKItitle.valueString }} |
| Trust Anchor             | {{ reqProvidePKItitle.valueString }} |
{: .grid}

### 2:XX.3 Referenced Standards


### 2:XX.4 Messages

#### 2:XX.4.1 Retrieve PKI Material Request Message
##### 2:XX.4.1.1 Trigger Events
{{ reqRequestPKIdescription.valueMarkdown}}

##### 2:XX.4.1.2 Message Semantics
OPTIONS TO DISCUSS:
* DID / JSON Web Keys
* mCSD Endpoint

##### 2:XX.4.1.3 Expected Actions
{{ reqProvidePKIdescription.valueMarkown}}

#### 2:XX.4.2 Retrieve PKI Material Response Message 

##### 2:XX.4.2.1 Trigger Events

A [Trust Anchor](ActorDefinition-TrustAnchor.html) initiates an Retrieve PKI Material Response Message once it has completed, to the extent possible, the expected actions upon receipt of a Retrieve PKI Material Request message.

##### 2:XX.4.2.2  Message Semantics
The Retrieve PKI Material request MAY take one of several forms, depending on the transport and representation models adopted by the content profile. Potential representations include:

- A FHIR Parameters resource with serialized public key material (e.g., PEM, DER, or JWK)
- A DID Document conforming to [W3C DID Core](https://www.w3.org/TR/did-core/)
- A pointer to a .well-known URI under organizational control, with machine-readable key data
    
The payload SHOULD include sufficient metadata to identify the submitting entity and bind the key material to its intended usage context (e.g., use: "sig", keyOps, x5c chain).

Content profiles SHALL define exact payload constraints, validation rules, and error behaviors.

##### 2:XX.4.2.3 Expected Actions
{{ reqReceivePKIdescription.valueMarkdown }}


### 2:XX.5 Security Considerations 
All Retrieve PKI Material interactions SHOULD occur over secure channels using TLS 1.2 or higher, with mTLS recommended for enhanced endpoint authentication. The Trust Anchor SHOULD validate the authenticity, scope, and expiration of all retrieved key material before publishing or caching.

Clients (e.g., {{ linkvhlr }}s and {{ linkvhls }}s) SHOULD verify the signature chain or integrity envelope of the material prior to using it for signature verification or secure session establishment.

Implementers SHOULD ensure that any out-of-band trust anchors or directory sources (e.g., .well-known/ endpoints) are tamper-resistant and publicly resolvable.

Content profiles MAY define additional constraints, such as:
- Minimum key lengths
- Permitted algorithms (e.g., RSA-2048, ECDSA P-256)
- CRL/OCSP freshness requirements
- Retry and caching behavior






