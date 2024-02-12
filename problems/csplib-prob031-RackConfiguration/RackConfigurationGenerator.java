import java.util.Random ;

// Order of generation is important
// * Each card requires a type, so only need at most as many types as cards
// * required power cannot be higher than the max power available
//     So generate req_power after max_power
// * Maximum possible number of connections is n_racks * max connects available in
//   the max_connects function.
//     So generate n_cards after max_connects
//
// Essentially we need to generate the rack information before the cards:
// 1. n_racks, n_models
// 2. max_power, max_connects, price
// 3. n_cards, n_types
// 4. req_power, ctype

/**
 * Parameters (integers)
 * n_models: the number of rack models
 * n_types: the number of card types
 * n_cards: the number of cards to be plugged into racks
 * n_racks: the number of racks to use
 *
 * Parameters (functions)
 * max_power: the maximum power a rack model can supply
 * max_connects : the maximum number of connections a rack model can accomodate
 * price: the price of a rack model
 * req_power: the amount of power required by a particular card type
 * ctype: the type of a particular card
 */
public final class RackConfigurationGenerator {
  // command line arguments
  private static int seed ;
  private static int racksUB ;
  private static int modelsUB ;
  private static int powerUB ;
  private static int connectionsUB ;
  private static int priceUB ;
  private static int cardsUB ;
  
  private static Random random ;
  
  // Generated parameters and bounds
  private static int n_models, n_types, n_cards, n_racks ;
  private static int maxPowerAvailable  = 0 ;
  private static int totalConnectionsAvailable ;

  /**
   * The language statement for a param file.
   * A comment recording the generator settings
   */
  private static void generatePreamble() {
    System.out.println("language Essence 1.3\n") ;
    System.out.println("$ Generated using seed: "+seed+"\n") ;
  }
  
  /**
   * Could (but don't have to) constrain:
   *   n_models (rack models) to be less than n_racks
   * Avoid generating 0 racks or models
   */
  private static void generateRackIntegerParameters() {
    n_racks = random.nextInt(racksUB)+1 ;
    n_models = random.nextInt(modelsUB)+1 ;
    System.out.println("letting n_racks be "+n_racks) ;
    System.out.println("letting n_models be "+n_models) ;
    System.out.println() ;
  }
  
  /**
   * max_power, max_connects, and price only require n_models
   */
  private static void generateRackFunctionParameters() {
    // max_power is the maximum power a rack model can supply
    System.out.println("letting max_power be function(") ;
    for (int i = 1; i <= n_models; i++) {
      // avoid 0 power supply
      int randPower = random.nextInt(powerUB)+1 ;
      System.out.print(i + " --> " + randPower) ;
      if (randPower > maxPowerAvailable)
        maxPowerAvailable  = randPower ;
      if (i < n_models)
        System.out.println(",") ;
    }
    System.out.println("\n)\n") ;
    
    // max_connects is the maximum number of connections a rack model can supply
    // Keep track of the maximum connections available to calculate the total
    //   connections available
    System.out.println("letting max_connects be function(") ;
    int maxConnectionsAvailable = 0 ;
    for (int i = 1; i <= n_models; i++) {
      // avoid 0 connections
      int randConnections = random.nextInt(connectionsUB)+1 ;
      System.out.print(i + " --> " + randConnections) ;
      if (randConnections > maxConnectionsAvailable)
        maxConnectionsAvailable = randConnections ;
      if (i < n_models)
        System.out.println(",") ;
    }
    System.out.println("\n)\n") ;
    totalConnectionsAvailable = n_racks * maxConnectionsAvailable ;
    
    // price is the cost of each rack model
    System.out.println("letting price be function(") ;
    for (int i = 1; i <= n_models; i++) {
      // avoid 0 price
      System.out.print(i + " --> " + (random.nextInt(priceUB)+1)) ;
      if (i < n_models)
        System.out.println(",") ;
    }
    System.out.println("\n)\n") ;
  }
  
  /**
   * Display maxPowerAvailable and totalConnectionsAvailable in the param file
   */
  private static void generateDebuggingComments() {
    System.out.println("$ max power available: "+maxPowerAvailable) ;
    System.out.println("$ total connections available: " + totalConnectionsAvailable) ;
    System.out.println() ;
  }
  
  /**
   * Only need (at most) as many types as there are cards.
   * n_cards cannot be greater than the totalConnectionsAvailable
   * Avoid generating 0 cards or types
   */
  private static void generateCardIntegerParameters() {
    n_cards = random.nextInt(Math.min(cardsUB,totalConnectionsAvailable))+1 ;
    n_types = random.nextInt(n_cards)+1 ;
    System.out.println("letting n_cards be "+n_cards) ;
    System.out.println("letting n_types be "+n_types) ;
    System.out.println() ;
  }
  
  /**
   * req_power depends on the maximum power available
   */
  private static void generateCardFunctionParameters() {
    // req_power is the power required for each type of card
    System.out.println("letting req_power be function(") ;
    for (int i = 1; i <= n_types; i++) {
      // avoid 0 power required
      System.out.print(i + " --> " + (random.nextInt(maxPowerAvailable)+1)) ;
      if (i < n_types)
        System.out.println(",") ;
    }
    System.out.println("\n)\n") ;
    // ctype is the type of each card
    System.out.println("letting ctype be function(") ;
    for (int i = 1; i <= n_cards; i++) {
      System.out.print(i + " --> " + (random.nextInt(n_types)+1)) ;
      if (i < n_cards)
        System.out.println(",") ;
    }
    System.out.println("\n)\n") ;
  }
  
  /**
   * Exposes many of the bounds as parameters.
   * The remainder are dependent on these.
   */
  public static void main (String[] args) {
    if (args.length != 7) {
      System.out.println("Usage: java RackConfigurationGenerator <seed> <6xUB>") ;
      System.out.println("Where the upper bounds are for: ") ;
      System.out.println("\tn_racks UB") ;
      System.out.println("\tn_models UB") ;
      System.out.println("\tpower UB (for each rack model)") ;
      System.out.println("\tconnections UB (for each rack model)") ;
      System.out.println("\tprice UB (for each rack model)") ;
      System.out.println("\tn_cards UB (also constrained by total connections available)") ;      
      return ;
    }
    seed = Integer.parseInt(args[0]) ;
    random = new Random(seed) ;

    racksUB = Integer.parseInt(args[1]) ;
    modelsUB = Integer.parseInt(args[2]) ;
    powerUB = Integer.parseInt(args[3]) ;
    connectionsUB = Integer.parseInt(args[4]) ;
    priceUB = Integer.parseInt(args[5]) ;
    cardsUB = Integer.parseInt(args[6]) ;
    
    generatePreamble() ;
    generateRackIntegerParameters() ;
    generateRackFunctionParameters() ;
    generateDebuggingComments() ;
    generateCardIntegerParameters() ;
    generateCardFunctionParameters() ;
  }
}
