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
* description = "Capability Statement for a VHL Sharer implementing the Retrieve Manifest [ITI-YY5] transaction as a server. This server supports FHIR search on List resources with _include parameter to retrieve document manifests authorized by Verified Health Links."
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #application/fhir+json
* format[1] = #application/fhir+xml

* rest
  * mode = #server
  * documentation = "VHL Sharer provides access to document manifests (List resources) and references (DocumentReference resources) authorized by Verified Health Links (VHLs). Authorization is based on validated VHL tokens containing manifest URLs with folder IDs."
  
  * security
    * description = "Implementations SHALL support ATNA Authenticate Node [ITI-19] for mutual TLS authentication. VHL-based authorization is required (folder ID in _id parameter), optionally supplemented by OAuth 2.0 or other token-based authentication."
  
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
      * documentation = "The patient whose documents are referenced in the List. SHOULD be supported. The VHL Sharer SHALL accept chained searches on patient.identifier (e.g., patient.identifier=system|value) for List searches."
    
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
    
    // Search Includes
    * searchInclude = "List:item"

  // DocumentReference Resource
  * resource[+]
    * type = #DocumentReference
    * profile = "http://hl7.org/fhir/StructureDefinition/DocumentReference"
    * documentation = "DocumentReference resources are included in search results via the _include parameter. They are not directly searchable in this transaction but are returned as part of the List search response."
    
    * interaction[0]
      * code = #read
      * documentation = "Read DocumentReference by ID. May be used after Retrieve Manifest to get updated metadata."

Instance: VHLReceiverCapabilityStatement
InstanceOf: CapabilityStatement
Usage: #definition
* url = "http://profiles.ihe.net/ITI/VHL/CapabilityStatement/vhl-receiver-client"
* version = "1.0.0"
* name = "VHLReceiverCapabilityStatement"
* title = "VHL Receiver Client Capability Statement"
* status = #active
* experimental = false
* date = "2024-01-15"
* publisher = "IHE ITI"
* description = "Capability Statement for a VHL Receiver implementing the Retrieve Manifest [ITI-YY5] transaction as a client. This client searches for List resources using VHL-authorized manifest URLs and can request inclusion of DocumentReference resources via the _include parameter."
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #application/fhir+json
* format[1] = #application/fhir+xml

* rest
  * mode = #client
  * documentation = "VHL Receiver retrieves document manifests (List resources) and optionally DocumentReference resources from VHL Sharers using VHL-authorized manifest URLs. The client extracts the manifest URL from the VHL payload (obtained via ITI-YY4 Provide VHL) and performs a FHIR search with mandatory parameters."
  
  * security
    * description = "Implementations SHALL support ATNA Authenticate Node [ITI-19] for mutual TLS authentication. The VHL Receiver SHALL provide the VHL authorization token (folder ID) and MAY provide additional authentication tokens (OAuth 2.0, JWS signatures)."
  
  // List Resource
  * resource[0]
    * type = #List
    * profile = "http://hl7.org/fhir/StructureDefinition/List"
    * documentation = "The VHL Receiver searches for List resources using the manifest URL extracted from the VHL payload. The search SHALL include mandatory parameters: _id (folder ID), code, and status, and SHALL include the patient identifier using FHIR chained search on the patient parameter (i.e., patient.identifier=system|value). The VHL Receiver MAY request inclusion of DocumentReference resources via the _include parameter."
    
    * interaction[0]
      * code = #search-type
      * documentation = "Search for List resources using manifest URL from VHL payload. The VHL Receiver SHALL support searching with _id, code, and status parameters, and SHALL support chained search on the patient parameter (patient.identifier=system|value) to identify the patient. The VHL Receiver SHALL support the _include=List:item parameter to retrieve DocumentReference resources in a single request."
    
    // Search Parameters
    * searchParam[0]
      * name = "_id"
      * definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
      * type = #token
      * documentation = "Folder ID from VHL payload. This is the primary authorization mechanism. SHALL be supported and SHALL be included in every manifest retrieval request."
    
    * searchParam[+]
      * name = "code"
      * definition = "http://hl7.org/fhir/SearchParameter/List-code"
      * type = #token
      * documentation = "List type, typically 'folder'. SHALL be supported and SHALL be included in manifest URL from VHL payload."
    
    * searchParam[+]
      * name = "status"
      * definition = "http://hl7.org/fhir/SearchParameter/List-status"
      * type = #token
      * documentation = "List status, typically 'current'. SHALL be supported and SHALL be included in manifest URL from VHL payload."
    
    * searchParam[+]
      * name = "patient"
      * definition = "http://hl7.org/fhir/SearchParameter/List-patient"
      * type = #reference
      * documentation = "Patient reference search parameter. SHALL be supported with FHIR chained search (patient.identifier=system|value) to identify the patient by identifier without requiring a direct Patient resource reference. SHALL be included in the manifest URL from the VHL payload."
    
    // Search Includes
    * searchInclude = "List:item"

  // DocumentReference Resource
  * resource[+]
    * type = #DocumentReference
    * profile = "http://hl7.org/fhir/StructureDefinition/DocumentReference"
    * documentation = "DocumentReference resources MAY be returned as included resources when _include=List:item is used in the List search. The VHL Receiver SHALL be capable of processing DocumentReference resources returned with search.mode='include' in the searchset Bundle."
    
    * interaction[0]
      * code = #read
      * documentation = "Read individual DocumentReference resources by ID. Used when _include is not supported by the VHL Sharer or when retrieving updated metadata after the initial manifest retrieval."
    
    * interaction[+]
      * code = #search-type  
      * documentation = "Search for DocumentReference resources. MAY be used to retrieve individual DocumentReferences when _include is not available or to apply additional filters after manifest retrieval."