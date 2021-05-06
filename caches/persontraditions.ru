prefix :      <http://purl.bdrc.io/ontology/core/>
prefix adm:   <http://purl.bdrc.io/ontology/admin/>
prefix bdo:   <http://purl.bdrc.io/ontology/core/>
prefix bdr:   <http://purl.bdrc.io/resource/>
prefix tmp:   <http://purl.bdrc.io/ontology/tmp/>
prefix owl:   <http://www.w3.org/2002/07/owl#>
prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#>
prefix skos:  <http://www.w3.org/2004/02/skos/core#>
prefix vcard: <http://www.w3.org/2006/vcard/ns#>
prefix xsd:   <http://www.w3.org/2001/XMLSchema#>
prefix bdg:   <http://purl.bdrc.io/graph/>
prefix bda:   <http://purl.bdrc.io/admindata/>


CLEAR GRAPH bdg:CacheTraditions ;

#
# The logic is the following (copied from tbrc.org):
#   - take the latest event with an associatedTradition, that gives the tradition associated with the place
#   - take the places associates with the PersonOccupiesSeat, their associated tradition gives you the traditions associated with the persons
#


INSERT
  { 
    GRAPH bdg:CacheTraditions { 
  		?pl bdo:associatedTradition ?plt .
  		?p bdo:associatedTradition ?pt .  
  	} 
  }
WHERE
{
  {
    ?pl :placeEvent ?ple .
    ?ple :associatedTradition ?plt .
  } union {
    ?p :personEvent ?pe .
    ?pe a :PersonOccupiesSeat ;
        :eventWhere ?ppl .
    ?ppl :placeEvent ?pple .
    ?pple :associatedTradition ?pt . 
  }
}
