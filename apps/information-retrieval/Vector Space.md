
## Scoring using the Vector Space Model

Previously we discussed tf-idf as a way to calculate how relevant a search term
is given a set of indexed documents. When having multiple terms, we used
*overlap score measure* consisting in the sum of the *tf-idf* for each term in
the given input. A more general and flexible way of scoring multi-term searches
is using the **vector space model**.

In the vector space model, each document in the corpus is represented by a
vector. The search input terms are also represented by a vector. Scoring search
results consists then in vector operations between the documents vectors and the
search terms vector.



But what is each of these vectors made of? Basically they define term
frequencies. That is, each dimension in a vector represents the term frequency
for a given term. Then, a document is represented in a multi-dimensional space
by a vector of the frequencies of each of the words in hte corpus. Equally, a
search input is represented by a vector in the same space but using the input
terms.

### Python implementation

The following is a Python representation if this concept.


    import re
    
    class IrIndex:
        """An in-memory inverted index"""
    
        pattern = re.compile("^\s+|\s*,*\s*|\s+$")
    
        def __init__(self):
            self.index = {}
            self.documents = []
            self.vectors = []
    
        def index_document(self, document):
            # split
            terms = [word for word in self.pattern.split(document)]
            # add to documents
            self.documents.append(document)
            document_pos = len(self.documents) - 1
            # add posts to index, while creating document vector
            vector = {}
            for term in terms:
                if term not in self.index:
                    self.index[term] = []
                self.index[term].append(document_pos)
                if term not in vector:
                    vector[term] = 1
                else:
                    vector[term] += 1
            # add the vector
            self.vectors.append(vector)

We use the same `IrIdenx` class and a boolean search schema. The difference is
when calculating scores. We don't store a precalculated `tf` structure anymore
but operate vectors directly.

In terms of complexity, when indexing we have moved from:
* Recalculate every `tf` entry when indexing a new document. This involves
lookup + sum for each term in the document.

To:
* Indexing stage: store a new document as a vectors of `tf` values. Here we save
the recalculation of `tf` entries.

So as we can see, the indexing stage is simpler (and more scalable) when using
the vector space model. This scalability gain when indexing is not to be
overlooked. In an index with hundreds of thousands or even millions of terms,
indexing a new large document and recalculating term frequencies at a global
scale can be costly. We could calculate term frequencies when searching instead,
but then using the vector space model makes even more sense.

Next the search and scoring part.


    from numpy import array, dot
    from math import log
    
    def create_tfidf_list(self, *args):
            if len(args) == 1:
                res = [tf for tf in args[0].itervalues()]
            elif len(args) == 2:
                res = []
                for term in args[0].iterkeys():
                    if term in args[1]:
                        idf = log(float(len(self.documents)) / float(len(self.index[term])))
                        res.append(args[1][term] * idf)
                    else:
                        res.append(0)
            return res
    
    def create_tf_dictionary(self, terms):
        res = {}
        for term in self.pattern.split(terms):
            if term not in res:
                res[term] = terms.count(term)
        return res
    
    def vector_space_search(self, terms):
        res = []
        hits = {}
        # create a numeric vector from terms
        terms_tf_dictionary = self.create_tf_dictionary(terms)
        terms_tfidf_list = self.create_tfidf_list(terms_tf_dictionary)
        # create a numeric vector for each hitting document
        hitting_terms = [term for term in self.pattern.split(terms) if term in self.index]
        for term in hitting_terms:  # for each term having at least on hit...
            for post in self.index[term]:  # for each document create the numeric vector
                if post not in hits:
                    tfidf_list = self.create_tfidf_list(terms_tf_dictionary, self.vectors[post])
                    hits[post] = tfidf_list
        # do the dot products
        for post in hits.iterkeys():
            score = dot(array(terms_tfidf_list), array(hits[post]))
            res.append((score, self.documents[post]))
        return res
    
    
    IrIndex.create_tf_dictionary = create_tf_dictionary
    IrIndex.create_tfidf_list = create_tfidf_list
    IrIndex.vector_space_search = vector_space_search

At search stage, we have moved from:

* Calculate the `idf` and access the `tf` lookup table for each search term and
document hit. Sum the resulting `tf-idf` values for each document hit. This is
done using two for loops, one of them including another nested internal for
loop.

To:
* Access the `index` lookup table for any of the search terms and perform dot-
product with the resulting vectors. The later is an overhead introduced by this
approach in the search stage.

The new search stage has introduced vector dot products where there were just
sums (although using nested lopps) when the vector space model was not used.
However the data structures and their usage has been simplified. Note that we
build the vectors from pre-calculated dictionaries. Doing so we can determine
the dimensions form the search query vector.

### Other benefits of the Vector Space Model

