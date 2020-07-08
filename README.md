# Code and scripts for "Geodesic cycle length distributions in delusional and other social networks"

A recently published paper [Martin (2017) JoSS 18(1):1-21] investigates the structure of an unusual set of social networks, those of the alternate personalities described by a patient undergoing therapy for multiple personality disorder (now known as dissociative identity disorder). The structure of these networks is modeled using the dk-series, a sequence of nested network distributions of increasing complexity. Martin finds that the first of these networks contains a striking feature of a large "hollow ring"; a cycle with no shortcuts, so that the shortest path between any two nodes in the cycle is along the cycle (in more precise graph theory terms, this is a geodesic cycle). However the subsequent networks have much smaller largest cycles, smaller than those expected by the models. In this work I re-analyze these delusional social networks using exponential random graph models (ERGMs) and investigate the distribution of the lengths of geodesic cycles. I also conduct similar investigations for some other social networks, both fictional and empirical, and show that the geodesic cycle length distribution is a macro-level structure that can arise naturally from the micro-level processes modeled by the ERGM.

Keywords: Geodesic cycle, Exponential random graph model, ERGM, dk-series random graphs, Social networks, Fictional networks, Dissociative identity disorder

## Code and scripts

The code and scripts in this repository were imported from the geodesic_cycles_code_scripts.tar.gz file available from https://sites.google.com/site/alexdstivala/home/geodesic_cycles.

The code for counting geodesic cycles uses the Waffles machine learning library https://github.com/mikegashler/waffles.

## Reference
Stivala, A. 2020.  "Geodesic cycle length distributions in delusional and other social networks". Unpublished manuscript.
