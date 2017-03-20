# Org db link

Keep a database of links, use them in your org document.

# Motivation

When making large documents it is common to link to the same document in multiple places.
When doing this it makes sense to add a layer of indirection so you can update a link in just one place.
`org-db-link` lets you do this in `org-mode`.

# Installing

```
(require 'org-db-link)
```

# Using

Links look like this:

```
[[db:db.org:Heading1.Heading2][Link]]

```

When you try to follow or export this link the contents of "Heading1.Heading2" is looked up in `db.org` and the link there is followed or inserted.

This is what `db.org` looks like

```
db.org

* Heading1
** Heading2
[[http://www.google.com][Google]]
```

# Prior work similar tools

The above is largely a description of bibliographies.
You have a single list of documents (your bibliography) and your document refers to entries in bibliography.
Bibliographies tend *not* to link directly to sources, but rather link to a description of the source.
This is due to their history in print text where links were rarely followed.

`Bibtex` is a tool to maintained and create bibliographies for latex.

`org-ref` provides a collection of emacs tools to export latex documents with latex citations that bibtex will understand. Export is only supported to for latex.



