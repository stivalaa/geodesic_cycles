# Code, scripts, and data for "Geodesic cycle length distributions in delusional and other social networks" (2020) and "Geodesic cycle length distributions in fictional character networks" (2023)

## Geodesic cycle length distributions in delusional and other social networks

A recently published paper [Martin (2017) JoSS 18(1):1-21] investigates the structure of an unusual set of social networks, those of the alternate personalities described by a patient undergoing therapy for multiple personality disorder (now known as dissociative identity disorder). The structure of these networks is modeled using the dk-series, a sequence of nested network distributions of increasing complexity. Martin finds that the first of these networks contains a striking feature of a large "hollow ring"; a cycle with no shortcuts, so that the shortest path between any two nodes in the cycle is along the cycle (in more precise graph theory terms, this is a geodesic cycle). However the subsequent networks have much smaller largest cycles, smaller than those expected by the models. In this work I re-analyze these delusional social networks using exponential random graph models (ERGMs) and investigate the distribution of the lengths of geodesic cycles. I also conduct similar investigations for some other social networks, both fictional and empirical, and show that the geodesic cycle length distribution is a macro-level structure that can arise naturally from the micro-level processes modeled by the ERGM.

Keywords: Geodesic cycle, Exponential random graph model, ERGM, dk-series random graphs, Social networks, Fictional networks, Dissociative identity disorder

## Geodesic cycle length distributions in fictional character networks

A geodesic cycle in a graph is a cycle with no shortcuts, so that the
shortest path between any two nodes in the cycle is the path along the
cycle itself. A recently published paper used random graph models to
investigate the geodesic cycle length distributions of a unique set of
delusional social networks, first examined in an earlier work, as well
as some other publicly available social networks. Here I test the
hypothesis, suggested in the former work, that fictional character
networks, and in particular those from works by a single author, might
have geodesic cycle length distributions which are extremely unlikely
under random graph models, as the delusional social networks do. The
results do not show any support for this hypothesis. In addition, the
recently published work is reproduced using a method for counting
geodesic cycles exactly, rather than the approximate method used
originally.  The substantive conclusions of that work are unchanged,
but some differences in the results for particular networks are
described.

Keywords: Geodesic cycle, Isometric cycle, Exponential random graph model, ERGM, dk-series random graphs, Social networks, Fictional character networks

## Code and scripts

The code for finding "atomic cycles" uses the Waffles machine learning library https://github.com/mikegashler/waffles.

The code for counting geodesic cycles uses the CYPATH software from http://research.nii.ac.jp/~uno/code/cypath11.zip (see http://research.nii.ac.jp/~uno/code/cypath.html) to find chordless cycles.

Both the R and Python scripts use the igraph graph library https://igraph.org/.

## References

Martin, J. L. 2017. "The structure of node and edge generation in a delusional social network". Journal of Social Structure, 18(1):1–22. https://doi.org/10.21307/joss-2018-005

Martin, J. L. 2020. "Comment on Geodesic Cycle Length Distributions in Delusional and Other Social Networks". Journal of Social Structure, 21(1):77-93. https://doi.org/10.21307/joss-2020-003

Stivala, A. 2019. "The hollow ring of randomness: Large worlds in small data". Fourth Annual Australian Social Network Analysis Conference (ASNAC 2019), November 28-29, 2019, Adelaide, South Australia. https://stivalaa.github.io/AcademicWebsite/slides/geodesic_cycles_slides.pdf

Stivala, A. 2020a. "Geodesic cycle length distributions in delusional and other social networks". Journal of Social Structure, 21(1):35-76. https://doi.org/10.21307/joss-2020-002

Stivala, A. 2020b. "Reply to “Comment on Geodesic Cycle Length Distributions in Delusional and Other Social Networks”" Journal of Social Structure 21(1):94-106. https://doi.org/10.21307/joss-2020-004

Stivala, A. 2023. "Geodesic cycle length distributions in fictional character networks". arXiv preprint https://arxiv.org/abs/2303.11597

