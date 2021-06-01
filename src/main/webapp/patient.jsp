<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<html>
    <head>
        <title>Patient Page</title>
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
            <div class="card-body table-responsive" style="text-align: center; padding-bottom: 0;">
                <label for="patname" id="patname"></label><br>
                <label for="phoneno" id="phoneno"></label>
            </div>
            <div class="card-body table-responsive" style="display: inline-block;">
                <label for="vital" class="col-2"><b>Enter Oxygen Level: </b></label>
                <input class="form-control form-control-sm col-6" type="number" name="vital" id="vital" style="display:inline-block; width:300px;margin-top:25px;" min="0" max="100" required>
                <button onClick="sendVitals();" class="btn btn-success btn-sm">Submit</button>
            </div>
        </div>

        <div class="card content-body bg-light border-none" style="margin: 2%; margin-left: 2%;">
            <div class="card-body table-responsive p-0" style="min-height: 400px;">
                <table class="table table-striped table-bordered table-head-fixed text-nowrap" id="detailstable">
                    <thead>
                        <tr>
                            <th style="width: 10%" >Doctor Name</th>
                            <th style="width: 10%" >Prescription</th>
                            <th style="width: 10%" >Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <!-- Ptient dashboard data -->
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    </body>

    <script>
	    var url = new URL(window.location.href);
	    document.getElementById("patname").innerHTML = '<b>Patient Name : '+url.searchParams.get("username")+'</b>';
	    document.getElementById("phoneno").innerHTML = '<b>Doctor Name : '+url.searchParams.get("phoneno")+'</b>';
	    
	    var websocket = new WebSocket("ws://localhost:8080/Project_-_5_Hospital_Inpatient_Service/VitalCheckEndPoint");
        websocket.onmessage = function processVital(vital) {
            var jsondata = JSON.parse(vital.data);
            if(jsondata.message != null) {
                var details = jsondata.message.split(",");
                var row = document.getElementById("detailstable").insertRow();
                row.innerHTML = '<td>'+details[0]+'</td><td>'+details[1]+'</td><td>'+details[2]+'</td>';
            }
        }

        function sendVitals() {
        	if(vital.value < 0 || vital.value > 100) {
        		alert("Either of the fields entered is not valid");
        	}
        	else {
        		websocket.send(vital.value+','+url.searchParams.get("phoneno"));
	            vital.value = "";
	            phoneno.value = "";
        	}
        }

    </script>

</html>
