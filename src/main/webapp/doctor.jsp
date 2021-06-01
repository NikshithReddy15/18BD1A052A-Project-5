<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<html>
    <head>
        <title>Doctor Page</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
        <meta name="viewport" content="width=device-width, initial-scale=1">
    </head>
    <body class="hold-transition">

        <header class="card notranslate" id="topnav">
            <nav id="navbar_top" class="navbar navbar-expand-lg navbar-dark bg-success">
                <div class="container">
                    <a class="navbar-brand" href="localhost:8080/Project_-_5_Hospital_Inpatient_Service" style="padding-right: 60%;">Tracker</a>
                </div>
            </nav>
        </header>

        <div class="card content-body bg-light border-none" style="margin: 2%; margin-left: 2%;">
            <div class="card-body table-responsive" style="text-align: center;">
                <label for="doctorname" id="docname"></label>
            </div>
        </div>

        <div class="card content-body bg-light border-none" style="margin: 2%; margin-left: 2%;">
            <div class="card-body table-responsive p-0" style="min-height: 400px;">
                <table class="table table-striped table-bordered table-head-fixed text-nowrap" id="detailstable">
                    <thead>
                        <tr>
                            <th style="width: 10%" >Patient Name</th>
                            <th style="width: 10%" >Oxygen Level</th>
                            <th style="width: 10%" >Contact</th>
                            <th style="width: 10%" >Action</th>
                        </tr>
                    </thead>
                    <tbody id="detailstable1">
                        <!-- Doctor dashboard data -->
                    </tbody>
                </table>
            </div>
        </div>
        <!-- <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="exampleModalLabel">Online Prescription</h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
                <div class="modal-body">
                  <label>Medicine Name</label>
                  <input type="text" class="form-control" id="medicine_name" style="margin:10px 0;" required>
                  <label>Description</label>
                  <textarea id="medicine_description" class="form-control" required></textarea>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                  <button type="button" class="btn btn-info" id="submit_btn">Submit</button>
                </div>
              </div>
            </div>
        </div> -->
    </body>
    
    
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <script>

	    var url = new URL(window.location.href);
	    document.getElementById("docname").innerHTML = '<b>Doctor Name : '+url.searchParams.get("username")+'</b>';
    
        var websocket = new WebSocket("ws://localhost:8080/Project_-_5_Hospital_Inpatient_Service/VitalCheckEndPoint");
        websocket.onmessage = function processVital(vital) {
            var jsondata = JSON.parse(vital.data);
            if(jsondata.message != null) {
                var details = jsondata.message.split(",");
                if(details.length > 2) {
	                var row = document.getElementById("detailstable1");
	                if(!document.getElementById("row"+details[0])) {
	                	row.innerHTML = '<tr id="row'+details[0]+'"><td>'+details[0]+'</td><td>'+details[1]+'</td><td>'+details[2]+'</td><td><input type="button" id="'+details[0]+'ambbtn" value="Summon Ambulance" class=\'btn btn-sm btn-danger\' onClick=\'sendInstructions("'+details[0]+'","'+details[2]+'")\'><input type="button" id="'+details[0]+'medbtn" value="Prescribe medication" class=\'btn btn-sm btn-info\' onClick=\'sendInstructions("'+details[0]+'","medication")\'></td></tr>' + row.innerHTML;
	                } else {
	                	document.getElementById("row"+details[0]).innerHTML = '<td>'+details[0]+'</td><td>'+details[1]+'</td><td>'+details[2]+'</td><td><input type="button" id="'+details[0]+'ambbtn" value="Summon Ambulance" class=\'btn btn-sm btn-danger\' onClick=\'sendInstructions("'+details[0]+'","'+details[2]+'")\'><input type="button" id="'+details[0]+'medbtn" value="Prescribe medication" class=\'btn btn-sm btn-info\' onClick=\'sendInstructions("'+details[0]+'","medication")\'></td>';
	                }
                } else {
                	document.getElementById(details[0]+"ambbtn").disabled = true;
                	document.getElementById(details[0]+"medbtn").disabled = true;
            		document.getElementById("row"+details[0]).outerHTML="";
                }
                
            }
        }

        function sendInstructions(username, message) {
            if(message != 'medication') {
                websocket.send(username+',ambulance,'+message+','+url.searchParams.get("username"));     //message = contact
            } else {
                
				var medicine = prompt("Enter Medicine names : ");
				var description = prompt("Enter Description : ");
				if(medicine.length != 0 && description.length != 0) {
					websocket.send(username+','+message+','+medicine+','+description+','+url.searchParams.get("username"));
				} else if(medicine_name.length == 0 && medicine_description.length == 0) {
					alert("Medicines and Description are missing");
				} else if(medicine_name.length == 0 && medicine_description.length != 0) {
					alert("Medicines are missing");
				} else {
					alert("Description is missing");
				}
				
				/*$('#exampleModal').modal('show');	
				
				var medicine = document.getElementById("medicine_name").value;
				var description = document.getElementById("medicine_description").value;
				
				document.getElementById("submit_btn").onclick = function() {
					
					alert(medicine);
					
					if(medicine.length != 0 && description.length != 0) {
						websocket.send(username+','+message+','+medicine+','+description+','+url.searchParams.get("username"));
						
						medicine_name.value="";
						medicine_description.value="";
						$('#exampleModal').modal('hide');
					} else if(medicine_name.length == 0 && medicine_description.length == 0) {
						alert("Medicines and Description are missing");
					} else if(medicine_name.length == 0 && medicine_description.length != 0) {
						alert("Medicines are missing");
					} else {
						alert(medicine+",Description is missing");
					}
				}*/
            }
        }

    </script>

</html>
