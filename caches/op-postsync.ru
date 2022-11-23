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


CLEAR GRAPH bdg:EtextAccess ;

INSERT
  { 
    GRAPH bdg:EtextAccess { 
      ?eiadm adm:status ?st ;
             adm:access ?acc ;
             adm:restrictedInChina ?ric .
      ?ei    :instanceReproductionOf ?mw .
      ?mw    :instanceHasReproduction ?ei .
      ?ei    :instanceOf ?wa .
    } 
  }
WHERE
  { 
    {
        ?eiadm adm:syncAgent bdr:SAOPT ;
               adm:adminAbout ?ei .
        ?ei :instanceReproductionOf ?w .
        ?w a :ImageInstance .
        ?w :instanceReproductionOf ?mw .
        ?wadm adm:adminAbout ?w .
        ?wadm adm:status ?st ;
              adm:access ?acc ;
              adm:restrictedInChina ?ric .
    } union {
      ?eiadm adm:syncAgent bdr:SAOPT ;
               adm:adminAbout ?ei .
      ?ei :instanceReproductionOf ?w .
      ?w :instanceOf ?wa .
    }
  }
