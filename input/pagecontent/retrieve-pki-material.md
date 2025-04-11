
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

The Retrieve PKI Material transaction returns a list of trusted public key material to be used by a trust network participant to validate document singatures, establish secure connections, or decrypt data.
A {{ linkvhlh }} or a {{ linkvhls }} initiates the Retrieve PKI Material against a {{ linkta }}.

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
None defined. Up to a content profile to define.

##### 2:XX.4.2.3 Expected Actions
{{ reqReceivePKIdescription.valueMarkdown }}


### 2:XX.5 Security Considerations 
Depends on the content profile.






