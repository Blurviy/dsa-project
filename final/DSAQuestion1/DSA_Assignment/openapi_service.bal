import ballerina/http;
import ballerina/time;

listener http:Listener ep0 = new (8080, config = {host: "localhost"});

// In-memory storage for programmes
map<Programme> programmes = {};

service / on ep0 {
    # Retrieve all programmes
    #
    # + return - Successful operation 
    resource function get programmes() returns Programme[] {
        return programmes.toArray();
    }

    # Add a new programme
    #
    # + payload - Programme details 
    # + return - Programme created successfully or invalid input error
    resource function post programmes(@http:Payload Programme payload) returns http:Created|http:BadRequest {
        if (payload.programmeCode == "" || payload.nqfLevel <= 0 || payload.faculty == "" || 
            payload.department == "" || payload.qualificationTitle == "" || 
            payload.registrationDate == "" || payload.courses.length() == 0) {
            return <http:BadRequest>{body: "All fields are required and must be valid"};
        }
        
        programmes[payload.programmeCode] = payload;
        return <http:Created>{
            body: "Programme created successfully", 
            headers: {"Location": "/programmes/" + payload.programmeCode}
        };
    }

    # Get a programme by programme code
    #
    # + programmeCode - The programme code 
    # + return - Programme details or not found error
    resource function get programmes/[string programmeCode]() returns Programme|http:NotFound {
        Programme? programme = programmes[programmeCode];
        if programme is () {
            return <http:NotFound>{body: "Programme not found"};
        }
        return programme;
    }

    # Update a programme by programme code
    #
    # + programmeCode - The programme code 
    # + payload - Updated programme details 
    # + return - Programme updated successfully or not found error
    resource function put programmes/[string programmeCode](@http:Payload Programme payload) returns http:Ok|http:NotFound {
        if (!programmes.hasKey(programmeCode)) {
            return <http:NotFound>{body: "Programme not found"};
        }
        
        programmes[programmeCode] = payload;
        return <http:Ok>{body: "Programme updated successfully"};
    }

    # Delete a programme by programme code
    #
    # + programmeCode - The programme code 
    # + return - Programme deleted successfully or not found error
    resource function delete programmes/[string programmeCode]() returns http:NoContent|http:NotFound {
        if (!programmes.hasKey(programmeCode)) {
            return <http:NotFound>{body: "Programme not found"};
        }
        
        _ = programmes.remove(programmeCode);
        return <http:NoContent>{};
    }

    # Retrieve programmes due for review
    #
    # + return - Programmes due for review or error
    resource function get programmes/due\-for\-review() returns Programme[]|error {
        time:Utc currentDate = time:utcNow();
        Programme[] dueForReview = [];
        
        foreach Programme prog in programmes {
            time:Utc registrationDate = check time:utcFromString(prog.registrationDate);
            int yearsDifference = calculateYearDifference(currentDate, registrationDate);
            if (yearsDifference >= 5) {
                dueForReview.push(prog);
            }
        }
        
        return dueForReview;
    }

    # Retrieve programmes by faculty
    #
    # + facultyName - The name of the faculty 
    # + return - Programmes in the specified faculty
    resource function get programmes/by\-faculty/[string facultyName]() returns Programme[] {
        return programmes.toArray().filter(prog => prog.faculty == facultyName);
    }
}

# Calculate the difference in years between two dates
#
# + date1 - The later date
# + date2 - The earlier date
# + return - The difference in years
function calculateYearDifference(time:Utc date1, time:Utc date2) returns int {
    time:Civil civil1 = time:utcToCivil(date1);
    time:Civil civil2 = time:utcToCivil(date2);
    
    int yearDiff = civil1.year - civil2.year;
    
    // Adjust for cases where we haven't reached the anniversary yet
    if (civil1.month < civil2.month || (civil1.month == civil2.month && civil1.day < civil2.day)) {
        yearDiff -= 1;
    }
    
    return yearDiff;
}