But what other benefits come with the vector space model? These are some of
them:
* Treating queries as vectors allows us simplifying data structures and
calculations. Where we used two dictionaries and loops, now we use a single
dictionary and linear algebra.
* The compact and easy to operate vector representation leaves the door open to
different weighting and transformation schemas that were difficult to apply
before (or at least the result were not so clean).
* Vectors can be the input of additional Information Retrieval and Machine
Learning techniques including supervised (e.g. classification) and unsupervised
(e.g. clustering, frequent pattern mining).


### Examples

Let us now recall our sample wine-related mini-corpus in order to see if we get
similar results using the new Vector Space Model. Remember that results are
given unsorted. Just pay attention to the scores.


    index = IrIndex()
    index.index_document("Bruno Clair Chambertin Clos de Beze 2001, Bourgogne, France")
    index.index_document("Bruno Clair Chambertin Clos de Beze 2005, Bourgogne, France")
    index.index_document("Bruno Clair Clos Saint Jaques 2001, Bourgogne, France")
    index.index_document("Bruno Clair Clos Saint Jaques 2002, Bourgogne, France")
    index.index_document("Bruno Clair Clos Saint Jaques 2005, Bourgogne, France")
    index.index_document("Coche-Dury Bourgogne Chardonay 2005, Bourgogne, France")
    index.index_document("Chateau Margaux 1982, Bordeaux, France")
    index.index_document("Chateau Margaux 1996, Bordeaux, France")
    index.index_document("Chateau Latour 1982, Bordeaux, France")
    index.index_document("Domaine Raveneau Le Clos 2001, Bourgogne, France")


    index.vector_space_search("hello")




    []




    index.vector_space_search("Bordeaux")




    [(1.2039728043259361, 'Chateau Latour 1982, Bordeaux, France'),
     (1.2039728043259361, 'Chateau Margaux 1982, Bordeaux, France'),
     (1.2039728043259361, 'Chateau Margaux 1996, Bordeaux, France')]




    index.vector_space_search("Margaux")




    [(1.6094379124341003, 'Chateau Margaux 1982, Bordeaux, France'),
     (1.6094379124341003, 'Chateau Margaux 1996, Bordeaux, France')]




    index.vector_space_search("Bourgogne")




    [(0.22314355131420976,
      'Bruno Clair Chambertin Clos de Beze 2001, Bourgogne, France'),
     (0.22314355131420976,
      'Bruno Clair Chambertin Clos de Beze 2005, Bourgogne, France'),
     (0.22314355131420976,
      'Bruno Clair Clos Saint Jaques 2001, Bourgogne, France'),
     (0.22314355131420976,
      'Bruno Clair Clos Saint Jaques 2002, Bourgogne, France'),
     (0.22314355131420976,
      'Bruno Clair Clos Saint Jaques 2005, Bourgogne, France'),
     (0.44628710262841953,
      'Coche-Dury Bourgogne Chardonay 2005, Bourgogne, France'),
     (0.22314355131420976, 'Domaine Raveneau Le Clos 2001, Bourgogne, France')]




    index.vector_space_search("hello Bordeaux")




    [(1.2039728043259361, 'Chateau Latour 1982, Bordeaux, France'),
     (1.2039728043259361, 'Chateau Margaux 1982, Bordeaux, France'),
     (1.2039728043259361, 'Chateau Margaux 1996, Bordeaux, France')]




    index.vector_space_search("Bourgogne Bordeaux")




    [(0.22314355131420976,
      'Bruno Clair Chambertin Clos de Beze 2001, Bourgogne, France'),
     (0.22314355131420976,
      'Bruno Clair Chambertin Clos de Beze 2005, Bourgogne, France'),
     (0.22314355131420976,
      'Bruno Clair Clos Saint Jaques 2001, Bourgogne, France'),
     (0.22314355131420976,
      'Bruno Clair Clos Saint Jaques 2002, Bourgogne, France'),
     (0.22314355131420976,
      'Bruno Clair Clos Saint Jaques 2005, Bourgogne, France'),
     (0.44628710262841953,
      'Coche-Dury Bourgogne Chardonay 2005, Bourgogne, France'),
     (1.2039728043259361, 'Chateau Margaux 1982, Bordeaux, France'),
     (1.2039728043259361, 'Chateau Margaux 1996, Bordeaux, France'),
     (1.2039728043259361, 'Chateau Latour 1982, Bordeaux, France'),
     (0.22314355131420976, 'Domaine Raveneau Le Clos 2001, Bourgogne, France')]




    index.vector_space_search("Margaux Bordeaux")




    [(1.2039728043259361, 'Chateau Latour 1982, Bordeaux, France'),
     (2.8134107167600364, 'Chateau Margaux 1982, Bordeaux, France'),
     (2.8134107167600364, 'Chateau Margaux 1996, Bordeaux, France')]


