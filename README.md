
# lds-queries 

A repository of SPARQL queries to be used by [LDS-PDI](https://github.com/buda-base/lds-pdi/).

## Format of the query files

The queries are in a custom format where information about the parameters is given in sparql commentaries.

Query files must have the extension `.arq` and be formatted as in this example:

```sparql
#QueryScope=General
#QueryReturnType=Table
#QueryResults=A table containing the Id and matching literal for the given query and language tag with the given limit
#QueryParams=L_NAME,LG_NAME,I_LIM
#QueryUrl=/Res_withFacet?L_NAME=("mkhan chen" AND ("'od zer" OR "ye shes"))&LG_NAME=bo-x-ewts&I_LIM=100

#param.L_NAME.type=string
#param.L_NAME.langTag=LG_NAME
#param.L_NAME.isLucene=true
#param.L_NAME.example=("'od zer" OR "ye shes")
#param.I_LIM.type=int
#param.I_LIM.desc=the maximum number of results

#output.?s.type=URI
#output.?s.desc=the resource URI
#output.?f.type=URI
#output.?f.desc=the resourceType URI of the resource
#output.?lit.type=string
#output.?lit.desc=the label/pref. label of the resource

select distinct ?s ?f ?lit
WHERE {
  { (?s ?sc ?lit) text:query ( skos:prefLabel ?L_NAME ) . }
  union
  { (?s ?sc ?lit) text:query ( skos:altLabel ?L_NAME ) . }
  union
  { (?t ?sc ?lit) text:query ( rdfs:label ?L_NAME ) . ?s ?p ?t } .
  ?s a ?f  .
}
limit ?I_LIM
```

### Query metadata

These parameters must be defined for all the queries, at the top of the file:

| Parameter | Values | Description |
| ----- | ----- | ----- |
| `QueryScope` | ? | ? |
| `QueryReturnType` | `Table` or `Graph` | Indicates if the (resp.) `SELECT` or `CONSTRUCT` keyword is used. |
| `QueryResults` | ? | ? |
| `QueryParams` | ? | ? |
| `QueryUrl` | ? | ? |


### Variable metadata

Then information must be given on the input variables (variables that are supposed to be changed by the user).

#### Variable name conventions

The format is made so that lds-pdi can perform a parameter evaluation in order to prevent SPARQL injection. It understands 3 formats of variables in the SPARQL query itself:

- *Literal*: each literal parameter name must be prefixed by `L_` (ex : `L_NAME`)
- *Literal lang tag*: each literal parameter can be associated with a lang tag using a parameter prefixed by `LG_` (Ex : if you want `L_FOO` to be associated with the `bar` lang tag, you can add `LG_FOO=bar` to your request and declare it in the `QueryParams` section of your template).
- *Integer*: each literal parameter name must be prefixed by `I_` (ex : `I_LIM`)
- *Resource*: each resource URI parameter must be prefixed `R_` (ex : `R_RES`)

#### Variables metadata

#### Input variables

For each input variable, there must be definitions in the form:

```sparql
#{metadata_type}.{variable_name}.{key}={value}
```

where:
- `{metadata_type}` is `param` (see output variables for another possible value)
- `{variable_name}` is the name of the variable as appearing in the SPARQL query (using the conventions indicated above)
- `{key}` and `{value}` are the metadata

The possible key / values are:

| Key | Value | Note |
| ----- | ----- | ----- |
| `langTag` | a BCP47 lang tag value | only for *Literal* variables |
| `isLucene` | `true` or `false` | only for *Literal* variables, indicates if the value should be parsed as a Lucene query (for [text:query Jena extension](https://jena.apache.org/documentation/query/text-query.html)) |
| `example` | an example of value | optional |
| `type` | `boolean`, `integer`, `string`, `URI` | gives the type of variable (is it optional?) |
| `subType` | an indication of subtype | optional, only for *Resource* variables |
| `desc` | a description of the value | optional |
| `langTag` | the value of another variable | this gives the `{variable_name}` of the lang tag used in the SPARQL query |

Note that you do not have to create entries for the lang tag variables as long as they are indicated as a `langTag` value.

Here is an example:

```sparql
#param.L_NAME.type=string
#param.L_NAME.langTag=LG_NAME
#param.L_NAME.isLucene=true
#param.L_NAME.example=("'od zer" OR "ye shes")
#param.L_NAME.desc=the name to query
```

#### Output variables

For `SELECT` queries where the result contains values of SPARQL variables, the template also requires a small set of information about the returned variables. It is in the same format as the input variable, except:
- `{metadata_type}` is `output`
- there is no need to respect the conventions for variable names
- only `desc` and `type` are valid metadata keys


### FILTER SPARQL Injection

Additional rule : Filter on variables should be the last ones in a query

ex:

```sparql
FILTER (contains(?root_name, ?NAME ))

FILTER ((contains(?comment_type, "commentary" ))
```

will fail because it is subject to an injection attack while :

```sparql
FILTER ((contains(?comment_type, "commentary" ))

FILTER (contains(?root_name, ?NAME ))
```

will be considered safe.


### Examples :


```sparql
#QueryScope=General
#QueryReturnType=Table
#QueryResults=A table containing the Id and matching literal for the given query and language tag with the given limit
#QueryParams=L_NAME,LG_NAME,I_LIM
#QueryUrl=/Res_byName?L_NAME=("mkhan chen" AND ("'od zer" OR "ye shes"))&LG_NAME=bo-x-ewts&I_LIM=100

select distinct ?s ?lit
WHERE {
  { (?s ?sc ?lit) text:query ( skos:prefLabel ?L_NAME ) . }
  union
  { (?s ?sc ?lit) text:query ( rdfs:label ?L_NAME ) . }
} limit ?I_LIM

```


```sparql
#QueryScope=Person
#QueryReturnType=Table
#QueryResults=All the detailed admin info (notes, status, log entries) about the person data
#QueryParams=R_RES
#QueryUrl=/Person_adminDetails?R_RES=P1583


select distinct
?ID
?preferredName
?y ?noteRef ?note_value ?admin_prop ?admin_ref ?log_value ?git ?status
where {
    {
      ?ID skos:prefLabel ?preferredName ;
          adm:gitRevision ?git;
        adm:status ?status .
      Filter(?ID=?R_RES)
  }
    UNION {
      OPTIONAL{ ?ID  :note ?noteRef }.
      ?noteRef ?y ?note_value .
      Filter(?ID=?R_RES)
  }
    UNION {
      OPTIONAL{ ?ID  adm:logEntry ?admin_ref }.
      ?admin_ref ?admin_prop ?log_value .
      Filter(?ID=?R_RES)
  }
}
```
### Limiting text search output :

You can limit the text search output (i.e the number of matches returned by jena Text) using a LI_XXX param where XXX is the name of the text variable (for instance: `L_NAME`)

This naming convention is illustrated by that query string:

`/Name_of_the_template?L_XXX=("མཁན་ཆེན་"+AND+("འོད་ཟེར་"+OR+"ཡེ་ཤེས་"))&LG_XXX=bo&LI_XXX=25`

if no `LI_XXX` is specified, then the limit is set to a default value definied in the application properties:

`text_query_limit=1000`

## Copyright and License

These SPARQL queries are Copyright Buddhist Digital Resource Center 2017-2019, and are provided under the [Apache License 2.0](LICENSE).
