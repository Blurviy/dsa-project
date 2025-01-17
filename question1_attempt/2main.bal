import ballerina/http;
import ballerina/time;


type Program record {
    readonly string programCode;
    int nqfLevel;
    string faculty;
    string department;
    string title;
    time:Date registrationDate;
    Course[] courses;
};

type Course record {
    string courseName;
    readonly string courseCode;
    int nqfLevel;
    string department;
};

table<Program> key(programCode) programs = table [
    {programCode: "07BCMS", nqfLevel: 7, faculty: "FCI", department: "computerScience", title: "Software Engineering", registrationDate: {year: 2023, month: 12, day: 6} , courses: [] },
    {programCode: "08BCMS", nqfLevel: 8, faculty: "FCI", department: "computerScience", title: "Data Science", registrationDate: {year: 2024, month: 1, day: 15} , courses: [] },
    {programCode: "09BCMS", nqfLevel: 9, faculty: "FCI", department: "computerScience", title: "Artificial Intelligence", registrationDate: {year: 2024, month: 3, day: 1} , courses: [] },
    {programCode: "07ACCA", nqfLevel: 7, faculty: "Accounting", department: "Accounting", title: "Financial Accounting", registrationDate: {year: 2023, month: 12, day: 6} , courses: [] },
    {programCode: "08ACCA", nqfLevel: 8, faculty: "Accounting", department: "Accounting", title: "Management Accounting", registrationDate: {year: 2024, month: 1, day: 15} , courses: [] },
    {programCode: "07ENGE", nqfLevel: 7, faculty: "Engineering", department: "Civil Engineering", title: "Civil Engineering", registrationDate: {year: 2023, month: 12, day: 6} , courses: [] },
    {programCode: "08ENGE", nqfLevel: 8, faculty: "Engineering", department: "Electrical Engineering", title: "Electrical Engineering", registrationDate: {year: 2024, month: 1, day: 15} , courses: [] }
];

table<Course> key(courseCode) courses = table [
    {courseName: "Software Design", courseCode: "SDN611S", nqfLevel: 7, department: "computerScience" },
    {courseName: "Machine Learning", courseCode: "MLN612S", nqfLevel: 8, department: "computerScience" },
    {courseName: "Deep Learning", courseCode: "DLN613S", nqfLevel: 9, department: "computerScience" }
];

type ErrorDetails record {
    string message;
    string details;
};

type ProgramNotFound record {|
    ErrorDetails body;
|};



service /DSA\-PROJECT on new http:Listener(9090) {

//Retrieve the details of a specific programme by their programme code.
    resource function get programs/[string programCode]() returns Program | ErrorDetails | error {
        Program? program = programs[programCode];
        if program is () {
            ErrorDetails errorDetails = {
                message: "Program not found",
                details: "programCode: ${programCode}"
            };
            return errorDetails;
        } else {
        return program;
    } }
//getting all programs
    resource function get AllPrograms() returns Program[] | error? {
        return programs.toArray();
    } 
resource function get ProgramsByFaculty(string faculty) returns table<Program> key<string>|ErrorDetails {
    table<Program> key<string> programsByFaculty = programs.filter(p => p.faculty == faculty);

//getting programs within a faculty
    if programsByFaculty.length() == 0 {
        ErrorDetails errorDetails = {
            message: "No programs found for faculty ",
            details: "faculty: ${faculty}"
        };
        return errorDetails;
    } else {
        return programsByFaculty;
    }
}
}


     
 


