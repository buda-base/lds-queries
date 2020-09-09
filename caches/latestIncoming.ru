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


CLEAR GRAPH bdg:CacheLatest ;

INSERT
  { GRAPH bdg:CacheLatest { ?eadm tmp:lastSync ?d } }
WHERE
  { 
  	{
  	  select ?eadm (max(?sdate) as ?d)
      where {
        ?le adm:logDate ?sdate .
        FILTER(?sdate > "2020-08-20T00:00:00"^^xsd:dateTime)
        ?le a adm:Synced .
        ?va adm:logEntry ?le ;
            adm:adminAbout ?v .
        ?v bdo:volumeOf ?iinstance .
        ?eadm adm:adminAbout ?iinstance .
      } group by ?eadm

    }
  } ;
INSERT
  { GRAPH bdg:CacheLatest { ?eadm tmp:dateCreated ?sdate } }
WHERE
  {
    	?le adm:logDate ?sdate .
        FILTER(?sdate > "2020-08-20T00:00:00"^^xsd:dateTime)
        ?le a adm:InitialDataCreation .
        ?eadm adm:logEntry ?le ;
            adm:adminAbout ?e .
        ?e a ?type .
        FILTER (?type != bdo:ImageGroup)
    }