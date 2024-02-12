import java.util.Random ;

/**
 * Parameters (integers)
 * n_boats
 * n_periods
 *
 * Parameters (functions)
 * capacity : of each boat for hosting purposes
 * crew :     crew size of each boat
 *
 * Order of generation:
 * Since a boat can never revisit a host, trivially unsat if n_periods > n_boats-1
 *   (since guest crew will not visit themselves).
 * need n_boats before either function can be generated.
 * Capacity includes space for own crew, so capacity first.
 */
public final class PPPGenerator {
  // command line arguments
  private static int seed ;
  private static int nBoatsUB, capacityUB ;
  
  private static Random random ;
  
  // Generated parameters and bounds
  private static int n_boats, n_periods ;
  private static int maxCapacity = 0 ;
  
  /**
   * The language statement for a param file.
   * A comment recording the generator settings
   */
  private static void generatePreamble() {
    System.out.println("language Essence 1.3\n") ;
    System.out.println("$ Generated using seed: "+seed+"\n") ;
  }
  
  /**
   * Avoid generating 0, 1 boats or 0 periods
   * A boat can never revisit a host, so trivially unsat if n_periods > n_boats-1
   *   assuming there are some guest crews (since guest crew will not visit
   *   themselves).
   */
  private static void generateIntegerParameters() {
    n_boats = random.nextInt(nBoatsUB-1)+2 ;
    n_periods = random.nextInt(n_boats-1)+1 ;
    System.out.println("letting n_boats be "+n_boats) ;
    System.out.println("letting n_periods be "+n_periods) ;
    System.out.println() ;
  }
  
  /**
   * capacity, crew
   */
  private static void generateFunctionParameters() {
    // Used to cap generated crew sizes later
    int[] storedCapacities = new int[n_boats] ;
    System.out.println("letting capacity be function(") ;
    for (int i = 1; i <= n_boats; i++) {
      // avoid 0 capacity
      int randCapacity = random.nextInt(capacityUB)+1 ;
      System.out.print(i + " --> " + randCapacity) ;
      storedCapacities[i-1] = randCapacity ;
      if (i < n_boats)
        System.out.println(",") ;
    }
    System.out.println("\n)\n") ;
    
    // Capacity includes space for crew, so crew for a boat is at most
    //  its capacity
    System.out.println("letting crew be function(") ;
    for (int i = 1; i <= n_boats; i++) {
      // avoid 0 crew
      int randCrew = random.nextInt(storedCapacities[i-1])+1 ;
      System.out.print(i + " --> " + randCrew) ;
      if (i < n_boats)
        System.out.println(",") ;
    }
    System.out.println("\n)\n") ;
  }
  
  /**
   *
   */
  public static void main (String[] args) {
    if (args.length != 3) {
      System.out.println("Usage: java PPPGenerator <seed> <nBoatsUB> <capacityUB>") ;
      return ;
    }
    seed = Integer.parseInt(args[0]) ;
    nBoatsUB = Integer.parseInt(args[1]) ;
    capacityUB = Integer.parseInt(args[2]) ;
    random = new Random(seed) ;

    generatePreamble() ;
    generateIntegerParameters() ;
    generateFunctionParameters() ;
  }
}
