# Cache queries

These self-contained update queries are supposed to be executed at regular interval in order to generate a cache that makes other queries faster.

To send to an endpoint (using `s-update` from jena):

```
for f in *.ru; do 
	s-update --file=$f --service=http://buda1.bdrc.io:13180/fuseki/corerw/update ;
done
```