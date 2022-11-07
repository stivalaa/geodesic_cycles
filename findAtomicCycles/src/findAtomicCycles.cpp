/*****************************************************************************
 * 
 * File:    findAtomicCycles.cpp
 * Author:  Alex Stivala
 * Created: August 2019
 *
 * Ffind 'atomic cycles' in a graph using the routines from the
 * Waffles machine learning library:
 *
 * http://gashler.com/mike/waffles/index.html
 * https://github.com/mikegashler/waffles
 * 
 * References:
 *
 * Gashler, M. (2011). Waffles: A machine learning toolkit. Journal of
 * Machine Learning Research, 12(Jul), 2383-2387
 *
 * Gashler, M., & Martinez, T. (2012). Robust manifold learning with
 * CycleCut. Connection Science, 24(1), 57-69.
 *
 * Usage: findAtomicCycles N edgelist.txt
 *   N is the number of nodes in the input network
 *   edgelist.txt is edge list space delimited format and nodes
 *   must be numbered consecutively 0..N-1
 *   e.g. (N = 8):
 *   0 1
 *   1 2
 *   2 3
 *   3 4
 *   4 5
 *   5 6
 *   6 7
 *   7 0
 *   0 4
 *   7 5
 *
 * Output is to stdout in format:
 *     u1 u2 u3 u4 .. ul
 * where the ui are node numbers in an atomic cycle (one per line). E.g.:
 * 4 0 7 5
 * 2 1 0 4 3
 * 6 7 5
 * And so the number of lines written to stdout can be used to count the
 * number of atomic cycles, and the number of nodes listed on each line to
 * get atomic cycle lengths.
 ****************************************************************************/


#include <GClasses/GMatrix.h>
#include <GClasses/GGraph.h>
#include <GClasses/GRand.h>
#include <iostream>

using namespace GClasses;
using std::cout;

class AtomicCycleFinder : public GAtomicCycleFinder
{

public:
  AtomicCycleFinder(size_t nodes) : GAtomicCycleFinder(nodes)
  { }

  virtual ~AtomicCycleFinder()
  { }
 
  virtual bool onDetectAtomicCycle(std::vector<size_t>& cycle)
  {
    //cout << "found atomic cycle of size " << cycle.size() << std::endl;
    for (int i = 0; i < cycle.size(); i++) {
      cout << cycle[i];
      if (i < cycle.size()-1) {
        cout << " ";
      }
    }
    cout << std::endl;
    return true;
  }
};


// test from GGraph.cpp
static void test()
{
  // 6-7-0-1
  // |/ /  |
  // 5-4-3-2
  AtomicCycleFinder graph(8);
  graph.addEdge(0, 1);
  graph.addEdge(1, 2);
  graph.addEdge(2, 3);
  graph.addEdge(3, 4);
  graph.addEdge(4, 5);
  graph.addEdge(5, 6);
  graph.addEdge(6, 7);
  graph.addEdge(7, 0);
  graph.addEdge(0, 4);
  graph.addEdge(7, 5);
  graph.compute();
}

int main(int argc, char *argv[])
{
  GMatrix M; 
  GCSVParser p;

  if (argc != 3) {
     std::cerr << "Usage: " << argv[0] << " N infilename" << std::endl;
     exit(1);
  }
  int numNodes = atoi(argv[1]);
  char *infilename = argv[2];

  p.setSeparator('\0'); // arbitrary amount of whitespace as delimiter
  p.parse(M, infilename);
  //M.print(cout); // print M to stdout

  AtomicCycleFinder graph(numNodes);
  for (int i = 0; i < M.rows(); i++) {
    if (M[i][0] < 0 || M[i][1] < 0 ||
        M[i][0] >= numNodes || M[i][1] >= numNodes) {
      std::cerr << "Error: bad node number in input row " << i << std::endl;
      exit(1);
    }
    graph.addEdge(M[i][0], M[i][1]);
  }
  graph.compute();

  return 0;
}
