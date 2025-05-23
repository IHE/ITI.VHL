
{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}

## 2:XX Publish PKI Material

{% assign reqSubmitPKI = site.data.Requirements-SubmitPKIMaterial %}
{% assign reqDistributePKI = site.data.Requirements-DistributePKIMaterial %}


{% assign reqSubmitPKItitle = reqSubmitPKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqDistributePKItitle = reqDistributePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign reqSubmitPKIdescription = reqSubmitPKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign reqDistributePKIdescription = reqDistributePKI.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}



### 2:XX.1 Scope

The Publish PKI Material transaction is used by a trust network participants to share their key material. 

A {{ linkvhlh }} or a {{ linkvhls }} initiates the Publish PKI Material on a {{ linkta }}.

### 2:XX.2 Actor Roles



| Actor | Role |
|-------|------|
| {{ linkvhlr}}, {{ linkvhls}} | {{ reqSubmitPKItitle.valueString }}     |
| {{ linkta }}            | {{ reqDistributePKItitle.valueString }} |
{: .grid}


### 2:XX.3 Referenced Standards


### 2:XX.4 Messages

#### 2:XX.4.1 Publish PKI Material Request Message
##### 2:XX.4.1.1 Trigger Events
{{ reqSubmitPKIdescription.valueMarkdown}}

{% include requirements-list-statements.liquid site=site req=reqSubmitPKI  %}

##### 2:XX.4.1.2 Message Semantics
The message semantics for the submission of key material is left to the implementing jurisdiction of the trust network.  Within a trust network there may be different requirements for submission of key material depending on the usage of that key material,  For example:
* publication of key material at a URL that is shared with the {{ linkta }} via publication at a well-known website
* publication of key material at a URL that is shared with the {{ linkta }} through official channels (e.g. official letters) 
* submission of key material via API over a secured connection by a service managed by the {{ linkta }}
* secure in-person physcial transfer with verification of identify on a storage device.


##### 2:XX.4.1.3 Expected Actions
{{ reqDistributePKIdescription.valueMarkdown }}

{% include requirements-list-statements.liquid req=reqDistributePKI site=site  %}

#### 2:XX.4.2 Publish PKI Material Response Message 

There is no Publish PKI Material Repsonse Message defined in this profile.  This is up to the implementing jurisidiction of the {{ linkta }}


### 2:XX.5 Security Considerations 
The secure, trusted exchange of public key material is an essential component of a trust network.  The utmost care should be taken to ensure that key material is not compromised.  Implementers should pay particular attention to requirements from the implementing jurisidiction of the {{ linkta }}.






