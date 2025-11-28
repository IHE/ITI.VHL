Instance: IHE.VHL.TrustAnchor
InstanceOf: CapabilityStatement
Usage: #definition
* name = "TrustAnchor"
* title = "Trust Anchor"
* description = "CapabilityStatement for Trust Anchor Actor in the IHE IT Infrastructure Technical Framework Supplement IHE VHL. An authorized organization in the trust framework that manages and distributes PKI material—such as public key certificates and revocation lists—to participants in the network. It ensures that this material is trustworthy and available, enabling VHL Sharers and VHL Receivers to verify digital signatures and authenticate the origin of shared data."
* status = $pubStatus#active
* publisher = "IHE"
* date = "2025-03-07"
* kind = #capability
* fhirVersion = #"4.0.1"
* format[+] = #"application/fhir+xml"
* format[+] = #"application/fhir+json"

Instance: VHLSharerCapabilityStatement
InstanceOf: CapabilityStatement
Usage: #definition
* url = "http://profiles.ihe.net/ITI/VHL/CapabilityStatement/vhl-sharer-server"
* version = "1.0.0"
* name = "VHLSharerCapabilityStatement"
* title = "VHL Sharer Server Capability Statement"
* status = #active
* experimental = false
* date = "2024-01-15"
* publisher = "IHE ITI"
* description = "Capability Statement for a VHL Sharer implementing the Retrieve Manifest [ITI-YY5] transaction. This server supports FHIR search on List resources with _include parameter to retrieve document manifests authorized by Verified Health Links."
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #application/fhir+json
* format[1] = #application/fhir+xml

* rest
  * mode = #server
  * documentation = "VHL Sharer provides access to document manifests (List resources) and references (DocumentReference resources) authorized by Verified Health Links (VHLs). Authorization is based on validated VHL tokens containing manifest URLs with folder IDs."
  
  * security
    * description = "Implementations SHALL support ATNA Authenticate Node [ITI-19] for mutual TLS authentication. VHL-based authorization is required, optionally supplemented by OAuth 2.0 or other token-based authentication."
  
  // List Resource
  * resource[0]
    * type = #List
    * profile = "http://hl7.org/fhir/StructureDefinition/List"
    * documentation = "The List resource represents a folder or collection of documents authorized by a VHL. The List.id (folder ID) has 256-bit entropy and serves as the authorization token. List.entry.item contains references to DocumentReference resources."
    
    * interaction[0]
      * code = #search-type
      * documentation = "Search for List resources by folder ID, identifier, patient, code, or status. Used to retrieve document manifests authorized by VHLs. This transaction uses HTTP POST to the _search endpoint to securely transmit authorization parameters."
    
    // Search Parameters
    * searchParam[0]
      * name = "_id"
      * definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
      * type = #token
      * documentation = "Folder ID with 256-bit entropy from the VHL. This is the primary authorization mechanism. SHALL be supported."
    
    * searchParam[+]
      * name = "identifier"
      * definition = "http://hl7.org/fhir/SearchParameter/List-identifier"
      * type = #token
      * documentation = "Business identifier for the List/folder. SHOULD be supported."
    
    * searchParam[+]
      * name = "patient"
      * definition = "http://hl7.org/fhir/SearchParameter/List-patient"
      * type = #reference
      * documentation = "The patient whose documents are referenced in the List. SHOULD be supported."
    
    * searchParam[+]
      * name = "code"
      * definition = "http://hl7.org/fhir/SearchParameter/List-code"
      * type = #token
      * documentation = "The type of List, typically 'folder' from MHD CodeSystem. SHOULD be supported."
    
    * searchParam[+]
      * name = "status"
      * definition = "http://hl7.org/fhir/SearchParameter/List-status"
      * type = #token
      * documentation = "The status of the List (current, retired, etc.). SHOULD be supported."
    
    * searchParam[+]
      * name = "_include"
      * definition = "http://hl7.org/fhir/SearchParameter/Resource-include"
      * type = #special
      * documentation = "Include referenced DocumentReference resources. SHALL support '_include=List:item' to include all DocumentReference resources referenced by List.entry.item."
  
  // DocumentReference Resource
  * resource[+]
    * type = #DocumentReference
    * profile = "http://hl7.org/fhir/StructureDefinition/DocumentReference"
    * documentation = "DocumentReference resources are included in search results via the _include parameter. They are not directly searchable in this transaction but are returned as part of the List search response."
    
    * interaction[0]
      * code = #read
      * documentation = "Read DocumentReference by ID. May be used after Retrieve Manifest to get updated metadata."