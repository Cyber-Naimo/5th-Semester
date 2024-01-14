<?php require "includes/header.php"; ?>
<?php require "config/config.php"; ?>
<?php 

$userId = $_SESSION['user_id']; 

// Call the Stored Procedure to Get Most Visited Country ID
$stmt = $conn->prepare("CALL GetMostVisitedCountry(:userId, @mostVisitedCountryId)");
$stmt->bindParam(':userId', $userId, PDO::PARAM_INT);
$stmt->execute();

// Fetch the result
$result = $conn->query("SELECT @mostVisitedCountryId AS mostVisitedCountryId")->fetch(PDO::FETCH_ASSOC);
$mostVisitedCountryId = $result['mostVisitedCountryId'];

$discountFactor = 0.9; // 10% discount for the most visited country

// Update the SQL Query with Prepared Statements
$countriesQuery = "
    SELECT countries.id AS id, countries.name AS name, countries.image AS image, 
    countries.continent AS continent, countries.population AS population, 
    countries.territory AS territory, countries.description as description, 
    AVG(cities.price) * IF(countries.id = :mostVisitedCountryId, :discountFactor, 1) AS avg_price 
    FROM countries 
    JOIN cities ON countries.id = cities.country_id 
    GROUP BY countries.id
";

$countries = $conn->prepare($countriesQuery);
$countries->bindParam(':mostVisitedCountryId', $mostVisitedCountryId, PDO::PARAM_INT);
$countries->bindParam(':discountFactor', $discountFactor, PDO::PARAM_STR);
$countries->execute();
$allCountries = $countries->fetchAll(PDO::FETCH_OBJ);


?>

  <!-- ***** Main Banner Area Start ***** -->
  <section id="section-1">
    <div class="content-slider">
        <?php foreach( $allCountries as $country) : ?>

          <input type="radio" id="banner<?php echo  $country->id; ?>" class="sec-1-input" name="banner" checked>
        <?php endforeach; ?>
      <div class="slider">

      <?php foreach( $allCountries as $country) : ?>
        <div id="top-banner-<?php echo $country->id; ?>" class="banner">
          <div class="banner-inner-wrapper header-text">
            <div class="main-caption">
              <h2>Take a Glimpse Into The Beautiful Country Of:</h2>
              <h1><?php echo $country->name; ?></h1>
              <div class="border-button"><a href="about.php?id=<?php echo $country->id; ?>">Go There</a></div>
            </div>
            <div class="container">
              <div class="row">
                <div class="col-lg-12">
                  <div class="more-info">
                    <div class="row">
                      <div class="col-lg-3 col-sm-6 col-6">
                        <i class="fa fa-user"></i>
                        <h4><span>Population:</span><br><?php echo $country->population; ?> M</h4>
                      </div>
                      <div class="col-lg-3 col-sm-6 col-6">
                        <i class="fa fa-globe"></i>
                        <h4><span>Territory:</span><br><?php echo $country->territory; ?> KM<em>2</em></h4>
                      </div>
                      <div class="col-lg-3 col-sm-6 col-6">
                        <i class="fa fa-home"></i>
                        <h4><span>AVG Price:</span><br>$<?php echo $country->avg_price; ?></h4>
                      </div>
                      <div class="col-lg-3 col-sm-6 col-6">
                        <div class="main-button">
                          <a href="about.php?id=<?php echo $country->id; ?>">Explore More</a>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      <?php endforeach; ?>



    
      </div>
      <nav>
        <div class="controls">
          <?php foreach( $allCountries as $country) : ?>

            <label for="banner<?php echo $country->id; ?>"><span class="progressbar"><span class="progressbar-fill"></span></span><span class="text"><?php echo $country->id; ?></span></label>
          <?php endforeach; ?> 
        </div>
      </nav>
    </div>
  </section>
  <!-- ***** Main Banner Area End ***** -->
  
  <div class="visit-country">
    <div class="container">
      <div class="row">
        <div class="col-lg-5">
          <div class="section-heading">
            <h2 style="padding:5px; margin:1px !important;">Visit One Of Our Countries Now</h2>
            <p style="width: 600px;">Explore our amazing destinations and plan your next adventure with us</p>
          </div>
        </div>
      </div>
      <div class="row">
        <div class="col-lg-8">
          <div class="items">
            <div class="row">
              <?php foreach($allCountries as $country) : ?>
                <div class="col-lg-12">
                  <div class="item">
                    <div class="row">
                      <div class="col-lg-4 col-sm-5">
                        <div class="image">
                          <img src="<?php echo COUNTRIESIMAGES; ?>/<?php echo $country->image; ?>" alt="">
                        </div>
                      </div>
                      <div class="col-lg-8 col-sm-7">
                        <div class="right-content">
                          <h4><?php echo $country->name; ?></h4>
                          <span><?php echo $country->continent; ?></span>
                          <div class="main-button">
                            <a href="about.php?id=<?php echo $country->id; ?>">Explore More</a>
                          </div>
                          <p>
                          <?php echo $country->description; ?>
                          </p>
                          <ul class="info">
                            <li><i class="fa fa-user"></i> <?php echo $country->population; ?> Mil People</li>
                            <li><i class="fa fa-globe"></i> <?php echo $country->territory; ?> km2</li>
                            <li><i class="fa fa-home"></i> $<?php echo $country->avg_price; ?></li>
                          </ul>
                          <div class="text-button">
                            <a href="about.php?id=<?php echo $country->id; ?>">Need Directions ? <i class="fa fa-arrow-right"></i></a>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              <?php endforeach; ?>
             
            </div>
          </div>
        </div>
        <div class="col-lg-4">
          <div class="side-bar-map">
            <div class="row">
              <div class="col-lg-12">
                <div id="map"> 
                  <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d14163511.624200856!2d58.32364902238183!3d29.925109697033538!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x38db52d2f8fd751f%3A0x46b7a1f7e614925c!2sPakistan!5e0!3m2!1sen!2s!4v1701807224475!5m2!1sen!2s" width="600" height="750" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

 <?php require "includes/footer.php"; ?>