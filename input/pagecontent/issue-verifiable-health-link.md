
{% assign linkta = '<a href="ActorDefinition-TrustAnchor.html">Trust Anchor</a>' %}
{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}
{% assign linkvhlr = '<a href="ActorDefinition-VHLReceiver.html">VHL Receiver</a>' %}

## 2:XX Issue Verfiable Health Link

{% assign reqRequestVHL = site.data.Requirements-RequestVHL %}
{% assign reqGenerateVHL = site.data.Requirements-GenerateVHL %}
{% assign reqReceiveVHL = site.data.Requirements-ReceiveVHL %}

{% assign reqRequestVHLtitle = reqRequestVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqReceiveVHLtitle = reqReceiveVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqGenerateVHLtitle = reqGenerateVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}

{% assign reqRequestVHLdescription = reqRequestVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign reqReceiveVHLdescription = reqReceiveVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign reqGenerateVHLdescription = reqGenerateVHL.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}


### 2:XX.1 Scope

The Issue Verfiable Health Link transaction returns a Verifiable Health Link authorization mechanism which can be used to provide access to one or more documents.  A {{ linkvhlh }} initiates the Issue VHL transaction against a {{ linkvhls }}.
 
### 2:XX.2 Actor Roles




| Actor        | Role |
|--------------|--------|
| {{linkvhlh}} |  {{ reqRequestVHLtitle.valueString }} |
|            |  {{ reqReceiveVHLtitle.valueString }} |
| {{ linkvhls}} |  {{ reqGenerateVHLtitle.valueString }} |
{: .grid}

### 2:XX.3 Referenced Standards


### 2:XX.4 Messages

#### 2:XX.4.1 Issue VHL Request Message
##### 2:XX.4.1.1 Trigger Events
{{ reqRequestVHLdescription.valueMarkdown}}

##### 2:XX.4.1.2 Message Semantics
None defined. Up to a content profile to define.

##### 2:XX.4.1.3 Expected Actions
{{ reqGenerateVHLdescription.valueMarkdown}}

#### 2:XX.4.2 Issue VHL Response Message

##### 2:XX.4.2.1 Trigger Events


A [VHL Sharer](ActorDefinition-VHLSharer.html) initiates an Issue Verifiable Health Link Response Message once it has completed, to the extent possible, the expected actions upon receipt of a Issue Verifiable Health Link Request message, as specified by an appropriate content profile.

##### 2:XX.4.2.2  Message Semantics
None defined. Up to a content profile to define.

##### 2:XX.4.2.3 Expected Actions
{{ reqReceiveVHLdescription.valueMarkdown }}


### 2:XX.5 Security Considerations 
Depends on the content profile.






