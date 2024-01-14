<?php require "../layouts/header.php"; ?>      
<?php require "../../config/config.php"; ?> 

<?php 

  if(!isset($_SESSION["adminname"])) {
    header("location: ".ADMINURL."");
  }

  // Fetch booking history from the database
  $history = $conn->query("SELECT * FROM booking_history");
  $history->execute();

  $allHistory = $history->fetchAll(PDO::FETCH_OBJ);

?> 

      <div class="row">
        <div class="col">
          <div class="card">
            <div class="card-body">
              <h5 class="card-title mb-4 d-inline ">Booking History</h5>
            
              <table class="table mt-4">
                <thead>
                  <tr>
                    <th scope="col">#</th>
                    <th scope="col">Booking ID</th>
                    <th scope="col">Modification Date</th>
                    <th scope="col">Action</th>
                    <th scope="col">User ID</th>
                    <th scope="col">City ID</th>
                    <th scope="col">Number of Guests</th>
                    <th scope="col">Check-in Date</th>
                    <th scope="col">Destination</th>
                    <th scope="col">Status</th>
                    <th scope="col">Payment</th>
                  </tr>
                </thead>
                <tbody>
                  <?php foreach($allHistory as $historyItem) : ?>
                    <tr>
                      <th scope="row"><?php echo $historyItem->id; ?></th>
                      <td><?php echo $historyItem->booking_id; ?></td>
                      <td><?php echo $historyItem->modification_date; ?></td>
                      <td><?php echo $historyItem->action; ?></td>
                      <td><?php echo $historyItem->user_id; ?></td>
                      <td><?php echo $historyItem->city_id; ?></td>
                      <td><?php echo $historyItem->num_of_geusts; ?></td>
                      <td><?php echo $historyItem->checkin_date ? date('Y-m-d H:i:s', strtotime($historyItem->checkin_date)) : ''; ?></td>
                      <td><?php echo $historyItem->destination; ?></td>
                      <td><?php echo $historyItem->status; ?></td>
                      <td><?php echo $historyItem->payment; ?></td>
                    </tr>
                  <?php endforeach; ?>
                </tbody>
              </table> 
            </div>
          </div>
        </div>
      </div>


<?php require "../layouts/footer.php"; ?>