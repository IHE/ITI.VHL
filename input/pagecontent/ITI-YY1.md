
{% assign linkvhlh = '<a href="ActorDefinition-VHLHolder.html">VHL Holder</a>' %}
{% assign linkvhls = '<a href="ActorDefinition-VHLSharer.html">VHL Sharer</a>' %}


## 2:XX Generate VHL
 {% assign reqGenerateVHLRequest = site.data.Requirements-InitiateVHLGenerationRequest %}
 {% assign reqGenerateVHLResponse = site.data.Requirements-RespondtoGenerateVHLRequest %}


### 2:XX.1 Scope

{% assign reqGenerateVHLRequesttitle = reqGenerateVHLRequest.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}
{% assign reqGenerateVHLResponsetitle = reqGenerateVHLResponse.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.title" | first %}


{% assign reqGenerateVHLRequestdescription = reqGenerateVHLRequest.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}
{% assign reqGenerateVHLResponsedescription = reqGenerateVHLResponse.extension  | where: "url", "http://hl7.org/fhir/5.0/StructureDefinition/extension-Requirements.description" | first %}

### 2:XX.2 Actor Roles

| Actor | Role |
|-------|------|
| {{ linkvhlh}} | {{ reqGenerateVHLRequesttitle.valueString }}     |
| {{ linkvhls }}            | {{ reqGenerateVHLResponsetitle.valueString }} |
{: .grid}


### 2:XX.3 Referenced Standards


### 2:XX.4 Messages

#### 2:XX.4.1 Re Generate VHL Request Message
##### 2:XX.4.1.1 Trigger Events
{{ reqGenerateVHLRequestdescription.valueMarkdown}}

{% include requirements-list-statements.liquid site=site req=reqGenerateVHLRequest  %}
##### 2:XX.4.1.2 Message Semantics
OPTIONS TO DISCUSS:


##### 2:XX.4.1.3 Expected Actions
{{ reqGenerateVHLResponsedescription.valueMarkdown }}

{% include requirements-list-statements.liquid req=reqGenerateVHLResponse site=site  %}

#### 2:XX.4.2  Generate VHL Response Message 

##### 2:XX.4.2.1 Trigger Events


##### 2:XX.4.2.2  Message Semantics


##### 2:XX.4.2.3 Expected Actions



### 2:XX.5 Security Considerations 






